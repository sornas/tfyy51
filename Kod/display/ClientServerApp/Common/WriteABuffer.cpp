

#include "WriteABuffer.h"


BOOL WriteABuffer(wchar_t* lpBuf, HANDLE hComm)
{
	OVERLAPPED osWrite = {0};
	DWORD dwWritten;
	BOOL fRes;

	unsigned char printBuf[COMSTR_LEN];
	unsigned char* ptrPrintBuf;
	ptrPrintBuf = &printBuf[0];

	int lenBuf = (int) lpBuf[1];
	int ii;

//	printf("\tInteger: %d\n",lenBuf);

//	printf("\tLength of lpBuf: %d\n",wcslen(lpBuf));

	for (ii=0; ii<lenBuf+EXTRA_LEN; ii++) 
	{
		printBuf[ii] = (unsigned char) lpBuf[ii];
//		printf("\nWriteABuffer, variable printBuf[%d]: %d \n", ii, printBuf[ii]); 
	}
	printBuf[ii] ='\0';
//    printf("\nWriteABuffer, variable printBuf[%d]: %d \n", ii, printBuf[ii]); 






	// Create this writes OVERLAPPED structure hEvent.
	osWrite.hEvent = CreateEvent(NULL, TRUE, FALSE, NULL);
	if (osWrite.hEvent == NULL)
		// Error creating overlapped event handle.
		return FALSE;

	// Issue write.
//	printf("\tNum to write: %i\n",dwToWrite);
//	if (!WriteFile(hComm, lpBuf, dwToWrite, &dwWritten, &osWrite)) {
	if (!WriteFile(hComm, ptrPrintBuf, lenBuf+3, &dwWritten, &osWrite)) {
		if (GetLastError() != ERROR_IO_PENDING) { 
			// WriteFile failed, but it isn't delayed. Report error and abort.
			fRes = FALSE;
		}
		else {
			// Write is pending.
			if (!GetOverlappedResult(hComm, &osWrite, &dwWritten, TRUE))
				fRes = FALSE;
			else
				// Write operation completed successfully.
				fRes = TRUE;
		}
	}
	else
		// WriteFile completed immediately.
		fRes = TRUE;

	CloseHandle(osWrite.hEvent);
	return fRes;
}


