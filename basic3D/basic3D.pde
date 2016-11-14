//basic3D, Jarek Rossignac Oct 2016
float dz=0; // distance to camera. Manipulated with wheel or when 
float rx=-0.06*TWO_PI, ry=-0.04*TWO_PI;    // view angles manipulated when space pressed but not mouse
float w=400; // half-size of the cube containing the scene displayed

BALLS B = new BALLS(); // polyloop in 3D


void setup() {
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureMode(NORMAL);          
  size(600, 600, P3D); // p3D means that we will do 3D graphics
  noSmooth();
  B.declare();
  B.addBall(P(30,20,70),10,magenta);
  B.addBall(P(-60,80,10),20,cyan);
  B.addBall(P(40,60,-40),30,green);
  B.addBall(P(-40,-80,-40),30,blue);
  }

void draw() {
  background(255);
  hint(ENABLE_DEPTH_TEST); 
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  
    camera();       // sets a standard perspective
    translate(width/2,height/2,dz); // puts origin of model at screen center and moves forward/away by dz
    lights();  // turns on view-dependent lighting
    rotateX(rx); rotateY(ry); // rotates the model around the new origin (center of screen)
    rotateX(PI/2); // rotates frame around X to make X and Y basis vectors parallel to the floor
    noStroke(); // if you use stroke, the weight (width) of it will be scaled with you scaleing factor
    showFrame(50); // X-red, Y-green, Z-blue arrows
    fill(yellow); pushMatrix(); translate(0,0,-w/2-1.5); box(w,w,1); popMatrix(); // draws floor as thin plate
    noFill(); stroke(black); showBlock(w,w,w, 0,0,0 ,0);
    noStroke();
     
   
    
    B.showBalls();
     
    pt PP = pick( mouseX, mouseY ); 
    if(picking) 
      {
      picking=false;
      B.pickClosest(PP);
      } 
    else // shows red ball on from most surface under the mouse (but only on surfaces displayed so far, so not on the caplets displayed below).
      {
      fill(red); 
      show(PP,3);
      }
       
    fill(grey); B.capletH(0,1); B.capletH(1,2); B.capletH(2,3);

    if(mousePressed) B.showPickedBall();
    
   popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas

   hint(DISABLE_DEPTH_TEST); // no z-buffer test to ensure that help text is visible

   
   // for demos: shows the mouse and the key pressed (but it may be hidden by the 3D model)
   if(keyPressed) {stroke(red); fill(white); ellipse(mouseX,mouseY,26,26); fill(red); text(key,mouseX-5,mouseY+4);}
      
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  if(scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if(change) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".png");  // save next frame to make a movie

  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  }
  
void keyPressed() {
  if(key=='?') scribeText=!scribeText;
  if(key=='!') snapPicture();
  if(key=='~') filming=!filming;
  if(key=='w') B.saveBALLS("./data/savedBalls");
  if(key=='l') B.loadBALLS("./data/savedBalls");
  change=true;
  }

void mouseWheel(MouseEvent event) {dz -= event.getAmount(); change=true;}

void mousePressed() {picking=true;}
  
void mouseMoved() {
  if (keyPressed && key==' ') {rx-=PI*(mouseY-pmouseY)/height; ry+=PI*(mouseX-pmouseX)/width;};
  if (keyPressed && key=='z') dz+=(float)(mouseY-pmouseY)*5; // approach view (same as wheel)
  }
  
void mouseDragged() 
  {
  }  

// **** Header, footer, help text on canvas
void displayHeader() // Displays title and authors face on screen
    { 
    scribeHeader(title,0); 
    scribeHeaderRight(name); 
    fill(white); 
    image(myFace, width-myFace.width/2,25,myFace.width/2,myFace.height/2); 
    }
    
void displayFooter() { // Displays help text at the bottom
    scribeFooter(guide,1); 
    scribeFooter(menu,0); 
    }

String title ="base3D code for projects: ", name ="Your Name and pic here!",
       menu="?:help, !:picture, ~:videotape, space (no mouse):rotate, wheel or z (no mouse):zoom",
       guide="click on a ball to select it "; // user's guide
       