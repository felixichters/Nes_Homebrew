#pragma once
#include "wx/wx.h"
#include "wx/listctrl.h"

class Main : public wxFrame
{
private:
	//Main variables 
	int index;
	//std::vector <Room> rooms;

public:
	Main();
	//Control
	wxMenuBar* mBar = nullptr;
	wxMenu* add = nullptr;
	wxMenuItem* room = nullptr;
	wxMenuItem* line = nullptr;
	wxMenuItem* rect = nullptr;
	wxListView* objList = nullptr;
	wxTextCtrl* nameTxt = nullptr;
	wxTextCtrl* xsTxt = nullptr;
	wxTextCtrl* ysTxt = nullptr;
	wxTextCtrl* xeTxt = nullptr;
	wxTextCtrl* yeTxt = nullptr;
	wxButton* nameSave = nullptr;
	wxButton* xsSave = nullptr;
	wxButton* ysSave = nullptr;
	wxButton* xeSave = nullptr;
	wxButton* yeSave = nullptr;
	//Event functions
	void roomClicked(wxCommandEvent& evt);
	void lineClicked(wxCommandEvent& evt);
	void rectClicked(wxCommandEvent& evt);
	void saveName(wxCommandEvent& evt);
	void saveXS(wxCommandEvent& evt);
	void saveYS(wxCommandEvent& evt);
	void saveXE(wxCommandEvent& evt);
	void saveYE(wxCommandEvent& evt);
	DECLARE_EVENT_TABLE();
};  