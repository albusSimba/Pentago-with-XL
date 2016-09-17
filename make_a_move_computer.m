function [ pos_played,rotation_played ] = make_a_move_computer( board , who_to_play )
tic
callLines();
rng('shuffle');
countEmpty = numel(find(board == 0));

display('make_a_move_computer2');
if countEmpty > 32
    [ pos_played,rotation_played ] = Cheat(board,countEmpty,who_to_play);
else
    if who_to_play == 1
        [pos_played,rotation_played ] = max_min(board,countEmpty,who_to_play);
    else
        [pos_played,rotation_played ] = min_max(board,countEmpty,who_to_play);
    end
    
end
toc
return;
%--------------------------------------------------------------------------
function returnlogger = P1maximise(board,countEmpty)

emptyPos = find(board == 0);

logger = zeros(0,4);

for k = 1:countEmpty
    editBoard1 = board;
    editBoard1(emptyPos(k)) = 1;
   
    rotation = 1;
    while rotation < 9
        rotBoard1 = RotBoard(rotation,editBoard1);
        [P1score,P2score] = ScoreChker(rotBoard1);
        
        currmaxP1score = max(P1score);
        currmaxP2score = max(P2score);
        
        if isempty(logger)
            logger(1,:) = [currmaxP1score currmaxP2score emptyPos(k) rotation];
        elseif logger(1,end) <= currmaxP1score
            logger(end+1,:) = [currmaxP1score currmaxP2score emptyPos(k) rotation]; %#ok<*AGROW>
        end
        
        if isequal(rotBoard1,editBoard1)
            rotation = rotation + 2;
        else
            rotation = rotation + 1;
        end
        
    end
    
end

%maximise P1
maxP1score = max(logger(:,1));
maxP2score = max(logger(:,2));

if maxP1score >= maxP2score

%Remove rows without max P1 score
logger = logger(logger(:,1) == maxP1score,:);

%minimise P2
minP2score = min(logger(:,2));

logger = logger(logger(:,2) == minP2score,:);

countRows = numel(logger(:,1));
if  countRows > 1
    for i = 1:countRows
        
        zeroBoard = zeros(6);
        zeroBoard(logger(i,3)) = 1;
        zeroBoard = RotBoard(logger(i,4),zeroBoard);
        refBoard = RotBoard(logger(i,4),board);
        endPos = find(zeroBoard == 1);
        numIntersect = countIntersect(endPos,refBoard);
        relogger(i,:) = [numIntersect logger(i,:)];
    end
    relogger = sortrows(relogger);
    returnlogger = relogger(:,2:end);
    %pos_played = relogger(end,end-1);
    %rotation_played = relogger(end,end); 
else
    returnlogger = logger;
    %pos_played = logger(end,end-1);
    %rotation_played = logger(end,end);  
end
else
    minP2score = min(logger(:,2));
    %Remove rows without min P1 score
    logger = logger(logger(:,2) == minP2score,:);
   
    countRows = numel(logger(:,1));
    if  countRows > 1
        for i = 1:countRows
            
            zeroBoard = zeros(6);
            zeroBoard(logger(i,3)) = 1;
            zeroBoard = RotBoard(logger(i,4),zeroBoard);
            refBoard = board;
            %refBoard(logger(i,3)) = 2;
            %refBoard = RotBoard(logger(i,4),refBoard);
            endPos = find(zeroBoard == 1);
            numDistruction = countLinesDestroyed(endPos,refBoard);
            relogger(i,:) = [numDistruction logger(i,:)];
        end
        relogger = relogger(relogger(:,1) == max(relogger(:,1)),:);
        %relogger = relogger(relogger(:,3) == max(relogger(:,3)),:);
        
        relogger = sortrows(relogger);
        
        returnlogger = relogger(:,2:end);
    else
        returnlogger = logger;

    end
    
end

return
%--------------------------------------------------------------------------
function returnlogger = P2minimise(board,countEmpty)


