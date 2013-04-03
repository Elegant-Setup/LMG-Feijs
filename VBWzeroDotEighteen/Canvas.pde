//Copyright (C) <2013> <Loe Feijs and TU/e
class Canvas extends Cell {
      final boolean verbose = false;
      
      final int MAXX = int(1270.0/sqrt(2)); //one pixel = 2mm real VBW, real VBW is 127 x 127cm, vertical 179cm
      final int MAXY = int(1270.0/sqrt(2)); //displayWidth x displayHeight @ TU/e HG3.53 = 1920 x 1080, 1600 x 900 @ TU/e laptop
                 
      //special "attribute"" fields for lozenge:
      int xMin(int y) { if (y < yCtr()) return xMin + (yCtr() - y); else return xMin + (y - yCtr()); }
      int xMax(int y) { if (y < yCtr()) return xMax - (yCtr() - y); else return xMax - (y - yCtr()); }
      int yMin(int x) { if (x < xCtr()) return yMin + (xCtr() - x); else return yMin + (x - xCtr()); }
      int yMax(int x) { if (x < xCtr()) return yMax - (xCtr() - x); else return xMax - (x - xCtr()); }
 
  //CONCEPTION
  Canvas(int x, int y){
         type = "Canvas";
         xMin = x - MAXX/2;      
         xMax = x + MAXX/2; 
         yMin = y - MAXY/2;      
         yMax = y + MAXY/2; 
         parent = null;
         age = 0;   
         midlifetrigger = 110;
  }  

  //COMPOSITION  
  void setup(){
       //make a Victory Boogie Woogie tribute composition
       clr = new Color(WHITE);
  
       final int NRQUADS  =   2;//do not change this
       final int NRHLINES =  15;//many get purge'd anyhow
       final int NRVLINES =  30;//idem
       final int NRMINIS =   75;//idem
       final int NRMICROS =  20;//idem
       cells = new Cell[4*NRQUADS + NRHLINES + 2*NRVLINES + NRMINIS + NRMICROS];
       midlifetrigger = 500;
      
       //add an upmost quadruple configuration 
       int qy = int(random(yMin + 50,yMin + 125));
       int qx = int(random(xMin(qy) + 10,xMax(qy) - 10));
       Quad q = new Quad(this);
       q.setxy(qx,qy);
       q.setup(false);
       insert(q);
       
       //and a downmost yellow/gris configuration
       q = new Quad(this);
       q.setxy(xCtr(),yMax - RAND(50,100));
       q.setup(true);
       insert(q);

       //now compose a grid, a bit Broadway
       for (int i=0;  i < NRHLINES; i++) {
            //first create the empty HLines, which is important: 
            //these HLines help some (most) of the VLines to stop,
            //for example the twins (otherwise they re-unite again).
            HLine h = new HLine(this); 
            insert(h);
       }
       for (int i=0;  i < NRVLINES; i++) {
            //then the VLines and their twins,
            //the Hlines must be there already
            VLine v = new VLine(this);
            insert(v);
            v.prep();
            if (v.stoppi) {
                VLine twin = new VLine(this); 
                v.copy(twin); 
                int y = (v.yCtr() < yMax/2) ? 6*yMax/7 : yMax/3;//near opposite side
                twin.yMin = y;
                twin.yMax = y;
                twin.prep();
                insert(twin);
            }
       }//end for      
        purge1(); 
       //then fill in the remaining details of the HLines
       //which will include intersection atoms
       for (int i=0;  i < cells.length; i++) { 
            if (cells[i] != null && cells[i].type == "HLine"){
               ((HLine)cells[i]).setup();
           }
       }//end for
       //then fill in the remaining details of the VLines
       for (int i=0;  i < cells.length; i++) { 
            if (cells[i] != null && cells[i].type == "VLine"){
               ((VLine)cells[i]).setup();
           }
       }//end for
       for (int i=0; i < NRMINIS; i++){
            Mini m = new Mini(this);
            insert(m);
            //setup postponed
       }//end for       
       for (int i=0; i < NRMICROS; i++){
            Micro m = new Micro(this);
            insert(m);
            //setup postponed
       }//end for
       
       //and some more cleanup
       purge2();
       purge3();
  }
         
