//============================================================================
// Name        : matlabClient.cpp
// Author      : Erik Hellström, hellstrom@isy.liu.se, 2008-12-14
// Modified    : Emil Larsson, lime@isy.liu.se, 2012-01-13
// Modified    : Emil Larsson, lime@isy.liu.se, 2012-09-04
//               Data from LCD is written to the shared memory. By request, the
//               data is copied to a local Matlab variable.
//
// Description : The client requests data to be sent by the server.
//
//============================================================================


#include <stdio.h>
#include <string>
#include "ComConduit.h"
//#ifdef _CHAR16T
//#define CHAR16_T
//#endif
#include "mex.h"

int send_communication(bool doShutdown,wchar_t* input_string,int buflen,int flag){
	// Conduit object
	ComConduit Link;
	// Key
	KeyType key[KEY_LEN] = COM_KEY;
	// Work variables
	wchar_t data[COMSTR_LEN];
	wchar_t dataFromLCD[COMSTR_LEN];
	WaitResult wr;

	int retval, ii;


	// Initialize data
	retval = 0;
	data[0] = '\0';

	//	strcpy((char*) data,input_string);
	//	wcscpy_s(&data[0],COMSTR_LEN, input_string);

	/* Copy data from input_string to data */
	for (ii=0; ii<input_string[1]+3; ii++) 
	{
		data[ii] = input_string[ii];
		//	mexPrintf("\ndata[%d]: %d \n", ii,  *((unsigned char*) &data[ii])); 
	}

	/* Stop with a "null" char */
	data[ii] = '\0';



	/* Start client */
	if(!Link.StartClient(key)) {
		mexPrintf("StartClient() failed.\n");
		retval = 1;
		return retval;
	}

	if(doShutdown) {
		mexPrintf("Shutdown requested!!.\n");
		// Request shutdown
		if(!Link.CauseShutdown()) {
			mexPrintf("\nCauseShutdown() failed.\n");
			retval = 1;
			return retval;
		}
	}
	else if (flag == 2){

		/* Get data from shared memory */
		if(!Link.GetData(dataFromLCD)) {
			mexPrintf("GetData() failed.\n");
			retval = 1;
		}

		/* Length of Buffer */
		int lenBuf = (int) dataFromLCD[1];

		for (ii=0; ii < lenBuf+3; ii++){
			/* Copy data from temporary string */
			input_string[ii] = dataFromLCD[ii];
			//			mexPrintf("\ndataFromLCD[%d]: %d \n", ii, input_string[ii]);

		};
	}
	else {
		do {
			// Check if server is ready
			wr = Link.WaitForEvent(COM_READY,0);      
			if(wr != WAIT_OK) {
				mexPrintf("Server is not ready. Start the server application.\n");
				retval = 2;
				break;
			}

			// Set data in shm
			if(!Link.SetData(data)) {
				mexPrintf("SetData() failed.\n");
				retval = 1;
				break;
			}


			// Request that the server send the data
			if(!Link.CauseEvent(COM_REQUEST)) {
				mexPrintf("CauseEvent() failed.\n");
				retval = 1;
				break;
			}
		} while(false);
	}

	//
	// Shutdown
	//
	if(!Link.Shutdown()) {
		mexPrintf("Shutdown() failed.\n");
		retval = 1;
	}
	return retval;
}


