//  ******************* Tango dancer 3D 2016 ***********************
Boolean animating=true, PickedFocus=false, center=true, showViewer=false, showBalls=true, showCone=true, showCaplet=false, solidBalls=false;
float t=0, s=0;
void setup() {
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureMode(NORMAL);          
  size(900, 900, P3D); // P3D means that we will do 3D graphics
  P.declare(); Q.declare(); PtQ.declare(); // P is a polyloop in 3D: declared in pts
  //P.resetOnCircle(4,100); Q.copyFrom(P); // use this to get started if no model exists on file: move points, save to file, comment this line
  P.loadPts("data/pts");  Q.loadPts("data/pts2"); // loads saved models from file (comment out if they do not exist yet)
  noSmooth();
  }

void draw() {
  background(255);
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  // set view
    float fov = PI/3.0;
    float cameraZ = (height/2.0) / tan(fov/2.0);
    camera(0,0,cameraZ,0,0,0,0,1,0  );       // sets a standard perspective
    perspective(fov, 1.0, 0.1, 10000);
    
    translate(0,0,dz); // puts origin of model at screen center and moves forward/away by dz
    lights();  // turns on view-dependent lighting
    rotateX(rx); rotateY(ry); // rotates the model around the new origin (center of screen)
    rotateX(PI/2); // rotates frame around X to make X and Y basis vectors parallel to the floor
    if(center) translate(-F.x,-F.y,-F.z);  // center the focus on F
    
    noStroke(); // if you use stroke, the weight (width) of it will be scaled with you scaleing factor
    showFrame(50); // show the vectors of the main coordinate system: X-red, Y-green, Z-blue arrows
   
  // show yellow floor  
  fill(yellow); pushMatrix(); translate(0,0,-1.5); box(400,400,1); popMatrix(); // draws floor as thin plate
  
  // show focus point F and its shadow
  fill(magenta); show(F,4); // magenta focus point (stays at center of screen)
  fill(magenta,100); showShadow(F,5); // magenta translucent shadow of focus point (after moving it up with 'F'

  computeProjectedVectors(); // computes screen projections I, J, K of basis vectors (see bottom of pv3D): used for dragging in viewer's frame    
  pp=P.idOfVertexWithClosestScreenProjectionTo(Mouse()); // Software pick of vertex of P with closest screen projection to mouse (us in keyPressed 'x'...

  PtQ.setToL(P,s,Q); // compute LERP-interpolated balls between P and Q: used for animation turned on/off byh pressing 'a'

  if(showBalls) // shows 
    {
     pushMatrix(); fill(grey,100); scale(1,1,0.01); P.drawBalls(4); Q.drawBalls(4); PtQ.drawBalls(4); popMatrix(); // show floor shadow of green balls
     fill(green); P.drawBalls(4); // draw green balls
     fill(red); Q.drawBalls(4); // draw green balls
     fill(blue); PtQ.drawBalls(4); // draw green balls
     fill(red,100); P.showPicked(6); // shows currently picked vertex in transparent red (last key action 'x', 'z'
     }
    
  showDancer(PtQ.Pt(0), PtQ.Pt(1), PtQ.Pt(2), PtQ.Pt(3));  // THIS CALLS YOUR CODE IN TAB "RenderScene"
   

  // Locks focus on point Of until Of is reset (mouse pressed, but no key)
  if(PickedFocus) F=P(Of); 
  if(mousePressed&&!keyPressed) // when mouse is pressed (but no key), show red ball at surface point under the mouse (and its shadow)
     {
     PickedFocus=false;  
     Of = pick( mouseX, mouseY);  
     fill(magenta); show(Of,3); 
     fill(red,100); showShadow(Of,5);  
     }   

 if(viewpoint) {Viewer = viewPoint(); viewpoint=false; showViewer=true;} // remember current viewpoint to shows viewer/floor frustum as part of the scene
     
 if(showViewer) // shows viewer/floor frustum (toggled with ',')
     {
     noFill(); stroke(red); show(Viewer,P(200,200,0)); show(Viewer,P(200,-200,0)); show(Viewer,P(-200,200,0)); show(Viewer,P(-200,-200,0));
     noStroke(); fill(red,100); 
     show(Viewer,5); noFill();
     }
   
 
  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas

  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX,mouseY,26,26); fill(red); text(key,mouseX-5,mouseY+4);}
     
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  if(scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if (animating) { t+=PI/180/2; if(t>=TWO_PI) t=0; s=(cos(t)+1.)/2; } // periodic change of time 
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  // save next frame to make a movie
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  }
  