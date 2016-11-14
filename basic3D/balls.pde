
class BALLS // class for manipulaitng and displaying balls
 { 
 int pv = 0, // index of picked ball
     nv = 0;  // number of vertices currently used in P
 int maxnv = 1000;                 //  max number of vertices
 pt[] G = new pt [maxnv];           // ball centers
 float[] r = new float [maxnv];     // radii
 color[] c = new color [maxnv];     // colors
 
  BALLS() {}
 
  void declare() {for (int i=0; i<maxnv; i++) {G[i]=P(); r[i]=1; c[i]=yellow;}}     // init all point objects

  BALLS empty() {nv=0; pv=0; return this;} // resets P so that we can start adding points
      
  BALLS addBall(pt Pp, float rp, color cp) { 
    G[nv].setTo(Pp); 
    r[nv]=rp; 
    c[nv]=cp; 
    pv=nv;
    nv++;  
    return this;} // adds a point at the end
    
  void showBalls() 
    { 
    noStroke(); 
    for (int v=0; v<nv; v++) 
      {
      fill(c[v]); 
      show(G[v],r[v]); 
      fill(c[v]); 
      showShadow(G[v],r[v],-w/2+2); 
      }
    } 


  void pickClosest(pt M) { // for picking a vertex with the mouse
    pv=0; 
    for (int i=1; i<nv; i++) if (d(M,G[i])<=d(M,G[pv])) pv=i; 
    }
    
    
  void movePicked(vec V) { G[pv].add(V); }      // moves selected point (index p) by amount mouse moved recently

  void showPickedBall() {fill(yellow,100); show(G[pv],r[pv]+5); println("SHOW pv="+pv);} 
  
  void caplet(int i, int j)
    {
    showCaplet(G[i],r[i],G[j],r[j]);
    }

  void capletH(int i, int j) // Halfsize caplet
    {
    showCaplet(G[i],r[i]/2,G[j],r[j]/2);
    }

  void saveBALLS(String fn) {
    String [] inpBALLS = new String [nv+1];
    int s=0;
    inpBALLS[s++]=str(nv);
    for (int i=0; i<nv; i++) {inpBALLS[s++]=str(G[i].x)+","+str(G[i].y)+","+str(G[i].z);}
    saveStrings(fn,inpBALLS);
    };
  
  void loadBALLS(String fn) {
    println("loading: "+fn); 
    String [] ss = loadStrings(fn);
    String subBALLS;
    int s=0;   int comma, comma1, comma2;   float x, y;   int a, b, c;
    nv = int(ss[s++]); print("nv="+nv);
    for(int k=0; k<nv; k++) {int i=k+s; float [] xy = float(split(ss[i],",")); G[k].setTo(xy[0],xy[1],xy[2]);}
    pv=0;
    }; 

  } // end of BALLS class