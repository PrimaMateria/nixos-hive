-- Claude plan limits on the bar. ~/.claude/statusline.sh caches the
-- `rate_limits` Claude Code passes to its status line into rate-limits.json:
--   {"five_hour":{"used_percentage":4,"resets_at":<unix>},
--    "seven_day":{"used_percentage":3,"resets_at":<unix>},"updatedAt":<unix>}

local FILE = "@rateLimitsFile@"
local HIGH = 85

-- Percent used in a limit window; 0 once its reset time has passed.
local function percent(limit)
  if limit == nil or limit.used_percentage == nil then
    return nil
  end
  if limit.resets_at ~= nil and limit.resets_at <= os.time() then
    return 0
  end
  return math.floor(limit.used_percentage + 0.5)
end

local function resets(limit)
  if limit == nil or limit.resets_at == nil then
    return "-"
  end
  return os.date("%a %H:%M", limit.resets_at)
end

function update()
  noctalia.setUpdateInterval(30000)

  local raw = noctalia.readFile(FILE)
  local usage = raw and noctalia.json.decode(raw)
  if usage == nil or usage.updatedAt == nil then
    barWidget.setVisible(false)
    return
  end

  local session = percent(usage.five_hour)
  local week = percent(usage.seven_day)
  barWidget.setVisible(true)
  barWidget.setGlyph("sparkles")
  barWidget.setText(string.format("5h %s%% · wk %s%%", session or "-", week or "-"))

  local high = (session or 0) > HIGH or (week or 0) > HIGH
  barWidget.setColor(high and "error" or "on_surface")

  barWidget.setTooltip({
    { "Session", string.format("%s%% (resets %s)", session or "-", resets(usage.five_hour)) },
    { "Week", string.format("%s%% (resets %s)", week or "-", resets(usage.seven_day)) },
    { "Updated", os.date("%H:%M", usage.updatedAt) },
  })
end
