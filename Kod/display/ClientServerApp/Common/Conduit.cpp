/*
 * Conduit.cpp
 *
 * Definition of the Conduit class
 *
 *      Author: Erik Hellström, hellstrom@isy.liu.se, 2008-12-14
 *    Modified: Emil Larsson, lime@isy.liu.se, 2012-01-13
 */

#include <stdio.h>
#include "Conduit.h"
#include <tchar.h>

// Constructor
Conduit::Conduit() {

	ptrShm    = NULL;
	isServer  = false;
	iNumSems  = 0;

	hMapObject = NULL;
	for(int i=0; i<MAX_NUM_SEM; i++)
		hSemaphore[i] = NULL;
}

// Destructor
Conduit::~Conduit() {

	// Issue shutdown function
	Shutdown();
}

// Detach and/or remove shared memory segment
bool Conduit::Shutdown() {

	bool ret = true;
	int i;

	if(hMapObject != NULL) {
		// Detach shared memory segment
		if(!UnmapViewOfFile(ptrShm))
			ret = false;

		if(isServer) {
			// Remove shared memory segment
			if(CloseHandle(hMapObject) == FALSE)
				ret = false;

			// Destroy semaphores
			for(i=0; i<iNumSems; i++) {
				if(CloseHandle(hSemaphore[i]) == FALSE)
					ret = false;
			}
		}
		hMapObject = NULL;
	}

	ptrShm   = NULL;
	isServer = false;

	return ret;
}

// Server initialization
bool Conduit::StartServer(KeyType* key) {

	int i;
	bool ret = true;

	if(ptrShm != NULL)
		return false;

	// Calculate number of semaphores
	iNumSems = NumberOfSemaphores();

	if(iNumSems > MAX_NUM_SEM)
		return false;


	// WIN32 IPC: Shared memory based on file mapping.

	char strKey[KEY_LEN+2];
	SECURITY_ATTRIBUTES attr;

	// Fill struct with security attributes
	attr.nLength = sizeof(SECURITY_ATTRIBUTES);
	attr.lpSecurityDescriptor = NULL;
	attr.bInheritHandle = FALSE;

	// Convert integer array 'key' to char array 'strKey'
	for(i=0; i<KEY_LEN; i++)
		strKey[i+1] = key[i]+48;
	strKey[0]         = 'A';
	strKey[KEY_LEN+1] = '\0';


	// Create shared memory segment
	hMapObject = CreateFileMapping(INVALID_HANDLE_VALUE, // Use paging file
			&attr,                // Security attr.
			PAGE_READWRITE,       // Read/write access
			0,                    // Size: high 32-bits
			GetDataSize(),        // Size: low 32-bits
			strKey);              // Name of map object

	if(hMapObject == NULL)
		return false;

	// Attach to shared memory segment
	ptrShm = MapViewOfFile(hMapObject,     // Object to map view of
			FILE_MAP_WRITE, // Read/write access
			0,              // High offset: map from
			0,              // Low offset: beginning
			0);             // Default: map entire file
	if(ptrShm == NULL) {
		CloseHandle(hMapObject);
		return false;
	}

	// Create semaphore for mutual exclusion [initial value 1]
	strKey[0]++;
	hSemaphore[0] = CreateSemaphore(&attr,   // Security attributes
			1,       // Initial count
			1,       // Maximum count
			strKey); // Named semaphore
	if(hSemaphore[0] == NULL)
		ret = false;

	// Create semaphores for event tracking [initial value 0]
	for(i=1; i<iNumSems; i++) {
		strKey[0]++;
		hSemaphore[i] = CreateSemaphore(&attr,   // Security attributes
				0,       // Initial count
				1,       // Maximum count
				strKey); // Named semaphore
		if(hSemaphore[i] == NULL)
			ret = false;
	}

	// Making absolutely sure that the semaphores are initialized correctly
	Signal(0);
	for(i=1; i<iNumSems; i++)
		Wait(i,0);



	if(ret) {
		isServer = true;
		return true;
	}
	else {
		isServer = true;
		Shutdown();
		isServer = false;
		return false;
	}
}

