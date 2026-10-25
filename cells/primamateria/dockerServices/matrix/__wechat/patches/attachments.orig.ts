import { createDecipheriv, createHash } from "node:crypto";
import { readdir, readFile, realpath, stat } from "node:fs/promises";
import { basename, dirname, join, resolve } from "node:path";
import { imageType, messageMetadata as metadata } from "./media";
import { protobufPath } from "./protobuf";
import { APIError, type Message } from "./types";

const md5 = (input: string | Buffer) => createHash("md5").update(input).digest("hex");
export function attachmentChecksum(message: Message): string {
  const root = metadata(message);
  return String(root?.videomsg?.md5 || root?.appmsg?.md5 || root?.img?.md5 || "").toLowerCase();
}
function accountDirectory(message: Message, home: string) {
  const database = message.native?.database;
  if (typeof database !== "string")
    throw new APIError("media_unavailable", "Attachment source is unavailable");
  const directory = resolve(dirname(database), "../..");
  if (
    dirname(directory) !== join(resolve(home), "xwechat_files") ||
    !basename(directory).startsWith(message.account_id + "_") ||
    !/_[a-f0-9]{4}$/.test(directory)
  )
    throw new APIError("media_unavailable", "Invalid attachment account");
  return directory;
}
async function cachedBytes(path: string, account: string) {
  const actual = await realpath(path),
    root = await realpath(account);
  if (!actual.startsWith(root + "/"))
    throw new APIError("media_unavailable", "Invalid attachment path");
  const info = await stat(actual);
  if (!info.isFile() || info.size > 64 * 1024 * 1024)
    throw new APIError("media_unavailable", "Attachment exceeds the limit");
  return readFile(actual);
}
function months(message: Message) {
  const time = new Date(message.timestamp < 1e12 ? message.timestamp * 1000 : message.timestamp);
  return [-1, 0, 1].map((offset) =>
    new Date(Date.UTC(time.getUTCFullYear(), time.getUTCMonth() + offset, 15))
      .toISOString()
      .slice(0, 7),
  );
}
export async function receivedThumbnail(message: Message, home = "/home/wechat") {
  const checksum = String(metadata(message).appmsg?.appattach?.cdnthumbmd5 || "").toLowerCase();
  if (!/^[a-f0-9]{32}$/.test(checksum))
    throw new APIError("media_unavailable", "Cached thumbnail metadata is unavailable");
  const account = accountDirectory(message, home);
  for (const month of months(message)) {
    const directory = join(account, "cache", month, "Message", md5(message.chat_id), "Thumb");
    let files: string[];
    try {
      files = await readdir(directory);
    } catch (error: any) {
      if (error.code === "ENOENT") continue;
      throw error;
    }
    for (const name of files) {
      const bytes = await cachedBytes(join(directory, name), account),
        type = imageType(bytes);
      if (type && md5(bytes) === checksum) return { bytes, type };
    }
  }
  throw new APIError("media_unavailable", "Link thumbnail is not cached yet");
}

export function decodeImageV2(bytes: Buffer, key: Buffer, xor: number) {
  if (bytes.subarray(0, 6).toString("hex") !== "070856320807" || bytes.length < 31)
    throw new APIError("media_unavailable", "Unsupported image cache format");
  const plainSize = bytes.readUInt32LE(6),
    tailSize = bytes.readUInt32LE(10);
  const encryptedSize = (Math.floor(plainSize / 16) + 1) * 16;
  if (!plainSize || encryptedSize + tailSize > bytes.length - 15)
    throw new APIError("media_unavailable", "Image cache is incomplete");
  const decoder = createDecipheriv("aes-128-ecb", key, null);
  const head = Buffer.concat([
    decoder.update(bytes.subarray(15, 15 + encryptedSize)),
    decoder.final(),
  ]);
  if (head.length !== plainSize)
    throw new APIError("media_unavailable", "Image cache length mismatch");
  const tail = Buffer.from(bytes.subarray(bytes.length - tailSize));
  for (let i = 0; i < tail.length; i++) tail[i] ^= xor;
  return Buffer.concat([head, bytes.subarray(15 + encryptedSize, bytes.length - tailSize), tail]);
}