emptyPos = find(board == 0);

logger = zeros(0,4);

for k = 1:countEmpty
    editBoard1 = board;
    editBoard1(emptyPos(k)) = 2;
    rotation = 1;
    while rotation < 9
        rotBoard1 = RotBoard(rotation,editBoard1);
        [P1score,P2score] = ScoreChker(rotBoard1);
        
        currmaxP1score = max(P1score);
        currmaxP2score = max(P2score);
        
        if isempty(logger)
            logger(1,:) = [currmaxP1score currmaxP2score emptyPos(k) rotation];
        else
            logger(end+1,:) = [currmaxP1score currmaxP2score emptyPos(k) rotation];
        end
        
        if isequal(rotBoard1,editBoard1)
            rotation = rotation + 2;
        else
            rotation = rotation + 1;
        end
        
    end
    
end

%maximise P2
maxP1score = max(logger(:,1));
maxP2score = max(logger(:,2));

if maxP1score < maxP2score
    %Remove rows without max P1 score
    logger = logger(logger(:,2) == maxP2score,:);
    
    %minimise P2
    minP1score = min(logger(:,1));
    %added + 1
    logger = logger(logger(:,1) <= minP1score + 1,:);
    
    countRows = numel(logger(:,1));
    if  countRows > 1
        for i = 1:countRows
            
            zeroBoard = zeros(6);
            zeroBoard(logger(i,3)) = 1;
            zeroBoard = RotBoard(logger(i,4),zeroBoard);
            refBoard = RotBoard(logger(i,4),board);
            endPos = find(zeroBoard == 1);
            numIntersect = countIntersect(endPos,refBoard);
            relogger(i,:) = [numIntersect logger(i,:)];
        end
        relogger = sortrows(relogger);
        
        returnlogger = relogger(:,2:end);        
    else
        returnlogger = logger;
    end
else
    minP1score = min(logger(:,1));
    %Remove rows without min P1 score
    logger = logger(logger(:,1) <= minP1score,:);
   
    countRows = numel(logger(:,1));
    if  countRows > 1
        for i = 1:countRows
            
            zeroBoard = zeros(6);
            zeroBoard(logger(i,3)) = 1;
            zeroBoard = RotBoard(logger(i,4),zeroBoard);
            refBoard = board;
            %refBoard(logger(i,3)) = 2;
            %refBoard = RotBoard(logger(i,4),refBoard);
            endPos = find(zeroBoard == 1);
            numDistruction = countLinesDestroyed(endPos,refBoard);
            relogger(i,:) = [numDistruction logger(i,:)];
        end
        relogger = relogger(relogger(:,1) == max(relogger(:,1)),:);
        %relogger = relogger(relogger(:,3) == max(relogger(:,3)),:);
        
        relogger = sortrows(relogger);
     
        returnlogger = relogger(:,2:end);
    else
        returnlogger = logger;

    end
    
end
return
%--------------------------------------------------------------------------
function [pos_played,rotation_played ] = max_min(board,countEmpty,who_to_play)

logger = P1maximise(board,countEmpty);
countMoves = numel(logger(:,3));

if countMoves > 80 || countEmpty == 34
logger = findDefensiveMoves(board,logger);
countMoves = numel(logger(:,3));
end

if max(logger(:,1)) ~= 5
    for k = 1:countMoves
        editBoard1 = board;
        editBoard1(logger(k,3)) = who_to_play;
        editBoard1 = RotBoard(logger(k,4),editBoard1);
        edit1Empty = numel(find(editBoard1 == 0));
        P2logger1 = P2minimise(editBoard1,edit1Empty);
        if ~isempty(P2logger1)
            logger(k,1) = max(P2logger1(:,1));
            logger(k,2) = min(P2logger1(:,2));
        end
    end
end
%maximise P1
maxP1score = max(logger(:,1));
maxP2score = max(logger(:,2));

if maxP1score >= maxP2score

