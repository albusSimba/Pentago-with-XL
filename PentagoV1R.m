function PentagoV1R()
%PENTAGO     The Mind Twisting Strategy Board Game
%
% Reference from: Dan C. Massie, 9 July 2008
% Objective:  Get five pieces in a row.
% Game Play:  White goes first. Place a game piece on any unoccupied square,
%             then twist one of the sub-boards clockwise or counter-clockwise.
%             First player to get five in a row wins.This is a player vs
%             player game of a player vs computer game
%             This program also includes the Pentago XL version.The board is
%             made of 9 3×3 boards, and there are 4 colours (red, yellow,
%             green and blue) instead of the basic 2.
%
% Background: This game was invented in 2003 by Tomas Floden of Sweden.
%             It is sold as a board game by MindTwisterUSA.com. It has won
%             numerous awards including the prestigious Mensa Select Award.
clc
clf
clear
rng('shuffle')

global handles;     %Graphics handles used by various functions
global Timer;       %Timer handle
global prevTurn;    %Track change of trun for timer reset purpose
global countTimer;  %Timer counter
global mode;        %Determines the mode the user selected to play PVP or PVC
global CPUstart;    %Determines who the cpu plays as
global txt;         %Text handler for the display of turns
global numPlayers;  %Number of players playing the game
global size;        %Determine the size of the board 6x6 or 9x9
global endGameVec;  %Determine if the game has ended
global board;       %The board matrix numbers correspond to the player's number 
global rotate;      %Graphics handle for the selection of subboards
global selectMatrix;%Determines which subboard the user selects to be rotated
global turn;        % Keeps track of whose turn it is. 'P1'=(RED), ...
                    %'P2'=Player1(BLUE), 'P3'=(GREEN) & 'P4'=(YELLOW)
global history;     %Track History of board
global countInstruct
%delete all timers
listOfTimers = timerfindall; % List all timers.
numberOfTimers = length(listOfTimers);
% I KNOW I want ONLY ONE timer in my app.
% If there are others, (say from prior runs of this function),
% get rid of them all, so that only one remains.
if numberOfTimers > 0
	delete(listOfTimers(:));
end
                    
%Initialise game
txt =[];
countInstruct = 1;
FigPlayersettings();

%For testing purposes
%BoardSize();

return;
%---------------------------------------------------------------------
%GUI
%---------------------------------------------------------------------
function FigPlayersettings()
%This function is to set the mode of the game

%Declare variables
global handles

%Initialise variables
handles = [];
h(1) = {'Player VS Player'};
h(2) = {'Player VS Computer(Easy)'};
h(3) = {'Player VS Computer'};

%Get screen size
screensize = get(0,'ScreenSize');

%Intialise figure 1
%Done on 1280 x 1080
handles(1) = figure(1);
xScale = screensize(3)/1280;
yScale = screensize(4)/1080;

%Figure 1 settings
set(handles(1),'Name','Mode');
set(handles(1),'Toolbar','none');
set(handles(1),'Resize','off');
set(handles(1), 'MenuBar', 'none');
set(handles(1),'NumberTitle','off');
img = imread('Picture1.png','png'); 
imshow(img);
%set(handles(1),'Position',[(1280/4)*xScale,(1080/4)*yScale,650*xScale,400*yScale]);
axis off;axis equal ;
pos= get(handles(1),'Position');
width = pos(3);
height = pos(4);
% Draw button on figure 1(refer to ModeCallback to see what each
% button does)
for k=1:3
    uicontrol('Style','PushButton','String',h(k),'Units','normalized',...
        'Value',0,'Position',[0.24*k-0.155 0.05 0.2 0.1], ...
        'Callback',{@Callback_Mode,k});
end

%Draw EXIT push button refer to exitFcn function
uicontrol(handles(1),'Style','PushButton','Units','normalized',...
    'Position',[0.8158 0.05 0.1 0.1],...
    'String','Exit',...
    'Callback',@ButtonexitFcn);

return;
%---------------------------------------------------------------------
function ButtonexitFcn(varargin)
%This function close all figures and terminate program
close all;
return;
%---------------------------------------------------------------------
function Callback_NumPlayer(hObject,~,checkBoxId)
%This function checks if the checkbox is selected and it will determine
%the number of players that is selected

%Declare variable
global numPlayers

%Determine which check box is pressed
value = get(hObject,'Value');
if value
    switch checkBoxId
        case 1
            numPlayers = 4;
            FigPlayerNames();
            closereq;
        case 2
            numPlayers = 3;
            FigPlayerNames();
            closereq;
        case 3
            numPlayers = 2;
            FigPlayerNames();
            closereq;
        otherwise
            close all
    end
end

return;
%---------------------------------------------------------------------
function Callback_Mode(hObject,~,checkBoxId)
%This function checks if the checkbox is selected and it will determine
%the mode that is selected

%Declare variable
global mode

%Determine which check box is pressed
value = get(hObject,'Value');
if value
    switch checkBoxId
        case 1
            mode = 'PlayerVsPlayer';
            FigBoardSize();
            closereq;
        case 2
            mode = 'PlayerVsComputer1';
            FigInitializeCPU();
            closereq;
        case 3
            mode = 'PlayerVsComputer2';
            FigInitializeCPU();
            closereq;
        otherwise
            close all
    end
end

return;
%---------------------------------------------------------------------
function FigPlayerCount()
%This function determine the number of players playing the game

%Declare variables
global handles

