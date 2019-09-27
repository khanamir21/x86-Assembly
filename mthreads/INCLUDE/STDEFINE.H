/* Standard header file */
#ifndef _STDEFINE_H_
#define _STDEFINE_H_

/* Constant definition */
#define TRUE  1
#define FALSE 0

/* Standard type definition */
//typedef int BOOL;
typedef unsigned char  BYTE;
typedef unsigned short WORD;
typedef unsigned long  DWORD;
typedef long     int   LONG;

/* Define commonly used macros */
#define LOWBYTE(value)     ( (BYTE)  ((value) & 0x00FF) )
#define HIBYTE(value)      ( (BYTE)  ((value) >> 8)     )
#define LOWWORD(value)     ( (WORD)  ((value) & 0xFFFF) )
#define HIWORD(value)      ( (WORD)  ((value) >> 16)    )
#define MAKEWORD(hi, low)  ( (WORD)  (((hi)<<8)|(low))  )

#endif