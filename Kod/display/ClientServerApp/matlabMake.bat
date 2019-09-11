rem
rem Run to make the mex-file
rem

rem
rem Run first mex -setup for x86 architecture, i.e., in 
rem directory: "C:\Program Files (x86)\MATLAB\R2011b\bin"
rem

rem C:\PROGRA~2\MATLAB\R2011b\bin\mex  matlabClient\Debug\matlabclient.obj Common\Release\Conduit.obj Common\Release\ComConduit.obj Common\Release\WriteABuffer.obj -outdir Release\

C:\PROGRA~1\MATLAB\R2011b\bin\mex  matlabClient\Release\matlabclient.obj Common\Release\Conduit.obj Common\Release\ComConduit.obj Common\Release\WriteABuffer.obj -outdir Release\


rem 
rem move matlabClient\matlabclient.mexw32 Release