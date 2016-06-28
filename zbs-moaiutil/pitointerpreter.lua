-- Copyright 2011-13 Paul Kulchenko, ZeroBrane LLC
function pitoInterpreter(zbsmoai)
  local pito
  local win = ide.osname == "Windows"

  local function runDesktop(self, wfilename, rundebug)
      local file = wfilename:GetFullPath()
     local srcroot = wfilename:GetPath(wx.wxPATH_GET_VOLUME + wx.wxPATH_GET_SEPARATOR)
      local apk = false
      
      if rundebug then
        -- start running the application right away
        DebuggerAttachDefault({startwith = file, basedir = GetPathWithSep(file),
          runstart = ide.config.debugger.runonstart ~= false})
      --require("moaidebug") -- enable userdata debugging for moai
        
      
      local launchfolder = GetPathWithSep(file):gsub("\\","/")
      local code = (
        [[xpcall(function() 
            io.stdout:setvbuf('no')
            require("mobdebug").moai() -- enable debugging for coroutines
            MOAIFileSystem.setWorkingDirectory('%s')
            %s
          end, function(err) print(debug.traceback(err)) end)]]):format(launchfolder, rundebug)
      
      
        local tmpfile = wx.wxFileName()
        tmpfile:AssignTempFileName(".")
        file = tmpfile:GetFullPath()
        local f = io.open(file, "w")
          if not f then
            DisplayOutputLn("Can't open temporary file '"..file.."' for writing.")
            return 
          end
        f:write(code)
        f:close()

        -- add mobdebug as the first path to LUA_PATH to provide a workaround
        -- for a MOAI issue: https://github.com/pkulchenko/ZeroBraneStudio/issues/96
        local mdb = MergeFullPath(GetPathWithSep(ide.editorFilename), "lualibs/mobdebug/?.lua")
        local _, path = wx.wxGetEnv("LUA_PATH")
        if path and path:find(mdb, 1, true) ~= 1 then
          wx.wxSetEnv("LUA_PATH", mdb..";"..path)
        end
        
        --add moaidebug helper to path too.
         mdb = MergeFullPath(GetPathWithSep(ide.editorFilename), "packages/zbs-moaiutil/?.lua")
         _, path = wx.wxGetEnv("LUA_PATH")
        if path and path:find(mdb, 1, true) ~= 1 then
          wx.wxSetEnv("LUA_PATH", mdb..";"..path)
        end
      
      end --run debug

      
      local cmd, workdir
      cmd = ('"%s" run -s "%s"'):format(pito, file)
      workdir = self:fworkdir(wfilename)
      
      DisplayOutputLn("Launching with :"..cmd)
      -- CommandLineRun(cmd,wdir,tooutput,nohide,stringcallback,uid,endcallback)
      return CommandLineRun(cmd,workdir ,true,false,nil,nil,
        function() if rundebug then wx.wxRemoveFile(file) end end)
  end
  


  local function runAndroid(self, wfilename, rundebug)
      local file = wfilename:GetFullPath()
    
      local apk = false
      local zbsdebugdir
      
      if rundebug then
        local srcroot = wfilename:GetPath(wx.wxPATH_GET_VOLUME + wx.wxPATH_GET_SEPARATOR)
        -- start running the application right away
        DebuggerAttachDefault({startwith = file, basedir = GetPathWithSep(file),
          runstart = ide.config.debugger.runonstart ~= false})
        --require("moaidebug") -- enable userdata debugging for moai
       
        --apk = MergeFullPath(GetPathWithSep(ide.editorFilename), "packages/zbs-moaiutil/debugapk/zbs-debug.apk") 
        --run debug instead
        
        file =  MergeFullPath(srcroot,"zbs-debug-main.lua")
        local code = (
        [[
          -- Generated for android debugging from zbs-moaiutil
          -- this is safe to delete and is periodically overwritten
          xpcall(function() 
            package.path = package.path..";./zbs-debug/?.lua"
            io.stdout:setvbuf('no')
            require("mobdebug").moai() -- enable debugging for coroutines
            %s
          end, function(err) print(debug.traceback(err)) end)]]):format(rundebug)
          local f = io.open(file, "w")
          if not f then
            DisplayOutputLn("Can't open temporary debug file '"..file.."' for writing.")
            return 
          end
          f:write(code)
          f:close()
        zbsdebugdir = MergeFullPath(srcroot,"zbs-debug")
        wx.wxFileName.Mkdir(zbsdebugdir)
        
        local mobdebug = MergeFullPath(GetPathWithSep(ide.editorFilename), "lualibs/mobdebug/mobdebug.lua")
        wx.wxCopyFile(mobdebug,MergeFullPath(zbsdebugdir,'mobdebug.lua'))
      end --run debug

      local device = zbsmoai:getAndroidDevice()
      if not device then
        DisplayOutputLn("Couldn't find an android device to run on. Run halted")
        return
      end
         
      local apkSwitch = apk and '-p "'..apk..'"' or ''
        
      local cmd = ('"%s" run -a -d %s -s "%s"'):format(pito, device, file)
      local workdir = self:fworkdir(wfilename)
      DisplayOutputLn("Launching on android with :"..cmd)
      
      local androidCleanup = function()
         if not rundebug then return end
         DisplayOutputLn("Cleaning temp files")
         wx.wxRemoveFile( MergeFullPath(zbsdebugdir,'mobdebug.lua'))
         wx.wxFileName.Rmdir(zbsdebugdir)
         wx.wxRemoveFile(file)
      end
      
      -- CommandLineRun(cmd,wdir,tooutput,nohide,stringcallback,uid,endcallback)
      return CommandLineRun(cmd,workdir ,true,false,nil,nil, androidCleanup)
  end
  

  return {
    name = "Pito",
    description = "Moai Pito Project Interpreter",
    api = {"baselib", "moai"},
    frun = function(self,wfilename,rundebug)
      
      
      pito = zbsmoai:hasPito() and GetPathWithSep(zbsmoai.config.pitoHome..'/bin/')..'pito' -- check if the path is configured
      if not pito then
          DisplayOutputLn("PitoHome not configured, please configure this plugin")
          return
      end
      pito = win and pito..".bat" or pito
        
      if zbsmoai:runOnAndroid() then 
        runAndroid(self, wfilename, rundebug)
      elseif zbsmoai:runOnDesktop() then 
        runDesktop(self, wfilename, rundebug) 
      end
      
    end,
    hasdebugger = true,
    fattachdebug = function(self) DebuggerAttachDefault() end,
    scratchextloop = true,
  }
end

return pitoInterpreter