// Client initialization
bool Conduit::StartClient(KeyType* key) {

	int i;

	if(ptrShm != NULL)
		return false;

	// Calculate number of semaphores
	iNumSems = NumberOfSemaphores();


	// WIN32 IPC: Shared memory based on file mapping.

	char strKey[KEY_LEN+2];

	// Convert integer array 'key' to char array 'strKey'
	for(i=0; i<KEY_LEN; i++)
		strKey[i+1] = key[i]+48;
	strKey[0]         = 'A';
	strKey[KEY_LEN+1] = '\0';

	// Locate shared memory segment
	hMapObject = OpenFileMapping(FILE_MAP_WRITE, // Read/write acces
			FALSE,          // Handle not inheritable
			strKey);        // Name of map object
	if(hMapObject == NULL)
		return false;

	// Attach to shared memory segment
	ptrShm = MapViewOfFile(hMapObject,  // Object to map view of
			FILE_MAP_WRITE, // Read/write access
			0,              // High offset: map from
			0,              // Low offset: beginning
			0);             // Default: map entire file
	if(ptrShm == NULL)
		return false;

	// Locate semaphore for mutual exclusion
	strKey[0]++;
	hSemaphore[0] = OpenSemaphore(SEMAPHORE_MODIFY_STATE |
			STANDARD_RIGHTS_ALL, // Desired access
			FALSE,               // No inheritance
			strKey);             // Sempahore name
	if(hSemaphore[0] == NULL)
		return false;

	// Locate  semaphores for event tracking
	for(i=1; i<iNumSems; i++) {
		strKey[0]++;
		hSemaphore[i] = OpenSemaphore(SEMAPHORE_MODIFY_STATE |
				STANDARD_RIGHTS_ALL, // Desired access
				FALSE,               // No inheritance
				strKey);             // Sempahore name
		if(hSemaphore[i] == NULL)
			return false;
	}


	isServer = false;
	return true;
}

// Wait-operation on a semaphore
bool Conduit::Wait(int index) {


	if(hSemaphore[index] == NULL)
		return false;

	if(WaitForSingleObject(hSemaphore[index],INFINITE) != WAIT_OBJECT_0)
		return false;

	return true;


}

// Wait-operation with timeout [ms] on a semaphore
bool Conduit::Wait(int index, int timeout) {


	if(hSemaphore[index] == NULL)
		return false;

	if(WaitForSingleObject(hSemaphore[index],timeout) != WAIT_OBJECT_0)
		return false;

	return true;
}

// Signal-operation on semaphore
bool Conduit::Signal(int index) {

	if(hSemaphore[index] == NULL)
		return false;

	if(ReleaseSemaphore(hSemaphore[index],1,NULL) == FALSE) {
		if(GetLastError() == ERROR_TOO_MANY_POSTS)
			// Already unlocked
			return true;
		else
			// Error
			return false;
	}

	return true;
}

// Request lock on resource
bool Conduit::RequestLock() {

	return Wait(0);
}

// Release lock on resource
bool Conduit::ReleaseLock() {

	return Signal(0);
}

// Indicate change of flag
bool Conduit::IndicateChangedFlag() {

	return Signal(1);
}

// Wait for change of flag
bool Conduit::WaitForChangedFlag() {

	return Wait(1);
}

// Wait for change with timeout of flag
bool Conduit::WaitForChangedFlag(int timeout) {

	return Wait(1,timeout);
}

// Wait for a flag
WaitResult Conduit::WaitForFlag(FlagType flag) {

	bool ret,sflag;
	WaitResult wr;
	FlagType currentFlag;

	do {
		if(FlagEqual(flag,currentFlag))
			return WAIT_OK;

		// Perform wait
		ret = WaitForChangedFlag();

		wr = WAIT_OK;
		if(!ret || !GetShutdownFlag(sflag))
			wr = WAIT_FAIL;
		if(sflag)
			wr = WAIT_CLOSE;

	} while(wr == WAIT_OK);

	return wr;
}

