#ifndef _THREAD_H_
#define _THREAD_H_

/* contains header files */
#include "stdefine.h"

/* type declaration */
typedef int (*THREADPROC)(void *argv);

/* Function declaration */
int InitMultiThread(unsigned short cycle); /* cycle Time slice of the main thread */
void CloseMultiThread();    

/* proc thread entry function, argv parameter, cycle thread time slice, return value: thread ID */
int  CreateThread(THREADPROC proc, void *argv, WORD cycle);
void DestroyThread(int id);
void RunThread(int id);
void StopThread(int id);
void PauseThread(int t);
void KeepMainThread(int d);    //Run only the main thread
#endif