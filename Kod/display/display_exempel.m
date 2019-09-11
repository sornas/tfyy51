%% Version 0.1 
% Detta skript är exempel på hur kommunikation med den tryckkänsliga
% skärmen fungerar.

%% Start Server
addpath ClientServerApp\Release

cd ClientServerApp\Release

!startServer
cd ../..
%% Diagonal linje
DC1 = 17;
ESC = 27;
Code = 'GD';

% x1, y1, x2, y2, (320 x 240 pixlar)
% minst signifikanta bitar till vänster
% mest signifikanta bitar till höger
arg = [0, 0, 0, 0, 63, 1, 239, 0];

% Save the 'small package' as a string
data = [ESC, double(Code), arg];
len = length(data);
initStr = [DC1, len, data];
bcc = mod(sum(initStr), 256);
str = [initStr, bcc];

% Skriv
matlabclient(1, str')

%% Rita en rektangel som är fylld med mönster
DC1 = 17;
ESC = 27;
Code = 'RM';

% x1, y1, x2, y2, (320 x 240 pixlar)
% minst signifikanta bitar till vänster
% mest signifikanta bitar till höger
arg1 = [57, 0, 100, 0, 1, 1, 180, 0];

% Pattern
arg2 = 8;

% Save the 'small package' as a string
data = [ESC, double(Code), arg1, arg2];
len = length(data);
initStr = [DC1, len, data];
bcc = mod(sum(initStr), 256);
str = [initStr, bcc];

% Skriv
matlabclient(1, str')

%% Skriv en Test-sträng
DC1 = 17;
ESC = 27;
Code = double('ZL');

% x1, y1, (320 x 240 pixlar)
% minst signifikanta bitar till vänster
% mest signifikanta bitar till höger
arg1 = [117, 0, 32, 0];

% Textsträng
%arg2 = 'Test';

arg2 = 'DISPLAY!!!!!';

% Null
arg3 = 0;


% Save the 'small package' as a string
data = [ESC, double(Code), arg1, double(arg2), arg3];
len = length(data);
initStr = [DC1, len, data];
bcc = mod(sum(initStr), 256);
str = [initStr, bcc];

% Skriv
matlabclient(1, str')

%% Definierar en Touch-area
DC1 = 17;
ESC = 27;
Code = 'AK';

% x1, y1, x2, y2, (320 x 240 pixlar)
% minst signifikanta bitar till vänster
% mest signifikanta bitar till höger
%arg1 = [120, 0, 100, 0, 180, 0, 130, 0];
%arg1 = [120, 0, 100, 0, 200, 0, 120, 0];
%arg1 = [120, 0, 130, 0, 200, 0, 160, 0];
arg1 = [120, 0, 170, 0, 200, 0, 190, 0];

arg2 = 150;
arg3 = 151;

arg4 = 'CTouch Me';

% Null
arg5 = 0;

% Save the 'small package' as a string
data = [ESC, double(Code), arg1, arg2, arg3, double(arg4), arg5];
len = length(data);
initStr = [DC1, len, data];
bcc = mod(sum(initStr), 256);
str = [initStr, bcc];

% Skriv
matlabclient(1, str')
%fwrite(lcd, str)

%% Definierar en Touch-area
DC1 = 17;
ESC = 27;
Code = 'AJ';

% x1, y1, x2, y2, (320 x 240 pixlar)
% minst signifikanta bitar till vänster
% mest signifikanta bitar till höger
arg1 = [100, 0, 150, 0];

arg2 = 2;
arg3 = [20, 20];

arg4 = 'RMarkera mig';

% Null
arg5 = 0;

% Save the 'small package' as a string
data = [ESC, double(Code), arg1, arg2, arg3, double(arg4), arg5];
len = length(data);
initStr = [DC1, len, data];
bcc = mod(sum(initStr), 256);
str = [initStr, bcc];

matlabclient(1, str')
%fwrite(lcd, str)

%% Radera Displayen
DC1 = 17;
ESC = 27;
Code = 'DL';

% Save the 'small package' as a string
data = [ESC, double(Code)];
len = length(data);
initStr = [DC1, len, data];
bcc = mod(sum(initStr), 256);
str = [initStr, bcc];

% Skriv
matlabclient(1, str')
%fwrite(lcd, str)

%% Avsluta kommunikation med display
matlabclient(3);