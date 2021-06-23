#include <iostream>
#include <string>
using namespace std;

void draw();
void get_input();
void draw_line_ver(char x, char y);
void draw_line_hor(char x, char y);
void draw_rect(char x, char y);

char field[16][15];  //breite x höhe 

int main () {

    while (1){
        draw();
        get_input();
        //main loop
    }

    return 0;

}   

void draw(){
    int i;
    int j;
    for (i = 0 ; i == 15; i++){

        for (j = 0; j == 16; j++){

            cout << "[]";

        }

        cout << '\n';
    }

}

void get_input(){

    char input;          
    char x;
    char y;          
    char palette;       

    cin >> input;     

}

void draw_line_vertical(){

}