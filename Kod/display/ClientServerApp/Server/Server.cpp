//============================================================================
// Name        : Server.cpp
// Author      : Erik Hellström, hellstrom@isy.liu.se, 2008-12-14
// Modified    : Emil Larsson, lime@isy.liu.se, 2012-01-13
//
// Description : The server sends data on request from the client. Will
//               loop until an error occurs or the client requests shutdown.
//
//============================================================================

#include <stdio.h>
#include <string.h>
#include <wchar.h>
#include "ComConduit.h"
#include "WriteABuffer.h"
#include "ReadABuffer.h"

//
// Show the command-line usage
//
void Usage(char* argv[]) {

	printf("\nUsage: %s <optiona>\n\n",argv[0]);
	printf("  -P=<port>    Selects the COM port, ex: -Pcom1.\n");
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
	int i;
	char c,*ptr;
	wchar_t data[COMSTR_LEN];
	wchar_t* ptrData = &data[0];

	// Data that will be saved to the buffer
	wchar_t dataFromLCD[COMSTR_LEN];
	wchar_t* ptrDataFromLCD = &dataFromLCD[0];

	FlagType ret;
	unsigned char portnum;
	char port[] = "COM1";
	//	LPCWSTR port[] = "COM1";
	int counter=1;


	DCB dcb;
	COMMTIMEOUTS CommTimeouts;
	HANDLE hCom;

	WaitResult wr;

	// Initialize data
	portnum = '0';

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

		case 'P':
		case 'p':
			// Port selection
			if(sscanf_s(ptr,"com%c",&portnum) == 1)
				break;
			if(sscanf_s(ptr,"COM%c",&portnum) == 1)
				break;
			Usage(argv);
			return EXIT_FAIL;
		}
	}

	// Check valid args
	if(portnum == '0') {
		Usage(argv);
		return EXIT_FAIL;
	}
	port[3] = portnum;

	// TESTKOD
	printf("\nPort: %s\n", port);

	// TESTKOD  
	//  	printf("\nPort: %s\n", port);

	// Open COM port  
	hCom = CreateFile(port,                 // the port
		GENERIC_READ | GENERIC_WRITE, // access rights
		0,                            // exclusive access
		0,                            // handle can no be inherited
		OPEN_EXISTING,                // creation disposition
		0,                            // not overlapped i/o
		0);                           // no template file
	if(hCom == INVALID_HANDLE_VALUE) {
		fprintf(stderr,"\nCan't open com port.\n");
		return EXIT_FAIL;
	}
	//
	// Configure port
	//
	// Get the current Device Control Block (DCB)
	if(!GetCommState(hCom, &dcb)) {
		fprintf(stderr,"\nCan't get com port settings.\n");
		fprintf(stderr,"GetCommState failed with error %d.\n", GetLastError());
		return EXIT_FAIL;
	}
	if(!GetCommTimeouts(hCom, &CommTimeouts)) {
		fprintf(stderr,"\nCan't get com port time-out settings.\n");
		fprintf(stderr,"GetCommTimeouts failed with error %d.\n", GetLastError());
		return EXIT_FAIL;
	}

	// Print out Baud Rate