%Initialise variables
handles = [];
h(1) = {'4 Players'};
h(2) = {'3 Players'};
h(3) = {'2 Players'};

%Get screensize
screensize = get(0,'ScreenSize');
xScale = screensize(3)/1280;
yScale = screensize(4)/1080;


%Draw figure and set figure settings
handles(117) = figure(4);
set(handles(117),'Name','Number Players');
set(handles(117),'Toolbar','none');
set(handles(117),'Resize','off');
set(handles(117), 'MenuBar', 'none');
set(handles(117),'NumberTitle','off');
set(handles(117),'Position',[(1280/2-150)*xScale,(1080/2-75)*yScale,300*xScale,150*yScale]);
axis off; axis square;

%Draw button for user selection(refer to Callback_NumPlayer to see what each
%button does)
for k=1:3;
    uicontrol('Style','PushButton','String',h(k), ...
        'Value',0,'Position',[70*xScale (30*k+20)*yScale 170*xScale 30*yScale], ...
        'Callback',{@Callback_NumPlayer,k});
end

%Draw buttons
%Exit button
uicontrol(handles(117),'Style','PushButton',...
    'Position',[150*xScale 10*yScale 75*xScale 25*yScale],...
    'String','Exit',...
    'Callback',@ButtonexitFcn);

%Back button
uicontrol(handles(117),'Style','PushButton',...
    'Position',[70*xScale 10*yScale 75*xScale 25*yScale],...
    'String','Back',...
    'Callback',{@ButtonbackFcn,1});

return;
%---------------------------------------------------------------------
function FigBoardSize()
%This function determine the board size
h(1) = {'6 x 6'};
h(2) = {'9 x 9'};

%Declare object handler
global handles

%Draw figure and set figure settings
screensize = get(0,'ScreenSize');
xScale = screensize(3)/1280;
yScale = screensize(4)/1080;

handles(3) = figure(3);
set(handles(3),'Name','Board Size');
set(handles(3),'Toolbar','none');
set(handles(3),'Resize','off');
set(handles(3),'NumberTitle','off');
set(handles(3), 'MenuBar', 'none');
set(handles(3),'Position',[(1280/2-150)*xScale,(1080/2-75)*yScale,300*xScale,150*yScale]);
axis off; axis square;

%Draw button for user selection(refer to Callback_size to see what each
%button does)
for k=1:2;
    uicontrol('Style','PushButton','String',h(k), ...
        'Value',0,'Position',[70*xScale (30*k+30)*yScale 170*xScale 30*yScale], ...
        'Callback',{@Callback_size,k});
end

%Draw Buttons
%Exit Button
uicontrol(handles(3),'Style','PushButton',...
    'Position',[158*xScale 10*yScale 75*xScale 25*yScale],...
    'String','Exit',...
    'Callback',@ButtonexitFcn);
%Back Button
uicontrol(handles(3),'Style','PushButton',...
    'Position',[78*xScale 10*yScale 75*xScale 25*yScale],...
    'String','Back',...
    'Callback',{@ButtonbackFcn,1});

return;
%---------------------------------------------------------------------
function ButtonbackFcn(~,~,Id)
%Execution when back button is pressed
closereq;
global txt
txt =[];
switch Id
    
    case 1
        FigPlayersettings();
    case 2
        FigPlayerCount();
    case 3
        FigPlayerNames();
    otherwise
        display('Restarting game..')
        FigPlayersettings();
end

return;
%---------------------------------------------------------------------
function Callback_size(hObject,~,checkBoxId)
%This function determine the size of the board is selected to be played

%Declare varibles
global size
global numPlayers
global history

%Determine which check box is pressed
value = get(hObject,'Value');
if value
    switch checkBoxId
        case 1
            numPlayers = 2;
            size = 6;
            closereq;
            FigPlayerNames();
            %FigInitializeBoard();
        case 2
            size = 9;
            closereq;
            FigPlayerCount();
        otherwise
            close all
    end
end

history = zeros(size,size,0);
history(:,:,1) = zeros(size);

return;
%---------------------------------------------------------------------
function FigInitializeCPU()
%This function draws the figure for the user to select which player he will
%play as againist the computer

%Call Object handler
global handles
%Intialise variables
h(1) = {'Red'};
h(2) = {'Blue'};
h(3) = {'Coin Toss'};

%Get screensize
screensize = get(0,'ScreenSize');
xScale = screensize(3)/1280;
yScale = screensize(4)/1080;

%Draw figure and set figure settings
handles(2) = figure(2);
set(handles(2),'Name','Color Settings');
set(handles(2),'Toolbar','none');
set(handles(2),'Resize','off');
set(handles(2), 'MenuBar', 'none');
set(handles(2),'NumberTitle','off');
set(handles(2),'Position',[(1280/2-150)*xScale,(1080/2-75)*yScale,300*xScale,150*yScale]);
axis off; axis square;

%Draw button for user selection
for k=1:3;
    uicontrol('Style','PushButton','String',h(4-k), ...
        'Value',0,'Position',[70*xScale (30*k+20)*yScale 170*xScale 30*yScale], ...
        'Callback',{@Callback_CPUMode,4-k});
end

%Draw Buttons
%Exit Button
uicontrol(handles(2),'Style','PushButton',...
    'Position',[158*xScale 10*yScale 75*xScale 25*yScale],...
    'String','Exit',...
    'Callback',@ButtonexitFcn);

%Back Button
uicontrol(handles(2),'Style','PushButton',...
    'Position',[78*xScale 10*yScale 75*xScale 25*yScale],...
    'String','Back',...
    'Callback',{@ButtonbackFcn,1});

