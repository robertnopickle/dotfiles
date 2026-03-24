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

-- Is the computer docked?
IsDocked = function()
  return hs.fnutils.some(hs.usb.attachedDevices(), function(device)
    return device.productName == "OBSBOT Tiny 4K"
  end)
end

-- Elgato key light control toggle with e
hs.loadSpoon("ElgatoKey"):start()
hs.hotkey.bind(hyperkey, "E", function()
  if IsDocked() then
    spoon.ElgatoKey:toggle()
  end
end)

-- App Switching with hotkeys
-- - switch to arc with j
hs.hotkey.bind(hyperkey, "J", function()
  hs.application.launchOrFocus("Arc")
end)
-- - switch to terminal window with k
hs.hotkey.bind(hyperkey, "K", function()
  hs.application.launchOrFocus("iterm")
end)
-- - switch to slack window with l
hs.hotkey.bind(hyperkey, "L", function()
  hs.application.launchOrFocus("Slack")
end)
-- - switch to messages window with ;
hs.hotkey.bind(hyperkey, ";", function()
  hs.application.launchOrFocus("Messages")
end)

-- - switch to chrome with u
hs.hotkey.bind(hyperkey, "U", function()
  hs.application.launchOrFocus("Google Chrome")
end)
-- - switch to microsoft teams with i
hs.hotkey.bind(hyperkey, "I", function()
  hs.application.launchOrFocus("Microsoft Teams")
end)
-- - switch to microsoft outlook with o
hs.hotkey.bind(hyperkey, "O", function()
  hs.application.launchOrFocus("Microsoft Outlook")
end)

-- - switch to 1password with x
hs.hotkey.bind(hyperkey, "X", function()
  hs.application.launchOrFocus("1Password")
end)

-- Apple Music controls
-- - pause/unpause with p
hs.hotkey.bind(hyperkey, "P", function()
  hs.itunes.playpause()
  if hs.itunes.isPlaying() then
    hs.itunes.displayCurrentTrack()
  end
end)
-- - previous track with [
hs.hotkey.bind(hyperkey, "[", function()
  hs.itunes.previous()
  hs.itunes.displayCurrentTrack()
end)
-- - next track with ]
hs.hotkey.bind(hyperkey, "]", function()
  hs.itunes.next()
  hs.itunes.displayCurrentTrack()
end)