// Wait for a flag with timeout
WaitResult Conduit::WaitForFlag(FlagType flag, int timeout) {

	bool ret,sflag;
	WaitResult wr;
	FlagType currentFlag;

	do {
		if(FlagEqual(flag,currentFlag))
			return WAIT_OK;

		// Perform wait
		ret = WaitForChangedFlag(timeout);

		wr = WAIT_OK;
		if(!ret || !GetShutdownFlag(sflag))
			wr = WAIT_FAIL;
		if(sflag)
			wr = WAIT_CLOSE;

	} while(wr == WAIT_OK);

	return wr;
}

// Get flag but also check if equal to given parameter. Equal means
// that any of the bits set to one in flag matches a bit set to one in
// the current flag, i.e. if an and-operation gives a positive result.
bool Conduit::FlagEqual(FlagType flag, FlagType& current) {

	return(GetFlag(current) &&
			((flag == NULL_FLAG && current == NULL_FLAG) ||
					((current & flag) > 0)));
}

// Wait for an event (reserve associated semaphore)
WaitResult Conduit::WaitForEvent(int index) {

	bool ret,flag;

	if(!ValidIndex(index))
		return WAIT_FAIL;

	// Perform wait
	ret = Wait(index + FIRST_EVENT_SEM);

	if(!ret || !GetShutdownFlag(flag))
		return WAIT_FAIL;
	if(flag)
		return WAIT_CLOSE;

	return WAIT_OK;
}

// Wait for an event with timeout
WaitResult Conduit::WaitForEvent(int index, int timeout) {

	bool ret,flag;

	if(!ValidIndex(index))
		return WAIT_FAIL;

	// Perform wait
	ret = Wait(index + FIRST_EVENT_SEM,timeout);

	if(!ret || !GetShutdownFlag(flag))
		return WAIT_FAIL;
	if(flag)
		return WAIT_CLOSE;

	return WAIT_OK;
}

// Cause an event (release associated sempahore)
bool Conduit::CauseEvent(int index) {

	if(!ValidIndex(index))
		return false;
	else
		return Signal(index + FIRST_EVENT_SEM);
}

// Cause shutdown event
bool Conduit::CauseShutdown() {

	int i;

	// Indicate shutdown
	if(!SetShutdownFlag(true))
		return false;

	// Release all semaphores but the mutex
	for(i=1; i<iNumSems; i++) {
		if(!Signal(i))
			return false;
	}
	return true;
}

// Get state flag
bool Conduit::GetFlag(FlagType& flag) {

	bool ret = true;
	CommonData *ptr;

	// Request lock
	if(!RequestLock())
		return false;

	if((ptr = GetCommonData()) != NULL)
		flag = ptr->Flag;
	else
		ret = false;

	// Release lock
	if(!ReleaseLock())
		return false;

	return ret;
}

// Set state flag
bool Conduit::SetFlag(FlagType flag) {

	bool ret = true;
	CommonData *ptr;

	// Request lock
	if(!RequestLock())
		return false;

	if((ptr = GetCommonData()) != NULL)
		ptr->Flag = flag;
	else
		ret = false;

	// Release lock
	if(!ReleaseLock())
		return false;

	// Indicate change
	if(!IndicateChangedFlag())
		return false;

	return ret;
}

// Get shutdown boolean
bool Conduit::GetShutdownFlag(bool& flag) {

	bool ret = true;
	CommonData *ptr;

	// Request lock
	if(!RequestLock())
		return false;

	if((ptr = GetCommonData()) != NULL)
		flag = ptr->DoShutdown;
	else
		ret = false;

	// Release lock
	if(!ReleaseLock())
		return false;

	return ret;
}

// Set shutdown boolean
bool Conduit::SetShutdownFlag(bool flag) {

	bool ret = true;
	CommonData *ptr;

	// Request lock
	if(!RequestLock())
		return false;

	if((ptr = GetCommonData()) != NULL)
		ptr->DoShutdown = flag;
	else
		ret = false;

	// Release lock
	if(!ReleaseLock())
		return false;

	return ret;
}

// Check validity of semaphore index
bool Conduit::ValidIndex(int index) {

	if(index < 0 || index > (iNumSems - FIRST_EVENT_SEM))
		return false;

	return true;
}

// Calculate number of semaphores
int Conduit::NumberOfSemaphores() {

	return(FIRST_EVENT_SEM + GetNumEvents());
}



