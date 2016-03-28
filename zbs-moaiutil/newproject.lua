local Dialog = {}
local Dialog_mt = { __index = Dialog }

function Dialog:setupBindings()
  local b = require('wxbinder').create()
  self.bindings = b
  local ui = self.UI
  b:bindDirPicker("projectPath", ui.m_dirProjectPath)
  b:bindText("projectName", ui.m_projectName)
end


function Dialog:getValues()
  local result = self.UI.moaiProjectCreate:ShowModal()
  local conf = false
  if result == wx.wxID_OK then
    conf = self.bindings:getValues()
  end
  
  self.UI.moaiProjectCreate:Destroy()
  self.UI = nil 
  return conf
end


local function create() 
  local dlg = {
      UI = require("newproject-ui")()
  }
  setmetatable(dlg,Dialog_mt)
  dlg:setupBindings()
  return dlg
end

return create