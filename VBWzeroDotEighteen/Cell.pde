//Copyright (C) <2013> <Loe Feijs and TU/e
class Cell {
final boolean verbose = false;

      String type;
      Cell parent = null;;
      Cell coparent = null;
      int xMin, xMax, yMin,yMax;
      Color clr; 
      boolean hori = false;  //if true, it tends to grow horizontally,
      boolean verti = false; //if true, it ill grow vertically as well
      boolean stoppi = false;//if true, it stops upon bumping on cell.
      float ratio = -1;
      int age = 0;
      int epsilon = 0; 
      int activation = 0;
      int midlifetrigger = 0;
      Cell cells[] = null; //for the recursive cells
      Cell bours[] = null; //for collision detection
      
      //Derived properties:
      int xCtr() { return (xMin + xMax)/2;}
      int yCtr() { return (yMin + yMax)/2;}
      int area(){ return (xMax - xMin) * (yMax - yMin);}
      float dydx() { return float(yMax - yMin) / max(.1,float(xMax - xMin));}
      int nesting() { if (parent == null) return 0; else return 1 + parent.nesting(); } 
      boolean biparental() { return (parent != null && coparent != null); }
      
      //CONCEPTION
      Cell (){
           type = "Cell";
      }
      void setxy(int x, int y){
           xMin = x - 1;
           xMax = x + 1;
           yMin = y - 1;
           yMax = y + 1;
      }
      void copy(Cell dst){
           //from this to destination
           dst.type = this.type;
           dst.parent = this.parent;
           dst.coparent = this.coparent;
           dst.xMin = this.xMin;
           dst.xMax = this.xMax;
           dst.yMin = this.yMin;
           dst.yMax = this.yMax;
           dst.clr = this.clr;
           dst.hori = this.hori;
           dst.verti = this.verti;
           dst.stoppi = this.stoppi;
           dst.ratio = this.ratio;
           dst.age  = this.age;
           dst.epsilon = this.epsilon;
           dst.activation = this.activation;
           dst.midlifetrigger = this.midlifetrigger;
           if (cells != null){
               dst.cells = new Cell[this.cells.length];
               for (int i=0; i<cells.length; i++) {
                    if (cells[i] != null){
                        dst.cells[i] = new Cell();
                        cells[i].copy(dst.cells[i]);
                    }
               }
           }
      }
      void insert(Cell c){
           //Put given Cell c in the first free slot of this.cells, if any
           if (cells != null){
               int i = 0;
               while (i < cells.length && cells[i] != null)
                      i++;
               if (i < cells.length)
                   cells[i] = c; 
                   else {println("Cell: INSERT FAILED");c.tell();} 
           }   else     {println("Cell: INSERT FAILED");c.tell();} 
      }
      
      void insertUnique(Cell c){
           //Like insert, but avoid duplicates with respect to x,y.
           //Intersection planes in case of twin VLines are tricky.
           boolean found = false;
           if (cells != null)
               for (int i = 0; i < cells.length; i++)
                    if (cells[i] != null)
                        if (cells[i].xCtr() == c.xCtr() && cells[i].yCtr() == c.yCtr())
                            found = true;
           if (!found) insert(c);
      }
      
      void insertCells(Cell c){
           //Apply typically for a quadruple object c, being useless
           //but carrying four cells, to be inserted into the canvas
           if (c.cells != null)
               for (int i = 0; i < c.cells.length; i++)
                    insert(c.cells[i]);    
      }
      void compress(){
           //get rid of superflupuous null entries in cells
           if (cells != null){
               int cnt = 0;
               int old = cells.length;
               for (int i = 0; i < cells.length; i++)
                    if (cells[i] != null)
                        cnt++;   
               Cell[] newcells = new Cell[cnt];
               int j = 0;
               for (int i = 0; i < cells.length; i++)
                    if (cells[i] != null)
                        newcells[j++] = cells[i];
               cells = newcells;
               for (int i = 0; i < cells.length; i++)
                    cells[i].compress();
               if (verbose) { print("Cell: compression gain = "); println(old - cnt);}
           }
      }

      //ANALYSIS
      final int LEFT__  = 0; //directions
      final int RIGHT_  = 1;
      final int UPWARD  = 2;
      final int DNWARD  = 3;
      
      boolean contains(int xOther, int yOther, int epsilon){
              //the cell is supposed to have an extra area of epsilon around it,
              //yields true if extended area of this cell contains the other point
              return (  (xOther >= xMin-epsilon && xOther <= xMax+epsilon)
                     && (yOther >= yMin-epsilon && yOther <= yMax+epsilon)
                     )   ; 
      }
      
