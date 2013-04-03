//Copyright (C) <2013> <Loe Feijs and TU/e
class HLine extends Cell{
      final boolean verbose = false;
      final int NRINTERSECTS = 25;    //safe upperbound
      final int NRRHYTHMPLANES = 200; //many are purged
      final int NRATOMS = NRINTERSECTS + NRRHYTHMPLANES;

      //CONCEPTION
      HLine(Cell parent){
            type = "HLine";
            this.parent = parent;
            if (parent.type == "Canvas"){
                setxy(RAND(parent.xMin + 100, parent.xMax - 100),
                      RAND(parent.yMin + 100, parent.yMax - 100));
            }   else {
                setxy(RAND(parent.xMin + 10, parent.xMax - 10),
                      RAND(parent.yMin + 10, parent.yMax - 10));          
            }
            clr = new Color(YELLOW);
            hori = true; 
            stoppi = (abs(yCtr() - parent.yCtr()) < 50) || PROB(0.7); 
            //near parent.yCtr() be a stopper,
            //to prevent overruning the micros
            
            midlifetrigger = activation + 1000;
            cells = new Cell[NRATOMS];
            for (int k=0; k < cells.length; k++)
                 cells[k] = null;
      }
      void setxy(int x, int y){
           xMin = x - 1;
           xMax = x + 1;
           yMin = y - 6 - int(random(3));
           yMax = y + 5 + int(random(4));
      }
      
      //COMPOSITION
      void setup(){
           //setup: creates the internal content for this HLine, 
           //fill in details of hline: the famous rhythm planes.
           //PRECONDITION: VLines of canvas to be created first.
           for (int j=0; j < parent.cells.length; j++){
                Cell cj = parent.cells[j];
                if (cj != this && cj != null && cj.type == "VLine"){
                    VLine coparent = (VLine)cj;
                    Atom a = new Atom(this,coparent); 
                    coparent.insert(a);  
                    //atom in this HLine AND in coparent 
                    a.xMin = coparent.xCtr() - 1;
                    a.xMax = coparent.xCtr() + 1;
                    a.yMin = this.yCtr() - 1;
                    a.yMax = this.yCtr() + 1; 
                    a.ratio = -1; 
                    insertUnique(a);//beware of the twins
                }
           }
           //fill in the internal details with a "rhythm"
           for (int i = 0; i < NRRHYTHMPLANES; i++) {
                Atom a = new Atom(this);
                a.clr = new Color(RED,BLUE,WHITE,GRIS,NAVY);
                int x = int(random(parent.xMin,parent.xMax));
                int y = yCtr();
                a.xMin = x - 1;
                a.xMax = x + 1;
                a.yMin = y - 2; 
                a.yMax = y + 2; 
                a.hori = true;
                a.verti = true;
                a.stoppi = true;  
                a.epsilon = (this.yMax - this.yMin)/6; 
                a.ratio = 2.0;
                insert(a);         
           }    //end for 
           this.purge1(); 
           this.purge2(); 
      }//end setup
      
      //APOPTOSIS
      void purge1(){
           //meant for a collection of Atom cells supposedly "rhytmic" on Hline
           //eliminate some of the cells inside this which are too close anyhow
           for (int i=0; i < cells.length; i++){
               for (int j=0; j < cells.length; j++){
                   Cell ci = cells[i];
                   Cell cj = cells[j];
                   if (i != j && ci != null && cj != null)
                       if (  (!cj.biparental() && abs(ci.xCtr() - cj.xCtr()) < ci.epsilon + cj.epsilon) 
                              //make sure ci has some chance of not being squeezed already in the beginning
                          || ( cj.biparental() && abs(ci.xCtr() - cj.xCtr()) < (cj.coparent.xMax - cj.coparent.xMin) + ci.epsilon)
                              //meaning: keep extra distance from the intersection plane cells such as cj
                          )  if (!cells[i].biparental()) 
                                  cells[i] = null; 
               }
           }  
           if (verbose) { print("HLine purge1 @");println(age); }      
      }    //end purge1
      
      void purge2(){
           //eliminate atoms inside this HLine but outside the lozenge
           if (parent.type == "Canvas")
               if (cells != null)
                   for (int i=0; i < cells.length; i++)
                        if (cells[i] != null)
                            if (  cells[i].xMax < ((Canvas)parent).xMin(cells[i].yCtr())
                               || cells[i].xMin > ((Canvas)parent).xMax(cells[i].yCtr())
                               )  cells[i] = null;
           if (verbose) { print("HLine purge2 @");println(age); } 
      }    //end purge2
      
      void purge3(){
           //eliminate cells which did not reach 90% line height
           //and for intersect cells also even check their width
           //PS: warning: don't run this purge action too early.
           for (int i=0; i < cells.length; i++)
                if (  cells[i] != null 
                   && ((cells[i].yMax - cells[i].yMin +1) < 0.90*(yMax - yMin))
                   && ( cells[i].coparent == null || (cells[i].yMax - cells[i].yMin +1) < 0.90*(cells[i].coparent.yMax - cells[i].coparent.yMin))
                   )    cells[i] = null; 
           if (verbose) { print("HLine purge3 @");println(age); }    
      }    //end purge3 
      
      //TRIGGERED ACTION
      void trigger(){
           purge3();
           compress();
      }
}//end HLine

