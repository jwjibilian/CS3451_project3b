// points, vectors, frames in 3D
class vec { float x=0,y=0,z=0; 
   vec () {}; 
   vec (float px, float py, float pz) {x = px; y = py; z = pz;};
    } // end class vec
  
class pt { float x=0,y=0,z=0; 
   pt () {}; 
   pt (float px, float py) {x = px; y = py;};
   pt (float px, float py, float pz) {x = px; y = py; z = pz; };
   pt setTo(pt P) {x = P.x; y = P.y; z = P.z; return this;}; 
   pt setTo(float px, float py, float pz) {x = px; y = py; z = pz; return this;}; 
   pt add(vec V) {x+=V.x; y+=V.y; z+=V.z; return this;};
   }
   
// =====  vector functions
vec V() {return new vec(); };                                                                          // make vector (x,y,z)
vec V(float x, float y, float z) {return new vec(x,y,z); };                                            // make vector (x,y,z)
vec V(vec V) {return new vec(V.x,V.y,V.z); };                                                          // make copy of vector V
vec A(vec A, vec B) {return new vec(A.x+B.x,A.y+B.y,A.z+B.z); };                                       // A+B
vec A(vec U, float s, vec V) {return V(U.x+s*V.x,U.y+s*V.y,U.z+s*V.z);};                               // U+sV
vec M(vec U, vec V) {return V(U.x-V.x,U.y-V.y,U.z-V.z);};                                              // U-V
vec M(vec V) {return V(-V.x,-V.y,-V.z);};                                                              // -V
vec V(vec A, vec B) {return new vec((A.x+B.x)/2.0,(A.y+B.y)/2.0,(A.z+B.z)/2.0); }                      // (A+B)/2
vec V(vec A, float s, vec B) {return new vec(A.x+s*(B.x-A.x),A.y+s*(B.y-A.y),A.z+s*(B.z-A.z)); };      // (1-s)A+sB
vec V(vec A, vec B, vec C) {return new vec((A.x+B.x+C.x)/3.0,(A.y+B.y+C.y)/3.0,(A.z+B.z+C.z)/3.0); };  // (A+B+C)/3
vec V(vec A, vec B, vec C, vec D) {return V(V(A,B),V(C,D)); };                                         // (A+B+C+D)/4
vec V(float s, vec A) {return new vec(s*A.x,s*A.y,s*A.z); };                                           // sA
vec V(float a, vec A, float b, vec B) {return A(V(a,A),V(b,B));}                                       // aA+bB 
vec V(float a, vec A, float b, vec B, float c, vec C) {return A(V(a,A,b,B),V(c,C));}                   // aA+bB+cC
vec V(pt P, pt Q) {return new vec(Q.x-P.x,Q.y-P.y,Q.z-P.z);};                                          // PQ
vec U(vec V) {float n = n(V); if (n<0.0000001) return V(0,0,0); else return V(1./n,V);};               // V/||V||
vec U(pt P, pt Q) {return U(V(P,Q));};                                                                 // PQ/||PQ||
vec U(float x, float y, float z) {return U(V(x,y,z)); };                                               // make init vector from <x,y,z>

// ====== Cross and Mixed Product
vec N(vec U, vec V) {return V( U.y*V.z-U.z*V.y, U.z*V.x-U.x*V.z, U.x*V.y-U.y*V.x); };                  // UxV CROSS PRODUCT (normal to both)
vec N(pt A, pt B, pt C) {return N(V(A,B),V(A,C)); };                                                   // normal to triangle (A,B,C), not normalized (proportional to area)
vec B(vec U, vec V) {return U(N(N(U,V),U)); }                                                          // Unit vector orthgonal to U in the plane of U and V        
vec Normal(vec V) {                                                                                    // any non zero vector normal to V
  if(abs(V.z)<=min(abs(V.x),abs(V.y))) return V(-V.y,V.x,0); 
  if(abs(V.x)<=min(abs(V.z),abs(V.y))) return V(0,-V.z,V.y);
  return V(V.z,0,-V.x);
  }


