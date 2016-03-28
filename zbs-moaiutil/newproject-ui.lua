local function GetUI()

local UI = {}


-- create moaiProjectCreate
UI.moaiProjectCreate = wx.wxDialog (wx.NULL, wx.wxID_ANY, "Create Project", wx.wxDefaultPosition, wx.wxSize( 490,159 ), wx.wxDEFAULT_DIALOG_STYLE )
	UI.moaiProjectCreate:SetSizeHints( wx.wxDefaultSize, wx.wxDefaultSize )
	
	UI.bSizer8 = wx.wxBoxSizer( wx.wxVERTICAL )
	
	UI.bSizer9 = wx.wxBoxSizer( wx.wxHORIZONTAL )
	
	UI.m_staticText6 = wx.wxStaticText( UI.moaiProjectCreate, wx.wxID_ANY, "Project Path", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.m_staticText6:Wrap( -1 )
	UI.m_staticText6:SetMinSize( wx.wxSize( 100,-1 ) )
	
	UI.bSizer9:Add( UI.m_staticText6, 0, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	UI.m_dirProjectPath = wx.wxDirPickerCtrl( UI.moaiProjectCreate, wx.wxID_ANY, "", "Select a folder", wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxDIRP_DEFAULT_STYLE )
	UI.bSizer9:Add( UI.m_dirProjectPath, 1, wx.wxALL, 5 )
	
	
	UI.bSizer8:Add( UI.bSizer9, 0, wx.wxEXPAND, 5 )
	
	UI.bSizer91 = wx.wxBoxSizer( wx.wxHORIZONTAL )
	
	UI.m_staticText61 = wx.wxStaticText( UI.moaiProjectCreate, wx.wxID_ANY, "Project Name", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.m_staticText61:Wrap( -1 )
	UI.m_staticText61:SetMinSize( wx.wxSize( 100,-1 ) )
	
	UI.bSizer91:Add( UI.m_staticText61, 0, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	UI.m_projectName = wx.wxTextCtrl( UI.moaiProjectCreate, wx.wxID_ANY, "", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.bSizer91:Add( UI.m_projectName, 1, wx.wxALL, 5 )
	
	
	UI.bSizer8:Add( UI.bSizer91, 0, wx.wxEXPAND, 5 )
	
	UI.bSizer21 = wx.wxBoxSizer( wx.wxHORIZONTAL )
	
	UI.m_staticText13 = wx.wxStaticText( UI.moaiProjectCreate, wx.wxID_ANY, "", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.m_staticText13:Wrap( -1 )
	UI.m_staticText13:SetMinSize( wx.wxSize( 100,-1 ) )
	UI.m_staticText13:SetMaxSize( wx.wxSize( 100,-1 ) )
	
	UI.bSizer21:Add( UI.m_staticText13, 1, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	UI.m_staticText14 = wx.wxStaticText( UI.moaiProjectCreate, wx.wxID_ANY, "Project will be created at <project path>/<project name>", wx.wxDefaultPosition, wx.wxDefaultSize, 0 )
	UI.m_staticText14:Wrap( -1 )
	UI.m_staticText14:SetForegroundColour( wx.wxSystemSettings.GetColour( wx.wxSYS_COLOUR_GRAYTEXT ) )
	
	UI.bSizer21:Add( UI.m_staticText14, 1, wx.wxALL + wx.wxALIGN_CENTER_VERTICAL, 5 )
	
	
	UI.bSizer8:Add( UI.bSizer21, 0, wx.wxEXPAND, 5 )
	
	UI.m_sdbSizer2 = wx.wxStdDialogButtonSizer()
	UI.m_sdbSizer2OK = wx.wxButton( UI.moaiProjectCreate, wx.wxID_OK, "" )
	UI.m_sdbSizer2:AddButton( UI.m_sdbSizer2OK )
	UI.m_sdbSizer2Cancel = wx.wxButton( UI.moaiProjectCreate, wx.wxID_CANCEL, "" )
	UI.m_sdbSizer2:AddButton( UI.m_sdbSizer2Cancel )
	UI.m_sdbSizer2:Realize();
	
	UI.bSizer8:Add( UI.m_sdbSizer2, 1, wx.wxEXPAND, 5 )
	
	
	UI.moaiProjectCreate:SetSizer( UI.bSizer8 )
	UI.moaiProjectCreate:Layout()
	
	UI.moaiProjectCreate:Centre( wx.wxBOTH )

  return UI
end
return GetUI