return;
%---------------------------------------------------------------------
function Callback_CPUMode(hObject,~,checkBoxId)
%Ths function determine what player the player play as againist the
%computer

%Call variables
global CPUstart;
global size;
global numPlayers;
global history;
%Determine which check box is pressed
value = get(hObject,'Value');

size = 6;
history = zeros(size,size,0);
history(:,:,1) = zeros(size);
numPlayers = 2;
if value
    switch checkBoxId
        case 1
            CPUstart = 'P2';
            FigInitializeBoard();
            closereq;
        case 2
            CPUstart = 'P1';
            FigInitializeBoard();
            closereq;
        case 3
            i = randi([0 1]);
            if i == 1
                CPUstart = 'P1';
            else
                CPUstart = 'P2';
            end
            FigInitializeBoard();
            closereq;
        otherwise
            close all
    end
end


return;
%---------------------------------------------------------------------
function FigInitializeBoard()
% This functions draws the the game board.

%Call object handler
global handles;
%Declare variables
global board;
global rotate;
%Call variables
global turn;
global prevTurn;
global size;

% Create board matrix
board = zeros(size,size);
rotate = zeros(size);
% Create figure and handle list

% Draw the board
screensize = get(0,'ScreenSize');
xScale = screensize(3)/1280;
yScale = screensize(4)/1080;

handles(4) = figure(3);
set(handles(4),'Name','PENTAGO V1');
set(handles(4),'Toolbar','none');
set(handles(4), 'MenuBar', 'none');
set(handles(4),'NumberTitle','off');
%[ positionX positionY screensizeX screensizeY]
set(handles(4),'Position',[(1280/2-450)*xScale,(1080/2-450)*yScale,900*xScale,900*yScale]);
axis off; axis square;

%Define colors
tan = [.9 0.8 0.5];
bgcolor = [.82 0.58 0.34];
brown = [.7 .5 0.1];
piececolor = {'r',tan,'b','g','y'};

%Draw background & pieces,
%Draw outer border 
handles(5) = patch([0.8 0.8 size+1.2 size+1.2],[-0.8 -size-1.2 -size-1.2 -0.8],bgcolor);
count = 6;
sq = 3;
%Draw 3x3 patch
for i = 1:size/3
    for j = 1:size/3
        x = 3*(i-1)+1;
        y = 3*(j-1)+1;
        handles(count) = patch([x x x+sq sq+x],[-y -sq-y -sq-y -y],brown);
        set(handles(count),'ButtonDownFcn',{@Callback_Rotate,j,i})
        count = count + 1;
    end
end

count = 16;

uicontrol(handles(4),'Style','PushButton','Units','normalized',...
    'Position',[0.3 0.07 0.1 0.05],...
    'String','Undo',...
    'Callback',@ButtonUndoFcn);
uicontrol(handles(4),'Style','PushButton','Units','normalized',...
    'Position',[0.45 0.07 0.1 0.05],...
    'String','Instructions',...
    'Callback',@ButtoninstructionFcn);
handles(230) = uicontrol(handles(4),'Style','PushButton','Units','normalized',...
    'Position',[0.6 0.07 0.1 0.05],...
    'String','Timer Off',...
    'Callback',@ButtonTimerFcn);

handles(231) = text(2*(size)/3,5.5-size,'Timer','HorizontalAlignment','center',...
    'Visible','off');


%Draw circles/pieces
for i = 1:size
    for j = 1:size
        a=.3; % horizontal radius
        b=.3; % vertical radius
        x0=i+0.5; % x0,y0 ellipse centre coordinates
        y0=-j-0.5;
        t=-pi:0.01:pi;
        x=x0+a*cos(t);
        y=y0+b*sin(t);
        handles(count) = patch(x,y,piececolor{board(j,i)+2});
        set(handles(count),'ButtonDownFcn',{@Callback_Piece,j,i})
        count = count + 1;
    end
end
handles(97) = text((size+2)/2,-1.5-size,'Initializing','HorizontalAlignment','center');
set(handles(97),'FontWeight','bold');

count = 98;

%Draw arrows
for i = 1:size/3
    for j = 1:size/3
        
        a = 3*j-1.25;
        b = 3*i-2;
        [x,y] = DrawArrows();
        handles(count) = patch(x+a,y-b,'k');
        set(handles(count),'Visible','off');
        set(handles(count),'ButtonDownFcn',{@Callback_Arrow,90});
        a = 3*j+0.2;
        b = 3*i-2;
        handles(count+1) = patch(-x+a,y-b,'k');
        set(handles(count+1),'Visible','off');
        set(handles(count+1),'ButtonDownFcn',{@Callback_Arrow,270});
        count = count + 2;
        
    end
end



%Intialise turn
turn = 'P1';
prevTurn = turn;
%Pause and wait for user input 
Wait();

return;
%---------------------------------------------------------------------
function ButtonUndoFcn(varargin)
%This undo moves
global history;
global board;
global turn;
global numPlayers;
global handles;
global size;
global rotate;

if ~isequal(history(:,:,end),history(:,:,1))
    history(:,:,end) = [];
end
board = history(:,:,end);

prevTurn = str2double(turn(2)) - 1;

if prevTurn == 0
    prevTurn = numPlayers;
end

if ~isequal(history(:,:,end),history(:,:,1))
    turn = strcat('P',num2str(prevTurn));
