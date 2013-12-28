class Population{
  
  Individual[] populationList;
  int iterBestFitness;//the best fitness for one iteration
  int iterWorstFitness;//the worst fitness for one iteration
  Individual iterBestIndividual;
  
  Population(){
    populationList = new Individual[populationSize];
    for (int i=0;i<populationSize;i++){//initialize random inidividuals
      populationList[i] = new Individual(null);
    }
  }
  
  void iter() {//perform fitness test on all indivduals and create the next generation
    iterBestFitness=0;
    iterWorstFitness=100;
    ArrayList<Individual> matingPool = createMatingPool(populationList);
    Individual[] nextGeneration = new Individual[populationSize];
    for (int i=0;i<populationSize;i++){
      Individual individual = reproduce(matingPool);
      nextGeneration[i] = individual;
    }
    arrayCopy(nextGeneration, populationList);
    if (iterBestFitness>bestFitness){
      bestFitness = iterBestFitness;
      bestIndividual = iterBestIndividual;
      bestIndividual.render();
      save("test"+(generation)+".jpg");
    }
  }
  
  ArrayList<Individual> createMatingPool(Individual[] currentPopulation){
    ArrayList<Individual> matingPool = new ArrayList<Individual>();
    for (Individual individual : currentPopulation) {
      int fitness = individual.getFitness();
      if (fitness>iterBestFitness){
        iterBestFitness = fitness;
        iterBestIndividual = individual;
      }
      if (fitness<iterWorstFitness){
        iterWorstFitness = fitness;
      }
      for (int i=0;i<fitness;i++){
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
      child = parent1.crossover(parent2);
    } else {//clone
      child = new Individual(parent1.genes);
    }
    child.mutate();
    return child;
  }
}