%Remove rows without max P1 score
logger = logger(logger(:,1) == maxP1score,:);

%minimise P2
minP2score = min(logger(:,2));

logger = logger(logger(:,2) == minP2score,:);

countRows = numel(logger(:,1));
if  countRows > 1
    for i = 1:countRows
        
        zeroBoard = zeros(6);
        zeroBoard(logger(i,3)) = 1;
        zeroBoard = RotBoard(logger(i,4),zeroBoard);
        refBoard = RotBoard(logger(i,4),board);
        endPos = find(zeroBoard == 1);
        numIntersect = countIntersect(endPos,refBoard);
        relogger(i,:) = [numIntersect logger(i,:)];
    end
    relogger = sortrows(relogger);
    pos_played = relogger(end,end-1);
    rotation_played = relogger(end,end); 
else
    pos_played = logger(end,end-1);
    rotation_played = logger(end,end);  
end
else
    minP2score = min(logger(:,2));
    %Remove rows without min P1 score
    logger = logger(logger(:,2) == minP2score,:);
   
    countRows = numel(logger(:,1));
    if  countRows > 1
        for i = 1:countRows
            
            zeroBoard = zeros(6);
            zeroBoard(logger(i,3)) = 1;
            zeroBoard = RotBoard(logger(i,4),zeroBoard);
            refBoard = board;
            %refBoard(logger(i,3)) = 2;
            %refBoard = RotBoard(logger(i,4),refBoard);
            endPos = find(zeroBoard == 1);
            numDistruction = countLinesDestroyed(endPos,refBoard);
            relogger(i,:) = [numDistruction logger(i,:)];
        end
        relogger = relogger(relogger(:,1) == max(relogger(:,1)),:);
        %relogger = relogger(relogger(:,3) == max(relogger(:,3)),:);
        
        relogger = sortrows(relogger);
        %display(relogger)
        pos_played = relogger(end,end-1);
        rotation_played = relogger(end,end);
    else
        pos_played = logger(end,end-1);
        rotation_played = logger(end,end);
    end
    
end

return
%--------------------------------------------------------------------------
function [pos_played,rotation_played ] = min_max(board,countEmpty,who_to_play)


logger = P2minimise(board,countEmpty);
countMoves = numel(logger(:,3));

if countMoves > 80
logger = findDefensiveMoves(board,logger);
countMoves = numel(logger(:,3));
end
%display(sortrows(logger))


if max(logger(:,2)) ~= 5
    
    startTime = cputime;
    
    for k = 1:countMoves
        editBoard1 = board;
        editBoard1(logger(k,3)) = who_to_play;
        editBoard1 = RotBoard(logger(k,4),editBoard1);
        edit1Empty = numel(find(editBoard1 == 0));
        P1logger1 = P1maximise(editBoard1,edit1Empty);
        if ~isempty(P1logger1)
            logger(k,1) = max(P1logger1(:,1));
            logger(k,2) = min(P1logger1(:,2));
        end
        if cputime-startTime > 14
            break
        end
        
    end
end

%maximise P2
maxP1score = max(logger(:,1));
maxP2score = max(logger(:,2));

if maxP1score < maxP2score
    %Remove rows without max P1 score
    logger = logger(logger(:,2) == maxP2score,:);
    
    %minimise P2
    minP1score = min(logger(:,1));
    
    logger = logger(logger(:,1) == minP1score,:);
  
    countRows = numel(logger(:,1));
    if  countRows > 1
        for i = 1:countRows
            
            zeroBoard = zeros(6);
            zeroBoard(logger(i,3)) = 1;
            zeroBoard = RotBoard(logger(i,4),zeroBoard);
            refBoard = RotBoard(logger(i,4),board);
            endPos = find(zeroBoard == 1);
            numIntersect = countIntersect(endPos,refBoard);
            relogger(i,:) = [numIntersect logger(i,:)];
            
        end
        relogger = sortrows(relogger);
        pos_played = relogger(end,end-1);
        rotation_played = relogger(end,end);
    else
        pos_played = logger(end,end-1);
        rotation_played = logger(end,end);
    end
