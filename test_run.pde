import controlP5.*;
ControlP5 cp5;

Population test;
ArrayList<Object> maze = new ArrayList<Object>();
Object wall = new Object(0,0,0,0);
PVector goal = new PVector(400, 10);

//UI
Slider wWide;
Slider hHeight;
Slider rSpeed;
Slider iniDegree;

//control
int counter = 0;
int fail = 0;
int bestFitnessChange = 0;
float bestFitness = 0;

int level = 1;


boolean dragLock = false;
int objIndex = 8;
boolean STOP = false;
boolean firstAW = true;
boolean firstDW = true;

PVector pMouse;
PVector vMouse;

void setup(){
  size(1600,800);
  test = new Population(1000);
  maze.add(new Object(width/2,height+24, 2*width,60));//bottom edge
  maze.add(new Object(width/2,-24, 2*width,60));//upper edge
  maze.add(new Object(-24,height/2,60,2*height));//left edge
  maze.add(new Object(5*width/6+122,height/2,1*width/6,2*height));//right edge

  maze.get(3).changeColor(100,100,0,50);
  maze.get(0).lock = true;
  maze.get(1).lock = true;
  maze.get(2).lock = true;
  maze.get(3).lock = true;
  
  //rotate wall
  maze.add(new Object(width/6, height/2, 600, 10));
  maze.add(new Object(width/6, height/2, 600, 10));
  maze.add(new Object(3*width/6, height/2, 600, 10));
  maze.add(new Object(3*width/6, height/2,600, 10));
  //wall = maze.get(4);
  maze.get(4).rotateSpeed = 2;  
  maze.get(5).rotateSpeed = 2;
  maze.get(6).rotateSpeed = -2;
  maze.get(7).rotateSpeed = -2;
  
  maze.get(4).iniDegree = PI/2;
  maze.get(6).iniDegree = PI/2 + PI*0.25;
  maze.get(7).iniDegree += PI*0.25;
  
  maze.get(4).degree = maze.get(4).iniDegree;
  maze.get(6).degree = maze.get(6).iniDegree;
  maze.get(7).degree = maze.get(7).iniDegree;
  
  //garbege
  maze.add(new Object(0,0,0,0));
  
 
  
  cp5 = new ControlP5(this);
  cp5.begin(cp5.addBackground("abc"))
     .setPosition(5*width/6, 0);
     
  cp5.addToggle("Stop Resume")
     .setPosition(10,20)
     .setSize(200,50)
     .setMode(Toggle.SWITCH)
     .setFont(createFont("arial",30))
     ;
  
  wWide = cp5.addSlider("Width")
     .setPosition(10, height/6)
     .setSize(200, 20)
     .setRange(50, 700)
     .setValue(250)
     .setFont(createFont("arial",20))
     ;
  cp5.getController("Width").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("Width").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  hHeight = cp5.addSlider("Height")
     .setPosition(10, 2*height/6)
     .setSize(200, 20)
     .setRange(10,200)
     .setValue(20)
     .setFont(createFont("arial",20))
     ;
  cp5.getController("Height").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("Height").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  rSpeed = cp5.addSlider("Rspeed")
     .setPosition(10, 3*height/6)
     .setSize(200, 20)
     .setRange(-5, 5)
     .setNumberOfTickMarks(11)
     .setValue(250)
     .setFont(createFont("arial",20))
     ;
  cp5.getController("Rspeed").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  iniDegree = cp5.addSlider("INIDegree")
     .setPosition(10, 4*height/6)
     .setSize(200, 20)
     .setRange(0,2*PI)
     .setValue(0)
     .setFont(createFont("arial",20))
     ;
  cp5.getController("INIDegree").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("INIDegree").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  cp5.addButton("AddWall")
    .setValue(0)
    .setPosition(60,5*height/6-60)
    .setSize(100,40)
    .setFont(createFont("arial",20))
    ;
  cp5.getController("AddWall").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
}

