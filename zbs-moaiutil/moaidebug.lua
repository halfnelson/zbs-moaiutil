print("moaidebug installed")

local function serialize(val)
      local ref = getmetatable(val)
      local output = { 
        type = "UserData",
        classname = val.getClassName and val:getClassName() or "MOAILuaObject",
        members = ref.__index,
        interface = getmetatable(ref.__index),
        _properties = {}
      }
      local properties = output._properties
      for _,v in ipairs(ref.__properties or {}) do
       -- print("getting "..v)
        local propval = val["get"..v] and {val["get"..v](val)} or {}
        properties[v] = #propval == 1 and propval[1] or propval
      end
      
      return output
end


local function asSet(tab)
  local set = {}
  for _,v in pairs(tab) do
    set[v] = true
  end
  return set
end

local prop_blacklist = asSet({
     "Attr", "Listener", "AttrLink", "RefTable", "MemberTable", "Class", "Tile", "TileFlags","TileLoc","CellAddr"
})

local function propsfor(class)
    local obj = class.new()
    local interface = getmetatable(getmetatable(obj).__index)
    local props = {}
    for k,_ in pairs(interface) do
      local propname = string.match(k, "get(%w+)")
      if propname and not prop_blacklist[propname] then
          table.insert(props, propname) 
      end
    end
    return props
end

local function propertiesBagFor(obj)
  local props = {}
  
  local mt = {}
  mt.__index = function(table, key)
    if obj["get"..key] then
      local res = { obj["get"..key](obj) }
      
      if #res == 0 then return nil end
      
      if #res == 1 then 
        return res[1]
      end
      
      local valmeta = {}
      valmeta.__newindex = function(itable, ikey, ivalue)
        
        --get old value
        local oldval = { obj["get"..key](obj) }
        --update it
        oldval[ikey] = ivalue
        --put it back
        if obj["set"..key] then obj["set"..key](obj, unpack(oldval)) end
      end
      
      local mockres = {}
      setmetatable(mockres,valmeta)
      return mockres -- if anyone tries to set an index on this, it will try and call the property function with the nth param swapped out for the value
    end
  end
  
  mt.__newindex = function(table, key, value)
    if obj["set"..key] then 
     
      obj["set"..key](obj, value) 
    end
  end
  
  setmetatable(props, mt)
  return props --return our proxy table that calls setters on new index and getters on index

end



local function makeDebuggableWithProps(class, props) 
  local oldnew = class.new
  local propset = asSet(props)
  class.new = function ()
    local obj = oldnew()
    getmetatable(obj).__properties = props
    getmetatable(obj).__serialize = serialize
    obj._properties = propertiesBagFor(obj)
    return obj
  end
end

local function makeDebuggable(...)
  local classes = {...}
  
  for k,class in pairs(classes) do
    local props = propsfor(class)
    makeDebuggableWithProps(class, props)
  end
end


local function mergetables(...)
  local tables = {...}
  local output = {}
  
  for _,atable in pairs(tables) do
     for k,v in pairs(atable) do
        table.insert(output,v)
     end
  end
  return output
end

makeDebuggable(MOAIAction,
               MOAICoroutine,
               MOAIProp,
               MOAIProp2D,
               MOAITileDeck2D)
          
          
     
MOAIGridIntf = MOAIGrid.getInterfaceTable()     
MOAIGridIntf.getTiles = function(self) 
  local tiles = {}
  local sx, sy = self:getSize()
  for y = 1, sy do
    tiles[y] = {}
    for x = 1, sx do
      tiles[y][x] = self:getTile(x,y)
    end
  end
  return tiles
end
    
makeDebuggableWithProps(MOAIGrid, mergetables(propsfor(MOAIGrid), { "Tiles" }))
               
               
--patch root action
local obj = MOAIActionMgr.getRoot()
getmetatable(obj).__properties = propsfor(MOAIAction)
getmetatable(obj).__serialize = serialize
obj._properties = propertiesBagFor(obj)





