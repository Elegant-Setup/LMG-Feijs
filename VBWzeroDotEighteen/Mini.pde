//Copyright (C) <2013> <Loe Feijs and TU/e
class Mini extends Cell{
      final boolean verbose = false;
      
      //CONCEPTION
      Mini(Cell parent){
           type = "Mini";
           this.parent = parent;
           int dx, dy;
           if (PROB(0.25)){
               dx = 5; 
               dy = 3; //lying
           }   else 
           if (PROB(0.50)){
               dx = 3; 
               dy = 5; //standing
           }   else {
               dx = 2; 
               dy = 2; //square
           }
           int x = dx+int(random(parent.xMin,parent.xMax - dx));
           int y = dy+int(random(parent.yMin,parent.yMax - dy));
           xMin = x;
           xMax = x + dx;
           yMin = y;
           yMax = y + dy;
           clr = new Color(GRIS,RED,BLUE,WHITE,YELLOW);
           hori = true; 
           verti = true;
           stoppi = true;
           if (PROB(0.75)) ratio = float(dy) / float(dx); else ratio = -1;
           activation = 800 + RAND(200);
           midlifetrigger = activation + 200;
      }
      void fast(){
           //no more spreading in activation time,
           //things are smaller, setup gets faster
           activation = 50;
           midlifetrigger = activation + 200;  
      }
      void done(){
           //no more triggers
           midlifetrigger = -1; 
      }
      
      //COMPOSITION 
      float tiny(){   return fuzzy(area(),0,0,1000,2000); }
      float small(){  return fuzzy(area(),1000,2000,3000,4000); }
      float medium(){ return fuzzy(area(),3000,4000,6000,8000); }
      float large(){  return fuzzy(area(),6000,8000,INF,INF); }
      
      float hstretched(){ return fuzzy(dydx()   ,0.00,0.00,0.66,1.50);}
      float squarish()  { return fuzzy(dydx()   ,0.66,0.80,1.25,1.50);}
      float square()    { return fuzzy(dydx()   ,0.75,0.90,1.10,1.25);}
      float vstretched(){ return fuzzy(dydx()   ,0.66,1.50,INF ,INF );}  
      float recursible(){ return fuzzy(nesting(),0.00,0.00,0.80,3.20 );}
      
      final int INF = 1000000;
      float truth(){ return 1.0;}
      float NOT(float p){ return 1 - p; }
      boolean P(float p) { return random(1.0) < p;}
      
      float fuzzy(float a, float lo1, float lo2, float hi1, float hi2){
            //generic fuzzy logic predicate, membership test for
            //being between low and high boundary; fuzzy bounds,
            //roughly, lo1 < low < lo2 and also hi1 < high < hi2
            float f1 = (a - lo1)/max(.01,lo2 - lo1);
            float f2 = 1 - (a - hi1)/max(.01,hi2 - hi1);
            if (f1 < 0) f1 = 0;
            if (f1 > 1) f1 = 1;
            if (f2 < 0) f2 = 0;
            if (f2 > 1) f2 = 1;
            return f1 * f2;
      }

      void setup(){
            if (verbose) { print("Mini: setup, nesting = "); println(nesting());}
           //based on probabilistic (fuzzy) logic, cf. Zadeh
           //only for not-yet-decomposed Mini's,  of course;
           //the Mini must have reached its final dimensions
           nogrow();
           int retry = 0;
           boolean done = (cells != null || type == "Atom");
           while ( !done ){
                  if (retry++ > 1000) done = true;
                  int num = floor(random(22));
                  switch (num){                                                   
                  case 0:  if (P(recursible()) && P(hstretched()) && P(tiny())    ){ setupH2();       done = true;} break;
                  case 1:  if (P(recursible()) && P(hstretched()) && P(small())   ){ setupG();        done = true;} break;
                  case 2:  if (P(recursible()) && P(hstretched()) && P(medium())  ){ setupHN();       done = true;} break;
                  case 3:  if (P(recursible()) && P(hstretched()) && P(large())   ){ setupHN();       done = true;} break;          
                  case 4:  if (                   P(vstretched()) && P(tiny())    ){ setupA();        done = true;} break;
                  case 5:  if (                   P(vstretched()) && P(small())   ){ setupG();        done = true;} break;
                  case 6:  if (P(recursible()) && P(vstretched()) && P(medium())  ){ setupVNL();      done = true;} break;
                  case 7:  if (                   P(vstretched()) && P(medium())  ){ setupG();        done = true;} break;
                  case 8:  if (P(recursible()) && P(vstretched()) && P(large())   ){ setupVNU();      done = true;} break;
                  case 9:  if (P(recursible()) && P(vstretched()) && P(large())   ){ setupVNL();      done = true;} break;
                  case 10: if (                   P(squarish())   && P(tiny())    ){ setupA();        done = true;} break;
                  case 11: if (P(recursible()) && P(squarish())   && P(small())   ){ setupNxN();      done = true;} break; 
                  case 12: if (P(recursible()) && P(squarish())   && P(small())   ){ setupG();        done = true;} break; 
                  case 13: if (                   P(squarish())   && P(small())   ){ setup2x2();      done = true;} break;  
                  case 14: if (P(recursible()) && P(squarish())   && P(small())   ){ setup2x2();      done = true;} break;      
                  case 15: if (P(recursible()) && P(squarish())   && P(medium())  ){ setupG();        done = true;} break;    
                  case 16: if (P(recursible()) && P(square())     && P(tiny())    ){ setup2x2();      done = true;} break;         
                  case 17: if (P(recursible()) && P(square())     && P(small())   ){ setupG();        done = true;} break;
                  case 18: if (P(recursible()) && P(square())     && P(small())   ){ setup2x2();      done = true;} break;
                  case 19: if (P(recursible()) && P(square())     && P(medium())  ){ setup2x2();      done = true;} break;
                  case 20: if (P(recursible()) && P(square())     && P(medium())  ){ setupG();        done = true;} break;
                  case 21: if (P(0.01)/*no rule applicable*/)                      {setupA();         done = true;} break;
                  default: println("MINI SETUP SWITCH FAILURE");   
                  } 
           }         
      }
      
