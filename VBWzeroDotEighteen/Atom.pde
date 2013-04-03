//Copyright (C) <2013> <Loe Feijs and TU/e
class Atom extends Cell{
  
      //CONCEPTION
      Atom(Cell parent){
           this.iniAtom();
           this.parent = parent;
           this.clr = new Color(RED,YELLOW,BLUE,WHITE,GRIS,BLACK);
      }  
      Atom(Cell parent, Cell coparent){
           this.iniAtom();
           this.parent = parent;
           this.coparent = coparent;
           this.midlifetrigger = 500;
           this.clr = new Color(RED,NAVY,WHITE);
      } 
      private void iniAtom(){
              type = "Atom";
              hori = true;
              verti = true;
              stoppi = true;
              ratio = 1.0;
      }
      
      //TRIGGERED ACTION      
      void trigger(){
           if (parent != null && coparent != null)
               if (PROB(0.3))
                   split();
      }
      void split(){
           //as in atomic physics, they turn out splittable after all;)
           //for a dual parent atom, typically at H-VLine intersection.
           cells = new Cell[2];
           for (int i = 0; i < cells.length; i++){
                cells[i] = new Atom(this);
                cells[i].ratio = -1;
                cells[i].clr = (i == 0) ? clr : clr.complementary();
                cells[i].setxy(xCtr() + ((i == 0) ? 4 : -4),yCtr());
           }
      }
}//end class Atom