void mexFunction( int nlhs,mxArray* plhs[],int nrhs, const mxArray* prhs[] )
{
	/* Version */
	const double ver = 1.00;
	const char date[] = "9 November 2012";

	/* Initialize data */
	bool doShutdown;  
	int retval;
	mwSize ii, nx, mx, n;
	doShutdown = false;
	retval = 0;

	wchar_t x_short_w[COMSTR_LEN];

	/* checksum */
	unsigned char bcc=0;

	/* pointer to input string */
//	double dummy;
	double *prtData;

	/* Save in Shared memory */
	int saveInSHM = 1;

	/* Input flag: 1 = send to display, 2 = receive from display, 3 = shutdown */
	int flag = 10;
	if (nrhs > 0){
		flag = (int)*mxGetPr(prhs[0]);
	};

	plhs[1] = mxCreateDoubleMatrix(0,0,mxREAL);
	//	ptr_out = mxGetPr(plhs[1]);

	//if( (nrhs < 4) && (nrhs > 0)){
	//	flag = (int)*mxGetPr(prhs[0]);
	//};



	if(flag==3){
		/* If no error, call send_communication */
		doShutdown = true; 
	}

	/* Do some checks of input arguments */
	if (nrhs > 0){
		if (!mxIsDouble(prhs[0])) {
			mexPrintf("\nThe first input argument is not a double.\n");
			retval = 1;
		}
		else if (flag==4) {
			mexPrintf("\nMatlab Client\n");
			mexPrintf("=============\n");
			mexPrintf("Version: %4.2f.\n", ver);
			mexPrintf("Date: %s.\n", date);
			retval = 4;
		}
		else if (!(mxGetN(prhs[0]) == 1) || !(mxGetM(prhs[0]) == 1)) {
			mexPrintf("\nThe first input argument is not a scalar.\n");
			retval = 1;
		}
		else if (!(flag == 1 || flag == 2 || flag == 3)) {
			mexPrintf("\nWrong numerical value of the first argument.\n");
			retval = 1;
		}
		else if (flag == 1 && nrhs < 2) {
			mexPrintf("\nTo few input arguments.\n");
			retval = 1;
		}
	}
	else{
		mexPrintf("\nTo few input arguments\n");
		retval = 1;
	}

	if (nrhs > 1){
		if (!(flag == 1) || !mxIsDouble(prhs[1])) {
			mexPrintf("\nFirst and second argument mismatch.\n");
			flag = 1;
			retval = 1;
		}
		//		if (!mxIsDouble(prhs[1])) {
		//			retval = 1;
		//			mexPrintf("The second argument is not a double vector.\n");
		//		}
	}

	if (nrhs > 2){
		mexPrintf("\nTo many input arguments\n");
		retval = 1;
	}


	/* Save output argument */
	if ((retval == 1) || (retval == 4)){
		plhs[0] = mxCreateDoubleMatrix(1,1, mxREAL);
		*(mxGetPr(plhs[0])) = retval;
	}



	if ((nrhs > 0) && (retval == 0)){
		/* Get the length of the input string. */
		//		buflen = (mxGetM(prhs[0]) * mxGetN(prhs[0])) + 1;

		//		mexPrintf("\nbuflen: %d \n", buflen); 


		/* Allocate memory for input and output strings. */
		//		input_buf=(char *) mxCalloc(buflen, sizeof(char));
		//		external_buf=(wchar_t *) mxCalloc(buflen+1, sizeof(wchar_t));

		/* Copy the string data from prhs[0] into a C string 
		* input_buf. */
		//		status = mxGetString(prhs[0], input_buf, buflen);

		//		if (status != 0) 
		//			mexWarnMsgTxt("Not enough space. String will be truncated.");


		//		unsigned char *start_of_pr;
		//		size_t bytes_to_copy;


		/* get the length of the input vector and pointer to data*/
		if (nrhs > 1) {
			nx = mxGetN(prhs[1]);
			mx = mxGetM(prhs[1]);
			prtData = mxGetPr(prhs[1]);
		}
		else {
			nx = 1;
			mx = 1;
			prtData = mxGetPr(prhs[0]);
		}


		/* check if the argument is a row or col vector */
		if (nx > mx) 
			n = nx;
		else
			n = mx;


		/* Check length of buffer */
		if ((n > COMSTR_LEN) && (retval == 0) && (nrhs > 1)){
			mexPrintf("\nToo long data package.\n");
			retval = 1;
		}
		else if ((n < 4) && (retval == 0) && (nrhs > 1)) {
			mexPrintf("\nToo short data package.\n");
			retval = 1;
		}

		/* Check length of data package */
		if ((int) prtData[1] != n-3 && (nrhs > 1)) {
			mexPrintf("\nIncorrect data package.\n");
			retval = 1;
		}
		/* Check if the package starts with DC1 or DC2 */
		else if (((int) prtData[0] != 17) && ((int) prtData[0] != 18) && (nrhs > 1)) {
			mexPrintf("\nIncorrect data package.\n");
//		mexPrintf("\nIncorrect data package. %d\n", (int) prtData[0]);
			retval = 1;
		}

		/* Copy the double input vector to a wchar_t-string */	
		unsigned short int x_short[COMSTR_LEN];
		ii = 0;
		for  (ii=0; ii < n; ii++) 
		{
			x_short[ii] = (unsigned short int) prtData[ii];

			/* Calculate checksum bcc */
			if (ii < n-1) 
				bcc = bcc + x_short[ii];

			/* Check if the element is too large */
			if((x_short[ii] > 255)  && (retval == 0)) {
				mexPrintf("Vector element %d is larger then 255.\n", ii+1);
				retval = 1;
				break;
			}

			/* Copy each element */
			x_short_w[ii] = (wchar_t) x_short[ii];
			// mexPrintf("\nx_short[%d]: %d \n", ii, x_short[ii]); 

		}
		/* Stop with a "null" char */
		x_short_w[ii] = (wchar_t) '\0';

		/* Compare the checksum bcc with the last element */
		if ((x_short[n-1] != bcc)  && (retval == 0) && (nrhs > 1)) {
			mexPrintf("\nIncorrect data package.\n");
			// mexPrintf("\nChecksum %d mismatch. \n", x_short[n-1]); 
			//printf("\nChecksum %d mismatch. \n", x_short[n-1]); 
			retval = 1;
		}

		/* If no error, call send_communication */
		if (retval == 0){
			retval = send_communication(doShutdown,x_short_w,n,flag);
		}

		/* Save output argument */
		plhs[0] = mxCreateDoubleMatrix(1,1, mxREAL);
		*(mxGetPr(plhs[0])) = retval;

		/* Receive data from shared memory */
		if (flag == 2){

			/* Length of Buffer */
			int lenBuf = (int) x_short_w[1];

			//mexPrintf("\nHere: lenBuf %d: \n", lenBuf); 

			/* Save in Shared memory */
			// int saveInSHM = 1;

			if ((x_short_w[1] == 1) && (x_short_w[2])){
				saveInSHM = 1;
			}
			else if ((x_short_w[1] == 1) && (x_short_w[2] == 21)){
				saveInSHM = 1;
			}
			else {
				/* calculate checksum */
				bcc = 0;
				for  (ii=3; ii < (mwSize) x_short_w[4]+5; ii++){

					/* Calculate checksum bcc */
					bcc = bcc + x_short_w[ii];
				}
//				mexPrintf("\nHere: Checksum bcc %d: \n", bcc); 

				/* Compare the checksum bcc with the last element */
				if (x_short_w[ii] != bcc){
//					mexPrintf("\nHere: Checksum %d mismatch. \n", x_short_w[lenBuf+1]); 
					retval = 1;

					saveInSHM = 0;
				}
				else {
					saveInSHM = 1;
				}
			}



			if (saveInSHM == 1){

				/* Save output argument */
				double *ptr_out;
				plhs[1] = mxCreateDoubleMatrix(1,lenBuf,mxREAL);
				ptr_out = mxGetPr(plhs[1]);

				for (ii=2; ii < (mwSize) lenBuf+2; ii++){
					ptr_out[ii-2] = (double) x_short_w[ii];
					// mexPrintf("\nx_short_w[%d]: %f \n", ii, ptr_out[ii-1]);
				}
			}
		}

	}

}







