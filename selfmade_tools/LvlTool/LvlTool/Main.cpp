#include "Main.h"
#include "Room.h"
#include "Func.h"
#include <iostream>

#define ID_ROOM_M 10000
#define ID_LINE_M 10001
#define ID_RECT_M 10002
#define ID_NAME_B 10003
#define ID_XS_B 10004
#define ID_YS_B 10005
#define ID_YE_B 10006
#define ID_XE_B 10007

BEGIN_EVENT_TABLE(Main,wxFrame)
	EVT_MENU(ID_ROOM_M,roomClicked)
	EVT_MENU(ID_LINE_M,lineClicked)
	EVT_MENU(ID_RECT_M,rectClicked)
	EVT_BUTTON(ID_NAME_B,saveName )
	EVT_BUTTON(ID_XS_B,saveXS)
	EVT_BUTTON(ID_YS_B,saveYS)
	EVT_BUTTON(ID_XE_B,saveXE)
	EVT_BUTTON(ID_YE_B,saveYE)
END_EVENT_TABLE()

Main::Main() : wxFrame(nullptr, wxID_ANY, "frame", wxPoint(10,10),wxSize(800,800))
{
	index = 0;
	mBar = new wxMenuBar(); 
	add = new wxMenu();
	objList = new wxListView(this,wxID_ANY,wxPoint(10,10),wxSize(480,750));
	room = new wxMenuItem(add, ID_ROOM_M, _("&room\tCtrl+r"));
	line = new wxMenuItem(add, ID_LINE_M, _("&line\tCtrl+l"));
	rect = new wxMenuItem(add, ID_RECT_M, _("&line\tCtrl+t"));
	nameTxt = new wxTextCtrl(this, wxID_ANY, "name", wxPoint(520, 15), wxSize(100, 20));
	xsTxt = new wxTextCtrl(this, wxID_ANY, "x(coord)", wxPoint(520, 50), wxSize(100, 20));
	ysTxt = new wxTextCtrl(this, wxID_ANY, "y(coord)", wxPoint(520, 75), wxSize(100, 20));
	xeTxt = new wxTextCtrl(this, wxID_ANY, "x(start)", wxPoint(520, 105), wxSize(100, 20));
	yeTxt = new wxTextCtrl(this, wxID_ANY, "y(end)", wxPoint(520, 130), wxSize(100, 20));
	nameSave = new wxButton(this, ID_NAME_B, "confirm name", wxPoint(650,15),wxSize(85,20));
	xsSave = new wxButton(this, ID_XS_B, "confirm x", wxPoint(650,50),wxSize(85,20));
	ysSave = new wxButton(this, ID_YS_B, "confirm y", wxPoint(650, 75),wxSize(85,20));
	xeSave = new wxButton(this, ID_XE_B, "confirm xs", wxPoint(650, 105),wxSize(85,20));
	yeSave = new wxButton(this, ID_YE_B, "confirm ye", wxPoint(650, 130),wxSize(85,20));
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

//Menu Events -------------------------------------------------------------------------------------------------------
void Main::roomClicked(wxCommandEvent& evt)
{
	objList->InsertItem(index,"room");
	index += 1;
	evt.Skip();
}

void Main::lineClicked(wxCommandEvent& evt)
{
	objList->InsertItem(index, "line");
	index += 1;
	evt.Skip();
}

void Main::rectClicked(wxCommandEvent& evt)
{
	objList->InsertItem(index, "rect");
	index += 1;
	evt.Skip();
}
//Button Events ------------------------------------------------------------------------------------------------------
void Main::saveName(wxCommandEvent& evt)
{
	objList->SetItem(getTmpIndex(objList, index),1, nameTxt->GetValue());
	evt.Skip();
}

void Main::saveXS(wxCommandEvent& evt)
{
	objList->SetItem(getTmpIndex(objList, index), 2, xsTxt->GetValue());
	evt.Skip();
}

void Main::saveYS(wxCommandEvent& evt)
{
	objList->SetItem(getTmpIndex(objList, index), 3, ysTxt->GetValue());
	evt.Skip();
}

void Main::saveXE(wxCommandEvent& evt)
{
	objList->SetItem(getTmpIndex(objList, index), 4, xeTxt->GetValue());
	evt.Skip();
}

void Main::saveYE(wxCommandEvent& evt)
{
	objList->SetItem(getTmpIndex(objList, index), 5, yeTxt->GetValue());
	evt.Skip();
}