// ===== point functions
pt P() {return new pt(); };                                                                          // point (x,y,z)
pt P(float x, float y, float z) {return new pt(x,y,z); };                                            // point (x,y,z)
pt P(float x, float y) {return new pt(x,y); };                                                       // make point (x,y)
pt P(pt A) {return new pt(A.x,A.y,A.z); };                                                           // copy of point P
pt P(pt A, float s, pt B) {return new pt(A.x+s*(B.x-A.x),A.y+s*(B.y-A.y),A.z+s*(B.z-A.z)); };        // A+sAB "LERP"
pt P(pt A, pt B) {return P((A.x+B.x)/2.0,(A.y+B.y)/2.0,(A.z+B.z)/2.0); }                             // (A+B)/2 "Average"
pt P(pt A, pt B, pt C) {return new pt((A.x+B.x+C.x)/3.0,(A.y+B.y+C.y)/3.0,(A.z+B.z+C.z)/3.0); };     // (A+B+C)/3 "Average"
pt P(pt A, pt B, pt C, pt D) {return P(P(A,B),P(C,D)); };                                            // (A+B+C+D)/4 "Average"
pt P(float s, pt A) {return new pt(s*A.x,s*A.y,s*A.z); };                                            // sA scaling
pt A(pt A, pt B) {return new pt(A.x+B.x,A.y+B.y,A.z+B.z); };                                         // A+B do not use by itself (helper for affine combinations)
pt P(float a, pt A, float b, pt B) {return A(P(a,A),P(b,B));}                                        // aA+bB 
pt P(float a, pt A, float b, pt B, float c, pt C) {return A(P(a,A),P(b,B,c,C));}                     // aA+bB+cC 
pt P(float a, pt A, float b, pt B, float c, pt C, float d, pt D){return A(P(a,A,b,B),P(c,C,d,D));}   // aA+bB+cC+dD
pt P(pt P, vec V) {return new pt(P.x + V.x, P.y + V.y, P.z + V.z); }                                 // P+V
pt P(pt P, float s, vec V) {return new pt(P.x+s*V.x,P.y+s*V.y,P.z+s*V.z);}                           // P+sV
pt P(pt O, float x, vec I, float y, vec J) {return P(O.x+x*I.x+y*J.x,O.y+x*I.y+y*J.y,O.z+x*I.z+y*J.z);}  // O+xI+yJ
pt P(pt O, float x, vec I, float y, vec J, float z, vec K) {return P(O.x+x*I.x+y*J.x+z*K.x,O.y+x*I.y+y*J.y+z*K.y,O.z+x*I.z+y*J.z+z*K.z);}  // O+xI+yJ+kZ
void makePts(pt[] C) {for(int i=0; i<C.length; i++) C[i]=P();}


// ===== mouse
pt Mouse() {return P(mouseX,mouseY,0);};                                          // current mouse location
pt Pmouse() {return P(pmouseX,pmouseY,0);};
vec MouseDrag() {return V(mouseX-pmouseX,mouseY-pmouseY,0);};                     // vector representing recent mouse displacement
pt ScreenCenter() {return P(width/2,height/2);}                                                        //  point in center of  canvas

// ===== measures
float d(vec U, vec V) {return U.x*V.x+U.y*V.y+U.z*V.z; };                                            //U*V dot product
float dot(vec U, vec V) {return U.x*V.x+U.y*V.y+U.z*V.z; };                                            //U*V dot product
float det2(vec U, vec V) {return -U.y*V.x+U.x*V.y; };                                       // U|V det product
float det3(vec U, vec V) {return sqrt(d(U,U)*d(V,V) - sq(d(U,V))); };                                       // U|V det product
float m(vec U, vec V, vec W) {return d(U,N(V,W)); };                                                 // (UxV)*W  mixed product, determinant
float m(pt E, pt A, pt B, pt C) {return m(V(E,A),V(E,B),V(E,C));}                                    // det (EA EB EC) is >0 when E sees (A,B,C) clockwise
float n2(vec V) {return sq(V.x)+sq(V.y)+sq(V.z);};                                                   // V*V    norm squared
float n(vec V) {return sqrt(n2(V));};                                                                // ||V||  norm
float d(pt P, pt Q) {return sqrt(sq(Q.x-P.x)+sq(Q.y-P.y)+sq(Q.z-P.z)); };                            // ||AB|| distance
float area(pt A, pt B, pt C) {return n(N(A,B,C))/2; };                                               // area of triangle 
float volume(pt A, pt B, pt C, pt D) {return m(V(A,B),V(A,C),V(A,D))/6; };                           // volume of tet 
boolean parallel (vec U, vec V) {return n(N(U,V))<n(U)*n(V)*0.00001; }                              // true if U and V are almost parallel
float angle(vec U, vec V) {return acos(d(U,V)/n(V)/n(U)); };                                       // angle(U,V)
boolean cw(vec U, vec V, vec W) {return m(U,V,W)>0; };                                               // (UxV)*W>0  U,V,W are clockwise
boolean cw(pt A, pt B, pt C, pt D) {return volume(A,B,C,D)>0; };                                     // tet is oriented so that A sees B, C, D clockwise 
boolean projectsBetween(pt P, pt A, pt B) {return dot(V(A,P),V(A,B))>0 && dot(V(B,P),V(B,A))>0 ; };
float disToLine(pt P, pt A, pt B) {return det3(U(A,B),V(A,P)); };
pt projectionOnLine(pt P, pt A, pt B) {return P(A,dot(V(A,B),V(A,P))/dot(V(A,B),V(A,B)),V(A,B));}

