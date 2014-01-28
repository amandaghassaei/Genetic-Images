class Population{
  
  Individual[] populationList = new Individual[populationSize];
  Individual iterBestIndividual;
  
  Population(){
    for (int i=0;i<populationSize;i++){//initialize random individuals
      populationList[i] = new Individual();
      iterBestIndividual = populationList[0];//initialize something as iterBestIndividual to start
    }
  }
  
  void iter() {//perform fitness test on all indivduals and create the next generation
    Individual[] nextGeneration = new Individual[populationSize];
    if (hillClimb){
      for (int i=0;i<populationSize;i++){
        iterBestIndividual = hillClimb(populationList[i]);
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
      Individual mutant = parent.copy().mutate(true);
      if (mutant.getFitness()>parent.getFitness()){
        stagGenNum = 0;
        return mutant;
      }
      if ((stagGenNum++ > numPlateau) && parent.genes.length==currentNumGenes){
        currentNumGenes++;
        stagGenNum = 0;
      }
      return parent;
  }
  
  ArrayList<Individual> createMatingPool(Individual[] currentPopulation){
    ArrayList<Individual> matingPool = new ArrayList<Individual>();
    for (Individual individual : currentPopulation) {
      float fitness = individual.getFitness();
      if (fitness>iterBestIndividual.getFitness()){
        iterBestIndividual = individual;
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
      return parent1.crossover(parent2).mutate(false);
    } else {//clone
      return parent1.copy().mutate(false);
    }
  }
}
