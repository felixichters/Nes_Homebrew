#pragma once
#include <string>

class Room
{
private:
	short y;
	short x;
	short height;
	short width;
	std::string name;
public:
	//set methods
	void set_x(short x);
	void set_y(short y);
	void set_height(short height);
	void set_width(short width);
	void set_name(std::string name);
	//get methods
	short get_x();
	short get_y();
	short get_height();
	short get_width();
	std::string get_name();
};