//============================================================================
// Name        : Client.cpp
// Author      : Erik Hellström, hellstrom@isy.liu.se, 2008-12-14
// Modified    : Emil Larsson, lime@isy.liu.se, 2012-01-13
//
// Description : The client requests data to be sent by the server.
//
//============================================================================

#include <stdio.h>
#include <string>
#include "ComConduit.h"

//
// Show the command-line usage
//
void Usage(char* argv[]) {

	printf("\nUsage: %s <options>\n\n",argv[0]);
	printf("  -S=<message> Send message, ex -S=\"hello world\".\n");
	printf("  -X           Shutdown server.\n");
	printf("\n\n");
}





//
// Module main function
//
int main(int argc, char* argv[]) {

	// Conduit object
	ComConduit Link;
	// Key
	KeyType key[KEY_LEN] = COM_KEY;
	// Work variables
	wchar_t data[COMSTR_LEN];
	bool doShutdown;
	FlagType ret;
	int i,j;
	char c,*ptr;
	WaitResult wr;

	// Initialize data
	data[0] = '\0';
	doShutdown = false;

	//
	// Parse the command-line.
	//
	for (i=1; i<argc; i++) {
		ptr = argv[i];

		while(*ptr == '-') // Step forward
			ptr++;
		c = *ptr;          // Get option
		ptr++;
		if(*ptr == '=')   // Step forward
			ptr++;

		switch(c) {

	case 'S':
	case 's':
		// Read message
		j = 0;
		do {
			// add 1 to avoid the "null" character
//			data[j] = (*ptr)+1;
			data[j] = (*ptr);
			ptr++;
			j++;
		} while(j<COMSTR_LEN && *ptr != '\0');
		if(j >= COMSTR_LEN) {
			fprintf(stderr,"\nToo long message.\n");
			return EXIT_FAIL;
		}
		data[j] = '\0';
		break;

	case 'X':
	case 'x':
		// Shutdown
		doShutdown = true;
		break;
		}
	}

	// Check valid args
	if(!doShutdown && data[0] == '\0') {
		Usage(argv);
		return EXIT_FAIL;
	}

	//
	// Start client
	//
	if(!Link.StartClient(key)) {
		fprintf(stderr,"StartClient() failed.\n");
		return EXIT_FAIL;
	}

	ret = EXIT_OK;
	if(doShutdown) {
		// Tell server to shutdown
		if(!Link.CauseShutdown()) {
			fprintf(stderr,"\nCauseShutdown() failed.\n");
			ret = EXIT_FAIL;
		}
	}
	else {
		do {
			// Check if server is ready
			wr = Link.WaitForEvent(COM_READY,0);      
			if(wr != WAIT_OK) {
				fprintf(stderr,"Server is not ready.\n");
				ret = EXIT_FAIL;
				break;
			}

			// Set data in shm
			if(!Link.SetData(data)) {
				fprintf(stderr,"SetData() failed.\n");
				ret = EXIT_FAIL;
				break;
			}

			// Request that the server send the data
			if(!Link.CauseEvent(COM_REQUEST)) {
				fprintf(stderr,"CauseEvent() failed.\n");
				ret = EXIT_FAIL;
				break;
			}
		} while(false);
	}

	//
	// Shutdown
	//
	if(!Link.Shutdown()) {
		fprintf(stderr,"Shutdown() failed.\n");
		ret = EXIT_FAIL;
	}
	if(ret == EXIT_OK)
		fprintf(stdout, "\nClean exit.\n");

	return ret;
}