else
    turn = 'P1';
    display('1st turn')
end

for i = 1: size*size/9
    set(handles(96+2*i),'Visible','off');
    set(handles(97+2*i),'Visible','off');
end
rotate = zeros(size);

DrawBoard();
Wait();

return;
%---------------------------------------------------------------------
function ButtoninstructionFcn(varargin)
%This function close all figures and terminate program
FigInstuctions();

return;
%---------------------------------------------------------------------
function FigInstuctions()
global pictures
global handles
global countInstruct
pictures{1} = imread('Instuction1.png','png'); 
pictures{2} = imread('Instuction2.png','png'); 
pictures{3} = imread('Instuction3.png','png'); 
pictures{4} = imread('Instuction4.png','png'); 

screensize = get(0,'ScreenSize');
xScale = screensize(3)/1280;
yScale = screensize(4)/1080;


handles(229) = figure(7);
set(handles(229),'Name','Instructions');
set(handles(229),'NumberTitle','off');
set(handles(229),'Toolbar','none');
set(handles(229),'Resize','off');
set(handles(229), 'MenuBar', 'none');

imshow(pictures{countInstruct});
%set(handles(229),'Position',[(1280/2-150)*xScale,(1080/2-75)*yScale,500*xScale,400*yScale]);
axis off; axis square;
pos= get(handles(229),'Position');
width = pos(3);
height = pos(4);
%Exit button
uicontrol(handles(229),'Style','PushButton','Units','normalized',...
    'Position',[0.25 0.05 0.2 0.1],...
    'String','Back',...
    'Callback',@ButtonInstructBackFcn);
 

%Back button
uicontrol(handles(229),'Style','PushButton','Units','normalized',...
    'Position',[0.55 0.05 0.2 0.1],...
    'String','Next',...
    'Callback',@ButtonInstructNextFcn);
    
return
%---------------------------------------------------------------------
function ButtonInstructNextFcn(varargin)
global countInstruct

countInstruct = countInstruct + 1;
if countInstruct >4
    countInstruct = 4;
end
FigInstuctions()

return;
%---------------------------------------------------------------------
function ButtonInstructBackFcn(varargin)
global countInstruct

countInstruct = countInstruct - 1;
if countInstruct < 1
    countInstruct = 1;
end
FigInstuctions()
return;
%---------------------------------------------------------------------
function timerCallback(~,~)

global countTimer
global handles
global history
global board
global prevTurn
global turn
global size

if isequal(prevTurn,turn)
    countTimer = countTimer + 1; 
else
    countTimer = 0;
    prevTurn = turn;
    
end

if ~isempty(handles(231)) && ishandle(handles(231))
    set(handles(231),'String',countTimer);
end

if countTimer == 15
    countTimer = 0;
    countCurrEmpty = sum(board == 0);
    countPrevEmpty = sum(history(:,:,end) == 0);
    if countCurrEmpty == countPrevEmpty
        randRow = randi([1 size]);
                randCol = randi([1 size]);
                while board(randRow,randCol)~= 0 
                    randRow = randi([1 size]);
                    randCol = randi([1 size]);
                end
                
                board(randRow,randCol) = str2double(turn(2));             
                
    end
    randRot = randi([90 91]);
    randMatrix = randi([1 size*size/9]);
    pause(0.1)
    PlayerSwitch()
    gameOver = gameState(board);
        
    %Rotate matrix
    if gameOver == false
        rotMatrix(randMatrix,randRot);
    end
    history(:,:,end+1) = board;
    
    DrawBoard();
    Wait();
end

return
%---------------------------------------------------------------------
function ButtonTimerFcn(varargin)
%This function close all figures and terminate program
global handles
global Timer
global countTimer

listOfTimers = timerfindall; % List all timers.
numberOfTimers = length(listOfTimers);
% I KNOW I want ONLY ONE timer in my app.
% If there are others, (say from prior runs of this function),
% get rid of them all, so that only one remains.
if numberOfTimers > 0
	delete(listOfTimers(:));
end

Timer = timer('ExecutionMode', 'FixedRate', ...
    'Period',0.95 , ...
    'TimerFcn', @timerCallback);
countTimer = 0;
if ~isempty(handles(231)) && ishandle(handles(231))
    
    if strcmp(get(handles(231),'visible'),'on')
        
        set(handles(231),'Visible','off');
        set(handles(230),'String','Timer Off');
        stop(Timer);
        delete(Timer);
        
    else
        start(Timer);
        set(handles(231),'Visible','on');
        set(handles(230),'String','Timer On');
        
    end
end


return;
%---------------------------------------------------------------------
function Callback_Piece(~,~,row,col)
% This function is executed whenever an enabled piece is clicked on. Updates
%board matrix based on the click.

%Call variables
global board;
global turn;

%Determine which piece is clicked on
if board(row,col)~=0
    %Error checking
    disp('Invalid Move');
else
    if strcmp(turn,'P1')
        board(row,col) = 1;
    elseif strcmp(turn,'P2')
        board(row,col) = 2;
    elseif strcmp(turn,'P3')
        board(row,col) = 3;
    elseif strcmp(turn,'P4')
        board(row,col) = 4;
        
    else
        board(row,col) = 0;
    end
    %Redraw board
    DrawBoard();
    %Check game state
    if numel(board == 0) <36
        gameOver = gameState(board);
    else
            gameOver =false;
    end
    
    %Disable clicking of pieces
    EnablePieces('off');
    %Enable user to select subboards for rotation
    EnableRotation('on');
    
    %End game if there is a winner
    if gameOver == true
        Wait();
    end

