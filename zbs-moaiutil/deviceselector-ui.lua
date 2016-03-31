UI = {}

local function GetUI()

local UI = {}

  -- create DeviceSelector
  UI.DeviceSelector = wx.wxDialog (wx.NULL, wx.wxID_ANY, "", wx.wxDefaultPosition, wx.wxSize( 337,286 ), wx.wxDEFAULT_DIALOG_STYLE )
	UI.DeviceSelector:SetSizeHints( wx.wxDefaultSize, wx.wxDefaultSize )
	
	UI.bSizer1 = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.bSizer2 = wx.wxBoxSizer( wx.wxHORIZONTAL )
	
	UI.m_staticText1 = wx.wxStaticText( UI.DeviceSelector, wx.wxID_ANY, "Select a device", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.m_staticText1:Wrap( -1 )
	UI.bSizer2:Add( UI.m_staticText1, 1, wx.wxALL, 5 )
	
	UI.m_Refresh = wx.wxButton( UI.DeviceSelector, wx.wxID_ANY, "Refresh", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.bSizer2:Add( UI.m_Refresh, 0, wx.wxALL, 5 )
	
	
	UI.bSizer1:Add( UI.bSizer2, 0, wx.wxEXPAND, 5 )
	
	UI.m_deviceListChoices = { }
	UI.m_deviceList = wx.wxListBox( UI.DeviceSelector, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize, UI.m_deviceListChoices, wx.wxLB_SINGLE )
	UI.bSizer1:Add( UI.m_deviceList, 1, wx.wxALL + wx.wxEXPAND, 5 )
	
	UI.m_sdbSizer1 = wx.wxStdDialogButtonSizer()
	UI.m_sdbSizer1OK = wx.wxButton( UI.DeviceSelector, wx.wxID_OK, "" )
	UI.m_sdbSizer1:AddButton( UI.m_sdbSizer1OK )
	UI.m_sdbSizer1Cancel = wx.wxButton( UI.DeviceSelector, wx.wxID_CANCEL, "" )
	UI.m_sdbSizer1:AddButton( UI.m_sdbSizer1Cancel )
	UI.m_sdbSizer1:Realize();
	
	UI.bSizer1:Add( UI.m_sdbSizer1, 0, wx.wxEXPAND, 5 )
	
	
	UI.DeviceSelector:SetSizer( UI.bSizer1 )
	UI.DeviceSelector:Layout()
	
	UI.DeviceSelector:Centre( wx.wxBOTH )
  
    return UI
end
return GetUI