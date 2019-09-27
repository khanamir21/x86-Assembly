/* contains header files */
#include <stdio.h>
#include <stdlib.h>
#include <dos.h>
#include <conio.h>
#include "thread.h"

int graph_sig1e=1;  //If there are DOS system calls in multiple threads,
		    //  separate them with semaphores

unsigned char i = 30;
unsigned char j = 30;

char far *textScreen = (char far*) 0xB8000000;

void directWrite(unsigned char x, unsigned char y, unsigned char attrib, char character);
void directWrite(unsigned char x, unsigned char y, unsigned char attrib, char character)
{
	int index = x + (y*2) + (x*159);
	textScreen[ index ] = character;
	textScreen[ index+1 ] = attrib;

}

int work(void)
{
	int x, y, attrib;
    while (1)
    {
		x = rand() % 25;
		y = rand() % 80;
		attrib = rand() % 14 + 1;
		char character = rand() % 70 + 30;
		directWrite(x, y, attrib, character);
	}
}

/* The following is the test procedure */
int fun(void *a)
{
	while (1)
	{
		work();
	}
}

int fun1(void *a)
{
	while (1)
	{
		work();
	}
}

int fun2(void *a)
{
	while (1)
	{
		work();
	}
}

int fun3(void *a)
{
	while (1)
	{
		work();
	}
}

int fun4(void *a)
{
	while (1)
	{
		work();
	}
}

/* Demonstrates three threads: main thread, fun, and fun2 */
main()
{
    int id1;
    int id2;
    int id3;
    int id4;
    int id5;


    clrscr();
    InitMultiThread(1);
    id1 = CreateThread(fun, NULL, 1);
    id2 = CreateThread(fun1, NULL, 1);
	id3 = CreateThread(fun2, NULL, 1);
	id4 = CreateThread(fun3, NULL, 1);
	id5 = CreateThread(fun4, NULL, 1);
    while (!kbhit())
    {
		delay(1000);
    }
	getch();
	DestroyThread(id5);
	DestroyThread(id4);
	DestroyThread(id3);
	DestroyThread(id2);
	DestroyThread(id1);
	CloseMultiThread();
	
	printf("i=%i, j=%i\n", i,j);
}