end
return;
%---------------------------------------------------------------------
function DrawBoard()
%This utility function changes the color of the game pieces to reflect the
%"board" matrix state.

%Call object handler
global handles;

%Declare variables
global board;
global size;
global rotate;

% Define colors
tan = [.9 0.8 0.5];
brown = [.7 .5 0.1];
Dkbrown = [.5 0.3 0.3];
rotColor = {brown,Dkbrown};
piececolor = {tan,'r','b','g','y'};

count = 6;

%draw 3x3 patch
for i = 1:size/3
    for j = 1:size/3
        if ~isempty(handles(count)) && ishandle(handles(count))
            set(handles(count),'FaceColor',rotColor{rotate(j,i)+1});
            count = count + 1;
        end
    end
end
% Draw background, pieces, and lines
count = 16;
for i = 1:size
    for j = 1:size
        if ~isempty(handles(count)) && ishandle(handles(count))
            set(handles(count),'FaceColor',piececolor{board(j,i)+1});
            count = count + 1;
        end
    end
end

return;
%---------------------------------------------------------------------
function Wait()

%Declare variables
global CPUstart;
global board;
global turn;
global mode;
global size;

%Check game state
gameOver = gameState(board);

%Disable user selection of subboard for rotation
EnableRotation('off');
%Disable user selection of arrows for rotation
EnableArrows('off');

%Depending on the mode of the game determine code to execute
switch mode
    
    case 'PlayerVsPlayer'
        %Determine turn and enable pieces selection for user
        if gameOver == false
            if strcmp(turn,'P2')
                Text_displayTurn(turn);
                EnablePieces('on');
            else
                Text_displayTurn(turn);
                EnablePieces('on');
            end
        else
            %Reset game
            clf;
            clear;
            FigPlayersettings();
        end
        
    case 'PlayerVsComputer1'
        if gameOver == false
            %Determine turn and enable pieces selection for user
            if strcmp(turn,CPUstart)
                Text_displayTurn(turn);
                %RNG Computer mode
                EnablePieces('off');
                Trollbot();                
                randRow = randi([1 size]);
                randCol = randi([1 size]);
                while board(randRow,randCol)~= 0 
                    randRow = randi([1 size]);
                    randCol = randi([1 size]);
                end
                randRot = randi([90 91]);
                randMatrix = randi([1 size*size/9]);
                board(randRow,randCol) = str2double(CPUstart(2));
                pause(0.1)
                PlayerSwitch()
                gameOver = gameState(board);
                
                %Rotate matrix
                if gameOver == false
                    rotMatrix(randMatrix,randRot);
                end
                DrawBoard();
                Wait();
            else
                Text_displayTurn(turn);
                EnablePieces('on');
            end
        else
            %Reset game
            clf;
            clear;
            FigPlayersettings();
        end
        
    case 'PlayerVsComputer2'
        if gameOver == false
             DrawBoard();
            %Determine turn and enable pieces selection for user
            if strcmp(turn,CPUstart)
                Text_displayTurn(turn);
                %RNG Computer mode
                EnablePieces('off');
                if strcmp(CPUstart,'P1')
                    who_to_play = 1;
                else
                    who_to_play = 2;
                end
                
                Text_DisplayStatus('CPU Thinking..');
                pause(0.5)
                
                [ pos_played,rotation_played ] = make_a_move_computer( board , who_to_play );
                
                board(pos_played) = str2double(CPUstart(2));
                pause(0.1)
                PlayerSwitch()
                
                [selectMatrix,rotation] = rotation_Converter(rotation_played);
                %Rotate matrix
                rotMatrix(selectMatrix,rotation);
                DrawBoard();
                Wait();
            else
                Text_displayTurn(turn);
                EnablePieces('on');
            end
        else
            %Reset game
            clf;
            clear;
            FigPlayersettings();
        end
        %Text_DisplayStatus('Mode Not Ready');
    otherwise
        %Error detection msg
        Text_DisplayStatus('Error in selecting mode please restart game.');
end

return;
%---------------------------------------------------------------------
function Callback_Rotate(~,~,row,col)
%Ths function determine which sub-board is clicked on 

%Call event handler
global handles;

%Call variables
global rotate;%This is the variable for drawing subboard
global size;
global selectMatrix;

%If other sub-boards are pressed reset visibility of arrows and sub-boards
for i = 1: size*size/9
    set(handles(96+2*i),'Visible','off');
    set(handles(97+2*i),'Visible','off');
end
rotate = zeros(size);

%Redraw subboard that is selected
rotate(row,col)= 1;

%Determine subboard that is selected
selectMatrix = size/3*(row-1)+col;

%Enable arrow for user input of rotation
EnableArrows('on');

%Show arrows for user input
set(handles(96+2*selectMatrix),'Visible','on');
set(handles(97+2*selectMatrix),'Visible','on');

%Redraw Board
DrawBoard();

return;
%---------------------------------------------------------------------
function Callback_Arrow(~,~,rotation)
%This function determine which arrows is clicked on and rotates the
%subboards

%Call object handler
global handles;
%Call variables
global selectMatrix;
global rotate;
global size;
global board;
global history;

%Reset subboard color
rotate = zeros(size);

%Change player
PlayerSwitch();

%Rotate subboards
rotMatrix(selectMatrix,rotation);

%Disable arrows and subboard  selection 
EnableArrows('off');
EnableRotation('off');

