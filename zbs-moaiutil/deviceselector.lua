local Dialog = {}
local Dialog_mt = { __index = Dialog }

function Dialog:setupBindings()
  local b = require('wxbinder').create()
  self.bindings = b
  local ui = self.UI
  b:bindChoice("selectedDevice", ui.m_deviceList)
end


function Dialog:getDevice(devices)
  if not devices then
    self:refreshDevices()
  else
    self:setDevices(devices)
  end
  
  
  local result = self.UI.DeviceSelector:ShowModal()
  local conf = false
  if result == wx.wxID_OK then
    local vals = self.bindings:getValues()
    if (vals.selectedDevice) then
       local serial, description =  vals.selectedDevice:match("(.-)   (.+)") 
       if (serial) then
          conf = { serial = serial, description = description }
       end
    end
  end
  
  self.UI.DeviceSelector:Destroy()
  self.UI = nil 
  self.android = nil
  return conf
end

function Dialog:setDevices(devices)
  local choices = {}
  for _,v in ipairs(devices) do
    table.insert(choices,v.serial.."   "..v.description)
  end
  self.UI.m_deviceList:Set(choices)
end


function Dialog:refreshDevices()
  local devices = self.android:listDevices()
  self:setDevices(devices)
end


function Dialog:onRefreshClick()
  self:refreshDevices()
end




local function create(android) 
  
  local dlg = {
      UI = require("deviceselector-ui")(),
      ['android'] = android
  }
  setmetatable(dlg,Dialog_mt)
  dlg:setupBindings()
  
  dlg.UI.m_Refresh:Connect( wx.wxEVT_COMMAND_BUTTON_CLICKED, function(event)
    --implements thing
	  dlg:onRefreshClick()
    event:Skip()
	end )
  return dlg
end

return create