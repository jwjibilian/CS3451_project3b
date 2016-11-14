// Demo of a bouncing ball with a mirror by Jarek Rossignac
float rx=0, ry=0;    // view angles
PImage wood;         // texture image
BALL B = new BALL();
  
void setup() {
  size(600, 600, P3D); 
  PFont font = loadFont("Courier-14.vlw"); textFont(font, 14);      // load font
  wood = loadImage("floor.jpg");         // load texture
  textureMode(NORMAL);          
  B.reset();
  } 
 
void draw() {         // rendering loop to refresh the window
  background(255);  lights();
  directionalLight(256,256,256, 0, 1, 0);
  fill(50); text("Jarek Rossignac",40,40);
  if (mousePressed) {rx+=(mouseY-pmouseY)/800.;ry-=(mouseX-pmouseX)/800.;};
  translate(width/2,0,0); rotateY(ry);  translate(-width/2,0,0); 
  rotateX(rx); translate(0,0,-100);
  noStroke(); fill(0); 
  B.move();  
  showFloor(); B.showShadow(); fill(100,150,50); B.show();
  showWall();
  scale(1,1,-1); translate(0,0,600);
  showFloor(); B.showShadow();  fill(200,250,150);  noLights(); lights(); directionalLight(256,256,256, 0, -1, 0);B.show();
 };

void keyPressed() {  
   if (key==' ') B.reset();
   if (key=='!') {String S="bounce"+"-####.tif"; saveFrame(S);};   // makes a picture
   };
   
void showFloor() {  
  beginShape(QUADS);    texture(wood);          // activate texture
  vertex( 600, height+2, 300, 1, 1); vertex(600, height+2, -300, 1, 0); vertex(0,height+2,-300, 0, 0);  vertex( 0, height+2, 300, 0, 1);  
  endShape(); 
  }
  
void showWall() {  
  fill(200,200,20); beginShape();           // activate texture
  vertex( 0, 0, -300); vertex(600, 0, -300); vertex(600,height,-300);  vertex( 0, height, -300);  
  vertex( 0, 100, -300); vertex(100, 100, -300); vertex(100,500,-300);  vertex( 500, 500, -300);  
  vertex( 500, 100, -300); 
  vertex(1, 99, -300);  
  endShape(CLOSE); 
  }


class BALL {
  BALL() {reset();}
  float x, y, vx, vy, a, r=40;
  void reset() {x=r; y=height-r; vx=1; vy=-6; a=0.05;}
  void show() {pushMatrix(); translate(x,y,0);   sphere(r);  popMatrix();}
  void showShadow() {pushMatrix(); translate(0,height,0); scale(1,-0.001,1);  translate(x,y,0); fill(10,10,10); sphere(r); popMatrix(); } 
  void move() { x+=vx; y+=vy; vy+=a;  if(y>height-r) vy=-vy; }
  }