%Turn off visibility arrows
set(handles(96+2*selectMatrix),'Visible','off');
set(handles(97+2*selectMatrix),'Visible','off');

history(:,:,end+1) = board;

%Redraw board
DrawBoard();

%Await next user input
Wait();

return;
%---------------------------------------------------------------------
function EnablePieces(str)
%This function enables or disables the game pieces for user input
global handles;
global size;
for i = 16:15+size*size, 
    if ~isempty(handles(i)) && ishandle(handles(i))
        set(handles(i),'HitTest',str); 
    end
end
return;
%---------------------------------------------------------------------
function EnableRotation(str)
%This function enables or disables the game pieces for user input

%Call object handler
global handles;
%Call variables
global size;

for i = 6:5+size*size/9
    if ~isempty(handles(i)) && ishandle(handles(i))
        set(handles(i),'HitTest',str);
    else
        break;
    end
end
return;
%---------------------------------------------------------------------
function EnableArrows(str)
%This function enables or disables the game pieces

%Call object handler
global handles;
%Call variables
global size;
for i = 98:(97+2*(size*size/9)),
    if ~isempty(handles(i)) && ishandle(handles(i))
        set(handles(i),'HitTest',str);
    end
end
return;
%---------------------------------------------------------------------
function FigPlayerNames()
%This function will draw the figure that will take the players names 

%Call Object handler
global handles;
%Call variables
global numPlayers;


%Get screensize
screensize = get(0,'ScreenSize');
xScale = screensize(3)/1280;
yScale = screensize(4)/1080;

%Draw figure and set figure settings
handles(118) = figure(5);
set(handles(118),'Name','Names Input');
set(handles(118),'NumberTitle','off');
set(handles(118),'Toolbar','none');
set(handles(118),'Resize','off');
set(handles(118), 'MenuBar', 'none');
set(handles(118),'Position',[(1280/2-150)*xScale,(1080/2-75)*yScale,300*xScale,(90+20*numPlayers)*yScale]);
axis off; axis square;
count =119;

%Draw text box for player name input
for k=1:numPlayers
    handles(count) = uicontrol(handles(118),'Style','edit',...
        'String','Enter name',...
        'Position',[70*xScale (25*k+30)*yScale 160*xScale 20*yScale]);
    count= count + 1;

end

%Draw Buttons
%Random Button
uicontrol(handles(118),'Style','PushButton',...
    'Position',[115*xScale 10*yScale 75*xScale 25*yScale],...
    'String','Random',...
    'Callback',{@ButtonNextFcn,1});

%Back Button
uicontrol(handles(118),'Style','PushButton',...
    'Position',[30*xScale 10*yScale 75*xScale 25*yScale],...
    'String','Back',...
    'Callback',{@ButtonbackFcn,2});
%Next Button
uicontrol(handles(118),'Style','PushButton',...
    'Position',[200*xScale 10*yScale 75*xScale 25*yScale],...
    'String','Next',...
    'Callback',{@ButtonNextFcn,2});


return;
%--------------------------------------------------------------------------
function FigCfmPlayer()
%This function draws the figure and random the players

%Call Object handler
global handles;

%call variables
global numPlayers;
global txt;


%Get screensize
screensize = get(0,'ScreenSize');
xScale = screensize(3)/1280;
yScale = screensize(4)/1080;

%Draw figure and set figure settings
handles(224) = figure(6);
set(handles(224),'Name','Names');
set(handles(224),'Toolbar','none');
set(handles(224),'Resize','off');
set(handles(224), 'MenuBar', 'none');
set(handles(224),'NumberTitle','off');
set(handles(224),'Position',[(1280/2-150)*xScale,(1080/2-75)*yScale,300*xScale,(90+20*numPlayers)*yScale]);
axis off; axis square;

%Display Players names
for k=1:numPlayers
    txttodisplay=strcat('Player',{' '},num2str(numPlayers-k+1),{': '},txt{k});
    handles(k+224) = uicontrol(handles(224),'Style','text',...
                'String',txttodisplay,...
        'Position',[70*xScale (25*k+30)*yScale 160*xScale 20*yScale]);
end

%Draw Buttons
%Exit Button
uicontrol(handles(224),'Style','PushButton',...
    'Position',[150*xScale 10*yScale 75*xScale 25*yScale],...
    'String','Next',...
    'Callback',{@ButtonNextFcn,3});
%Next Button
uicontrol(handles(224),'Style','PushButton',...
    'Position',[70*xScale 10*yScale 75*xScale 25*yScale],...
    'String','Back',...
    'Callback',{@ButtonbackFcn,3});

return;
%--------------------------------------------------------------------------
function ButtonNextFcn(~,~,Id)
%This function will random the players
global numPlayers;
global handles;
global txt;
%call variables
if Id == 1 || Id == 2
    
    %Intialise variables
    txt = cell(numPlayers,1);
    if Id == 1
        ranPlayers = randperm(numPlayers);
    else
        ranPlayers = 1:numPlayers;
    end
    count = 119+numPlayers;
    
    %Store textbox data
    for k = 1:numPlayers
        if strcmp(get(handles(count-k),'String'),'Enter name')
            txt{numPlayers-ranPlayers(k)+1} =strcat('Player',{' '},...
                num2str(ranPlayers(k)));
        else
            txt{numPlayers-ranPlayers(k)+1}= get(handles(count-k),'String');
        end
        guidata(handles(count-k), txt{numPlayers-ranPlayers(k)+1});
 
    end
    
    %destroy figure
    closereq;
    %call next figure
    FigCfmPlayer();
