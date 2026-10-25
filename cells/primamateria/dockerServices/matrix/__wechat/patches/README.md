# Runtime patches

Both images run TypeScript straight from `/opt/matrix-wechat/packages/*/src/`
with `BUN_RUNTIME_TRANSPILER_CACHE_PATH=0`, so a patched file mounted over the
original takes effect on restart — no image rebuild.

`attachments.orig.ts` is the pristine copy taken from
`matrix-wechat-runtime@sha256:87cd64fa...a95916` (identical to upstream master
at the time). Keep it in sync: `diff -u attachments.orig.ts attachments.ts`
is the whole delta. If the image digest in `dockerService.nix` is bumped,
re-extract the original and re-derive the patch — a stale whole-file mount
would silently revert upstream changes to this file.

## attachments.ts — thumbnail fallback

`receivedImage()` only ever read `<cacheID>_h.dat` / `<cacheID>.dat`, the
originals. WeChat writes those only when a human opens the image in the
client, which cannot happen in a headless container, so every image bridged as
`[image unavailable in the local WeChat cache]` forever.

WeChat *does* always cache `<cacheID>_t.dat`, encrypted identically. The patch
tries originals first (MD5-verified, unchanged) and falls back to the
thumbnail, which cannot be MD5-verified because the message metadata carries
the original's hash.

The `console.log` on fallback is temporary, for confirming the cacheID derived
from `packed_info_data` matches the `_t.dat` stem on disk.
