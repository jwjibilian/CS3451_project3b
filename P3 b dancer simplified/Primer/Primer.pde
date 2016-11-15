import processing.sound.*;


//  ******************* Tango dancer 3D 2016 ***********************
Boolean animating=true, PickedFocus=false, center=true, showViewer=false, showBalls=false, showCone=true, showCaplet=true, showImproved=true, solidBalls=false;
float t=0, s=0;
int frame = 0;
SoundFile file;
int maxFrame = 120;
int _hipAngle2 = 0;
pt free, supp, hold;
float sf;
boolean init = true;
boolean isBFree = false;
boolean goingForward = true;
int stepCount = 1;
void setup() {
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureMode(NORMAL);          
  size(900, 900, P3D); // P3D means that we will do 3D graphics
  P.declare(); Q.declare(); PtQ.declare(); // P is a polyloop in 3D: declared in pts
  // P.resetOnCircle(3,100); Q.copyFrom(P); // use this to get started if no model exists on file: move points, save to file, comment this line
  P.loadPts("data/pts");  Q.loadPts("data/pts2"); // loads saved models from file (comment out if they do not exist yet)
  noSmooth();
  frameRate(30);
  
  file = new SoundFile(this, "tango.mp3");
  file.play();
  }

void draw() {
  background(255);
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  setView();  // see pick tab
  showFloor(); // draws dance floor as yellow mat
  doPick(); // sets point Of and picks closest vertex to it in P (see pick Tab)
   
  // Footprints shown as reg, green, blue disks on the floor 
  pt A = P.Pt(0), B = P.Pt(1), C = P.Pt(2);
  fill(grey);  showShadow(A,8);  showShadow(B,8); showShadow(C,8); 

  vec ForwardDirection = V(1,0,0);
  vec BackDirection = V(-1,0,0);
  // Footprints shown as reg, green, blue disks on the floor 
  //showNaiveDancer(A, s, B, ForwardDirection);  // THIS CALLS YOUR CODE IN TAB "Dancer"
  pt center = showDancer(A, s, B, ForwardDirection);  // THIS CALLS YOUR CODE IN TAB "Dancer"
  showDancer(P(B.x + 100, B.y - 20), s, P(A.x + 100, A.y - 20), BackDirection);
   
  pt cProj = B;
  cProj = P(cProj, 1.0/3.0, V(B,A));
  t=(1.-cos(PI*frame/maxFrame))/5;
      
      if (frame==0){
        if (init) {
          A.setTo( P(20,B.y));
          _hipAngle2 = 0;
         
          B.setTo(P(120,B.y));
          init = false;

        }
     
      }
      
      if(frame>0 && frame<=40){
        cProj = P(B, t, V(B, A));
        if(frame == 40) {
          if (free == null) {
            free = B;
            supp = A;
            isBFree = true;
          } else {
            if (goingForward) {
            hold = supp;
            supp = free;
            free = hold; 
            sf = d(free, supp);
            }
          }
          
          sf = d(free, supp);
          //pt next = P();
        }
      }
      
      if(frame>40 && frame<=80) {
         free = P(free, t, V(free,supp)); 
         println(free.x);
         if(isBFree) B.setTo(free.x,B.y, B.z);
         else A.setTo(free.x, A.y, A.z);
      }
      if (frame > 80 && frame <= 120) {
        if(goingForward) free = P(supp, t, V(supp, P((supp.x-sf)*2, (supp.y-sf)*2)));
        else free = P(supp, t, V(supp, P((supp.x+sf)*2, (supp.y+sf)*2)));
        if(isBFree) B.setTo(free.x,B.y, B.z);
        else A.setTo(free.x,A.y, A.z);
        
      }
      if (frame > 120) {
        frame = 0;
        if (stepCount % 2 != 0) {
           if (isBFree) isBFree = false;
           else isBFree = true;
           
        } else {
          if (goingForward) goingForward = false;
          else goingForward = true;
          stepCount = 0;
        }

        stepCount++;
      }
      
      frame++;
 

 //if(viewpoint) {Viewer = viewPoint(); viewpoint=false; showViewer=true;} // remember current viewpoint to shows viewer/floor frustum as part of the scene
     
 //if(showViewer) // shows viewer/floor frustum (toggled with ',')
 //    {
 //    noFill(); stroke(red); show(Viewer,P(200,200,0)); show(Viewer,P(200,-200,0)); show(Viewer,P(-200,200,0)); show(Viewer,P(-200,-200,0));
 //    noStroke(); fill(red,100); 
 //    show(Viewer,5); noFill();
 //    }
   
 
  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas

  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX,mouseY,26,26); fill(red); text(key,mouseX-5,mouseY+4);}
     
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  if(scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if (animating) { t+=PI/30; if(t>=TWO_PI) t=0; s=(cos(t)+1.)/2; } // periodic change of time 
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  // save next frame to make a movie
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  }
  