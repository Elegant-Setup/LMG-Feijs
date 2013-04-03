//Copyright (C), 2013, Loe Feijs and TU/e
//THIS FILE ALSO CONTAINS GLOBAL DEFINITIONS
//NOTABLY OF P, PROB, RAND, stroke, and fill

final int RED   =  0;
final int BLUE   = 1;
final int YELLOW=  2;
final int BLACK  = 3;
final int WHITE  = 4;
final int GRIS   = 5;
final int NAVY   = 6;
      
//design of class Color: the average color component values have been obtained by
//sampling typical fields of the real Victory Boogie Woogie. The idea is that different
//red fields have slightly different colors which all go under te label "RED".
//When avoiding two neighbours to get assigned the same color, the labels must be compared,
//not the realised color components. Therefore colors are objects, carrying the label info.
//DO NOT CHANGE THE ORDER, THE "fresh" METHODS RELY ON THE ORDER, So RED = 0; .. GRIS = 5;!
//Sampling of color components on selected fields using adobe photoshop histogram tools and image found at:
//artedeximena.wordpress.com/arte-contemporaneo/introduccion-aspectos-formales-y-esferas-del-arte/la-victory-boogie-woogie-1944-mondrian/
//when better phhotographic material is available, this could be done better. Now I did a subjective correction of my own best guess.
      
class Color {
      int label;
      color clr;
      Color(int label){
            float w;
            this.label = label;
            int DM = RAND(- 8, 8);//variation of main color component
            int DA = RAND(- 6, 6);//variation of additional main color
            int DS = RAND(- 4, 4);//variation of second color component
            int DT = RAND(- 4, 4);//variation of third color component
            switch (label){
                    case RED    : clr = color(225 + DM, 15 + DS,  8 + DT);         break; //by sampling VBW I found 225,15,8
                    case BLUE   : clr = color( 30 + DM, 60 + DS,141 + DT);         break; //by sampling VBW I found 70,80,131 (but I changed to 30,60,141)
                    case YELLOW :clr =  color(238 + DM,176 + DA, 14 + DT);         break; //by sampling VBW I found 228,166,14 (but I changed to 238,176,14)
                    case BLACK  : w = 10; clr = color(w,w,w);                      break;
                    case WHITE  : w = int(random(215,250)); clr = color(w,w,w);    break;
                    case GRIS   : w = int(random(140,180)); clr = color(w,w,w);    break;
                    case NAVY   : clr = color(15,20,random(70,100));               break; 
                    default: println("COLOR CONSTRUCTOR SWITCH FAILURE");             
      }    }
 
     //CONSTRUCTORS
     Color(int label1, int label2){ Color c = PROB(0.5) ? new Color(label1) : new Color(label2) ; label = c.label; clr = c.clr;}
     Color(int label1, int label2, int label3){ Color c = PROB(0.33) ? new Color(label1) : PROB(0.50) ? new Color(label2) : new Color(label3) ; label = c.label; clr = c.clr;}
     Color(int label1, int label2, int label3, int label4){ Color c = PROB(0.25) ? new Color(label1) : PROB(0.33) ? new Color(label2) : PROB(0.50) ? new Color(label3) : new Color(label4) ; label = c.label; clr = c.clr;}
     Color(int label1, int label2, int label3, int label4, int label5) { Color c = PROB(0.20) ? new Color(label1) : PROB(0.25) ? new Color(label2) : PROB(0.33) ? new Color(label3) : PROB(0.50) ? new Color(label4) : new Color(label5) ; label = c.label; clr = c.clr;}
     Color(int label1, int label2, int label3, int label4, int label5, int label6){ Color c = PROB(0.16) ? new Color(label1) : PROB(0.20) ? new Color(label2) : PROB(0.25) ? new Color(label3) : PROB(0.33) ? new Color(label4) : PROB(0.50) ? new Color(label5) : new Color(label6) ; label = c.label; clr = c.clr;}
     Color(int label1, int label2, int label3, int label4, int label5, int label6, int label7){ Color c = PROB(0.14) ? new Color(label1) : PROB(0.16) ? new Color(label2) : PROB(0.20) ? new Color(label3) : PROB(0.25) ? new Color(label4) : PROB(0.33) ? new Color(label5) : PROB(0.50) ? new Color(label6) : new Color(label7) ; label = c.label; clr = c.clr;}
     
     boolean PROB(float p) { return random(1.0) < p;   }       //true with probability p
     int RAND(int lo, int hi) { return int(floor(random(lo,hi+1))); }  //random in range
     int RAND(int hi) { return int(floor(random(0,hi+1))); } //random in range from zero
     
      Color darker(){
            Color n = new Color(label);
            n.clr = color(max(0,red(clr) - 10),max(0,green(clr) - 10),max(0,blue(clr) - 10));
            return n;
      }
      Color lighter(){
            Color n = new Color(label);
            n.clr = color(red(clr) + 10,green(clr) + 10,blue(clr) + 10); 
            return n;
      }
      Color complementary(){
            //not as in classic color theory, but for G Minis
            //a red or white eye in a gris field, for example
            Color c = new Color(BLACK);
            switch (label){
                    case RED    : c = new Color(GRIS);                               break;
                    case BLUE   : c = PROB(0.9)? new Color(YELLOW) : new Color(RED); break;
                    case YELLOW : c = new Color(BLUE);                               break;
                    case BLACK  : c = new Color(WHITE);                              break;
                    case WHITE  : c = new Color(BLACK);                              break;
                    case GRIS   : c = PROB(0.5)? new Color(RED) : new Color(WHITE);  break;
                    case NAVY   : c = new Color(RED);                                break;
                    default: println("COLOR CONSTRUCTOR SWITCH FAILURE"); 
              }     
            return c;
      }       
      Color fresh(){
            int f = label;
            while (f == label)
                   f = RAND(RED,GRIS);
            return new Color(f);
      }
      Color fresh(int exclude){
            int f = label;
            while (f == label || f == exclude)
                   f = RAND(RED,GRIS);
            return new Color(f);
      }
      Color fresh(int x1, int x2){
            int f = label;
            while (f == label || f == x1 || f == x2)
                   f = RAND(RED,GRIS);
            return new Color(f);
      }
      Color fresh(Cell x){ 
            return fresh(x.clr.label); 
      }
      Color fresh(Cell x1, Cell x2){ 
            return fresh(x1.clr.label,x2.clr.label); 
      }
      boolean isSAMELABEL(Color c) { 
              return label == c.label; 
      }
      
      //PRESENTATION
      void tell(){
           print("Color label = "); 
           switch (label){
                    case RED    : print("RED");    break;
                    case BLUE   : print("BLUE");   break;
                    case YELLOW : print("YELLOW"); break;
                    case BLACK  : print("BLACK");  break;
                    case WHITE  : print("WHITE");  break;
                    case GRIS   : print("GRIS");   break;
                    case NAVY   : print("NAVY");   break;
                    default: println("COLOR CONSTRUCTOR SWITCH FAILURE");             
}     }    }
//end Class color
           
