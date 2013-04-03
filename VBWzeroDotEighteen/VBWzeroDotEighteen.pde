//Copyright (C) <2013> <Loe Feijs and TU/e
import processing.pdf.*;

int seed = 8738635; //choose any positive integer (-1 means random)
boolean speedy = false;
boolean rontgen = false;
boolean frozen = false; 
boolean oldlook = false;
boolean boxing = false;
boolean sketchFullScreen(){ return false;}

Canvas victory;
int s; //seed
void setup(){
     if (displayHeight >= 1080) size(1000,1000); else size(900,900);  
     s = int(random(10000000)); if (seed > 0) s = seed; 
     randomSeed(s);   print("seed = "); println(s); 
     //two-stage random generation supports replay
     victory = new Canvas(width/2,height/2);
     victory.setup();
     frameRate(400);
}

void draw(){
     if (!frozen){ 
         victory.grow(speedy ? 20 : 2);
         victory.draw(false);
     }
     if (rontgen) 
         victory.rontgen();
}

void keyPressed(){
     if (key == 'b')
         boxing = ! boxing;
     if (key == 'c')
         victory.count();
     if (key == 'e')
         exit();
     if (key == 'f')
         frozen = !frozen;
     if (key == 'g'){
         victory.grow(1);
         victory.draw(false);
     }
     if (key == 'o'){
         oldlook = !oldlook;
     }
     if (key == 'p'){
        String file = "canvas" + Integer.toString(s);
        println("printing " + file + ".pdf .."); 
        beginRecord(PDF,file + ".pdf");
        victory.draw(true);
        endRecord();
        println("done");
     }
     if (key == 's')
         speedy = !speedy;
     if (key == 't')
         victory.tell();
     if (key == 'x'){
        rontgen = !rontgen;
        victory.draw();
     }
     if (key == 'z' || key == ' '){
         oldlook = false;
         setup();
     }
}
