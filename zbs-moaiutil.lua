
package.path =  package.path .. ';packages/zbs-moaiutil/lib/?.lua'
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
  return os.getenv("MOAI_SDK") or false
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

local function defaultConfig()
  return {
     androidNdkPath = findAndroidNdk(),
     androidSdkPath = findAndroidSdk(),
     moaiSdk = false,
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
  end
  self.config = overrideConfig(defaultConfig(), config or {}) 
end


function Plugin:saveGlobalConfig()
  local f = wx.wxFileName.DirName("cfg")
  f:SetFullName("zbs-moaiutil-config.lua")
  fileWrite(f:GetFullPath(), tableToConfigLua(self.config, "config"))
end

local ID_MOAIUTILGLOBALCONFIG = ID("ID_MOAIUTILGLOBALCONFIG")
local ID_MOAIUTILNEWPROJECT = ID("ID_MOAIUTILNEWPROJECT")
local ID_MOAIUTIL_PROJECT_CONFIG = ID("ID_MOAIUTIL_PROJECT_CONFIG")


function Plugin:hasConfig()
  local f = wx.wxFileName.DirName(self.projectDir)
  f:SetFullName("hostconfig.lua")
  return f:FileExists()
end

function Plugin:refreshMenu()
  local menucaption = self:hasConfig() and "Initialize Project..." or "Configure Project..."
  self.mainMenu:SetLabel(ID_MOAIUTIL_PROJECT_CONFIG,menucaption)
end


function Plugin:onProjectLoad(projdir) 
  self.projectDir = projdir
  self:refreshMenu()
end

function Plugin:addMainMenu()
  local menubar = ide:GetMenuBar()
  local menuOpts = {
    { ID_MOAIUTIL_PROJECT_CONFIG, TR("Initialize Project..."), TR("Configure This Project") },
    { },
    { ID_MOAIUTILGLOBALCONFIG, TR("Configure Defaults..."), TR("Configure Defaults") },
    { ID_MOAIUTILNEWPROJECT, TR("New Project..."), TR("Create a New Moai Project") },
  }
  
  self.mainMenu = wx.wxMenu(menuOpts)
  menubar:Append(self.mainMenu, "Moai")
end




function Plugin:onRegister() 
  self:loadGlobalConfig()
  self:addMainMenu()
end



local plugin = {
  name = "ZBS Moai Util",
  description = "Moai Hostutil GUI for ZBS",
  author = "David Pershouse",
  version = 0.1,
  dependencies = 1.10,
  onRegister = function() Plugin:onRegister() end
  
}

return plugin