else
    minP1score = min(logger(:,1));
    %Remove rows without min P1 score
    logger = logger(logger(:,1) == minP1score,:);
    
    countRows = numel(logger(:,1));
    if  countRows > 1
        for i = 1:countRows
            
            zeroBoard = zeros(6);
            zeroBoard(logger(i,3)) = 1;
            zeroBoard = RotBoard(logger(i,4),zeroBoard);
            refBoard = board;
            %refBoard(logger(i,3)) = 2;
            %refBoard = RotBoard(logger(i,4),refBoard);
            endPos = find(zeroBoard == 1);
            numDistruction = countLinesDestroyed(endPos,refBoard);
            relogger(i,:) = [numDistruction logger(i,:)];
        end
        relogger = relogger(relogger(:,1) == max(relogger(:,1)),:);
        relogger = sortrows(relogger);
        pos_played = relogger(end,end-1);
        rotation_played = relogger(end,end);
        
        
    else
        pos_played = logger(end,end-1);
        rotation_played = logger(end,end);
        
    end
end

return
%--------------------------------------------------------------------------
function numDistruction = countLinesDestroyed(~,board) 

global lines

lines_translation = zeros(32,5);


for k = 1:32
    lines_translation(k,:) = board(lines(k,:));
end

[P1row,~] = find(lines_translation == 1);
[P2row,~] = find(lines_translation == 2);

destroyedLines = lines(intersect(P1row,P2row),:);

numDistruction = numel(destroyedLines);

return
%--------------------------------------------------------------------------
function numIntersect = countIntersect(endPos,board)
global lines

lines_translation = zeros(32,5);

for k = 1:32
    lines_translation(k,:) = board(lines(k,:));
end

[P1row,~] = find(lines_translation == 1);
[P2row,~] = find(lines_translation == 2);

destroyedLines = lines(intersect(P1row,P2row),:);
remLines = setdiff(lines,destroyedLines,'rows');

numIntersect = numel(find(remLines == endPos));

return
%--------------------------------------------------------------------------
function [ pos_played,rotation_played ] = Cheat(Board,currEmpty,who_to_play)
if currEmpty == 36
    pos = [8,26,11,29,15,21,22,16];
    rot = [1,7,3,5,3,7,7,3];
    r = randi([1 length(pos)]);
    pos_played = pos(r) ;
    rotation_played = rot(r);

    
    %{
    if Board(22) == 0
        pos_played = 22;
        rotation_played = 7;
    elseif Board(16) == 0
        pos_played = 16;
        rotation_played = 3;
    end
    %}
elseif who_to_play == 1
    if Board(8) == 1 || Board(29) == 1 || Board(26) == 1|| Board(11) == 1
        if Board(8) == 1
            if Board(29) == 0
                pos_played = 29;
                rotation_played = 4;
            elseif Board(26) == 0
                pos_played = 26;
                rotation_played = 1;
            elseif Board(11) == 0
                pos_played = 11;
                rotation_played = 6;
            end
        elseif Board(29) == 1
            if Board(8) == 0
                pos_played = 8;
                rotation_played = 8;
                
            elseif Board(26) == 0
                pos_played = 26;
                rotation_played = 2;
            elseif Board(11) == 0
                pos_played = 11;
                rotation_played = 6;
            end
            
        elseif Board(26) == 1
            if Board(11) == 0
                pos_played = 11;
                rotation_played = 6;
            elseif Board(8) == 0
                pos_played = 8;
                rotation_played = 8;
            elseif Board(29) == 0
                pos_played = 29;
                rotation_played = 4;
            end
            
        elseif Board(11) == 1
            if Board(26) == 0
                pos_played = 26;
                rotation_played = 2;
            elseif Board(8) == 0
                pos_played = 8;
                rotation_played = 8;
            elseif Board(29) == 0
                pos_played = 29;
                rotation_played = 4;
                
            end
        end
    else
        [pos_played,rotation_played ] = max_min(Board,currEmpty,who_to_play);
    end