//	printf("\nBaud rate: %u\n", dcb.BaudRate);

	// Fill in DCB
	dcb.DCBlength = sizeof(DCB);          // Length of dcb struct
	//  dcb.BaudRate = CBR_9600;              // set the baud rate to 9600 bps
	dcb.BaudRate = CBR_115200;            // set the baud rate to 115200 bps
	dcb.fBinary  = TRUE;                  // binary mode
	dcb.fParity  = FALSE;                 // No parity check
	dcb.fOutxCtsFlow = FALSE;             // No CTS output flow control 
	dcb.fOutxDsrFlow = FALSE;             // No DSR output flow control 
	dcb.fDtrControl = DTR_CONTROL_ENABLE; // DTR flow control type 
	dcb.fDsrSensitivity = FALSE;          // DSR sensitivity 
	dcb.fTXContinueOnXoff = TRUE;         // XOFF continues Tx 
	dcb.fOutX = FALSE;                    // No XON/XOFF out flow control 
	dcb.fInX = FALSE;                     // No XON/XOFF in flow control 
	dcb.fErrorChar = FALSE;               // Disable error replacement 
	dcb.fNull = FALSE;                    // Disable null stripping 
	dcb.fRtsControl = RTS_CONTROL_ENABLE; // RTS flow control 
	dcb.fAbortOnError = FALSE;            // Do not abort reads/writes on error
	dcb.XonLim = 256;                     // max. bytes allowed in the queue
	dcb.XoffLim = 256;                    // max. bytes in before XOFF
	dcb.ByteSize = 8;                     // Number of bits/byte, 4-8 
	dcb.Parity = NOPARITY;                // 0-4=no,odd,even,mark,space 
	dcb.StopBits = ONESTOPBIT;            // 0,1,2 = 1, 1.5, 2 
	// Set DCB
	if(!SetCommState(hCom, &dcb)) {
		fprintf(stderr,"\nCan't configure com port.\n");
		fprintf(stderr,"SetCommState failed with error %d.\n", GetLastError());
		return EXIT_FAIL;
	}  

	// Print out Baud Rate
	printf("\nBaud rate: %u\n", dcb.BaudRate);



	// Fill in CommTimeouts
	CommTimeouts.ReadIntervalTimeout = 0;  
	CommTimeouts.ReadTotalTimeoutMultiplier = 0;  
	CommTimeouts.ReadTotalTimeoutConstant = 50;    
	CommTimeouts.WriteTotalTimeoutMultiplier = 0;  
	CommTimeouts.WriteTotalTimeoutConstant = 0; 
	// Set CommTimeouts  
	if(!SetCommTimeouts(hCom, &CommTimeouts)) {
		fprintf(stderr,"\nCan't configure com port.\n");
		fprintf(stderr,"SetCommTimeouts failed with error %d.\n", GetLastError());
		return EXIT_FAIL;
	} 

	// Start server
	if(!Link.StartServer(key)) {
		fprintf(stderr,"StartServer() failed.");
		return EXIT_FAIL;
	}


	// Show that startup is done.
	printf("\nStartup done.\n");

	ret = EXIT_OK;
	while(true) {
		// Indicate that we are ready
		if(!Link.CauseEvent(COM_READY)) {
			fprintf(stderr,"CauseEvent() failed.\n");
			ret = EXIT_FAIL;
			break;
		}

		//
		// Wait for data send request (from client)
		//

		wr = Link.WaitForEvent(COM_REQUEST);
		//	printf("\nTestar Skriva ut!\n");
		if(wr != WAIT_OK) {
			// Check if there was an error
			// or if shutdown is requested

			// Exit
			if(wr == WAIT_CLOSE)
				printf("\nShutdown requested.\n");
			else {
				fprintf(stderr,"\nLink error.\n");
				ret = EXIT_FAIL;
			}
			break;
		}

		//printf("\nSend requested.\n");
		//putchar('.'); fflush(stdout);

		//
		// Read data
		//
		// Get data

		if(!Link.GetData(data)) {
			fprintf(stderr,"GetData() failed.\n");
			return EXIT_FAIL;
		}

		//
		//
		// For print out data in the consol
		//
		//
		wchar_t consoleData[COMSTR_LEN];
		wcscpy_s(&consoleData[0],COMSTR_LEN,&data[0]);



		//printf("\tLength of printData: %d\n",wcslen(consoleData));
		//
		// Send data
		//
		// Output data
		//printf("\tString: %ls\n",data);
		//		WriteABuffer(data,strlen(data),hCom);

		//wchar_t test[] = {17,12,27,90,76,117,0,32,0,84,101,115,116,0,19,'\0'};
		//wchar_t test[] = {17,3,27,68,76,191,'\0'};
		//		wchar_t* pa = &test[0];


		int ii;

		printf("After %d iteration(s), Content in Shared memory (before data \nis written to LCD buffer): \n",counter);
		printf("[");
		for  (ii=0; ii < ptrData[1]+2; ii++) 
		{
//			ReadABuffer(ptr_readChar,1,hCom);
			printf("%d, ", ptrData[ii]);
//			printf("After %d iteration(s), Content in Shared memory: %d, ",counter, dataFromLCD[ii]);
		}
		printf("%d]", ptrData[ii]);
		printf("\n\n");


		WriteABuffer(ptrData,hCom);

		//printf("\tPrint Test String: %ls\n",test);
		//printf("\tLength of data: %d\n",wcslen(test));



		//
		//
		// Check if correct string was sent to the display 
		// If output is 0x06, data package was sent correct
		//
		const int DC1 = 17;
		const int DC2 = 18;
		int DC;
		DC = (int) ptrData[0];

		int readBufLen;
		int printSHM = 1;

//		printf("Buffer nr: %d, \t<ACK>: %d\n",counter, DC);
//		printf("Buffer nr: %d, \t<ACK>: %d\n",counter, ptrData[1]);



		unsigned char readChar[COMSTR_LEN];
		unsigned char* ptr_readChar = &readChar[0];
		
		int jj = 0;
		if (DC == DC1){
			readBufLen = 1;
			ReadABuffer(ptr_readChar,readBufLen,hCom);
			dataFromLCD[0] = 0;
			dataFromLCD[1] = readBufLen;
			dataFromLCD[2] = (wchar_t) ptr_readChar[0];
			jj = 3;
		}
		else if (DC == DC2){
			ReadABuffer(ptr_readChar,3,hCom);

			dataFromLCD[2] = (wchar_t) ptr_readChar[0];
			dataFromLCD[3] = (wchar_t) ptr_readChar[1];
			dataFromLCD[4] = (wchar_t) ptr_readChar[2];
			readBufLen = (int) ptr_readChar[2];

			for (jj=0; jj < readBufLen+2; jj++){
				ReadABuffer(ptr_readChar,1,hCom);
				dataFromLCD[5+jj] = (wchar_t) ptr_readChar[0];
			}
			jj = jj+5;
			dataFromLCD[0] = 0;
			dataFromLCD[1] = readBufLen+4;		
		}
		else{
			printf("Data in Shared memory will not be written to the LCD buffer \nbecause the data package is not correct!!! \n\n");
			printSHM = 0;
		};

		/* Stop with a "null" char */
		dataFromLCD[jj] = (wchar_t) '\0';

//		unsigned char readChar;
//		unsigned char* ptr_readChar = &readChar;
//		ReadABuffer(ptr_readChar,20,hCom);


		if (printSHM == 1){
//			printf("After %d iteration(s), Content in Shared memory (after LCD \nbuffer is written to the Shared memory): \n",counter);
			printf("After %d iteration(s), Content in Shared memory (after LCD buffer is written):\n[",counter);
			for  (ii=2; ii < dataFromLCD[1]+1; ii++) 
			{
				//			ReadABuffer(ptr_readChar,1,hCom);
				printf("%d, ", dataFromLCD[ii]);
				//			printf("After %d iteration(s), Content in Shared memory: %d, ",counter, dataFromLCD[ii]);
			}
			printf("%d]", dataFromLCD[ii]);
			printf("\n\n");
		}

//		ReadABuffer(ptr_readChar,10,hCom);

//		printf("\nSend buffer nr: %d, \t<ACK>: %d\n",counter, ptr_readChar[0]);
//		printf("Send buffer nr: %d, \t<ACK>: %d\n",counter, ptr_readChar[1]);
//		printf("Send buffer nr: %d, \t<ACK>: %d\n",counter, ptr_readChar[2]);
//		printf("Send buffer nr: %d, \t<ACK>: %d\n",counter, ptr_readChar[3]);
//		printf("Send buffer nr: %d, \t<ACK>: %d\n",counter, ptr_readChar[4]);
//		printf("Send buffer nr: %d, \t<ACK>: %d\n",counter, ptr_readChar[5]);
//		printf("Send buffer nr: %d, \t<ACK>: %d\n",counter, ptr_readChar[6]);
//		printf("Send buffer nr: %d, \t<ACK>: %d\n",counter, ptr_readChar[7]);
//		printf("Send buffer nr: %d, \t<ACK>: %d\n",counter, ptr_readChar[8]);
//		printf("Send buffer nr: %d, \t<ACK>: %d\n",counter, ptr_readChar[9]);
//		printf("Send buffer nr: %d, \t<ACK>: %d\n\n",counter, ptr_readChar[10]);
		
		counter++;

//		int ii;
//		for  (ii=0; ii < 10; ii++) 
//		{
//
//			// copy each element
//			dataFromLCD[ii] = (wchar_t) ptr_readChar[ii];
//
//		}
//		/* Stop with a "null" char */
//		dataFromLCD[ii] = (wchar_t) '\0';


		// Set data in shm
		if(!Link.SetData(dataFromLCD)) {
			fprintf(stderr,"SetData() failed.\n");
			return EXIT_FAIL;
		}


		//		printf("\t\n");
	}




	//
	// Shutdown
	//

	// Close COM port
	if(CloseHandle(hCom) == 0) {
		fprintf(stderr,"\nCan't close com-port.\n");
		ret = EXIT_FAIL;
	}

	// Tell eventual clients to shutdown
	if(!Link.CauseShutdown()) {
		fprintf(stderr,"\nCauseShutdown() failed.\n");
		ret = EXIT_FAIL;
	}
	// Wait for clients to shutdown
	msleep(500);
	// Shutdown server
	if(!Link.Shutdown()) {
		fprintf(stderr,"Shutdown() failed.\n");
		ret = EXIT_FAIL;
	}
	// Exit
	if(ret == EXIT_OK)
		fprintf(stdout, "\nClean exit.\n");

	return ret;
}