/*
 * Conduit.h
 *
 * Declaration of the Conduit class
 *
 *      Author: Erik Hellström, hellstrom@isy.liu.se, 2008-12-14
 *    Modified: Emil Larsson, lime@isy.liu.se, 2012-01-13
 */

#ifndef CONDUIT_H_
#define CONDUIT_H_

#include "ipclink.h"
#include <windows.h>

// Segment key length
#define KEY_LEN 4
// Data type of segment key
typedef unsigned short int KeyType;

// Maximum number of semaphores
#define MAX_NUM_SEM 10

// First semaphore for event tracking
// Semaphore 0 : mutual exclusion
// Semaphore 1 : change of data
#define FIRST_EVENT_SEM 2


#if defined(__GNU_LIBRARY__) && !defined(_SEM_SEMUN_UNDEFINED)
// union semun is defined by including <sys/sem.h>
#else
// according to X/OPEN we have to define it ourselves
union semun {
	int val;                  // value for SETVAL
	struct semid_ds *buf;     // buffer for IPC_STAT, IPC_SET
	wchar_t *array;    // array for GETALL, SETALL
	// Linux specific part:
	struct seminfo *__buf;    // buffer for IPC_INFO
};
#endif


//
// The Conduit class
//
class Conduit {

public:

	// Construct & Destruct
	Conduit();
	virtual ~Conduit();

	// Server initialization
	bool StartServer(KeyType* key);
	// Client initialization
	bool StartClient(KeyType* key);
	// Detach and remove shared memory segment
	bool Shutdown();

	// Request lock on shared data
	bool RequestLock();
	// Release lock on shared data
	bool ReleaseLock();

	// Wait for a flag
	WaitResult WaitForFlag(FlagType flag);
	// Wait for a flag with timeout
	WaitResult WaitForFlag(FlagType flag, int timeout);

	// Wait for an event
	WaitResult WaitForEvent(int index);
	// Wait for an event with timeout [ms]
	WaitResult WaitForEvent(int index, int timeout);
	// Cause an event
	bool CauseEvent(int index);
	// Cause shutdown event
	bool CauseShutdown();

	// Get state flag
	bool GetFlag(FlagType& flag);
	// Set state flag
	bool SetFlag(FlagType flag);

	// Get shutdown boolean
	bool GetShutdownFlag(bool& flag);
	// Set shutdown boolean
	bool SetShutdownFlag(bool flag);

	//
	// Pure virtual functions
	//
	// Get shared data size
	virtual int GetDataSize() const = 0;
	// Get number of events
	virtual int GetNumEvents() const = 0;
	// Get pointer to common shared data
	virtual CommonData* GetCommonData() const = 0;

protected:

	// Pointer to shared memory segment
	void* ptrShm;

private:

	// Wait-operation on a semaphore
	bool Wait(int index);
	// Wait-operation with timeout [ms] on a semaphore
	bool Wait(int index, int timeout);
	// Signal-operation on semaphore
	bool Signal(int index);

	// Indicate change of flag
	bool IndicateChangedFlag();
	// Wait for change of flag
	bool WaitForChangedFlag();
	// Wait for change with timeout of flag
	bool WaitForChangedFlag(int timeout);
	// Get and compare flag
	bool FlagEqual(FlagType flag, FlagType& current);

	// Check validity of semaphore index
	bool ValidIndex(int index);
	// Calculate number of semaphores
	int NumberOfSemaphores();

	// State flag
	bool isServer;
	// Number of semaphores
	int iNumSems;

	// WIN32 IPC: Shared memory based on file mapping.

	// Shared memory segment handle
	HANDLE hMapObject;
	// Semaphore handle
	HANDLE hSemaphore[MAX_NUM_SEM];

};



#endif /* CONDUIT_H_ */