void draw(){
  //------------------------------------------------
  // make goal point
  background(155,200,255);
  fill(255,0,0);
  ellipse(goal.x, goal.y, 10, 10);
  //------------------------------------------------
  
  //level control
  //if(counter == 5 && level == 1){
  //  maze.add(new Object(100,height/2, 600, 10));
  //  counter = 0;
  //  level++;
  //}else if(counter == 10 && level == 2){
  //  maze.add(new Object(width/2+50,height/2-150, width/2-50, 10));
  //  counter = 0;
  //  level++;
  //}
  
  
  // print gen & counter
  textSize(64);
  fill(0, 408, 612, 816);
  text("gen : "+test.gen, 5, 50);
  
  textSize(64);
  fill(300, 408, 612, 816);
  text("counter : "+counter, 5, 180);
  
  textSize(64);
  fill(300, 408, 612, 816);
  text("fail : "+fail, 5, 310);
  
  
  
  if(test.allDotsDead()){
    print("best fitness change : ",bestFitnessChange+"\n");
    if(bestFitnessChange >= 2){
      print("BOOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
      bestFitnessChange = 0;
      fail = 0;
    }else if(counter == 0){// if bestfitnessChange 3 times mutateRate = 0.01

      fail++;
    }else{
      fail = 0;
    }
    for(int i = 0;i<maze.size();i++){
      maze.get(i).degree = maze.get(i).iniDegree;
    }
    
    test.calculateFitness();
    test.naturalSelection();
    test.mutateDemBabies();
  }else{
    if(STOP){
      test.update();
    }
    test.show();
  }
  
  //rotate wall
  if(STOP){
    for(int i = 4;i<maze.size();i++){
      maze.get(i).degree +=  maze.get(i).rotateSpeed/100;
      
    }
  }
  
  // detection collision
  for(int i = 0;i<maze.size();i++){
    maze.get(i).show();
    
    //check all dot collision
    for(int j = 0;j<test.getLength();j++){
      if(maze.get(i).collisionDetection(test.getDot(j).pos, test.getDot(j).vel)){
        test.getDot(j).dead = true;
      }
    }  
    
    //check mouse collide on wall
    pMouse = new PVector(mouseX, mouseY);
    vMouse = new PVector(0,0);
    
    if(!maze.get(i).lock && maze.get(i).collisionDetection(pMouse, vMouse)){
      maze.get(i).overBox = true;
      if(!dragLock){
        maze.get(i).stroke = true;
        maze.get(i).myStroke = 255;
        objIndex = i;
      }
    }else{
      maze.get(i).stroke = false;
      maze.get(i).myStroke = 255;
      
      maze.get(i).overBox = false;
    }
    //print("overBox = "+objIndex+" "+maze.get(objIndex).overBox+"  "+dragLock+"\n");
  }
  
}

void mousePressed(){
  if(maze.get(objIndex).overBox){
    dragLock = true;
    
  }else{
    dragLock = false;
  }

}

void mouseDragged(){
  
  if(!maze.get(objIndex).lock && dragLock){
    maze.get(objIndex).moveObject(pMouse.x, pMouse.y);
  }
  
}
void mouseReleased(){
  dragLock = false;
}
void mouseClicked(){
  wall = maze.get(objIndex);
  wWide.setValue(wall.w);
  hHeight.setValue(wall.h);
  rSpeed.setValue(wall.rotateSpeed);
  //print(objIndex);
}
public void controlEvent(ControlEvent theEvent) {
  //println(theEvent.getController().getName());
  switch(theEvent.getController().getName()){
    case ("Stop Resume"):
      if(STOP == true) STOP = false;
      else STOP = true;
      break;
    case ("Width"):
      wall.w = theEvent.getController().getValue();
      break;
    case("Height"):
      wall.h = theEvent.getController().getValue();
      break;
    case("Rspeed"):
      wall.rotateSpeed = theEvent.getController().getValue();
      break;
    case("INIDegree"):
      wall.iniDegree = theEvent.getController().getValue();
      
      wall.degree = wall.iniDegree;
      
      break;
    case("AddWall"):
      if(!firstAW){
        maze.add(new Object(width/2, height/2, 600, 10));
      }else firstAW = false;
      break;
    //case("DelWall"):
    //  if(!firstDW){
    //    maze.remove(objIndex-2);
        
    //  }else firstDW = false;
    //  break;
    }
}