      boolean boxed(){
              return (  ( coparent == null && paboxed() )
                     || ( coparent != null && (  paboxed() && coboxed()
                                              || paboxedXL(150) && coboxed()
                                              || paboxed() && coboxedXL(150)
                     )  )                     )  ;
      } 
      
      boolean paboxed() { 
              //whether this cells is boxed in the cell's parent
              return(  xMin >= parent.xMin && xMax <= parent.xMax 
                    && yMin >= parent.yMin && yMax <= parent.yMax 
                    )   ;
      } 
      
      boolean coboxed() { 
              //boxed in the cell's coparent
              return(  xMin >= coparent.xMin && xMax <= coparent.xMax 
                    && yMin >= coparent.yMin && yMax <= coparent.yMax 
                    )   ;
      }  
      
      boolean paboxedXL(int XL) { 
              //boxed in a strectched ("eXtra Large") version of the the cell's parent
              if (parent.hori)
              return(  xMin >= parent.xMin - XL && xMax <= parent.xMax + XL 
                    && yMin >= parent.yMin && yMax <= parent.yMax 
                    )   ;
              else if (parent.verti)
              return(  xMin >= parent.xMin && xMax <= parent.xMax 
                    && yMin >= parent.yMin - XL && yMax <= parent.yMax + XL
                    )   ;
              else return false;
      }  
      
      boolean coboxedXL(int XL) { 
              //boxed in the cell's coparent
              if (coparent.hori)
              return(  xMin >= coparent.xMin - XL && xMax <= coparent.xMax + XL 
                    && yMin >= coparent.yMin && yMax <= coparent.yMax 
                    )   ;
              else if (coparent.verti)
              return(  xMin >= coparent.xMin && xMax <= coparent.xMax 
                    && yMin >= coparent.yMin - XL && yMax <= coparent.yMax + XL 
                    )   ;
              else return false;
      }

      boolean bumped(Cell other, int epsilon){
              return 
                     (  contains(other.xMin,other.yMin,epsilon)
                     || contains(other.xMin,other.yMax,epsilon)
                     || contains(other.xMax,other.yMin,epsilon)
                     || contains(other.xMax,other.yMax,epsilon) 
                     )  ;
      }
      
      boolean bumped(Cell other, int epsilon, int richting){
              //eg richting==LEFT__ then bumped means colision around xMin side of this cell, etc.
              boolean b = false;
              int xMid = (xMin + xMax) / 2;
              int yMid = (yMin + yMax) / 2;
              int other_xMid = (other.xMin + other.xMax) / 2;
              int other_yMid = (other.yMin + other.yMax) / 2;
              switch (richting) {
              case LEFT__ :
                   b =    (  other.contains(xMin,yMin,epsilon) || this.contains(other.xMax,other.yMin,epsilon)
                          || other.contains(xMin,yMid,epsilon) || this.contains(other.xMax,other_yMid,epsilon)//new
                          || other.contains(xMin,yMax,epsilon) || this.contains(other.xMax,other.yMax,epsilon)
                          )  ; break;
              case RIGHT_ :
                   b =    (  other.contains(xMax,yMin,epsilon) || this.contains(other.xMin,other.yMin,epsilon)
                          || other.contains(xMax,yMid,epsilon) || this.contains(other.xMin,other_yMid,epsilon)//new
                          || other.contains(xMax,yMax,epsilon) || this.contains(other.xMin,other.yMax,epsilon)
                          )  ; break;
              case UPWARD :
                   b =    (  other.contains(xMin,yMax,epsilon) || this.contains(other.xMin,other.yMin,epsilon)
                          || other.contains(xMid,yMax,epsilon) || this.contains(other_xMid,other.yMin,epsilon)//new
                          || other.contains(xMax,yMax,epsilon) || this.contains(other.xMax,other.yMin,epsilon)
                          )  ; break;
              case DNWARD :
                   b =    (  other.contains(xMin,yMin,epsilon) || this.contains(other.xMin,other.yMax,epsilon)
                          || other.contains(xMid,yMin,epsilon) || this.contains(other_xMid,other.yMax,epsilon)//new
                          || other.contains(xMax,yMin,epsilon) || this.contains(other.xMax,other.yMax,epsilon)
                          )  ; break;
              }   
              return b && other.area() > 25; //was b && other.age > other.activation && !(other.clr.isWHITE()&&!this.clr.isGRIS());//a bit ad-hoc, admittedly    
      }
      
