class Object{
 
 float w;
 float h;
 PVector pos = new PVector(); 
 PVector[] onScreen = new PVector[4];
 float degree = 0;
 float iniDegree = 0;
 float rotateSpeed = 0;
 
 boolean overBox = false;
 boolean lock = false;
 
 int myStroke;
 int mR = 0;
 int mG = 0;
 int mB = 255;
 int mA = 255;
 boolean stroke = false;
 
 Object(int X, int Y, int W, int H){
  pos.x = X;
  pos.y = Y;
  w = W;
  h = H;
 }
 
 void show(){   
   
   pushMatrix();
   translate(pos.x, pos.y); 
   rotate(degree);
   fill(mR,mG,mB,mA);
   if(stroke){
     strokeWeight(10);
     stroke(myStroke);
     strokeWeight(4);
   }else{
     noStroke();
   }
   
   beginShape();
   vertex(w*-0.5, h*-0.5);  
   vertex(w*0.5, h*-0.5); 
   vertex(w*0.5, h*0.5); 
   vertex(w*-0.5, h*0.5); 
   endShape(CLOSE);
  
   onScreen[0] = translatePoint(new PVector(w*-0.5, h*-0.5));
   onScreen[1] = translatePoint(new PVector(w*0.5, h*-0.5));
   onScreen[2] = translatePoint(new PVector(w*0.5, h*0.5));
   onScreen[3] = translatePoint(new PVector(w*-0.5, h*0.5));
   popMatrix();
 }
 
 
 boolean collisionDetection(PVector dot, PVector dotVel){
   PVector tempDot = dot.copy().add(dotVel);
   boolean collision = false;
   for(int c=0; c<4; c++){
     int n=c+1;
     if(n == 4) n=0;
     if (((onScreen[c].y > tempDot.y && onScreen[n].y < tempDot.y) 
       || (onScreen[c].y < tempDot.y && onScreen[n].y > tempDot.y)) 
       && (tempDot.x < (onScreen[n].x-onScreen[c].x) * (tempDot.y-onScreen[c].y) / (onScreen[n].y-onScreen[c].y) + onScreen[c].x) ) {
              collision = !collision;
     }
   }
   return collision;
 }
 
  PVector translatePoint(PVector point) {
    float x = screenX(point.x, point.y);
    float y = screenY(point.x, point.y);
    return new PVector(x, y);
  }
  
  void moveObject(float x, float y){
    
    pos.x = x;
    pos.y = y;
  }
  void changeColor(int r, int g, int b, int a){
    mR = r;
    mG = g;
    mB = b;
    mA = a;
  }
}
