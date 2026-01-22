-- The hyperkey is shift + cmd + alt + ctrl, all on the left side of keyboard
-- This is remapped to capslock using Karabiner-Elements
hyperkey = {"lshift", "lcmd", "lalt", "lctrl"}

-- Reload config
hs.hotkey.bind(hyperkey, "R", function()
  hs.reload()
end)

-- Caffeine
hs.loadSpoon("Caffeine")
spoon.Caffeine:start()
caffeineOn = true -- set to true to turn it on for the first time when triggered
hs.hotkey.bind(hyperkey, "C", function()
  spoon.Caffeine:setState(caffeineOn)
  caffeineOn = not caffeineOn
end)

-- App Switching with hotkeys
-- - switch to arc with j
hs.hotkey.bind(hyperkey, "J", function()
  hs.application.launchOrFocus("Arc")
end)
-- - switch to chrome with u
hs.hotkey.bind(hyperkey, "U", function()
  hs.application.launchOrFocus("Google Chrome")
end)
-- - switch to kitty terminal window with k
hs.hotkey.bind(hyperkey, "K", function()
  hs.application.launchOrFocus("kitty")
end)
-- - switch to slack window with l
hs.hotkey.bind(hyperkey, "L", function()
  hs.application.launchOrFocus("Slack")
end)
-- - switch to messages window with ;
hs.hotkey.bind(hyperkey, ";", function()
  hs.application.launchOrFocus("Messages")
end)
-- - pause/unpause apple music with p
hs.hotkey.bind(hyperkey, "P", function()
  hs.itunes.playpause()
end)
