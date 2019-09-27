/* contains header files */
#include <mem.h>
#include <string.h>
#include <stdlib.h>
#include <setjmp.h>
#include <dos.h>
#include "stdefine.h"
#include "thread.h"

/* Constant definition */
#define MAX_THREAD_NUM    5       //16     Define the maximum number of threads
#define THREAD_STACK_SIZE 256     //512    Defines the memory requested by each thread
#define THREAD_DEAD       0
#define THREAD_READY      1
#define THREAD_RUNNING    2
#define THREAD_STOPPED    3

#define _INT_1CH          0x1c


/* type definition */
typedef struct
{
	THREADPROC proc;
	void      *argv;
	WORD       status;
	int       timer;       //current remaining time
	WORD       cycle;	   // allocated time slice size
	jmp_buf    jmpbuf;
	BYTE       stack[THREAD_STACK_SIZE];
} THREADITEM, PTHREADITEM;

/* Internal global variable definition */
static void interrupt (*old_int_1ch)(...);
static THREADITEM thread_list[MAX_THREAD_NUM] = {0};
static int cur_thread = 0;
static int main_thread_keep=0;        //main thread flag

int graph_sigle;				  // external semaphore, the solution can not reenter the problem, such as graphics library functions can not reenter
                                      //usually=1

/* Internal function declaration */
static void interrupt MULTI_THREAD_MAN(...);
static void changetimer(WORD t);


/* Function implementation */
int InitMultiThread(unsigned short cycle)    //Initialize multithreaded scheduler
{
	memset(thread_list, 0, sizeof(THREADITEM) * MAX_THREAD_NUM);
	cur_thread = 0;
	/* main thread cycle */
	thread_list[cur_thread].status = THREAD_RUNNING;
	thread_list[cur_thread].timer  = cycle;
	thread_list[cur_thread].cycle  = cycle;   
	old_int_1ch = getvect(_INT_1CH);
	setvect(_INT_1CH, MULTI_THREAD_MAN);
	return TRUE;
}

void CloseMultiThread()     //Close line program scheduling
{
//	changetimer(0);
	disable();
	setvect(_INT_1CH, old_int_1ch);
	enable();
}
void KeepMainThread(int d)  //Select whether to run only the main thread
{
	if(d==0)
	{
		main_thread_keep=0;      //multithreaded
		disable();
		setvect(_INT_1CH, MULTI_THREAD_MAN);  //The scheduler is re-acting
		enable();
	}
	else
	{
		main_thread_keep=1;     //==1, only run the main thread (single thread)
	}
}
int  CreateThread(THREADPROC proc, void *argv, WORD cycle)   //Create a new thread
{
	int i;
	for (i=0; i<MAX_THREAD_NUM; i++)
	{
		if (thread_list[i].status == THREAD_DEAD)
		{
			thread_list[i].proc   = proc;
			thread_list[i].argv   = argv;
			thread_list[i].status = THREAD_READY;
			thread_list[i].timer  = cycle;
			thread_list[i].cycle  = cycle;
			return i;
		}
	}
	return NULL;
}

void DestroyThread(int id)
{
	memset(&thread_list[id], 0, sizeof(THREADITEM));
}

void RunThread(int id)   //Restart the previously suspended thread
{
	disable();
	thread_list[id].status = THREAD_RUNNING;
	enable();
}

void StopThread(int id)   // used to temporarily close the secondary thread
{
	while(1)
	{
		if(graph_sigle==1)        //The thread is closed when the signal is 1.
		{
			disable();
			thread_list[id].status = THREAD_STOPPED;
			enable();
			break;
		}
	}
}

/* Internal function implementation */
static void changetimer(WORD t)     //Modify the unit time
{
	outportb(0x43, 0x3c);
	outportb(0x40, LOWBYTE(t));
	outportb(0x40, HIBYTE(t));
}

/* Thread scheduling function is the key to the entire system */
static void interrupt MULTI_THREAD_MAN(...)
{
	static int i;
	static int temp;
	/* Off interrupt */
	disable();
	if(cur_thread==0 && main_thread_keep==1)  
	{
		setvect(_INT_1CH, old_int_1ch);   //Close the thread scheduler when running to the main thread time slice and main_thread_keep==1
		enable();
		return;
	}
	// Multi-threaded scheduling
	if (--thread_list[cur_thread].timer > 0)
	{   // Multi-threaded scheduling
		enable();  /* open interrupt */
		return;
	}

	/* The current thread's time slice is used up, thread scheduling */
	thread_list[cur_thread].timer = thread_list[cur_thread].cycle;  /* Redistribute the time slice */
	if (!setjmp(thread_list[cur_thread].jmpbuf))  /* saves the running environment of the current thread */
	{   /* Start thread scheduling */
		for (i=0; i<MAX_THREAD_NUM; i++)
		{   /* Find the next schedulable thread */
			cur_thread++;
			cur_thread %= MAX_THREAD_NUM;
			if (thread_list[cur_thread].status == THREAD_READY)
			{
				/* Allocate a stack for new threads */
				temp = (WORD)(thread_list[cur_thread].stack);
				temp += THREAD_STACK_SIZE;
				asm mov sp, temp;
				asm mov ax, ds;
				asm mov ss, ax;

				/* Call thread function */
				thread_list[cur_thread].status = THREAD_RUNNING;
				outp(0x20, 0x20);  /* Clear interrupt mask */
				enable();  /* open interrupt */
				thread_list[cur_thread].proc(thread_list[cur_thread].argv);

				/* Thread running ends */
				disable(); /* 关中断 */
				thread_list[cur_thread].status = THREAD_DEAD;
				longjmp(thread_list[0].jmpbuf, 1);  /* returns to the main thread */
				break;
			}
			else if (thread_list[cur_thread].status == THREAD_RUNNING)
			{   /* scheduling thread */
				longjmp(thread_list[cur_thread].jmpbuf, 1);
				break;
			}
		}
	}
	outp(0x20, 0x20);  /* Clear interrupt mask */
	enable();  /* open interrupt */
}