      void setupA(){
           if (verbose) println("Mini: setupA");
           done();
      }
      void setup2x2(){
           if (verbose) println("Mini: setup2x2");
           //Mini divided in 4, better be really square
           cells = new Cell[4];
           int dx = xMax - xMin;
           int dy = yMax - yMin;
           cells[0] = new Atom(this);
           cells[1] = new Atom(this);
           cells[2] = new Atom(this);
           cells[3] = new Atom(this);
           
           cells[0].xMin = xMin;        cells[0].xMax = xMin + dx/2; cells[0].yMin = yMin;        cells[0].yMax = yMin + dy/2;
           cells[1].xMin = xMin + dx/2; cells[1].xMax = xMax;        cells[1].yMin = yMin;        cells[1].yMax = yMin + dy/2;  
           cells[2].xMin = xMin;        cells[2].xMax = xMin + dx/2; cells[2].yMin = yMin + dy/2; cells[2].yMax = yMax;   
           cells[3].xMin = xMin + dx/2; cells[3].xMax = xMax;        cells[3].yMin = yMin + dy/2; cells[3].yMax = yMax;
   
           cells[0].hori = false; cells[0].verti = false;    
           cells[1].hori = false; cells[1].verti = false; 
           cells[2].hori = false; cells[2].verti = false; 
           cells[3].hori = false; cells[3].verti = false;     
           
           cells[1].clr = cells[0].clr.fresh();
           cells[2].clr = cells[1].clr;
           cells[3].clr = cells[0].clr;
           done();
      }    //end setup2x2
      
      private void setupG(){
           if (verbose) println("Mini: setupG");
           // G-Mini, or "gooze-eye" Mini, the kind with probably one kernel,
           // It must have grown first,  and then will self-center again now;
           // let x,y be that center, create internal content, just obe cell.
           int x = (xMin + xMax)/2;
           int y = (yMin + yMax)/2;
           if (PROB(0.90)){
               cells = new Cell[1];
               Atom a = new Atom(this);
               int var = (xMax - xMin) > 50 && (yMax - yMin) > 50 
                       ?  RAND(9,13) 
                       :  RAND(5,min(xMax - xMin,yMax - yMin)/4);
               a.xMin = x - var; 
               a.xMax = x + var;
               a.yMin = y - var;
               a.yMax = y + var;
               a.clr = clr.complementary();
               a.hori = false;
               a.verti = false;
               if (a.boxed()) insert(a);
           } //only 90% of them have a kernel indeed
           done();
      }    //end setupG
     
      void setupNxN(){
           if (verbose) println("Mini: setupNxN");
           //kind of small checkerboard, 5x5 for example
           float dx = xMax - xMin;
           float dy = yMax - yMin;
           int Nx = max(1,round(dx / 10));
           int Ny = max(1,round(dy / 10));
           float xStep = dx/Nx; 
           float yStep = dy/Ny; 
           cells = new Cell[(Nx+2) * (Ny+2)];
           Color[][] prevs = new Color[Nx+1][Ny+1]; 
           for (int i=0; i < Nx; i++){
                for (int j=0; j < Ny; j++){
                     Atom a = new Atom(this);
                     a.xMin = int(xMin + i*xStep);
                     a.xMax = int(xMin + i*xStep + xStep);
                     a.yMin = int(yMin + j*yStep);
                     a.yMax = int(yMin + j*yStep + yStep);
                     a.clr = new Color(RED,BLUE,YELLOW,BLACK,WHITE,GRIS);
                     while (  i > 0 && a.clr.isSAMELABEL(prevs[i-1][j]) 
                           || j > 0 && a.clr.isSAMELABEL(prevs[i][j-1])
                           )  a.clr = new Color(RED,BLUE,YELLOW,BLACK,WHITE,GRIS);
                     a.hori = false;
                     a.verti = false;
                     a.stoppi = true;
                     a.activation = 100; //test
                     prevs[i][j] = a.clr;
                     insert(a);
                }   
           }//end for  
           done();     
      }   //endsetupNxN
      
