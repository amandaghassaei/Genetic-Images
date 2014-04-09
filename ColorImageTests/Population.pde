class Population{
  
  Individual[] populationList = new Individual[populationSize];
  Individual iterBestIndividual;
  Individual iterWorstIndividual;
  
  //hill climbing variables
  int stagGenNum = 0;//number of generations since a child was more fit than parent
  
  //genetic variables
  float crossoverRate = 1.0;//rate of crossover reproduction vs cloning
  
  Population(){
    for (int i=0;i<populationSize;i++){//initialize random individuals
      populationList[i] = new Individual();
    } 
    if (currentNumGenes==0){//if we're starting with no genes, we want to add a new one asap, (but still print one black screen for gen=0 to show where we started)
      stagGenNum = numPlateau;
    }
  }
  
  void iter() {//perform fitness test on all indivduals and create the next generation
    if (stagGenNum++ > numPlateau){
      if (!hillClimb ||  populationList[i].genes.count == currentNumGenes){//if we're hill climbing, we need to ensure the last new gene added has been adopted by the current individual
        currentNumGenes++;
        stagGenNum = 0;
      }
    }
    Individual[] nextGeneration = new Individual[populationSize];
    if (hillClimb){
      for (int i=0;i<populationSize;i++){
        iterBestIndividual = hillClimb(populationList[i]);
        iterWorstIndividual = iterBestIndividual;//same thing
        nextGeneration[i] = iterBestIndividual;
      }
    } else {
      ArrayList<Individual> matingPool = createMatingPool(populationList);
      for (int i=0;i<populationSize;i++){
        nextGeneration[i] = reproduce(matingPool);
      }
    }
    arrayCopy(nextGeneration, populationList);
  }
  
  Individual hillClimb(Individual parent){
      boolean mutateLastGeneOnly;
      if (currentNumGenes>parent.genes.length){
        mutateLastGeneOnly = true;
      } else {
        mutateLastGeneOnly = false;
      }
      Individual mutant = parent.copy().mutate(true, mutateLastGeneOnly);
      if (mutant.getFitness()>parent.getFitness()){
        stagGenNum = 0;
        return mutant;
      }
      return parent;
  }
  
  ArrayList<Individual> createMatingPool(Individual[] currentPopulation){
    iterBestIndividual.setFitness(0);
    iterWorstIndividual.setFitness(100);
    ArrayList<Individual> matingPool = new ArrayList<Individual>();
    for (Individual individual : currentPopulation) {
      float fitness = individual.getFitness();
      if (fitness>iterBestIndividual.getFitness()){
        iterBestIndividual = individual;
      }
      if (fitness<iterWorstIndividual.getFitness()){
        iterWorstIndividual = individual;
      }
      for (int i=0;i<int(fitness);i++){
        matingPool.add(individual);
      }
    }
    return matingPool;
  }
  
  Individual reproduce(ArrayList<Individual> matingPool){
    int poolSize = matingPool.size();
    Individual child;
    Individual parent1 = matingPool.get(int(random(poolSize)));
    if (random(1)<crossoverRate){//crossover
      Individual parent2 = matingPool.get(int(random(poolSize)));
      return parent1.crossover(parent2).mutate(false, false);
    } else {//clone
      return parent1.copy().mutate(false, false);
    }
  }
}
