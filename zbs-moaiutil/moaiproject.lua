local Project = {}
local Project_mt  = { __index = Project }


function Project:sdkPath(name)
  local f = wx.wxFileName.DirName(name:gsub("/",GetPathSeparator()))
  f:MakeAbsolute(self.moaiConfig.moaiSdk..GetPathSeparator())
  return f:GetFullPath()
end


function Project:pitoPath(name)
  local f = wx.wxFileName.DirName(name:gsub("/",GetPathSeparator()))
  f:MakeAbsolute(self.moaiConfig.pitoHome..GetPathSeparator())
  return f:GetFullPath()
end


function Project:makeProjectRelative(name)
  local dir = wx.wxFileName.DirName(name)
  dir:MakeAbsolute(self.projectDir)
  dir:MakeRelativeTo(self.projectDir)
  return dir:GetFullPath(wx.wxPATH_UNIX)
end

function Project:makeProjectAbsolute(name)
  local f = wx.wxFileName.DirName(name:gsub("/",GetPathSeparator()))
  f:MakeAbsolute(self.projectDir..GetPathSeparator())
  f:Normalize()
  return f:GetFullPath()
end



function Project:hasConfig()
  --DisplayOutputLn("Pito projself:makeProjectAbsolute(".").."hostconfig.lua")
  return wx.wxFileName.FileExists(self:makeProjectAbsolute(".").."hostconfig.lua")
end

function Project:runHostCommand(cmd)
  local fullcmd = self:pitoPath("bin").."pito host "..cmd.." 2>&1"
  local oldcwd = wx.wxFileName.GetCwd()
  wx.wxFileName.SetCwd(self.projectDir)
  local f = io.popen(fullcmd, 'r')
  while true do
    local s = f:read('*line')
    if s == nil then break end
    DisplayOutputLn(s)
  end
  wx.wxFileName.SetCwd(oldcwd)
end



function Project:editConfig()
  LoadFile(self:makeProjectAbsolute(".").."hostconfig.lua")
end


function Project:initialize()
   self:runHostCommand("init")
end




local function create(projDir, moaiConfig)
  local proj = {
    projectDir = projDir,
    moaiConfig = moaiConfig
  }
  setmetatable(proj, Project_mt)
  return proj
end

return create