      void setupVNU(){  
           if (verbose) println("Mini: setupVNU");
           //vertically decomposed mini with N sub-minis and a hLine near Upper edge
           int N;
           if (dydx() > 3) N = 5;
               else if (dydx() > 2) N = 4;
                        else N = 3;
           cells = new Cell[N];
           Color[] prevs = new Color[N]; 
           HLine h = new HLine(this);
                 h.setxy((xMin + xMax)/2,yMin + 4 + RAND(4)); 
                 h.clr = new Color(WHITE);  
                 h.setup(); 
                 h.yMin = yMin;
                 h.yMax = yMin + 2*(h.yCtr() - yMin);   
           insert(h);
           float yBegin = h.yMax;
           float yStep = (yMax - yBegin)/float(N - 1);
           Mini a = new Mini(this);
                //this is the first one
                yBegin += yStep/2;
                a.setxy((xMax + xMin)/2,int(yBegin));
                a.clr = new Color(GRIS,RED,BLUE,YELLOW);
                a.ratio = -1;
                a.fast();
                prevs[1] = a.clr;
                insert(a);
           for (int i = 2; i < N; i++){
                Mini b = new Mini(this);
                //align them vertically
                yBegin += yStep;
                b.setxy((xMax + xMin)/2,int(yBegin));
                b.clr = new Color(GRIS,RED,BLUE,YELLOW);
                while ( b.clr.isSAMELABEL(prevs[i-1]))
                        b.clr = new Color(GRIS,RED,BLUE,YELLOW);
                b.ratio = -1;
                b.fast();
                prevs[i] = b.clr;
                insert(b);
           }    
           done();
      }    //end setupVNU
      
      void setupVNL(){  
           if (verbose) println("Mini: setupVNL");
           //vertically decomposed mini with N sub-minis and a hLine near Lower edge 
           int N;
           if (dydx() > 3)          N = 5;
               else if (dydx() > 2) N = 4;
                        else        N = 3;
           cells = new Cell[N];
           Color[] prevs = new Color[N]; 
           HLine h = new HLine(this);
                 h.setxy((xMin + xMax)/2,yMax - 4 - RAND(4)); 
                 h.clr = new Color(WHITE);  
                 h.setup(); 
                 h.yMax = yMax;
                 h.yMin = yMax - 2*(yMax - h.yCtr());   
           insert(h);
           float yEnd = h.yMin;
           float yStep = (yEnd - yMin)/(N - 1);
           Mini a = new Mini(this);
                //this is the first one after the HLine
                float yBegin = yMin + yStep/2;
                a.setxy((xMax + xMin)/2,int(yBegin));
                a.clr = new Color(GRIS,RED,BLUE,YELLOW,WHITE);
                a.ratio = -1;
                a.fast();
                prevs[1] = a.clr;
                insert(a);
           for (int i = 2; i < N; i++){
                Mini b = new Mini(this);
                //align them vertically
                yBegin += yStep;
                b.setxy((xMax + xMin)/2,int(yBegin));
                b.clr = new Color(GRIS,RED,BLUE,YELLOW,WHITE);
                while ( b.clr.isSAMELABEL(prevs[i-1]))
                        b.clr = new Color(GRIS,RED,BLUE,YELLOW,GRIS);
                b.ratio = -1;
                b.fast();
                prevs[i] = b.clr;
                insert(b);
           } 
           done();
      }    //setupVNL
      
      void setupHN(){ 
           //Horizontally oriented composite mini, N sub-minis
           int N;
           if (dydx() < .33)          N = 5; 
               else if (dydx() < .50) N = 4;
                        else          N = 3;  
           setupHN(N);  
      }
      void setupH2(){
           setupHN(2);
      }
      
      void setupHN(int N){  
           if (verbose) println("Mini: setupHN"); 
           cells = new Cell[N];
           Color[] prevs = new Color[N]; 
           float xBegin = xMin;
           float xStep = (xMax - xBegin)/N;
           Mini a = new Mini(this);
                //this is really the first one
                xBegin += xStep/2;
                a.setxy(int(xBegin),(yMax + yMin)/2);
                a.clr = new Color(GRIS,RED,BLUE,YELLOW,WHITE);
                a.ratio = -1;
                a.fast();
                prevs[0] = a.clr;
                insert(a);
           for (int i = 1; i < N; i++){
                Mini b = new Mini(this);
                //align them horizontally
                xBegin += xStep;
                b.setxy(int(xBegin) + RAND(-int(xStep/2),int(+xStep/2)),(yMax + yMin)/2);
                b.clr = new Color(GRIS,RED,BLUE,YELLOW,WHITE);
                while ( b.clr.isSAMELABEL(prevs[i-1]))
                        b.clr = new Color(GRIS,RED,BLUE,YELLOW);
                b.ratio = -1;
                b.fast();
                prevs[i] = b.clr;
                insert(b);
           }
           done();
      }    //end setupHN
          
      //TRIGGERED ACTION
      void trigger(){
           setup();
           done();
      }
}//end Mini


