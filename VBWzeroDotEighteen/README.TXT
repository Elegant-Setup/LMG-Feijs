README (C) Loe Feijs and TU/e 2013.

The program runs in Processing 2.0
Install Processing from Processing.org first.
The code is in 10 files of type pde.
The code files must be in one directory with the same name as the main file.
Open the main file in Processing and press the Play button, or run by Sketch > Run. 
The output can be captured as a pdf file by pressing key 'p' after circa 25 seconds of development.
Or it can be captured with PRINTSCREEN, copy-pasted into Microsoft Paint and stored as BMP file.
The program was tested on Windows 7.

Code files:

Atom.pde
Canvas.pde
Cell.pde
Color.pde
HLine.pde
Micro.pde
Mini.pde
Quad.pde
VLine.pde
VBW + version number (this is the main file).

Extra files:

README.TXT (this file)
Een Programma voor Victory Boogie Woogie.pdf (design documentation)
canvas + seed number.pdf (Loe's favourite output so far)

The following keys control the behaviour of the program:

'b' boxing (toggle), draw boxes around cells
'c' count total number of cells
'e' exit program (result is gone, but replay with reported seed is possible)
'f' freeze (toggle)
'g' grow one step (when frozen)
'o' old look (toggle), add some speckles and rough edges - rather slow
'p' print, create a pdf file in the same directory as the pde
's' speedy(toggle), develop faster by skipping drawing steps
't' tell, report all cells in ASCII in console area
'x' x-ray (toggle), "rontgen", show gridlines and cell-centers
'z' start all over (depending on seed, -1 is random, see first line in main file).

The following variables in the prelude of the main file could be set to true if desired:

seed = 72; (-1 means random, note the reported seed in the console area)
boolean speedy = false;
boolean rontgen = false;
boolean frozen = false; 
boolean oldlook = false;
boolean boxing = false;
boolean sketchFullScreen(){ return false;}

