#include "wx/wx.h"
#include "App.h"

IMPLEMENT_APP(App);

App::App()
{

}
App::~App()
{

}

bool App::OnInit()
{
	frame = new Main();
	frame->Show();
	return true;
}
