class Population{
  
  Individual[] populationList;
  Individual iterBestIndividual;
  Individual iterWorstIndividual;
  
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
  
  void iter() {//perform fitness test on all indivduals and create the next generation
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
      for (int i=0;i<populationSize;i++){
        iterBestIndividual = hillClimb(populationList[i]);
        iterWorstIndividual = iterBestIndividual;//same thing
        nextGeneration[i] = iterBestIndividual;
      }
    } else {//genetic
      calculateAllFitness(populationList);
      ArrayList<Individual> matingPool = createMatingPool(populationList);
      for (int i=0;i<populationSize;i++){
        nextGeneration[i] = reproduce(matingPool);
      }
    }
    arrayCopy(nextGeneration, populationList);
    if (generation==0) {
      bestIndividualSoFar = iterBestIndividual.copy();
      bestIndividualSoFar.setFitness(iterBestIndividual.getFitness());
    }
    if (iterBestIndividual.getFitness()>bestIndividualSoFar.getFitness()){
      bestIndividualSoFar = iterBestIndividual.copy();
      bestIndividualSoFar.setFitness(iterBestIndividual.getFitness());
      stagGenNum = 0;
    }
  }
  
  Individual hillClimb(Individual parent){
      boolean mutateLastGeneOnly;
      if (currentNumGenes>parent.genes.length){
        mutateLastGeneOnly = true;
      } else {
        mutateLastGeneOnly = false;
      }
      Individual mutant = parent.copy().mutate(true, mutateLastGeneOnly);
      if (mutant.getFitness(0,0,true)>parent.getFitness(0,0,true)){
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
      Individual individual = currentPopulation[i];
      float fitness;
      if (renderOneAtATime){
        background(0);
        fitness = individual.getFitness();
      } else {
        fitness = individual.getFitness(i/numCols, i%numCols, false);
      }
      if (fitness>iterBestIndividual.getFitness()){
        iterBestIndividual = individual.copy();
        iterBestIndividual.setFitness(fitness);
      }
      if (fitness<iterWorstIndividual.getFitness()){
        iterWorstIndividual = individual.copy();
        iterWorstIndividual.setFitness(fitness);
      }
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
    float scalingFactor = 20.0;//picked an arbitrary val of 20 to scale, change this to increase/decrease range of fitness
    float adjustedFitness = (fitness-worstFitness)*scalingFactor/(bestFitness-worstFitness);
    return adjustedFitness;
  }
  
  Individual reproduce(ArrayList<Individual> matingPool){
    int poolSize = matingPool.size();
    Individual child;
    Individual parent1 = matingPool.get(int(random(poolSize)));
//    boolean mutateLastGeneOnly = bestIndividualSoFar.genes.length < currentNumGenes;
    boolean mutateLastGeneOnly = false;
    if (random(1)<crossoverRate){//crossover
      Individual parent2 = matingPool.get(int(random(poolSize)));
      return parent1.crossover(parent2).mutate(false, mutateLastGeneOnly);
    } else {//clone
      return parent1.copy().mutate(false, mutateLastGeneOnly);
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
