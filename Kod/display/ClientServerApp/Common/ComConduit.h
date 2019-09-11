/*
 * ComConduit.h
 *
 * Declaration of the ComConduit class
 *
 *      Author: Erik Hellström, hellstrom@isy.liu.se, 2008-12-14
 *    Modified: Emil Larsson, lime@isy.liu.se, 2012-01-13
 */

#ifndef COMCONDUIT_H_
#define COMCONDUIT_H_

// Include conduit base class
#include "Conduit.h"
// Include ipc interface
#include "ipclink.h"

#include <stdio.h>
//
// The ComConduit class
//
class ComConduit : public Conduit {

public:

	// Construct & Destruct
	ComConduit();
	virtual ~ComConduit();

	// Server initialization
	bool StartServer(KeyType* key);
	// Client initialization
	bool StartClient(KeyType* key);
	// Detach and remove shared memory segment
	bool Shutdown();

	// Get shared data size
	int GetDataSize() const;
	// Get number of events
	int GetNumEvents() const;
	// Get pointer to common shared data
	CommonData* GetCommonData() const;

	// Write data
	bool SetData(const wchar_t* data);

	// Data read
	bool GetData(wchar_t* data);

private:

	// Pointer to shared data
	COMdata* ptrData;

};



#endif /* COMCONDUIT_H_ */