   //APOPTOSIS
   private void purge1(){
       //meant for the collection of Hlines and VLines typically:
       //eliminate some of the cells being either too close anyhow,
       //or HLines vertizontally too close, or VLines horizontally too close,
       //(being too close depends on the width for a VLine and height for an HLine)
       //but avoid removing twins. PS RUN THIS ONLY BEFORE GROWTH, NOT AT MIDLIFETRIGGERS
       for (int i=0; i < cells.length; i++){
           for (int j=0; j < cells.length; j++){
               Cell ci = cells[i];
               Cell cj = cells[j];
               if (i != j && ci != null && cj != null && !ci.twin(cj)){
                   if (  (  ci.type == "Micro" && cj.type == "Micro"
                         && abs(ci.xCtr() - cj.xCtr()) < 30 && abs(ci.yCtr() - cj.yCtr()) < 30
                         )
                      || (  ci.type == "Mini" && cj.type == "Mini" &&
                            (  abs(ci.xCtr() - cj.xCtr()) < 30 && abs(ci.yCtr() - cj.yCtr()) < 30
                            || ci.bumped(cj,0)
                            )
                         )
                      || (  ci.type == "HLine" && cj.type == "HLine"
                         && abs(ci.yCtr() - cj.yCtr()) <= 3 + (ci.yMax - ci.yMin)/2 + (cj.yMax - cj.yMin)/2 
                         )
                      || (  ci.type == "VLine" && cj.type == "VLine"
                         && abs(ci.xCtr() - cj.xCtr()) <= 3 + (ci.xMax - ci.xMin)/2 + (cj.xMax - cj.xMin)/2   
                         )    
                      )  cells[i] = null;
               }
           }
       }  
       if (verbose) { print("Canvas purge1 @");println(age); }   
  }    //end purge1
  
  void purge2(){
       //remove cells with x,y outside lozenge
       if (cells != null)
           for (int i=0; i < cells.length; i++)
                if (cells[i] != null){
                    cells[i].exitIfOutLier(this);
       }
       if (verbose) { print("Canvas purge2 @");println(age); }
  }    //end purge2
  
  void purge3(){
       //also get rid of HLines with unfortunate positions 
       for (int i = 0; i < cells.length; i++)                
            if (cells[i] != null)
                if (cells[i].type == "HLine")
                    if (  cells[i].yCtr() < yMin + 50 
                       || cells[i].yCtr() > yMax - 50 
                       )   cells[i] = null;
       //also get rid of VLines with unfortunate positions 
       for (int i = 0; i < cells.length; i++)                
            if (cells[i] != null)
                if (cells[i].type == "VLine")
                    if (  cells[i].xCtr() < xMin + 75 
                       || cells[i].xCtr() > xMax - 75
                       )  cells[i] = null;
       //also get rid of Minis with unfortunate positions 
       for (int i = 0; i < cells.length; i++)                
            if (cells[i] != null)
                if (cells[i].type == "Mini")
                    if (  cells[i].xCtr() < xMin + 100
                       || cells[i].xCtr() > xMin + 800
                       || cells[i].yCtr() < yMin + 100 
                       )  cells[i] = null;              
       if (verbose) { print("Canvas purge3 @");println(age);}
  }    //end purge3
  
  
  //TRIGGERED ACTION
  void trigger(){
       compress();
  }
  
  //PRESENTATION
  void grid(){
       stroke(0,180,0);
       for (int x = 0; x < xMax; x += 10){
            if (x%100 == 0) strokeWeight(1); else strokeWeight(0);
            line(x,0,x,yMax);
       }    strokeWeight(0);
       for (int y = 0; y < yMax; y += 10){
            if (y%100 == 0) strokeWeight(1); else strokeWeight(0);
            line(0,y,yMax,y);
       }    strokeWeight(1);//default
  }
  void rontgen(){
       grid();
       super.rontgen(4);
  }
  int  count(){
       int n = super.count();
       print("cell count = "); 
       println(n);
       return n; 
  }
  void lozenge(boolean printing){
       noStroke();
       if (rontgen) 
           fill(145,165,145,200);  //transparent
           else if (printing)      //no ink waste
                    fill(255,255,255,255);//white
                    else fill(0,0,0,255); //black
  
       int xMin = (width - MAXX)/2;
       int xMax = (width + MAXX)/2 + 1;
       int xCtr = (width)/2;
       int yMin = (height - MAXY)/2;
       int yMax = (height + MAXY)/2 + 1;
       int yCtr = (height)/2;
       triangle(xMin,yMin,xCtr,yMin,xMin,yCtr);
       triangle(xCtr,yMin,xMax,yMin,xMax,yCtr);
       triangle(xMax,yCtr,xMax,yMax,xCtr,yMax);
       triangle(xCtr,yMax,xMin,yMax,xMin,yCtr);
       stroke(180,180,180);
       line(xCtr,yMin,xMin,yCtr);
       line(xCtr,yMin,xMax,yCtr);
       line(xMax,yCtr,xCtr,yMax);
       line(xCtr,yMax,xMin,yCtr);    
  }    //end lozenge
  
  void draw(boolean printing){
       //White background is better for printing
       //other wise, black is better for screen.
       super.draw();
       this.lozenge(printing);
       if (verbose) if (age % 500 == 0){ print("Canvas @"); println(age);}
  } 
}//end Canvas

