//Copyright (C) <2013> <Loe Feijs and TU/e
class VLine extends Cell{
      final boolean verbose = false;
      final int NRINTERSECTS = 25;    //safe upperbound
      final int NRRHYTHMPLANES = 200; //many are purged
      final int NRATOMS = NRINTERSECTS + NRRHYTHMPLANES;
       
      //CONCEPTION
      VLine(Cell parent){
            type = "VLine";
            this.parent = parent;
            int x = int(random(parent.xMin + 5,parent.xMax - 5));
            int y;
            if  (parent.type == "Canvas")
                 y = int(random(((Canvas)parent).yMin(x) + 5,((Canvas)parent).yMax(x) - 5)); 
            else y = int(random(         parent. yMin    + 5,         parent. yMax    - 5));
            xMin = x - 5 - int(random(5));
            xMax = x + 4 + int(random(6));
            //5% probability for a very wide vertical
            if (PROB(0.05)) { xMin -= int(random(8,15)); xMax += int(random(8,15)); }
            yMin=y - 1;
            yMax=y + 1;
            clr = new Color(YELLOW);
            hori = false;
            verti = true;
            stoppi = PROB(0.80);
            epsilon = 0;
            age = 0;
            activation = 300; //HLines must be setup first
            midlifetrigger = activation + 1000;
      }
      void setxy(int x, int y){
           xMin = x - 8 - int(random(4));
           xMax = x + 7 + int(random(4));
           yMin = y - 1;
           yMax = y + 1;
      }
      
      //COMPOSITION
      void prep(){
           //Kind of first version of the setpup
           //so it can be run separately already

           cells = new Cell[NRATOMS];
      }
      void setup(){
           //setup: creates the internal content for this VLine, 
           //the intersection squares are done already by HLine,
           //(so take care there are already some atoms present,
           //fill in details of hline: the famous rhythm planes.
           //Precondition: prep() done already
           for (int i = 0; i < NRRHYTHMPLANES; i++) { 
                Atom a = new Atom(this);
                a.clr = new Color(RED,YELLOW,BLUE,WHITE,GRIS,NAVY);
                a.xMin = this.xCtr() - 2; 
                a.xMax = this.xCtr() + 3; 
                int y = int(random(parent.yMin+1,parent.yMax-1));
                a.yMin = y - 1;
                a.yMax = y + 1;
                a.hori = true;
                a.verti = true;
                a.stoppi = true;  
                a.epsilon = (this.xMax - this.xMin)/7; //was /2
                a.ratio = 0.5; //bit wider //was square-ish 
                insert(a);
           }//end for 
           this.purge1(); 
           this.purge2();  
      }//end setup
      
      //APOPTOSIS
      void purge1(){
           //meant for a collection of Atom cells supposedly "rhytmic" on Vline
           //eliminate some of the cells inside this which are too close anyhow
           for (int i=0; i<cells.length; i++){
               for (int j=0; j<cells.length; j++){
                   Cell ci = cells[i];
                   Cell cj = cells[j];
                   if (i != j && ci != null && cj != null){
                       if (  (!cj.biparental() &&abs(ci.yCtr() - cj.yCtr()) < ci.epsilon + cj.epsilon)
                             //make sure ci has some chance of not being squeezed already in the beginning                    
                          || ( cj.biparental() && abs(ci.yCtr() - cj.yCtr()) < (cj.coparent.yMax - cj.coparent.yMin) + ci.epsilon  )
                             //meaning: keep extra distance from the intersection plane cells such as cj

                          )  if (!cells[i].biparental())
                                  cells[i] = null;
                   }
               }
           } 
           if (verbose) { print("VLine purge1 @");println(age); }            
      }    //end purge1
      
      void purge2(){
           //eliminate atoms inside this VLine but outside the lozenge
           if (parent.type == "Canvas")
               if (cells != null)
                   for (int i=0; i < cells.length; i++)
                        if (cells[i] != null)
                            if (  cells[i].xMax < ((Canvas)parent).xMin(cells[i].yCtr())
                               || cells[i].xMin > ((Canvas)parent).xMax(cells[i].yCtr())
                               )  cells[i] = null;
           if (verbose) { print("VLine purge2 @");println(age); }
      }    //end purge2
      
      void purge3(){
           //eliminate rhythm cells which did not reach 90% line width
           //and for intersect cells also even check their width
           //PS: warning: don't run this purge action too early.
           for (int i=0; i<cells.length; i++){
                if (  (cells[i] != null && (cells[i].xMax - cells[i].xMin + 1) < 0.90*(xMax - xMin))
                   && ( cells[i].coparent == null || (cells[i].xMax - cells[i].xMin +1) < 0.90*(cells[i].coparent.xMax - cells[i].coparent.xMin))              
                    )   cells[i] = null;
           }//end for  
           if (verbose) { print("VLine purge3 @");println(age); }    
      }    //end purge3 
      
      //TRIGGERED ACTION
      void trigger(){
           purge3();
           compress();
      }
}//end VLine


