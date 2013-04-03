 //Copyright (C) <2013> <Loe Feijs and TU/e
 class Quad extends Cell{
  
      //CONCEPTION
      Quad(Cell parent){
           type = "Quad";
           this.parent = parent;
           clr = parent.clr;
           hori = true;
           verti = true;
           stoppi = true;  
           ratio = .75;     
           activation = 0; 
           midlifetrigger = 100;
      }
      void setxy(int x, int y, int hsize, int vsize){
           xMin = x - hsize/2;
           xMax = x + hsize/2;
           yMin = y - vsize/2;
           yMax = y + vsize/2;
      }
      
      //COMPOSITION
      void setup(boolean faux){
           //compose a quadruple white/gris configuration, two whites (diagonally), two gris's,
           //first the quadruple is a carrier containing four elements, launched and positioned
           //as a whole, later remove the 100x100 carrier. The case i = 1 yields a fixed white. 
           setxy(xCtr(),yCtr(),100,100);
           cells = new Cell[4];
           for (int i = 0; i < 4; i++){
                int x = xCtr();
                int y = yCtr();
                Quad c = new Quad(this);
                c.setxy(xCtr(),yCtr());
                c.clr = new Color(i == 1 ? WHITE : i == 2 ? WHITE : GRIS);
                c.hori = c.verti = (i!=1);
                x += (i>1) ? 11 : 0;
                y += (i%2==1) ? 9 : 0;
                c.setxy(x,y,10,8);
                insert(c);
           }     
           if (faux) setupBIS();
      }      
    
      void setupBIS(){
           //this a a faux quadruple, that is, slighly mis-aligned, 
           //which works nice for a group of gris and yellow cells.
           int offset = RAND(50);
           cells[1].clr = new Color(YELLOW);
           cells[1].xMin -= offset;
           cells[1].xMax -= offset;
           cells[1].hori = true;
           cells[2].clr = new Color(YELLOW);
      } 
                  
      //TRIGGERED ACTION    
      void shrapnel(){
           //insert payload, remove carrier
           if (cells != null)
               for (int i  = 0; i < cells.length; i++){
                    cells[i].verti = cells[i].hori;
                    cells[i].parent = parent;
                    parent.insert(cells[i]);
               }
           if (cells != null) exit();
      }  
      
      void trigger(){
           shrapnel();
      }
 }//end class

