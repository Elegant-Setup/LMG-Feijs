//Copyright (C) <2013> <Loe Feijs and TU/e
class Micro extends Cell{
  
      //CONCEPTION
      Micro(Cell parent){
            type = "Micro";
            this.parent = parent;
            int y = parent.yCtr() + RAND(-75,75);
            int x = (PROB(0.5)) ? parent.xMin + RAND(75) : parent.xMax - RAND(75);
            //so micros typically live in the leftmost and in
            //the rightmost left and right corner of a canvas
            setxy(x,y);
            hori = true;
            verti = true;
            stoppi = true;
            ratio = 1.0;
            clr = parent.clr;
            epsilon = 10;
            activation = 10;
            midlifetrigger = activation + 50;
      }
      
      //COMPOSITION
      void setup(){
            //micros grow fast in the beginning, then at midlifetrigger they 
            //get the real micro in the middle of a large white enclosement,
            //where the "real" micros is yellow with an internal rectangle,
            //which is either gris or black. The idea of this nesting is to
            //force most of the lines and later mini's to stop and not over-
            //run the micro's (preferably they even keep appropriate distance).
            hori = false; 
            verti = false;
            //so growth is stopped
            if (largeEnough()){
                cells = new Cell[1];
                Micro a = new Micro(this);
                      a.xMin = xCtr() - int(random(10,15));
                      a.xMax = xCtr() + int(random(10,15));
                      a.yMin = yCtr() - int(random(15,20));
                      a.yMax = yCtr() + int(random(15,20));
                      a.hori = false; 
                      a.verti = false;
                      a.clr = new Color(YELLOW);
                insert(a);
                a.cells = new Cell[1];
                Atom b = new Atom(a);
                     b.xMax = a.xMax;
                     b.yMax = a.yMax;
                     b.xMin = a.xMin + (a.xMax - a.xMin)/3;
                     b.yMin = a.yMin + (a.yMax - a.yMin)/3;
                     b.hori = false; 
                     b.verti = false;
                     b.clr = (PROB(0.6)) ? new Color(GRIS) : new Color(BLACK);
                a.insert(b);
            }   else exit();
      }
      boolean largeEnough(){
               return xMax - xMin > 40
                   || yMax - yMin > 40;
      }
      
      //TRIGGERED ACTION      
      void trigger(){
           if (parent.type == "Canvas") 
               setup(); 
      }
}//end class Micro


