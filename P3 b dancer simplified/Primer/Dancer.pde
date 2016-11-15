// Student's should use this to render their model


 pt showDancer(pt LeftFoot, float transfer, pt RightFoot, vec Forward)
  {
  float footRadius=3, kneeRadius = 6,  hipRadius=12 ; // radius of foot, knee, hip
  float hipSpread = hipRadius; // half-displacement between hips
  float bodyHeight = 100; // height of body center B
  float ankleBackward=10, ankleInward=4, ankleUp=6, ankleRadius=4; // ankle position with respect to footFront and size
  float pelvisHeight=10, pelvisForward=hipRadius/2, pelvisRadius=hipRadius*1.3; // vertical distance form BodyCenter to Pelvis 
  float LeftKneeForward = 20; // arbitrary knee offset for mid (B,H)
  float torsoHeight = pelvisHeight + 10;

  vec Up = V(0,0,1); // up vector
  
  vec Right = N(Up,Forward); // side vector pointing towards the right
  
  // BODY
  pt BodyProjection = L(LeftFoot,1./3+transfer/3,RightFoot); // floor projection of B
  pt BodyCenter = P(BodyProjection,bodyHeight,Up); // Body center
  fill(blue); showShadow(BodyCenter,5); // sphere(BodyCenter,hipRadius);
  //fill(blue); arrow(BodyCenter,V(100,Forward),5); // forward arrow
  
 
 // ANKLES
  pt RightAnkle =  P(RightFoot, -ankleBackward,Forward, -ankleInward,Right, ankleUp,Up);
  fill(red);  
  capletSection(RightFoot,footRadius,RightAnkle,ankleRadius);  
  pt LeftAnkle =  P(LeftFoot, -ankleBackward,Forward, ankleInward,Right, ankleUp,Up);
  fill(green);  
  capletSection(LeftFoot,footRadius,LeftAnkle,ankleRadius);  
  fill(blue);  
  sphere(RightAnkle,ankleRadius);
  sphere(LeftAnkle,ankleRadius);
 
  // FEET (CENTERS OF THE BALLS OF THE FEET)
  fill(blue);  
  sphere(RightFoot,footRadius);
  pt RightToe =   P(RightFoot,5,Forward);
  capletSection(RightFoot,footRadius,RightToe,1);
  sphere(LeftFoot,footRadius);
  pt LeftToe =   P(LeftFoot,5,Forward);
  capletSection(LeftFoot,footRadius,LeftToe,1);

  // HIPS
  pt RightHip =  P(BodyCenter,hipSpread,Right);
  fill(red);  sphere(RightHip,hipRadius);
  pt LeftHip =  P(BodyCenter,-hipSpread,Right);
  fill(green);  sphere(LeftHip,hipRadius);

  // KNEES AND LEGs
  float RightKneeForward = 20;
  pt RightMidleg = P(RightHip,RightAnkle);
  pt RightKnee =  P(RightMidleg, RightKneeForward,Forward);
  fill(red);  
  sphere(RightKnee,kneeRadius);
  capletSection(RightHip,hipRadius,RightKnee,kneeRadius);  
  capletSection(RightKnee,kneeRadius,RightAnkle,ankleRadius);  
   
  pt LeftMidleg = P(LeftHip,LeftAnkle);
  pt LeftKnee =  P(LeftMidleg, LeftKneeForward,Forward);
  fill(green);  
  sphere(LeftKnee,kneeRadius);
  capletSection(LeftHip,hipRadius,LeftKnee,kneeRadius);  
  capletSection(LeftKnee,kneeRadius,LeftAnkle,ankleRadius);  

  // PELVIS
  pt Pelvis = P(BodyCenter,pelvisHeight,Up, pelvisForward,Forward); 
  fill(blue); sphere(Pelvis,pelvisRadius);
  capletSection(LeftHip,hipRadius,Pelvis,pelvisRadius);  
  capletSection(RightHip,hipRadius,Pelvis,pelvisRadius);  
  
  /*pt Torso = P(BodyCenter, torsoHeight *5, Up, pelvisForward, Forward);
  fill(blue); sphere(Torso, pelvisRadius *5);*/
  return BodyCenter;
  }
  
void capletSection(pt A, float a, pt B, float b) { // cone section surface that is tangent to Sphere(A,a) and to Sphere(B,b)
       float distance = d(A,B);
       float x = (a*(a-b))/distance;
       float x2 = (b*(b-a))/distance;
       float y = (float)Math.sqrt((a*a)-(x*x));
       float y2 =(float)Math.sqrt((b*b)-(x2*x2));
       pt C = P(A);
       C = P(C, (x/distance), V(A,B));
       pt Cprime = P(C, -(y/distance), R(V(A,B)));
  
       pt D = P(B, -((b*(b-a))/distance)/distance, V(A,B));
       pt Dprime = P(D,(y2/distance), R(V(A,B)));
       coneSection(C,D,d(C,Cprime),d(D,Dprime));
  }  