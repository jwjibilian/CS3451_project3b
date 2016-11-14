// **************************** AXIS ALIGNED PRIMITIVES
void showFrame(float d) { 
  noStroke(); 
  fill(metal); sphere(d/10);
  fill(blue);  showArrow(d,d/10);
  fill(red); pushMatrix(); rotateY(PI/2); showArrow(d,d/10); popMatrix();
  fill(green); pushMatrix(); rotateX(-PI/2); showArrow(d,d/10); popMatrix();
  }

void showFan(float d, float r) {
  float da = TWO_PI/36;
  beginShape(TRIANGLE_FAN);
    vertex(0,0,d);
    for(float a=0; a<=TWO_PI+da; a+=da) vertex(r*cos(a),r*sin(a),0);
  endShape();
  }

void showCollar(float d, float r, float rd) {
  float da = TWO_PI/36;
  beginShape(QUAD_STRIP);
    for(float a=0; a<=TWO_PI+da; a+=da) {vertex(r*cos(a),r*sin(a),0); vertex(rd*cos(a),rd*sin(a),d);}
  endShape();
  }

void showCone(float d, float r) {showFan(d,r);  showFan(0,r);}

void showStub(float d, float r, float rd) {
  showCollar(d,r,rd); showFan(0,r);  pushMatrix(); translate(0,0,d); showFan(0,rd); popMatrix();
  }
  
void showArrow(float d, float r) {
  float dd=d/5;
  showStub(d-dd,r*2/3,r/3); pushMatrix(); translate(0,0,d-dd); showCone(dd,r); popMatrix();
  }  
  
void showBlock(float w, float d, float h, float x, float y, float z, float a) {
  pushMatrix(); translate(x,y,z); rotateZ(TWO_PI*a); box(w, d, h); popMatrix(); 
  }
 
// **************************** PRIMITIVE FROM POINTS, VECTOR, RADIUS PARAMETER
void coneSection(pt P, pt Q, float p, float q) { // surface
  vec V = V(P,Q);
  vec I = U(Normal(V));
  vec J = U(N(I,V));
  collar(P,V,I,J,p,q);
  }

void cylinderSection(pt P, pt Q, float r) { coneSection(P,Q,r,r);} 
 
void showCaplet(pt A, float a, pt B, float b)  // cone section surface that is tangent to Sphere(A,a) and to Sphere(B,b)
  {
  // this code hould be replaced by the proper code for caplets
  coneSection(A,B,a,b);
  
  }   
  
// FANS, CONES, AND ARROWS
void disk(pt P, vec V, float r) {  
  vec I = U(Normal(V));
  vec J = U(N(I,V));
  disk(P,I,J,r);
  }

void disk(pt P, vec I, vec J, float r) {
  float da = TWO_PI/36;
  beginShape(TRIANGLE_FAN);
    v(P);
    for(float a=0; a<=TWO_PI+da; a+=da) v(P(P,r*cos(a),I,r*sin(a),J));
  endShape();
  }
  

void fan(pt P, vec V, float r) {  
  vec I = U(Normal(V));
  vec J = U(N(I,V));
  fan(P,V,I,J,r);
  }

void fan(pt P, vec V, vec I, vec J, float r) {
  float da = TWO_PI/36;
  beginShape(TRIANGLE_FAN);
    v(P(P,V));
    for(float a=0; a<=TWO_PI+da; a+=da) v(P(P,r*cos(a),I,r*sin(a),J));
  endShape();
  }
  
void collar(pt P, vec V, float r, float rd) {
  vec I = U(Normal(V));
  vec J = U(N(I,V));
  collar(P,V,I,J,r,rd);
  }
 
void collar(pt P, vec V, vec I, vec J, float r, float rd) {
  float da = TWO_PI/36;
  beginShape(QUAD_STRIP);
    for(float a=0; a<=TWO_PI+da; a+=da) {v(P(P,r*cos(a),I,r*sin(a),J,0,V)); v(P(P,rd*cos(a),I,rd*sin(a),J,1,V));}
  endShape();
  }

void cone(pt P, vec V, float r) {fan(P,V,r); disk(P,V,r);}

void stub(pt P, vec V, float r, float rd) {
  collar(P,V,r,rd); disk(P,V,r); disk(P(P,V),V,rd); 
  }
  
void arrow(pt P, vec V, float r) {
  stub(P,V(.8,V),r*2/3,r/3); 
  cone(P(P,V(.8,V)),V(.2,V),r); 
  }    