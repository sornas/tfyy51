/*
 * ipclink.h
 *
 * Interface for the shared memory communication
 *
 *      Author: Erik Hellström, hellstrom@isy.liu.se, 2008-12-14
 *    Modified: Emil Larsson, lime@isy.liu.se, 2012-01-13
 */

#ifndef IPCLINK_H_
#define IPCLINK_H_

// Include files for sleep-functions
#include <windows.h>

//
// Shared data description
//

// Keys
#define COM_KEY  {3,1,4,6}

// Define what is returned from wait operations
typedef unsigned int WaitResult;
#define WAIT_OK    0
#define WAIT_FAIL  1
#define WAIT_CLOSE 2

// Definition of flags
typedef unsigned int FlagType;
#define NULL_FLAG 0

// Exit flags
#define EXIT_OK   0
#define EXIT_FAIL 1

//
// COMMON DATA
//
typedef struct structCommonData {
	FlagType Flag;    // State flag
	bool DoShutdown;  // Shutdown flag
} CommonData;

//
// Length of <DC1>, len, and bcc 
// see manual for "smallprotocol package".
//
#define EXTRA_LEN 3


//
// COM CONDUIT
//
// Maximum string length
//#define COMSTR_LEN 512
// EXTRA_LEN is included
#define COMSTR_LEN 131
 


// Shared memory structure
typedef struct {
	CommonData Common; // Common data
	wchar_t string[COMSTR_LEN]; // Data string
} COMdata;

// Flags
//#define COM_FLAG   0x01 // Example flag
// Events
#define COM_NEVENTS 2 // Number of events
#define COM_READY   0 // Ready
#define COM_REQUEST 1 // Request

// Define sleep function
#define msleep(t) Sleep(t)



#endif /* IPCLINK_H_ */
