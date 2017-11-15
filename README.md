# Pentago-with-XL
![Alt text](Picture1.png?raw=true)

Pentago is a two-player abstract strategy game invented by Tomas Flodén. The Swedish company Mindtwister has the rights of developing and commercializing the product.  The game is played on a 6×6 board divided into four 3×3 sub-boards (or quadrants). Taking turns, the two players place a marble of their color (either black or white) onto an unoccupied space on the board, and then rotate one of the sub-boards by 90 degrees either clockwise or anti-clockwise. A player wins by getting five of their marbles in a vertical, horizontal or diagonal row (either before or after the sub-board rotation in their move). If all 36 spaces on the board are occupied without a row of five being formed then the game is a draw.  There is also a 3-4 player version called Pentago XL. The board is made of 9 3×3 boards.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

1) A copy of Matlab

### Running the program

1) Download all the files in the repository
2) Open `PentagoV1R.m` 

## Development of Minimax Algorithm

The development of the minimax algorithm code with alpha-beta punning is written in the file  `make_a_move_computer.m`.
The function call for the minimax algorithm is as follow:
```
[ pos_played,rotation_played ] = make_a_move_computer( board , who_to_play )
```
## Gameplay
The instructions to play the game is as follow:

1)
  ![Alt text](Instuction1.png?raw=true)

2)
  ![Alt text](Instuction2.png?raw=true)

3)
  ![Alt text](Instuction3.png?raw=true)

4)
  ![Alt text](Instuction4.png?raw=true)

## Deployment

Alternatively, the program can be deployed by installing:
1) MATLAB Runtime R2016a (9.01)  
    * [Windows](http://ssd.mathworks.com/supportfiles/downloads/R2016a/deployment_files/R2016a/installers/win64/MCR_R2016a_win64_installer.exe)
    * [Linux](http://ssd.mathworks.com/supportfiles/downloads/R2016a/deployment_files/R2016a/installers/glnxa64/MCR_R2016a_glnxa64_installer.zip)
    * [Mac](http://ssd.mathworks.com/supportfiles/downloads/R2016a/deployment_files/R2016a/installers/maci64/MCR_R2016a_maci64_installer.zip)
2) [`PENTAGO_DEMO.exe`](https://github.com/albusSimba/Pentago-with-XL/raw/master/PENTAGO_DEMO/for_testing/PENTAGO_DEMO.exe) 

## Built With

* [Matlab]( https://www.mathworks.com/?s_tid=gn_logo) – Development IDE 

## Authors
* **Ryan Seah ** - *Initial work* - [albusSimba]( https://github.com/albusSimba)
## License
The project is free for non-commercial purposes.
## Acknowledgments

* Adapted from Dan Massie [Pentago]( https://www.mathworks.com/matlabcentral/fileexchange/20636-pentago?requestedDomain=www.mathworks.com)