export async function receivedImage(message: Message, home = "/home/wechat") {
  const account = accountDirectory(message, home),
    expected = String(metadata(message).img?.md5 || "");
  const packed = message.native?.row?.packed_info_data?.base64;
  const cacheID = packed
    ? protobufPath(Buffer.from(packed, "base64"), [3, 4])?.toString()
    : undefined;
  if (!cacheID || !/^[a-f0-9]{32}$/i.test(cacheID) || !/^[a-f0-9]{32}$/i.test(expected))
    throw new APIError("media_unavailable", "Image cache mapping is unavailable");
  const suffix = basename(account).slice(-4),
    keys = new Set<string>();
  for (const file of await readdir(join(home, ".xwechat/net/kvcomm"))) {
    const uin = file.match(/^key_(\d+)_.*\.statistic$/)?.[1];
    if (uin && md5(uin).slice(0, 4) === suffix) keys.add(uin);
  }
  for (const month of months(message))
    for (const ending of ["_h.dat", ".dat"]) {
      let encoded: Buffer;
      try {
        encoded = await cachedBytes(
          join(account, "msg/attach", md5(message.chat_id), month, "Img", cacheID + ending),
          account,
        );
      } catch (error: any) {
        if (error.code === "ENOENT") continue;
        throw error;
      }
      for (const uin of keys) {
        try {
          const key = Buffer.from(md5(uin + message.account_id).slice(0, 16));
          const bytes = decodeImageV2(encoded, key, Number(uin) & 255),
            type = imageType(bytes);
          if (type && md5(bytes) === expected.toLowerCase()) return { bytes, type };
        } catch {}
      }
    }
  throw new APIError(
    "media_unavailable",
    "Original image is not downloaded or could not be verified",
  );
}

export async function receivedFile(message: Message, home = "/home/wechat") {
  const account = accountDirectory(message, home),
    app = metadata(message).appmsg;
  const packed = message.native?.row?.packed_info_data?.base64;
  const name = packed
    ? protobufPath(Buffer.from(packed, "base64"), [7, 1, 2])?.toString()
    : undefined;
  const checksum = String(app?.md5 || ""),
    size = Number(app?.appattach?.totallen);
  if (
    !name ||
    basename(name) !== name ||
    /[\\/\x00-\x1f]/.test(name) ||
    !/^[a-f0-9]{32}$/i.test(checksum) ||
    !Number.isSafeInteger(size) ||
    size < 0 ||
    size > 64 * 1024 * 1024
  )
    throw new APIError("media_unavailable", "File metadata is unavailable");
  for (const month of months(message)) {
    try {
      const bytes = await cachedBytes(join(account, "msg/file", month, name), account);
      if (bytes.length === size && md5(bytes) === checksum.toLowerCase())
        return { bytes, type: "application/octet-stream", name };
    } catch (error: any) {
      if (error.code !== "ENOENT") throw error;
    }
  }
  throw new APIError("media_unavailable", "File is not downloaded or could not be verified");
}

export async function receivedVideo(message: Message, home = "/home/wechat") {
  const account = accountDirectory(message, home),
    video = metadata(message).videomsg;
  const packed = message.native?.row?.packed_info_data?.base64;
  const cacheID = packed
    ? protobufPath(Buffer.from(packed, "base64"), [4, 8])?.toString()
    : undefined;
  const checksum = String(video?.md5 || ""),
    size = Number(video?.length);
  if (
    !cacheID ||
    !/^[a-f0-9]{32}$/i.test(cacheID) ||
    !/^[a-f0-9]{32}$/i.test(checksum) ||
    !Number.isSafeInteger(size) ||
    size < 12 ||
    size > 64 * 1024 * 1024
  )
    throw new APIError("media_unavailable", "Video metadata is unavailable");
  for (const month of months(message)) {
    try {
      const bytes = await cachedBytes(join(account, "msg/video", month, cacheID + ".mp4"), account);
      if (
        bytes.length === size &&
        bytes.subarray(4, 8).toString() === "ftyp" &&
        md5(bytes) === checksum.toLowerCase()
      )
        return { bytes, type: "video/mp4" };
    } catch (error: any) {
      if (error.code !== "ENOENT") throw error;
    }
  }
  throw new APIError("media_unavailable", "Video is not downloaded or could not be verified");
}
