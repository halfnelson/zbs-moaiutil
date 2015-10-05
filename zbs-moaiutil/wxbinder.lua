local Binder = {}
local Binder_mt = { __index = Binder }

  local function notEmpty(item)
      return item and item ~= "" 
    end
    


function Binder.setChoice(var, widget)
  if notEmpty(var) then
    widget:SetStringSelection(var)
  end
end

function Binder.setSpinner(var, widget)
  if var then
    widget:SetValue(var)
  end 
end

function Binder.setSpinnerPercent(var, widget)
  if var then
    widget:SetValue(var*100)
  end 
end

function Binder.setFilePicker(var, widget)
  if notEmpty(var) then
    widget:SetPath(var)
  end
end

function Binder.setDirPicker(var, widget)
  if notEmpty(var) then
    widget:SetPath(var)
  end
end

function Binder.setCheckbox(var, widget)
  widget:SetValue(var and true or false)
end

function Binder.setText(var, widget)
  if notEmpty(var) then
    widget:SetValue(var)
  end
end

function Binder.getText(widget)
  return widget:GetValue()
end


function Binder.getChoice(widget)
  return widget:GetStringSelection()
end

function Binder.getSpinner(widget)
  return widget:GetValue()
end

function Binder.getSpinnerPercent(widget)
  return widget:GetValue()/100
end

function Binder.getCheckbox(widget)
  return widget:GetValue()
end

function Binder.getFilePicker(widget)
  return widget:GetPath()
end

function Binder.getDirPicker(widget)
  return widget:GetPath()
end



function Binder:addBinding(name, widget, setter, getter)
  table.insert(self.Bindings, { name = name, widget = widget, setter = setter, getter = getter })
end

function Binder:bindCheckbox(name, widget)
  self:addBinding(name, widget, self.setCheckbox, self.getCheckbox)
end

function Binder:bindChoice(name, widget)
  self:addBinding(name, widget, self.setChoice, self.getChoice)
end

function Binder:bindSpinner(name, widget)
  self:addBinding(name, widget, self.setSpinner, self.getSpinner)
end

function Binder:bindSpinnerPercent(name, widget)
  self:addBinding(name, widget, self.setSpinnerPercent, self.getSpinnerPercent)
end

function Binder:bindFilePicker(name, widget)
  self:addBinding(name, widget, self.setFilePicker, self.getFilePicker)
end

function Binder:bindDirPicker(name, widget)
  self:addBinding(name, widget, self.setDirPicker, self.getDirPicker)
end

function Binder:bindText(name, widget)
  self:addBinding(name, widget, self.setText, self.getText)
end


function Binder:bindUIFrom(settings)
    for _,v in pairs(self.Bindings) do
      v.setter(settings[v.name],v.widget)
    end
end
  
function Binder:bindUITo(settings)
    for _,v in pairs(self.Bindings) do
      settings[v.name] = v.getter(v.widget)
    end
end

function Binder:setValues(settings)
  self:bindUIFrom(settings)
end

function Binder:getValues()
  local vals = {}
  self:bindUITo(vals)
  return vals
end

return {
  create = function() 
      local n = { 
         Bindings = {}
      }
      setmetatable(n, Binder_mt)
      return n
  end
}