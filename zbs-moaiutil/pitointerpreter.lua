-- Copyright 2011-13 Paul Kulchenko, ZeroBrane LLC
function pitoInterpreter(zbsmoai)
  local moai
  local win = ide.osname == "Windows"

  return {
    name = "Pito",
    description = "Moai Pito Project Interpreter",
    api = {"baselib", "moai"},
    frun = function(self,wfilename,rundebug)
      
      
      moai = zbsmoai:hasPito() and GetPathWithSep(zbsmoai.config.pitoHome..'/bin/')..'moai' -- check if the path is configured
      if not moai then
          DisplayOutputLn("PitoHome not configured, please configure this plugin")
          return
      end

      if true then
        DisplayOutputLn("We were going to run "..wfilename:GetFullPath().." with rundebug as "..rundebug)
      --  return
      end
      
      local file
    

      if rundebug then
        -- start running the application right away
        DebuggerAttachDefault({startwith = file,
          runstart = ide.config.debugger.runonstart ~= false})
        local code = (
  [[xpcall(function() 
      io.stdout:setvbuf('no')
      require("mobdebug").moai() -- enable debugging for coroutines
      require("moaidebug") -- enable userdata debugging for moai
      %s
    end, function(err) print(debug.traceback(err)) end)]]):format(rundebug)
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
        
        
      end

      file = file or wfilename:GetFullPath()
      local cmd = ('"%s" "%s"'):format(moai, file)
      local workdir = GetPathWithSep(self:fworkdir(wfilename)..GetPathSeparator().."src/")
      DisplayOutputLn("We were going to run "..cmd.." in folder "..workdir)
      -- CommandLineRun(cmd,wdir,tooutput,nohide,stringcallback,uid,endcallback)
      return CommandLineRun(cmd,workdir ,true,false,nil,nil,
        function() if rundebug then wx.wxRemoveFile(file) end end)
    end,
    hasdebugger = true,
    fattachdebug = function(self) DebuggerAttachDefault() end,
    scratchextloop = true,
  }
end

return pitoInterpreter