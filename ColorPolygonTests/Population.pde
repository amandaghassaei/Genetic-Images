class Population{
  
  Individual[] populationList;
  Individual iterBestIndividual;
  Individual iterWorstIndividual;
  
  boolean tempHillClimb = false;
  
  int stagGenNum = 0;//number of generations since a child was more fit than parent
  
  //genetic variables
  float crossoverRate = 1.0;//rate of crossover reproduction vs cloning
  
  Population(){
    iterBestIndividual = new Individual();
    iterWorstIndividual = new Individual();
    populationList = new Individual[populationSize];
    for (int i=0;i<populationSize;i++){//initialize random individuals
      populationList[i] = new Individual();
    } 
    if (currentNumGenes==0){//if we're starting with no genes, we want to add a new one asap, (but still print one black screen for gen=0 to show where we started)
      stagGenNum = numPlateau;
    }
  }
  
  void iter() {//perform fitness test on all indivduals and creates the next generation
    if (totalNumGenes>currentNumGenes||totalNumGenes==0){
      if (bestIndividualSoFar.genes.length == currentNumGenes){//we need to ensure the last new gene added has been successfully introduced before we add another
        if (stagGenNum++ > numPlateau){
          currentNumGenes++;
          stagGenNum = 0;
        }
      }
    }
    Individual[] nextGeneration = new Individual[populationSize];
    if (hillClimb){
      iterBestIndividual.setFitness(0);
      iterWorstIndividual.setFitness(100);
      background(0);
      for (int i=0;i<populationSize;i++){
        nextGeneration[i] = hillClimb(populationList[i], i/numCols, i%numCols);
        checkForIterBestAndWorst(nextGeneration[i]);
      }
      arrayCopy(nextGeneration, populationList);
    } else {//genetic
     if (!tempHillClimb){
        calculateAllFitness(populationList);
        if (iterBestIndividual.genes.length < currentNumGenes){//if we're adding a new gene
          tempHillClimb = true;
//          background(0);
//          for (int i=0;i<populationSize;i++){
//            nextGeneration[i] = populationList[i].copy(false);//add new gene
//            if (nextGeneration[i].getFitness(i/numCols, i%numCols)>iterBestIndividual.getFitness()){
//              tempHillClimb = false;
//            }
//          }
        } else {
          ArrayList<Individual> matingPool = createMatingPool(populationList);
          for (int i=0;i<populationSize;i++){
            nextGeneration[i] = reproduce(matingPool);
          }
          arrayCopy(nextGeneration, populationList);
        }
      } else {
        println("here");
        background(0);
        for (int i=0;i<populationSize;i++){
          nextGeneration[i] = hillClimb(populationList[i], i/numCols, i%numCols);
          if (nextGeneration[i].getFitness()>iterBestIndividual.getFitness() && nextGeneration[i].genes.length == currentNumGenes){
            tempHillClimb = false;
          }
        }
        if (!tempHillClimb){//make sure we end with all individuals having the added gene
          for (int i=0;i<populationSize;i++){
            if (nextGeneration[i].genes.length < currentNumGenes){
              nextGeneration[i] = nextGeneration[i].copy(false);
            }
          }
        }
        arrayCopy(nextGeneration, populationList);
      }
    }
    
    if (generation==0) {
      bestIndividualSoFar = iterBestIndividual.copy(true);
      bestIndividualSoFar.setFitness(iterBestIndividual.getFitness());
    }
    if (iterBestIndividual.getFitness()>bestIndividualSoFar.getFitness()){
      bestIndividualSoFar = iterBestIndividual.copy(true);
      bestIndividualSoFar.setFitness(iterBestIndividual.getFitness());
      stagGenNum = 0;
    }
  }
  
  void checkForIterBestAndWorst(Individual individual){
    float fitness = individual.getFitness();
    if (fitness>iterBestIndividual.getFitness()){
      iterBestIndividual = individual.copy(true);
      iterBestIndividual.setFitness(fitness);
    }
    if (fitness<iterWorstIndividual.getFitness()){
      iterWorstIndividual = individual.copy(true);
      iterWorstIndividual.setFitness(fitness);
    }
  }
  
  Individual hillClimb(Individual parent, int row, int col){
      Individual mutant;
      if (currentNumGenes>parent.genes.length){
        mutant = parent.copy(false);
      } else {
        mutant = parent.copy(false).mutate(true);
      }
      if (mutant.getFitness(row,col)>parent.getFitness()){
        stagGenNum = 0;
        return mutant;
      }
      return parent;
  }
  
  void calculateAllFitness(Individual[] currentPopulation){//calculate fitness of all individuals, set iterBest and Worst
    iterBestIndividual.setFitness(0);
    iterWorstIndividual.setFitness(100);
    background(0);//clear current image
    for (int i=0;i<populationSize;i++) {
      if (renderOneAtATime){
        currentPopulation[i].getFitness();
      } else {
        currentPopulation[i].getFitness(i/numCols, i%numCols);
      }
      checkForIterBestAndWorst(currentPopulation[i]);
    }
  }
  
  ArrayList<Individual> createMatingPool(Individual[] currentPopulation){
    ArrayList<Individual> matingPool = new ArrayList<Individual>();
    for (Individual individual : currentPopulation) {
      float fitness = adjustedFitnessForThisIter(individual.getFitness());
      if (fitness<1) fitness = 1;//get things going/give everyone some chance at mating
      for (int i=0;i<int(fitness);i++){
        matingPool.add(individual);
      }
    }
    return matingPool;
  }
  
  float adjustedFitnessForThisIter(float fitness) {//individuals are too similar - need to adjust fitness for this iter to promote selection
    float bestFitness = iterBestIndividual.getFitness();
    float worstFitness = iterWorstIndividual.getFitness();
    if (bestFitness==0) return 0.0;//no divide by 0
    if ((bestFitness-worstFitness)==0) return 0.0;//no divide by 0
    float scalingFactor = 20.0;//picked an arbitrary val to scale, change this to increase/decrease range of fitness
    float adjustedFitness = (fitness-worstFitness)*scalingFactor/(bestFitness-worstFitness);
    return adjustedFitness;
  }
  
  Individual reproduce(ArrayList<Individual> matingPool){
    int poolSize = matingPool.size();
    Individual child;
    Individual parent1 = matingPool.get(int(random(poolSize)));
    if (random(1)<crossoverRate){//crossover
      Individual parent2 = matingPool.get(int(random(poolSize)));
      return parent1.crossover(parent2).mutate(false);
    } else {//clone
      return parent1.copy(false).mutate(false);
    }
  }
  
  void printPolygons(){//save all polygons to PDF
    beginRecord(PDF, fileName+"_gen"+generation+"_polyCount"+currentNumGenes+".pdf");
    noStroke();
    background(0);
    if (renderOneAtATime){
        iterBestIndividual.render(0,0);
    } else {
      for (int i=0;i<populationSize;i++){
        populationList[i].render(i/numCols, i%numCols);
      }
    }
    endRecord();
  }
}
