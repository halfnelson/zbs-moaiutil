local Android = {}
local Android_mt = { __index = Android }


local currentDevice = false
local hasruncommand = false

function Android:adbBin()
  local adbExecutable = "adb"
  if ide.osname == "Windows" then
    adbExecutable = "adb.exe"
  end
  
  return self.sdkPath..GetPathSeparator().."platform-tools"..GetPathSeparator()..adbExecutable
end

function Android:listDevices()
  local deviceHeaderSeen = false
  
  local devices = {}
  
  local addDevice = function(line) 
    if not deviceHeaderSeen then 
      if line:match("List of devices attached") then
        deviceHeaderSeen = true
      end
      return
    end
    --debug output
    if line:match("%s%*") or string.lower(line):match("%s*adb%s") then
      return
    end
    
    local serial, description = line:match("(.-)%s(.+)")
    if serial then
      table.insert( devices,{ ['serial'] = serial, ['description'] = description })
    end
    
  end
  
  self:adbCommand("devices",addDevice)
  return devices
end

--Ensures the current selected device is still plugged in
--or shows the device picker dialog
function Android:getCurrentDevice()
  local devices = self:listDevices()
  
  if currentDevice then
    local hasCurrent = false
    for _,v in ipairs(devices) do 
      hasCurrent = (v.serial == currentDevice.serial)
    end
    if not hasCurrent then
      currentDevice = false
    end
  end
    
  --show dialog and let user pick (if more than one device found)
  
  if not currentDevice then
    DisplayOutputLn("Could not find currentDevice.. please select")
    local dlg = require("deviceselector")(self)
    local result = dlg:getDevice(devices)
    if result then
      DisplayOutputLn("got dialog result: ",result.serial)
    end
    currentDevice = result
  end
  
  return currentDevice

end


function Android:adbDeviceCommand(args, onOutput)
  
  if currentDevice then
    self:adbCommand("-s "..currentDevice.serial.." ")
  end
  
end



function Android:adbCommand(args, onOutput)
  if not self:hasadb() then
    DisplayOutputLn("Error: adb not found. Please configure zbsplugin")
    return 
  end
  
  
  local cmd = string.format("%s %s",self:adbBin(), args)
  DisplayOutputLn("Running: "..cmd)
  local f = io.popen(cmd, 'r')
  
  if not onOutput then
    onOutput = DisplayOutputLn
  end
  
  while true do
    local s = f:read('*line')
    if s == nil then break end
    onOutput(s)
  end
  
  f:close()
  hasruncommand = true
end

function Android:closeadb()
  if hasruncommand then
    --we probably own the adb server, that means we cant restart zbs since it never really goes all the way away. 
    -- shoot adb in the head so that we can also die
    os.execute(string.format("%s %s",self:adbBin(), "kill-server"))
  end
  
end

function Android:hasadb()
  return wx.wxFile.Exists(self:adbBin())
end

function create(sdk_path) 
  local obj = {
      sdkPath = sdk_path
  }
  setmetatable(obj,Android_mt)
  return obj
end

return create