// ===== rotate 
vec R(vec V) {return V(-V.y,V.x,V.z);} // rotated 90 degrees in XY plane
pt R(pt P, float a, vec I, vec J, pt G) {float x=d(V(G,P),I), y=d(V(G,P),J); float c=cos(a), s=sin(a); return P(P,x*c-x-y*s,I,x*s+y*c-y,J); }; // Rotated P by a around G in plane (I,J)
vec R(vec V, float a, vec I, vec J) {float x=d(V,I), y=d(V,J); float c=cos(a), s=sin(a); return A(V,V(x*c-x-y*s,I,x*s+y*c-y,J)); }; // Rotated V by a parallel to plane (I,J)
pt R(pt Q, pt C, pt P, pt R) { // returns rotated version of Q by angle(CP,CR) parallel to plane (C,P,R)
   vec I0=U(C,P), I1=U(C,R), V=V(C,Q); 
   float c=d(I0,I1), s=sqrt(1.-sq(c)); 
     if(abs(s)<0.00001) return Q;
   vec J0=V(1./s,I1,-c/s,I0);  
   vec J1=V(-s,I0,c,J0);  
   float x=d(V,I0), y=d(V,J0);
                                //  stroke(red); show(C,400,I0); stroke(blue); show(C,400,I1); stroke(orange); show(C,400,J0); stroke(magenta); show(C,400,J1); noStroke();
   return P(Q,x,M(I1,I0),y,M(J1,J0)); 
  } 
pt R(pt Q, float a) {float dx=Q.x, dy=Q.y, c=cos(a), s=sin(a); return P(c*dx+s*dy,-s*dx+c*dy,Q.z); };  // Q rotated by angle a around the origin
pt R(pt Q, float a, pt C) {float dx=Q.x-C.x, dy=Q.y-C.y, c=cos(a), s=sin(a); return P(C.x+c*dx-s*dy, C.y+s*dx+c*dy, Q.z); };  // Q rotated by angle a around point P

// ===== render
void normal(vec V) {normal(V.x,V.y,V.z);};                                          // changes normal for smooth shading
void vertex(pt P) {vertex(P.x,P.y,P.z);};                                           // vertex for shading or drawing
void v(pt P) {vertex(P.x,P.y,P.z);};                                           // vertex for shading or drawing
void nv(vec N) {normal(N.x,N.y,N.z);};                                           // vertex for shading or drawing
void vTextured(pt P, float u, float v) {vertex(P.x,P.y,P.z,u,v);};                          // vertex with texture coordinates
void show(pt P, pt Q) {line(Q.x,Q.y,Q.z,P.x,P.y,P.z); };                       // draws edge (P,Q)
void show(pt P, vec V) {line(P.x,P.y,P.z,P.x+V.x,P.y+V.y,P.z+V.z); };          // shows edge from P to P+V
void show(pt P, float d , vec V) {line(P.x,P.y,P.z,P.x+d*V.x,P.y+d*V.y,P.z+d*V.z); }; // shows edge from P to P+dV
void show(pt A, pt B, pt C) {beginShape(); vertex(A);vertex(B); vertex(C); endShape(CLOSE);};                      // volume of tet 
void show(pt A, pt B, pt C, pt D) {beginShape(); vertex(A); vertex(B); vertex(C); vertex(D); endShape(CLOSE);};                      // volume of tet 
void show(pt P, float r) {pushMatrix(); translate(P.x,P.y,P.z); sphere(r); popMatrix();}; // render sphere of radius r and center P
void show(pt P, float s, vec I, vec J, vec K) {noStroke(); fill(yellow); show(P,5); stroke(red); show(P,s,I); stroke(green); show(P,s,J); stroke(blue); show(P,s,K); }; // render sphere of radius r and center P
void show(pt P, String s) {text(s, P.x, P.y, P.z); }; // prints string s in 3D at P
void show(pt P, String s, vec D) {text(s, P.x+D.x, P.y+D.y, P.z+D.z);  }; // prints string s in 3D at P+D
void showShadow(pt P, float r) {pushMatrix(); translate(P.x,P.y,0); scale(1,1,0.01); sphere(r); popMatrix();} // shadow on plane z==0
void showShadow(pt P, float r, float h) {pushMatrix(); translate(P.x,P.y,h); scale(1,1,0.01); sphere(r); popMatrix();}

String toText(vec V){ return "("+nf(V.x,1,5)+","+nf(V.y,1,5)+","+nf(V.z,1,5)+")";}