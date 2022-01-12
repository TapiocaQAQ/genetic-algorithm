class Population{

  Dot[] dots;
  float fitnessSum;
  int gen = 1;
  
  int bestDot = 0;
  FloatDict topFiveDots = new FloatDict();
  
  //int minStep = 4000;
  
  Population(int size){
    dots = new Dot[size];
    for(int i = 0; i<size ; i++){
      dots[i] = new Dot();
    }
  
  }
  //----------------------------------------------------
  int getLength(){
    return dots.length;
  }
  //----------------------------------------------------
  Dot getDot(int index){
    return dots[index];
  }
  
  //----------------------------------------------------
  
  void show(){
    for(int i = 1; i<dots.length;i++){
      dots[i].show();
    }
    dots[0].show();
  }
  
  //---------------------------------------------------
  
  void update(){
    for(int i = 0;i<dots.length;i++){
        dots[i].update();
      }
  }
    
  
  //----------------------------------------------------
  
  void calculateFitness(){
    for(int i = 0; i<dots.length;i++){
      dots[i].calculateFitness();
    }
  }
  
  //-----------------------------------------------------
  boolean allDotsDead(){
    for(int i = 0; i<dots.length;i++){
      if(dots[i].reachedGoal){
        counter++;
        return true;
      }
      if(!dots[i].dead && !dots[i].reachedGoal){
        return false;// if one left,return false
      }
    }
    counter = 0;//if not reached Goal count = 0
    return true;//if all dead
  }
  
  //----------------------------------------------------
  
  void naturalSelection(){
    Dot[] newDots = new Dot[dots.length];
    //setBestDot();
    setTopFiveDots();
    calculateFitnessSum();//calculate the total fit sum, in order to pick a random parent.
    
    //newDots[0] = dots[bestDot].gimmeBaby();
    //newDots[0].isBest = true;
    int index = 0;
    for(String k:topFiveDots.keys()){
      newDots[index] = dots[int(k)].gimmeBaby();
      newDots[index].isBest = true;
      index++;
    }
    
    for(int i = 5; i<newDots.length; i++){
      
      //select parent based on fitness
      Dot parent = selectParent(); 
      
      //get baby from them
      newDots[i] = parent.gimmeBaby();
      
    }
    
    dots = newDots;
    gen++;
    
  }
  
  
  //---------------------------------------------------
  
  void calculateFitnessSum(){
    fitnessSum = 0;
    for(int i = 0; i< dots.length;i++){
      fitnessSum += dots[i].fitness;
    }
  }
  
  Dot selectParent(){
    float rand = random(fitnessSum);
    
    float runningSum = 0;
    
    for(int i = 0;i<dots.length;i++){
      runningSum+= dots[i].fitness;
      if(runningSum > rand){
        return dots[i];
      }  
    }
    // should never get to this point
    return null;
  }
  
  //-----------------------------------------------------------
  
  void mutateDemBabies(){
    for(int i = 5; i<dots.length; i++){
      dots[i].brain.mutate();
    }
  }
  
  //-----------------------------------------------------------
  
  void setBestDot(){
    float max = 0;
    int maxIndex = 0;
    for(int i = 0;i<dots.length;i++){
      if(dots[i].fitness > max){
        max = dots[i].fitness;
        maxIndex = i;
      }
    }
    bestDot = maxIndex; 
    
    //if(dots[bestDot].reachedGoal){
    //  minStep = dots[bestDot].brain.step;
    //}
  }
  
  void setTopFiveDots(){
    
    topFiveDots.clear();
    
    for(int i = 0;i<dots.length;i++){
      if(topFiveDots.size()<5){
        topFiveDots.set(str(i), dots[i].fitness); //dic((str)index : fitness)
      }else{
        for(String k: topFiveDots.keys()){
          if(dots[i].fitness > topFiveDots.get(k)){
            topFiveDots.remove(k);
            topFiveDots.set(str(i), dots[i].fitness);
          }
        }
      }
    }
    topFiveDots.sortValuesReverse(); //sort values ,[4]is the min
    float currentBest = 0;
    for(String k: topFiveDots.keys()){
      print(topFiveDots.get(k)+"\n");
      if(topFiveDots.get(k)>currentBest)
        currentBest = topFiveDots.get(k);
    }
    print("current : ", currentBest,"\n");
    print("Best : ", bestFitness,"\n");
    if(currentBest > bestFitness){

      bestFitness = currentBest;

      bestFitnessChange++;
    }else{
      bestFitness = currentBest;
      bestFitnessChange = 0;
    }
    print("Best : ", bestFitness,"\n");
    print("\n\n");
  }
  
}
