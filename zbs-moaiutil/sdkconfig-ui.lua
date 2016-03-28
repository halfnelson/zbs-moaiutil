----------------------------------------------------------------------------
-- Lua code generated with wxFormBuilder (version Jun 17 2015)
-- http://www.wxformbuilder.org/
----------------------------------------------------------------------------

-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
local function GetUI()

local UI = {}

-- create MoaiUtilConfig
UI.MoaiUtilConfig = wx.wxDialog (wx.NULL, wx.wxID_ANY, "Moai Util - Default Config", wx.wxDefaultPosition, wx.wxSize( 600,206 ), wx.wxDEFAULT_DIALOG_STYLE )
	UI.MoaiUtilConfig:SetSizeHints( wx.wxDefaultSize, wx.wxDefaultSize )
	
	UI.bSizer1 = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.bPitoDir = wx.wxBoxSizer( wx.wxHORIZONTAL )
	
	UI.m_staticText12 = wx.wxStaticText( UI.MoaiUtilConfig, wx.wxID_ANY, "Pito Home", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.m_staticText12:Wrap( -1 )
	UI.m_staticText12:SetMinSize( wx.wxSize( 100,-1 ) )
	
	UI.bPitoDir:Add( UI.m_staticText12, 0, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	UI.m_pitoHome = wx.wxDirPickerCtrl( UI.MoaiUtilConfig, wx.wxID_ANY, "", "Select a folder", wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxDIRP_DEFAULT_STYLE )
	UI.bPitoDir:Add( UI.m_pitoHome, 1, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	
	UI.bSizer1:Add( UI.bPitoDir, 1, wx.wxEXPAND, 5 )
	
	UI.bSdkDir = wx.wxBoxSizer( wx.wxHORIZONTAL )
	
	UI.m_staticText1 = wx.wxStaticText( UI.MoaiUtilConfig, wx.wxID_ANY, "Moai SDK Home", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.m_staticText1:Wrap( -1 )
	UI.m_staticText1:SetMinSize( wx.wxSize( 100,-1 ) )
	
	UI.bSdkDir:Add( UI.m_staticText1, 0, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	UI.m_moaiSdkDir = wx.wxDirPickerCtrl( UI.MoaiUtilConfig, wx.wxID_ANY, "", "Select a folder", wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxDIRP_DEFAULT_STYLE )
	UI.bSdkDir:Add( UI.m_moaiSdkDir, 1, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	
	UI.bSizer1:Add( UI.bSdkDir, 1, wx.wxEXPAND, 5 )
	
	UI.bAndroidSdkDir = wx.wxBoxSizer( wx.wxHORIZONTAL )
	
	UI.m_staticText111 = wx.wxStaticText( UI.MoaiUtilConfig, wx.wxID_ANY, "Android SDK", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.m_staticText111:Wrap( -1 )
	UI.m_staticText111:SetMinSize( wx.wxSize( 100,-1 ) )
	
	UI.bAndroidSdkDir:Add( UI.m_staticText111, 0, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	UI.m_androidSdkDir = wx.wxDirPickerCtrl( UI.MoaiUtilConfig, wx.wxID_ANY, "", "Select a folder", wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxDIRP_DEFAULT_STYLE )
	UI.bAndroidSdkDir:Add( UI.m_androidSdkDir, 1, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	
	UI.bSizer1:Add( UI.bAndroidSdkDir, 1, wx.wxEXPAND, 5 )
	
	UI.bAndroidNdkDir = wx.wxBoxSizer( wx.wxHORIZONTAL )
	
	UI.m_staticText11 = wx.wxStaticText( UI.MoaiUtilConfig, wx.wxID_ANY, "Android NDK", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.m_staticText11:Wrap( -1 )
	UI.m_staticText11:SetMinSize( wx.wxSize( 100,-1 ) )
	
	UI.bAndroidNdkDir:Add( UI.m_staticText11, 0, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	UI.m_androidNdkDir = wx.wxDirPickerCtrl( UI.MoaiUtilConfig, wx.wxID_ANY, "", "Select a folder", wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxDIRP_DEFAULT_STYLE )
	UI.bAndroidNdkDir:Add( UI.m_androidNdkDir, 1, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	
	UI.bSizer1:Add( UI.bAndroidNdkDir, 1, wx.wxEXPAND, 5 )
	
	UI.m_sdbSizer1 = wx.wxStdDialogButtonSizer()
	UI.m_sdbSizer1OK = wx.wxButton( UI.MoaiUtilConfig, wx.wxID_OK, "" )
	UI.m_sdbSizer1:AddButton( UI.m_sdbSizer1OK )
	UI.m_sdbSizer1Cancel = wx.wxButton( UI.MoaiUtilConfig, wx.wxID_CANCEL, "" )
	UI.m_sdbSizer1:AddButton( UI.m_sdbSizer1Cancel )
	UI.m_sdbSizer1:Realize();
	
	UI.bSizer1:Add( UI.m_sdbSizer1, 1, wx.wxEXPAND, 5 )
	
	
	UI.MoaiUtilConfig:SetSizer( UI.bSizer1 )
	UI.MoaiUtilConfig:Layout()
	
	UI.MoaiUtilConfig:Centre( wx.wxBOTH )


--wx.wxGetApp():MainLoop()

  return UI
end
return GetUI
--wx.wxGetApp():MainLoop()