      boolean bumped(Cell[] others, int epsilon, int richting){
              boolean test = false;
              for (int i=0; i<others.length; i++)
                  if (others[i]!=null && others[i]!=this)
                      if (bumped(others[i],epsilon,richting)) 
                          test = true;
              return test;
      }

      boolean rated(){
              //i.e. respecting the ratio constraint
              float dx = max(0.01,xMax - xMin);
              float dy = yMax - yMin;
              return (  ratio < 0 
                     || (  dx < 5 && dy < 5 )//allow the small ones to start growing
                     || (  (0.8*ratio) <= dy/dx && dy/dx <= (1.2*ratio) )
                     )  ;
      }
      boolean twin(Cell other){
              return (xCtr() == other.xCtr() && xMin == other.xMin && xMax == other.xMax);   
      }
      
      //and a few auxiliaries for random choice:
      boolean PROB(float p) { return random(1.0) < p;   }       //true with probability p
      int RAND(int lo, int hi) { return int(floor(random(lo,hi+1))); }  //random in range
      int RAND(int hi) { return int(floor(random(0,hi+1))); } //random in range from zero
      
      //GROWTH
      //first the preparations for the efficient collision detection
      final int dt = 50; //bours must be who-ever is reachable in dx
                         //growth steps, so not beyond distance  2dx.
                         //The term dx means "long distance" (radio ham slang).
                         //The term "bours" is supposed to mean neighbour (but
                         //I wanted a word as long as "cells").
      int min8(int a, int b, int c, int d, int e, int f, int g, int h){
               int ab = min(a,b);
               int cd = min(c,d);
               int ef = min(e,f);
               int gh = min(g,h);
               int abcd = min(ab,cd);
               int efgh = min(ef,gh);
               return min(abcd,efgh);
      }
      int mindist(Cell c, Cell d){
          //this distance is like the manhattan distance, but
          //now taking the minimum instead of adding x and y.
          return min8( abs(c.xMin - d.xMin)
                     , abs(c.xMin - d.xMax)
                     , abs(c.xMax - d.xMin)
                     , abs(c.xMax - d.xMax)
                     , abs(c.yMin - d.yMin)
                     , abs(c.yMin - d.yMax)
                     , abs(c.yMax - d.yMin)
                     , abs(c.yMax - d.yMax)
                     ) ;           
      }
      void newbours(int dt){
           //recalculate the set of new neighbours,
           //ie the cells bump-able within dx steps
           bours = cells;
           if (cells != null){
               Cell newbours[] = new Cell[cells.length];
               int twodx = 2*dt;
               int j = 0;
               for (int i = 0; i < cells.length; i++)
                    if (cells[i] != null)
                        if (mindist(this,cells[i]) <= twodx)
                            newbours[j++] = cells[i];
               bours = new Cell[j];
               for (int i = 0; i < j; i++)
                    bours[i] = newbours[i];
            }  
      }
      
      void grow4self(){ 
           //Grow the cell but no cells inside this, just
           //check the others, the box and respect ratio.
           Cell[] others = parent.cells;
           if (verti){
               int step = 1;
               yMin-=step; if ( stoppi && bumped(others,epsilon,DNWARD )|| !boxed() || !rated()) yMin+=step; 
               yMax+=step; if ( stoppi && bumped(others,epsilon,UPWARD )|| !boxed() || !rated()) yMax-=step; 
           }  //so we do backtracking
           if (hori) {
               int step = 1;
               xMin-=step; if ( stoppi && bumped(others,epsilon,LEFT__ ) || !boxed() || !rated()) xMin+=step; 
               xMax+=step; if ( stoppi && bumped(others,epsilon,RIGHT_ ) || !boxed() || !rated()) xMax-=step; 
           }
      }
      void grow4rec(){
           //now for recursion dont grow eg canvas but grow cells inside
           for (int i=0; i<cells.length; i++) {
                if (cells[i]!=null){
                    cells[i].grow();
                    //cells[i].shrink();//rethink
                }
           }
      }
      void grow(){
          if (age%dt == 0)
              newbours(dt);
              //every dx steps update bours
          if (age > activation){
              if (parent != null && parent.cells != null)
                  grow4self();
              if (cells != null)
                  grow4rec();
          }
          if (age == midlifetrigger){
              trigger();
              newbours(dt);
              //just in case the trigger changes things: 
              //update bours (ps means here "neighbours"
          }
          age++;
      }//end grow
      void grow(int steps){
           if (steps > 0){
               grow();
               grow(steps - 1);
           }
      }
      void nogrow(){
           hori = false;
           verti = false;     
      }
           
