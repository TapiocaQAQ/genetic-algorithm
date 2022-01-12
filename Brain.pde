class Brain{
  PVector[] directions;
  int step = 0;
  float MAXMUTATERATE = 0.3;
  
  Brain(int size){
    directions = new PVector[size];
    randomize();
    
    
  }
  
  //----------------------------------------------------
  
  void randomize(){
    for(int i = 0; i < directions.length ; i++){
      float randomAngle = random(2*PI);
      directions[i] = PVector.fromAngle(randomAngle);
    }
  }
  
  //---------------------------------------------------
  Brain clone(){
    Brain clone = new Brain(directions.length);
    for(int i = 0;i < directions.length;i++){
      clone.directions[i] = directions[i].copy();
    }
    return clone;
  }
  
  //---------------------------------------------------
  void mutate(){
    float mutationRate = 0.01 + fail*fail*0.001;
    if(mutationRate>MAXMUTATERATE)
      mutationRate = MAXMUTATERATE;
      //print("mutate Rate : ",mutationRate,"\n");
    float randChoise = random(1);// choise which dot to mutation
    //if(randChoise < mutationRate){
      for(int i = 0; i<directions.length;i++){
        float rand = random(1);
        if(rand < mutationRate){
          //choise which DNA to mutation in a dot
          // set this direction as a random direction
          float randAngle = random(2*PI);
          directions[i] = PVector.fromAngle(randAngle);
        }
      }
    //}else{
      
    //}
  }
}
