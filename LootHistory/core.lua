local CreateFrame, PlaySound = CreateFrame, PlaySound

-- support slash commands
SlashCmdList["OPEN_LOOT_HISTORY"] = function(msg)
  ToggleLootHistoryFrame()
end

-- add checkbox into InterfaceOptionsPanel (Control tab)
do
  local f = CreateFrame('Frame')
  f:Hide()
  f:RegisterEvent("VARIABLES_LOADED")
  f:SetScript('OnEvent', function(self)
    if not LootHistoryDB then
      LootHistoryDB = {
        autoOpenLootHistory = "0"
      }
    end
  end)

  ControlsPanelOptions.autoOpenLootHistory = { text = "AUTO_OPEN_LOOT_HISTORY_TEXT" }

  local button = CreateFrame('CheckButton', "$parentAutoOpenLootHistory", InterfaceOptionsControlsPanel, "InterfaceOptionsCheckButtonTemplate")
  button:SetPoint("TOPLEFT", "$parentAutoLootCorpse", "BOTTOMLEFT", 0, -70)
  button.type = CONTROLTYPE_CHECKBOX
  button.defaultValue = "0"
  button.label = "autoOpenLootHistory"
  button.GetValue = function(self)
    return self.value or LootHistoryDB[self.label]
  end
  button.SetValue = function(self, value)
    self.value = value
    LootHistoryDB[self.label] = value
    self:SetChecked(value)
  end
  button:SetScript('OnClick', function(self)
    local value = self:GetChecked() and "1" or "0"
    if value == "1" then
      PlaySound("igMainMenuOptionCheckBoxOn")
    else
      PlaySound("igMainMenuOptionCheckBoxOff")
    end
    self:SetValue(value)
  end)
  BlizzardOptionsPanel_RegisterControl(button, button:GetParent())

  -- helpful function
  function GetInterfaceOptionsVarBool(control)
    if control == 'autoOpenLootHistory' then
      return InterfaceOptionsControlsPanelAutoOpenLootHistory:GetValue() and true or false
    end
  end
end
