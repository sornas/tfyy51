#ifndef WRITEABUFFER_H
#define WRITEABUFFER_H

#include <windows.h>
#include <stdio.h>
#include "ipclink.h"

BOOL WriteABuffer(wchar_t * lpBuf, HANDLE hComm);

BOOL ReadABuffer(wchar_t * lpBuf, DWORD dwToWrite, HANDLE hComm);











#endif