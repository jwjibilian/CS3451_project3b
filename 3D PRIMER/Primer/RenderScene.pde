// Student's should use this to render their model

void showDancer(pt A, pt B, pt Ar, pt Br)
  {
  float a = d(A,Ar), b=d(B,Br);
  if(solidBalls) fill(orange); else fill(orange, 100); 
  show(A,a); show(B,b); 
  if(showCone)   {if(!solidBalls) fill(metal); coneSection(A,B,a,b);}   // toggled by 'K'
  if(showCaplet) {if(!solidBalls) fill(cyan);  capletSection(A,B,a,b);} // toggled by 'C' (does not work until you fix it)
  fill(green); block(10,100,50,100,0,0,.6);
  
  // once you have written and debugged capletSection, 
  // change the code above to display a dancer defined by its two feet positions and orientations of its hips and shoulders
  
  // also change the parameters to showDancer to include these 2 points A and Bm but also 2 angles
  
  // change the calling in "primer" draw() to call produce LERPS of these angles 
  // so that the dancer makes a step and also rotates the hips and shoulders
  
  }
  
void capletSection(pt A, pt B, float a, float b)  // cone section surface that is tangent to Sphere(A,a) and to Sphere(B,b)
  {
    // 4 short lines of code
    // including a call to coneSection() (see in tab "primitives"
  }  