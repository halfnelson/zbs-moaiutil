--package paths
local homepath = (ide.osname == 'Windows') and os.getenv("USERPROFILE") or os.getenv("HOME")
local homepackages = homepath..GetPathSeparator()..'.zbstudio'..GetPathSeparator()..'packages'..GetPathSeparator()..'zbs-moaiutil'..GetPathSeparator()..'?.lua'



package.path =  package.path .. ';packages/zbs-moaiutil/?.lua;'..homepackages
--local ProjectManager = require("packages.zbs-moaiutil.lib.texturepackerproject")

local Plugin = {}

local function hasVisualStudio() 
  return os.getenv("VS120COMNTOOLS") and true or false
end

local function hasXcode()
  local a,b,exitcode = os.execute("which xcrun")
  return exitcode == 0
end

local function hasJava()
  local a,b,exitcode = os.execute("java -version")
  return exitcode == 0 or os.getenv("JAVA_HOME") or false
end

function findAndroidNdk()
  return os.getenv("ANDROID_NDK") or false
end

function findMoaiSdk()
  return os.getenv("MOAI_SDK_HOME") or false
end

function os_exitcode(cmd)
  local a,b,exitcode = os.execute(cmd)
  return exitcode
end


function os_capture(cmd)
  local f = io.popen(cmd, 'r')
  if not f then return "" end
  local s = f:read('*a')
  f:close()
  return s
end

function findPito()
  local cmd
  if (ide.osname == 'Windows') then
    cmd = "where pito"
  else
    cmd = "which pito"
  end
  local res = os_exitcode(cmd)
  if (res == 0) then
    local osres = os_capture(cmd)
    local path = osres:match("(%S+)"..GetPathSeparator().."bin"..GetPathSeparator().."pito")
    return path or false
  else
    return false
  end
end



function findAndroidSdk()
  local fromenv = os.getenv("ANDROID_SDK_ROOT") or os.getenv("ANDROID_HOME") or os.getenv("ANDROID_SDK_HOME")
  if fromenv then return fromenv end
  
  
  if ide.osname == 'Windows' then
    local appdata = os.getenv("LOCALAPPDATA")
    if (appdata and wx.wxDir.Exists(appdata.."\\android\\sdk")) then
      return appdata.."\\android\\sdk"   
    end
  elseif ide.osname == 'Macintosh' then
    local home = os.getenv("HOME")
    if (home and wx.wxDir.Exists(home.."/Library/Android/sdk")) then
      return home.."/Library/Android/sdk"
    end
  else
    local home = os.getenv("HOME")
    local sdkpath = home.."/android-sdk-linux"
    if (home and wx.wxDir.Exists(sdkpath)) then
      return sdkpath
    end
  end
  
  return false
end



local md = require("mobdebug.mobdebug")
local function tableToLua(t)
  return md.line(t , {indent='  ', comment=false} )
end

local function tableToConfigLua(t, varname)
  return md.line(t , {indent='  ', comment=false, name =varname} )
end

local function tableToTopLevelLua(t)
  local tbl = tableToLua(t)
  tbl = tbl:gsub("{(.*)}","%1")
  tbl = tbl:gsub("(\n  [%a}][^\n]*),","%1")
  return tbl
end

