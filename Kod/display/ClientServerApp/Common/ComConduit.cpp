/*
 * ComConduit.cpp
 *
 * Definition of the ComConduit class
 *
 *      Author: Erik Hellström, hellstrom@isy.liu.se, 2008-12-14
 *    Modified: Emil Larsson, lime@isy.liu.se, 2012-01-13
 */

#include "ComConduit.h"
#include <string.h>
//#include "mex.h"

// Constructor
ComConduit::ComConduit() {

	ptrData = NULL;
}

// Destructor
ComConduit::~ComConduit() {

	// Issue shutdown function
	Shutdown();
}

// Detach and remove shared memory segment
bool ComConduit::Shutdown() {

	if(Conduit::Shutdown()) {
		ptrData = NULL;
		return true;
	}
	else
		return false;
}

// Server initialization
bool ComConduit::StartServer(KeyType* key) {

	if(!Conduit::StartServer(key))
		return false;

	ptrData = (COMdata*)ptrShm;
	ptrData->Common.Flag       = NULL_FLAG;
	ptrData->Common.DoShutdown = false;
	ptrData->string[0] = '\0';

	return true;
}

// Client initialization
bool ComConduit::StartClient(KeyType* key) {

	if(!Conduit::StartClient(key))
		return false;

	ptrData = (COMdata*)ptrShm;

	return true;
}

// Get shared data size
int ComConduit::GetDataSize() const {

	return sizeof(COMdata);
}

// Get pointer to common shared data
CommonData* ComConduit::GetCommonData() const {

	if(ptrData == NULL)
		return(NULL);
	else
		return(&ptrData->Common);
}

// Get number of events
int ComConduit::GetNumEvents() const {

	return COM_NEVENTS;
}

// Set the data
bool ComConduit::SetData(const wchar_t* data) {

	int ii;

	if(ptrData == NULL)
		return false;

	// Request lock
	if(!RequestLock())
		return false;

	// Copy string
//	wcscpy_s(ptrData->string,COMSTR_LEN, data);

	/* Copy the wchar_t-string manual */
	for (ii=0; ii<data[1]+EXTRA_LEN; ii++) 
	{
				ptrData->string[ii] = data[ii];
		//					printf("\nptrData->string[%d]: %d \n", ii, ptrData->string[ii]); 
	}
	/* Stop with a "null" char */
    ptrData->string[ii] = '\0';

	// Release lock
	if(!ReleaseLock())
		return false;

	return true;
}

// Get the data
bool ComConduit::GetData(wchar_t* data) {

	int ii;

	if(ptrData == NULL)
		return false;

	// Request lock
	if(!RequestLock())
		return false;

	// Copy string
//	wcscpy_s(data,COMSTR_LEN,ptrData->string);
//	strcpy((char*) data, ptrData->string);

	//printf("\tComConduit:GetData: %d\n",ptrData->string[1]);

	/* Copy the wchar_t-string manual */
	for (ii=0; ii<ptrData->string[1]+EXTRA_LEN; ii++) 
	{
		data[ii] = ptrData->string[ii];
		//printf("\nGetData:data[%d]: %d \n", ii, data[ii]); 
	}
	/* Stop with a "null" char */
	data[ii] = (wchar_t) '\0';
	//printf("\nGetData:data[%d]: %d \n", ii, data[ii]); 

	// Release lock
	if(!ReleaseLock())
		return false;

	return true;
}