else
    closereq;
    FigInitializeBoard();
end

return;
%-------------------------------------------------------------------------
function Text_DisplayStatus(str)
%This function updates the status text at the bottom of the game board.

%Call object handler
global handles;
if ~isempty(handles(97)) && ishandle(handles(97))
set(handles(97),'String',str);
end
return;
%---------------------------------------------------------------------
function Text_displayTurn(turn)
%This function display the status of who's turn is it to play
global txt
global numPlayers

if isempty(txt)
       txt = cell(numPlayers,1);
       txt{numPlayers-1+1} = 'Player 1';
       txt{numPlayers-2+1} = 'Player 2';
end
switch turn
    case 'P1'
        k = 1;
        Text_DisplayStatus(strcat(txt{numPlayers-k+1},'''s Turn(RED)'));
    case 'P2'
        k = 2;
        Text_DisplayStatus(strcat(txt{numPlayers-k+1},'''s Turn(BLUE)'));
    case 'P3'
        k = 3;
        Text_DisplayStatus(strcat(txt{numPlayers-k+1},'''s Turn(GREEN)'));
    case 'P4'
        k = 4;
        Text_DisplayStatus(strcat(txt{numPlayers-k+1},'''s Turn(YELLOW)'));
end
return;
%---------------------------------------------------------------------

%calculations starts here
%---------------------------------------------------------------------
function gameOver = gameState(board)
%This function checks if a player has won

%Declare variable
global endGameVec;
%Intialise variables
endGameVec = zeros(1,5) ;

%Determine size of board input
c = length(board);
c = c -4;

%Break board down
for m = 1:c
    for n = 1:c
        %Break board down in to 5x5 matrix
        selectMatrix = board(m:m+4,n:n+4);
        %Reset Diagonals
        VecDiagonal_1 = zeros(1,5);
        VecDiagonal_2 = zeros(1,5);
        %5x5 matrix down further into vectors
        for i = 1:5
            VecRow = selectMatrix(i,:);
            VecCol = selectMatrix(:,i);
            VecDiagonal_1(i) = selectMatrix(i,i);
            VecDiagonal_2(i) = selectMatrix(i,6-i);
            
            %Check if there is a winner
            gameState_chkFoWin(VecRow);
            gameState_chkFoWin(VecCol);
            if numel(VecDiagonal_1) == 5 && numel(VecDiagonal_2)== 5
                gameState_chkFoWin(VecDiagonal_1);
                gameState_chkFoWin(VecDiagonal_2);
            end
        end
    end
end

%Return state of the game
gameOver =gameState_Text(endGameVec);

return;
%---------------------------------------------------------------------
function rotMatrix(selectMatrix,direction)
%This function rotates the subboard from the selected matrix

%Call variables
global board;
global size;

%Breakdown main board into 3x3 sub boards
matrix1= board(1:3,1:3);
matrix2= board(1:3,4:6);
if size == 6
    matrix3= board(4:6,1:3);
    matrix4= board(4:6,4:6);
else
    matrix3= board(1:3,7:9);
    matrix4= board(4:6,1:3);
    matrix5= board(4:6,4:6);
    matrix6= board(4:6,7:9);
    matrix7= board(7:9,1:3);
    matrix8= board(7:9,4:6);
    matrix9= board(7:9,7:9);
end

%Determine which subboard is to be rotated
switch selectMatrix
    
    case 1
        editMatrix = matrix1;
    case 2
        editMatrix = matrix2;
    case 3
        editMatrix = matrix3;
    case 4
        editMatrix = matrix4;
    case 5
        editMatrix = matrix5;
    case 6
        editMatrix = matrix6;
    case 7
        editMatrix = matrix7;
    case 8
        editMatrix = matrix8;
    case 9
        editMatrix = matrix9;
    otherwise
        
end

%Rotate subboards
if direction == 90
    editMatrix = rot90(editMatrix);
else
    editMatrix = rot90(rot90(rot90(editMatrix)));
end
switch selectMatrix
    
    case 1
        matrix1 = editMatrix;
    case 2
        matrix2 = editMatrix;
    case 3
        matrix3 = editMatrix;
    case 4
        matrix4 = editMatrix;
    case 5
        matrix5 = editMatrix;
    case 6
        matrix6 = editMatrix;
    case 7
        matrix7 = editMatrix;
    case 8
        matrix8 = editMatrix;
    case 9
        matrix9 = editMatrix;
    otherwise
        
end

%return subboard to main board
switch size
    case 6
        board = ([matrix1 matrix2 ; matrix3 matrix4]);
    case 9
        board = ([matrix1 matrix2 matrix3; matrix4 matrix5 matrix6; matrix7 matrix8 matrix9]);
end

return;
%---------------------------------------------------------------------
function [x,y] = DrawArrows()
%This function draws the arrows for rotation

%This variable determine the size of the arrow drawn
scale = 0.2;

%Calculate points to draw arrows

x0=0;
y0=0;

a=1*scale + 0.1;
b=1*scale + 0.1;
t=0:0.01:pi;
x1=x0+a*cos(t);
y1=y0+b*sin(t);

a=1*scale -0.05 ;
b=1*scale -0.05 ;
x2=x0+a*cos(t);
y2=y0+b*sin(t);

x2 = fliplr(x2);
y2 = fliplr(y2);

x3 = [ -0.3 -1 0 1 -0.15]*scale;
y3 = [0 0 1 0 0]*scale;
x3 = x3 + 0.225 ;
x3 = fliplr(x3);
y3 = fliplr(y3);

rot = 180*pi/180;
x3 = x3*cos(rot)-y3 *sin(rot);
y3 = x3*sin(rot)+y3*cos(rot);

x = [x1 x3 x2];
y = [y1 y3 y2];

%rotate arrows
rot = -30*pi/180;

%return values to draw arrows
x = x*cos(rot)-y *sin(rot);
y = x*sin(rot)+y*cos(rot);

return;
%---------------------------------------------------------------------
function PlayerSwitch()
%This function switch the players turn

%Call variables
global turn;
global numPlayers;
global prevTurn;
prevTurn = turn;

%switch player's turns
switch turn
    case 'P1'
        Text_displayTurn(turn);
        turn = 'P2';
    case 'P2'
        Text_displayTurn(turn);
        if numPlayers == 2
            turn = 'P1';
        else
            turn = 'P3';
        end
        
    case 'P3'
        Text_displayTurn(turn);
        if numPlayers == 3
            turn = 'P1';
        else
            turn = 'P4';
        end
        
    case 'P4'
        Text_displayTurn(turn);
        turn = 'P1';
        
end


return;
%---------------------------------------------------------------------
function gameState_chkFoWin(Vec)
%This is a subfunction of gameState to help calculate if there are 5 pieces
%of the same color aligned together

%Check size of vector
[row,col] = size(Vec);
if row > col
    Vec = Vec';
end

%Declare variable
persistent Win
%Call variable
global endGameVec;

%Check is win has been intialised
if isempty(Win) || isequal(endGameVec,false(1,5))
    Win = zeros(1,5);
end

%create a reference vector
refVec = ones(1,numel(Vec));
for i = 1:5
    %check if pieces in the vector are aligned
    if Vec == i*refVec
        Win(i+1) = true;
    end
end

%return game state as a vector
endGameVec = Win;

return;
%---------------------------------------------------------------------
function gameOver = gameState_Text(gameStateVec)
%This function display the status text when the game has ended

%Call object handler
global handles;
global txt;
global numPlayers;
%Call variables
global board;

%Break down the vector
P1win = gameStateVec(2);
P2win = gameStateVec(3);
P3win = gameStateVec(4);
P4win = gameStateVec(5);

%Check if 2 or more players have won
if sum(gameStateVec)>= 2
    Text_DisplayStatus('Tie Game!');
    gameOver = true;
elseif P1win == true
    k = 1;
    Text_DisplayStatus(strcat(txt{numPlayers-k+1},{' '},'Wins!'))    
    gameOver = true;
elseif P2win == true
    k = 2;
    Text_DisplayStatus(strcat(txt{numPlayers-k+1},{' '},'Wins!'))    
    gameOver = true;
elseif P3win == true
    k = 3;
    Text_DisplayStatus(strcat(txt{numPlayers-k+1},{' '},'Wins!'))   
    gameOver = true;
elseif P4win == true
    k = 4;
    Text_DisplayStatus(strcat(txt{numPlayers-k+1},{' '},'Wins!'))   
    gameOver = true;
    
else
    gameOver = false;
end

%Check if board has been filled up
minimum = min(min(abs(board)));

if minimum > 0
    gameOver = true;
    Text_DisplayStatus('Draw Game!')
end

%Flash the text 3 times
if gameOver == true
    for i=1:3
        pause(0.2);
        set(handles(97),'Color','r');
        pause(0.2);
        set(handles(97),'Color','w');
    end
pause(3);   
end


return;
%---------------------------------------------------------------------

%Bot program starts from here
function Trollbot()
k = randi([1 2]);

switch k
    case 1
        
        
        Text_DisplayStatus('Let me thinking...');
        pause(2.5);
        Text_DisplayStatus('Wah liao damn lazy to play sia...');
        pause(2);
        Text_DisplayStatus('$#@%$#^%#^%$...');
        pause(1.5);
        Text_DisplayStatus('Sigh...');
        pause(0.7);
        case 2
        Text_DisplayStatus('Hmm.... Ai ya let u win lah can');
        pause(2.5);
        Text_DisplayStatus('qui qui ni lah');
        pause(2);
        Text_DisplayStatus('wo bu xiang wan le');
        pause(1.5);
        Text_DisplayStatus('Sigh...');
        pause(0.7);
        
        case 3
        Text_DisplayStatus('Bonjour....');
        pause(2.5);
        Text_DisplayStatus('Je suis un robot stupide');
        pause(2);
        Text_DisplayStatus('S''il vous plaît me donner la chance');
        pause(1.5);
        Text_DisplayStatus('Merci...');
        pause(0.7);
    otherwise
        Text_DisplayStatus('CPU Thinking very hard...');
        pause(2.5);
        Text_DisplayStatus('Hmm... give me somemore time...');
        pause(2);
        Text_DisplayStatus('This is too hard...');
        pause(1.5);
        Text_DisplayStatus('Oh well...');
        pause(0.7);
end

return;
%---------------------------------------------------------------------
function [selectMatrix,rotation] = rotation_Converter(toRotate)

switch toRotate
    case{1,2}
        selectMatrix = 2;
    case{3,4}
        selectMatrix = 4;
    case{5,6}
        selectMatrix = 3;
    case{7,8}
        selectMatrix = 1;
        
end

if mod(toRotate,2) == 0
    rotation = 90;
else
    rotation = 91;
end
return;