local function fileWrite(fname,content)
  local file = wx.wxFile(fname, wx.wxFile.write)
  file:Write(content, #content)
  file:Close()
end

local function defaultConfig(config)
  return {
     androidNdkPath = config.androidNdkPath or findAndroidNdk(),
     androidSdkPath = config.androidSdkPath or findAndroidSdk(),
     moaiSdk = config.moaiSdk or findMoaiSdk(),
     pitoHome = config.pitoHome or findPito(),
  }
end



local function overrideConfig(base, ext)
  local newSettings = {}
  for k,v in pairs(base) do
    newSettings[k]=v
  end
  
  for k,v in pairs(ext) do
    newSettings[k]=v
  end
  return newSettings
end

function Plugin:loadGlobalConfig()
  local f = wx.wxFileName.DirName("cfg")
  f:SetFullName("zbs-moaiutil-config.lua")
  local config
  if f:FileExists() then
      local cfgfn = loadfile(f:GetFullPath())
      if cfgfn then
        config = cfgfn()
      end
      self.config = defaultConfig(config or {})
  else
      self.config = defaultConfig({})
      self:saveGlobalConfig() --save us from running this again and again
  end

end

function Plugin:saveGlobalConfig()
  local f = wx.wxFileName.DirName("cfg")
  f:SetFullName("zbs-moaiutil-config.lua")
  fileWrite(f:GetFullPath(), tableToConfigLua(self.config, "config"))
end

local ID_MOAIUTILGLOBALCONFIG = ID("ID_MOAIUTILGLOBALCONFIG")
local ID_MOAIUTILNEWPROJECT = ID("ID_MOAIUTILNEWPROJECT")
local ID_MOAIUTIL_PROJECT_CONFIG = ID("ID_MOAIUTIL_PROJECT_CONFIG")
local ID_MOAIUTIL_RUN_ANDROID = ID("ID_MOAIUTIL_RUN_ANDROID")
local ID_MOAIUTIL_RUN_DESKTOP = ID("ID_MOAIUTIL_RUN_DESKTOP")


function Plugin:hasMoaiSdk()
  return self.config.moaiSdk and self.config.moaiSdk ~= "" and wx.wxDir.Exists(self.config.moaiSdk)
end

function Plugin:hasPito()
  return self.config.pitoHome and self.config.pitoHome ~= "" and wx.wxDir.Exists(self.config.pitoHome)
end


function Plugin:refreshMenu()
  local menucaption = self.project:hasConfig() and "Configure Project..." or "Initialize Project..."
  self.mainMenu:SetLabel(ID_MOAIUTIL_PROJECT_CONFIG,menucaption)
  
  self.mainMenu:Enable(ID_MOAIUTILNEWPROJECT, self:hasPito())
  self.mainMenu:Enable(ID_MOAIUTIL_PROJECT_CONFIG, self:hasPito())
end


function Plugin:onProjectLoad(projdir) 
  self.project = require("moaiproject")(projdir,self.config)
  self:refreshMenu()
  
  ProjectSetInterpreter("pito")
end

function Plugin:editGlobalConfig()
   local dlg = require("sdkconfig")(self.config)
   local newconfig = dlg:getConfig()
   if newconfig then
     for k,v in pairs(newconfig) do
       self.config[k] = v
     end
     self:saveGlobalConfig()
     self:refreshMenu()
   end
end    

function Plugin:editProjectConfig()
  if not self.project:hasConfig() then
    self.project:initialize()
  end
  
  self.project:editConfig()
end

function Plugin:newProject()
   local dlg = require("newproject")()
   local newconfig = dlg:getValues()
   if newconfig then
      local fullcmd = self.config.pitoHome ..GetPathSeparator().."bin"..GetPathSeparator().."pito new-project "..newconfig.projectName.." 2>&1"
      local oldcwd = wx.wxFileName.GetCwd()
      wx.wxFileName.SetCwd(newconfig.projectPath)
      local f = io.popen(fullcmd, 'r')
      while true do
        local s = f:read('*line')
        if s == nil then break end
        DisplayOutputLn(s)
      end
      wx.wxFileName.SetCwd(oldcwd)
      local projectDir = newconfig.projectPath..GetPathSeparator()..newconfig.projectName
      if wx.wxDir.Exists(projectDir) then
        --success
        ProjectUpdateProjectDir(projectDir)
      end
      
   end
end



function Plugin:addMainMenu()
  local menubar = ide:GetMenuBar()
  local menuOpts = {
    { ID_MOAIUTIL_PROJECT_CONFIG, TR("Initialize Project..."), TR("Configure Project") },
    { ID_MOAIUTIL_RUN_DESKTOP, TR("Run on Desktop"), TR("Run on this computer"),wx.wxITEM_RADIO },
    { ID_MOAIUTIL_RUN_ANDROID, TR("Run on Android"), TR("Run on android device"),wx.wxITEM_RADIO },
    { },
    { ID_MOAIUTILGLOBALCONFIG, TR("Configure Plugin..."), TR("Configure Pito Plugin") },
    { ID_MOAIUTILNEWPROJECT, TR("New Project..."), TR("Create a New Pito Project") },
  }
  
  self.mainMenu = wx.wxMenu(menuOpts)
  self.mainMenu:Check(ID_MOAIUTIL_RUN_DESKTOP, true)
  menubar:Append(self.mainMenu, "Pito")
  
  self.mainMenu:Connect(ID_MOAIUTILGLOBALCONFIG, wx.wxEVT_COMMAND_MENU_SELECTED, function () 
    self:editGlobalConfig()  
  end)

  self.mainMenu:Connect(ID_MOAIUTIL_PROJECT_CONFIG, wx.wxEVT_COMMAND_MENU_SELECTED, function()
    self:editProjectConfig()
  end)
    
  self.mainMenu:Connect(ID_MOAIUTILNEWPROJECT, wx.wxEVT_COMMAND_MENU_SELECTED, function()
    self:newProject()
  end)

   --self.mainMenu:Connect(ID_MOAIUTIL_RUN_ANDROID, wx.wxEVT_COMMAND_MENU_SELECTED, function()
  --  self:runOnAndroid()
 -- end)
    
end

function Plugin:runOnAndroid()
   return self.mainMenu:IsChecked(ID_MOAIUTIL_RUN_ANDROID)
end

function Plugin:runOnDesktop()
   return self.mainMenu:IsChecked(ID_MOAIUTIL_RUN_DESKTOP)
end

function Plugin:getAndroidDevice()
  local device = self.android:getCurrentDevice()
  return device and device.serial or false
end





function Plugin:onRegister() 
  self:loadGlobalConfig()
  self:addMainMenu()
  self.android = require('android')(self.config.androidSdkPath)
  --interpreter
  local interpreter = require('pitointerpreter')(self)
  ide:AddInterpreter("pito", interpreter)
end


local plugin = {
  name = "ZBS Moai Util",
  description = "Moai Hostutil GUI for ZBS",
  author = "David Pershouse",
  version = 0.1,
  dependencies = 1.10,
  onRegister = function() Plugin:onRegister() end,
  onAppClose = function() Plugin.android:closeadb() end,
  onProjectLoad = function(self, projectDir) Plugin:onProjectLoad(projectDir) end,
  instance = Plugin
}

return plugin



