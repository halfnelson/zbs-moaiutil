local Dialog = {}
local Dialog_mt = { __index = Dialog }

function Dialog:setupBindings()
  local b = require('wxbinder').create()
  self.bindings = b
  local ui = self.UI
  
  b:bindDirPicker("moaiSdk", ui.m_moaiSdkDir)
  b:bindDirPicker("androidNdkPath", ui.m_androidNdkDir)
  b:bindDirPicker("androidSdkPath", ui.m_androidSdkDir)
  b:bindDirPicker("pitoHome", ui.m_pitoHome)
end

function Dialog:init(config)
  self.bindings:setValues(config)
end



function Dialog:getConfig()
  local result = self.UI.MoaiUtilConfig:ShowModal()
  local conf = false
  if result == wx.wxID_OK then
    conf = self.bindings:getValues()
  end
  
  self.UI.MoaiUtilConfig:Destroy()
  self.UI = nil
  return conf
end


local function create(config) 
  local dlg = {
      UI = require("sdkconfig-ui")()
  }
  setmetatable(dlg,Dialog_mt)
  dlg:setupBindings()
  dlg:init(config)
  
  return dlg
end

return create