else
    [ pos_played,rotation_played ] = P2Cheat(Board,currEmpty,who_to_play);
end

if Board(pos_played) ~= 0
     if who_to_play == 1
        [pos_played,rotation_played ] = max_min(Board,currEmpty,who_to_play);
    else
        [pos_played,rotation_played ] = min_max(Board,currEmpty,who_to_play);
    end
    
end
return;
%--------------------------------------------------------------------------
function [ pos_played,rotation_played ] = P2Cheat(Board,currEmpty,who_to_play)

subBoard1 = Board(1:3,1:3);
subBoard4 = Board(4:6,4:6);


if currEmpty == 35 && (Board(15) == 1 || Board(16) == 1 || Board(21) == 1 || Board(22) == 1)
    if Board(15) == 1
        pos_played = 21;
        rotation_played = 7;
    elseif Board(16) == 1
        pos_played = 22;
        rotation_played = 6;
    elseif Board(21) == 1
        pos_played = 15;
        rotation_played = 2;
    elseif Board(22) == 1
        pos_played = 16;
        rotation_played = 3;
        
    end
    
elseif currEmpty == 35 && (Board(1) == 1 || Board(6) == 1 || Board(31) == 1 || Board(36) == 1)
    if Board(1) == 1
        pos_played = 21;
        rotation_played = 8;
    elseif Board(31) == 1
        pos_played = 15;
        rotation_played = 1;
    elseif Board(6) == 1
        pos_played = 22;
        rotation_played = 5;
    elseif Board(36) == 1
        pos_played = 16;
        rotation_played = 4;
        
    end
elseif currEmpty == 35 && (Board(3) == 1 || Board(4) == 1 || Board(33) == 1 || Board(34) == 1)
    if Board(3) == 1
        pos_played = 21;
        rotation_played = 3;
    elseif Board(4) == 1
        pos_played = 22;
        rotation_played = 7;
    elseif Board(33) == 1
        pos_played = 15;
        rotation_played = 5;
    elseif Board(34) == 1
        pos_played = 16;
        rotation_played = 1;
        
    end
    
elseif ((sum(sum(subBoard1 == 2)) == 2 || sum(sum(subBoard1 == 1)) == 2) && Board(8)~=0) ...
        || ((sum(sum(subBoard4 == 2)) == 2 || sum(sum(subBoard4 == 1)) == 2) && Board(29)~=0)
    if who_to_play == 1
        [pos_played,rotation_played ] = max_min(Board,currEmpty,who_to_play);
    else
        [pos_played,rotation_played ] = min_max(Board,currEmpty,who_to_play);
    end
    
elseif currEmpty>32
    if who_to_play == 2 && currEmpty == 35
        if Board(8) == 1
            pos_played = 29;
            rotation_played = 4;
        elseif Board(26) == 1
            pos_played = 11;
            rotation_played = 6;
        elseif Board(11) == 1
            pos_played = 26;
            rotation_played = 2;
        elseif Board(29) == 1
            pos_played = 8;
            rotation_played = 8;
        elseif Board(8) == 0
            pos_played = 8;
            rotation_played = 8;
        elseif Board(29) == 0
            pos_played = 29;
            rotation_played = 4;
        elseif Board(26) == 0
            pos_played = 26;
            rotation_played = 2;
        elseif Board(11) == 0
            pos_played = 11;
            rotation_played = 6;
        end
    else
        if Board(8) == 0
            pos_played = 8;
            rotation_played = 8;
        elseif Board(29) == 0
            pos_played = 29;
            rotation_played = 4;
        elseif Board(26) == 0
            pos_played = 26;
            rotation_played = 2;
        elseif Board(11) == 0
            pos_played = 11;
            rotation_played = 6;
        else
            [pos_played,rotation_played ] = max_min(Board,currEmpty,who_to_play);
        end
    end
    
