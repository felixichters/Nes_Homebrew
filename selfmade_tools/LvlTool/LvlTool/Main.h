#pragma once
#include "wx/wx.h"
#include "wx/listctrl.h"

class Main : public wxFrame
{
private:
	//std::vector <Room> rooms;

public:
	Main();
	wxMenuBar* mBar = nullptr;
	wxMenu* add = nullptr;
	wxMenuItem* room = nullptr;
	wxMenuItem* line = nullptr;
	wxMenuItem* rect = nullptr;
	wxListView* objList = nullptr;
	wxTextCtrl* nameTxt = nullptr;
	void roomClicked(wxCommandEvent& evt);
	void lineClicked(wxCommandEvent& evt);
	void rectClicked(wxCommandEvent& evt);
	DECLARE_EVENT_TABLE();
};  