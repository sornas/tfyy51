% Ställ dig i kod-mappen och kör det här skriptet. Skriptet testar att peta ut
% värden på displayen med varierande delay.

disp('Se till att du står i mappen kod!!')

cd display/ClientServerApp/Release
!startServer
cd ../../..

% for delta = 0.01:0.01:0.1
% 	disp('######');
% 	disp(delta);
% 	pause(2);
% 	for i = 0:10
% 		pause(delta);
% 		matlabclient(1, put_text(30 * i, 200 * delta, 'L', num2str(delta)));
% 	end
% end

% printa mega-mycket text istället, typ ett helt fönster brett
for y = 0:10
	matlabclient(1, put_text(30, 20 * y, 'L', '###############################################################'))
	pause(0.1)
end