end

return;
%--------------------------------------------------------------------------
function callLines()
global lines;

lines = zeros(32,5);
count = 1;
%horizontal lines
for i = 0:5
 lines(count,:) = [1+i,7+i,13+i,19+i,25+i];
 count = count + 1;
 lines(count,:) = [7+i,13+i,19+i,25+i,31+i];
 count = count + 1;
end
%vertical lines

for i = 0:6:30
 lines(count,:) = [1+i,2+i,3+i,4+i,5+i];
 count = count + 1;
 lines(count,:) = [2+i,3+i,4+i,5+i,6+i];
 count = count + 1;
end
%Diagonals
for i = 0:6:6
 lines(count,:) = [1+i,8+i,15+i,22+i,29+i];
 count = count + 1;
 lines(count,:) = [2+i,9+i,16+i,23+i,30+i];
 count = count + 1;
end
%Cross Diagonals
for i = 0:6:6
 lines(count,:) = [5+i,10+i,15+i,20+i,25+i];
 count = count + 1;
 lines(count,:) = [6+i,11+i,16+i,21+i,26+i];
 count = count + 1;
end

return;
%--------------------------------------------------------------------------
function editboard = RotBoard(arrow,board)
%This function rotates the subboard from the selected matrix

subBoard1 = board(1:3,1:3);
subBoard2 = board(1:3,4:6);
subBoard3 = board(4:6,1:3);
subBoard4 = board(4:6,4:6);
switch arrow
    case 1
        subBoard2 = rot90(subBoard2,-1);
    case 2
        subBoard2 = rot90(subBoard2);
    case 3
        subBoard4 = rot90(subBoard4,-1);
    case 4
        subBoard4 = rot90(subBoard4);
    case 5
        subBoard3 = rot90(subBoard3,-1);
    case 6
        subBoard3 = rot90(subBoard3);
    case 7
        subBoard1 = rot90(subBoard1,-1);
    case 8
        subBoard1 = rot90(subBoard1);
end
editboard = [subBoard1 subBoard2; subBoard3 subBoard4];

return;
%--------------------------------------------------------------------------
function [P1score,P2score] = ScoreChker(board)
global lines

lines_translation = zeros(32,5);

for k = 1:32
    lines_translation(k,:) = board(lines(k,:));
end

[P1row,~] = find(lines_translation == 1);
[P2row,~] = find(lines_translation == 2);

destroyedLines = intersect(P1row,P2row);
remP1row = setdiff(P1row,destroyedLines,'rows');
remP2row = setdiff(P2row,destroyedLines,'rows');

if ~isempty(remP1row)
    P1score = sum(lines_translation(remP1row,:) == 1,2);
else
    P1score = 0;
end

if ~isempty(remP2row)
    P2score = sum(lines_translation(remP2row,:) == 2,2);
else
    P2score = 0;
end


return;
%--------------------------------------------------------------------------
function logger = findDefensiveMoves(matrix,currlogger)
[r1,c1] = find(matrix == 1);

for k = 1:numel(r1)
    for i = -1:1:1
        for j = -1:1:1
            if r1(k)+i > 0 && c1(k)+j> 0 && r1(k)+i < 7 && c1(k)+j < 7
                if matrix(r1(k)+i,c1(k)+j) == 0 || matrix(r1(k)+i,c1(k)+j) == -1
                    matrix(r1(k)+i,c1(k)+j) = -1;
                elseif matrix(r1(k)+i,c1(k)+j) < 0
                    matrix(r1(k)+i,c1(k)+j) = -3;
                end
            end
        end
    end
end

pos = find(matrix == -1);

logger = currlogger(ismember(currlogger(:,3),pos),:);

if isempty(logger)
    logger = currlogger;
end
return
