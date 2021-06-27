#include "Main.h"
#include <iostream>

BEGIN_EVENT_TABLE(Main,wxFrame)
	EVT_MENU(10001,roomClicked)
	EVT_MENU(10002,lineClicked)
	EVT_MENU(10003,rectClicked)
END_EVENT_TABLE()

Main::Main() : wxFrame(nullptr, wxID_ANY, "frame", wxPoint(10,10),wxSize(800,800))
{
	mBar = new wxMenuBar(); 
	add = new wxMenu();
	objList = new wxListView(this,wxID_ANY,wxPoint(10,10),wxSize(480,750));
	room = new wxMenuItem(add, 10001, _("&room\tCtrl+r"));
	line = new wxMenuItem(add, 10002, _("&line\tCtrl+l"));
	rect = new wxMenuItem(add, 10003, _("&line\tCtrl+t"));
	nameTxt = new wxTextCtrl(this, wxID_ANY, "x", wxPoint(520, 15), wxSize(100, 20));
	mBar->Append(add, ("Add"));
	add->Append(room);
	add->Append(line);
	add->Append(rect);
	SetMenuBar(mBar);
	objList->AppendColumn("Type");
	objList->AppendColumn("Name");	
	objList->AppendColumn("X(coord)");
	objList->AppendColumn("Y(coord)");
	objList->AppendColumn("X(start)");
	objList->AppendColumn("Y(end)");
}

void Main::roomClicked(wxCommandEvent& evt)
{
	objList->InsertItem(0,"room");
	evt.Skip();
}

void Main::lineClicked(wxCommandEvent& evt)
{
	objList->InsertItem(1, "line");
	evt.Skip();
}

void Main::rectClicked(wxCommandEvent& evt)
{
	objList->InsertItem(2, "rect");
	evt.Skip();
}