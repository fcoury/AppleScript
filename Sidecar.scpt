set deviceName to "Felipe Coury’s iPad"
set sysVer to system version of (system info)
tell application "System Events"
  tell its application process "ControlCenter"
    -- Prevent error from automatically killing the process
    activate
    -- Click the Control Center menu.
    click menu bar item "Control Center" of menu bar 1
    -- Give the window time to draw.
    delay 0.5
    -- Get all of the checkboxes in the Control Center menu.
    set ccCheckboxes to title of (every checkbox of window "Control Center")
    --No need the group 1 of group 1 as in macOS < 12
    --return ccCheckboxes
    if ccCheckboxes contains "Connect to Sidecar" then
      -- If one of the checkboxes is named "Connect to Sidecar," click that checkbox.
      set sidecarToggle to checkbox "Connect to Sidecar" of window "Control Center"
      --No need the group 1 of group 1 as in macOS < 12
      click sidecarToggle
      -- This opens a secondary window that contains the button to actually connect to Sidecar. Give the window time to draw.
      delay 0.5
      -- The iPad checkbox should be the last one in the secondary menu. Access to it by specifying the -1 index.
      set iPadCheckboxes to title of item -1 of (every checkbox of scroll area 1 of window "Control Center")
      --In macOS 12, the checkboxes here belong to 'scroll area 1'.
      if iPadCheckboxes contains deviceName then
        -- If one of the checkboxes contains the same name/part of the name as the iPad (`deviceName`), click that checkbox to connect to Sidecar.
        set deviceToggle to checkbox iPadCheckboxes of scroll area 1 of window "Control Center"
        --In macOS 12, the checkboxes here belong to 'scroll area 1'.
        click deviceToggle
        -- Click the Control Center menu to close the secondary menu and return to the main menu.
        click menu bar item "Control Center" of menu bar 1
        -- Click the Control Center menu again to close the main menu.
        click menu bar item "Control Center" of menu bar 1
        do shell script "echo Connected to " & iPadCheckboxes
      end if
    else
      repeat with cb in ccCheckboxes
        if cb contains "Disconnect" then
          delay 0.5
          -- If one of the checkboxes has "Disconnect" in its name, Sidecar is already connected.
          set sidecarToggle to ((checkbox 1 of window "Control Center") whose title contains "Disconnect")
          -- Click the checkbox to disconnect Sidecar.
          click sidecarToggle
          -- Click the Control Center menu again to close the main menu.
          click menu bar item "Control Center" of menu bar 1
        end if
      end repeat
      do shell script "echo Disconnected!"
    end if
  end tell
end tell