      //APOPTOSIS
      void exit(){
           if (parent != null)
               if (parent.cells != null)
                   for (int i = 0; i < parent.cells.length; i++)
                        if (parent.cells[i] == this)
                            parent.cells[i] =  null;
      }
      
      void exitIfOutLier(Canvas canvas){
      //remove self if x,y outside lozenge
           if (  xMax < canvas.xMin(yCtr())
              || xMin > canvas.xMax(yCtr())
              )  exit();
      }//end exitIfOutLier 

      //TRIGGERED ACTION
      void trigger(){
           //callback by the growth engine triggered at midlifetrigger
           //for example delayed composition and various cleanups
           if      (type == "HLine")  ((HLine)  this).trigger();
           else if (type == "VLine")  ((VLine)  this).trigger();
           else if (type == "Canvas") ((Canvas) this).trigger();
           else if (type == "Mini")   ((Mini)   this).trigger();
           else if (type == "Quad")   ((Quad)   this).trigger();
           else if (type == "Atom")   ((Atom)   this).trigger();
           else if (type == "Atom")   ((Atom)   this).trigger();
           else if (type == "Cell")                            ; 
           else println("TRIGGER CALLBACK FAILURE");
      }
      
      //PRESENTATION
      void orect(int xMin,int yMin, int xMax, int yMax){
           //old rectangle: add a bit of speckles
           fill(clr.clr);
           rect(xMin,yMin,xMax,yMax);        
           noFill();
           stroke(clr.darker().darker().clr);
           if ((xMax-xMin+yMax-yMin)%2 > 0) stroke(clr.lighter().clr); 
           else stroke(clr.darker().clr);
           rect(xMin+1,yMin+1,xMax-2,yMax-2);
           fill(clr.clr);
           stroke(clr.darker().clr);
           for (int i=0; i < 25; i++)
               for (int j=0; j < 12; j++)
                   rect(  this.xMin + (i*i+113*j)%max(1,this.xMax-this.xMin),this.yMin + (i+j*i) % max(1,this.yMax-this.yMin),0.5,0.5);
      }
      
      void draw(){
           fill(clr.clr); 
           if (boxing) stroke(new Color(BLACK).clr); else stroke(clr.clr);
           if ( (xMax - xMin > 4 && yMax - yMin > 4)) {
               if (!oldlook ) rect(xMin,yMin,xMax-xMin,yMax-yMin);
               if ( oldlook ) orect(xMin,yMin,xMax-xMin,yMax-yMin);  
           }
           if (cells != null){
               for (int i = cells.length - 1; i >= 0; i--){ 
                    if (cells[i] != null){
                        cells[i].draw(); 
                    }
               }      
           }
      }//end draw
      
      void rontgen(int foppen){
           fill(0,255,0);
           stroke(0,125,0);
           if (hori && verti)  rect(xCtr() - foppen,yCtr() - foppen,2*foppen,2*foppen);
           if (hori &&!verti)  rect(xCtr() - 2*foppen,yCtr() - foppen,4*foppen,2*foppen); 
           if (!hori&& verti)  rect(xCtr() - foppen,yCtr() - 2*foppen,2*foppen,4*foppen); 
           if (!hori&& !verti) rect(xCtr() - foppen,yCtr() - foppen,2*foppen,2*foppen); 
           if (cells != null){
               for (int i=0; i<cells.length; i++) {
                    if (cells[i]!=null){
                        cells[i].rontgen(max(2,foppen-1)); 
                    }
               }      
           }
      }
      
      void tell(){
           tell(0); 
      }
      
      void tell(int indent){
           for (int i=0; i<4*indent; i++)
                print(" ");
           print(type+", ");
           clr.tell();
           print(",xMin=");print(xMin);
           print(",xMax=");print(xMax);
           print(",yMin=");print(yMin);
           print(",yMax=");print(yMax);
           print(",hori=");print(hori);
           print(",verti=");print(verti);
           print(",stoppi=");print(stoppi);
           print(",ratio=");print(ratio);
           print(",epsilon=");print(epsilon);
           print(",dydx()=");println(dydx());
           if (cells != null){
               for (int i=cells.length-1; i>=0; i--) {
                    if (cells[i]!=null){
                        cells[i].tell(indent + 1); 
                    }
               }      
           }
      }//end tell
      
      int count(){
          int n = 1;
          if  (cells != null) 
               for (int i = 0; i < cells.length; i++)
                    if (cells[i] != null)
                        n += cells[i].count();
          return n;
      }//end  count
}//end Cell
