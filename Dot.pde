class Dot{
  PVector pos;
  PVector vel;
  PVector acc;
  Brain brain;
  
  boolean dead = false;
  boolean reachedGoal = false;
  boolean isBest = false;
  
  float fitness = 0;
  
  Dot(){
    brain = new Brain(4000);
    
    pos = new PVector(width/2, height-150);
    vel = new PVector(0, 0);     //velocity
    acc = new PVector(0, 0);     //acceleration
  
  }
  
  
  
  
  //---------------------------------------------------
  
  void show(){
    
    noStroke();
    
    if(isBest){
      
      fill(0,255,0);
      ellipse(pos.x, pos.y, 8, 8);
    }else{
      
      fill(0);
      ellipse(pos.x, pos.y, 4, 4);
    }
    
    
  }
  
  //----------------------------------------------------
  
  void move(){
    
    
  }
  
  //--------------------------------------------------
  void update(){
    if(!dead && !reachedGoal){
      if(brain.directions.length > brain.step){
        acc = brain.directions[brain.step];//not dead
        brain.step++;
      }else{
        dead = true;
      }
      vel.add(acc);
      vel.limit(5);
      pos.add(vel);
      
      if(dist(pos.x, pos.y, goal.x, goal.y) < 5){
        // if reachd goal
        reachedGoal = true;
      }
    }
  }
  
  //--------------------------------------------------
  
  void calculateFitness(){
    if(reachedGoal){
      fitness = 1.0/16.0 + 100.0/(float)(brain.step * brain.step);
    }else{
      float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y);
      fitness = 1.0 / (distanceToGoal * distanceToGoal);
    
    }
  }
  
  //----------------------------------------------------
  
  //clone the best parent, and cross over
  Dot gimmeBaby(){
    Dot baby = new Dot();
    baby.brain = brain.clone();
    return baby;
  }
  
}
