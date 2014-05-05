class Population{
  
  Individual[] populationList = new Individual[populationSize];
  boolean matchFound = false;//once we've found a match, set this to true
  String matchGen = "no matches found";//record the gen number where match was found
  Individual iterBestIndividual;
  Individual iterWorstIndividual;
  
  Population(){
    for (int i=0;i<populationSize;i++){//initialize random inidividuals
      populationList[i] = new Individual(null);
    }
    iterBestIndividual = new Individual(null);
    iterBestIndividual.fitness = 0;
    iterWorstIndividual = new Individual(null);
    iterWorstIndividual.fitness = totalNumGenes;
  }
  
  void iter() {//perform fitness test on all indivduals and create the next generation
    Individual[] nextGeneration = new Individual[populationSize];
    if (hillClimb){
      for (int i=0;i<populationSize;i++){
        iterBestIndividual = hillClimb(i);
        nextGeneration[i] = iterBestIndividual;
      }
    } else {
      calcAllFitness(populationList);
      ArrayList<Individual> matingPool = createMatingPool(populationList);
      for (int i=0;i<populationSize/2;i++){
        Individual[] children = reproduce(matingPool);
        nextGeneration[2*i] = children[0];
        nextGeneration[2*i+1] = children[1];
      }
    }
    arrayCopy(nextGeneration, populationList);
  }
  
  Individual hillClimb(int i){
      Individual parent = populationList[i];
      Individual mutant = parent.makeCopy().mutate(true);
      if (mutant.getFitness()>parent.getFitness()){
        iterWorstIndividual = parent;
        return mutant;
      }
      iterWorstIndividual = mutant;
      return parent;
  }
  
  void calcAllFitness(Individual[] currentPopulation){
    iterBestIndividual.fitness = 0;
    iterWorstIndividual.fitness = totalNumGenes;
    for (Individual individual : currentPopulation) {
      int fitness = individual.getFitness();
      if (fitness>iterBestIndividual.getFitness()){
        iterBestIndividual = individual;
      }
      if (fitness<iterWorstIndividual.getFitness()){
        iterWorstIndividual = individual;
      }
      if (fitness==totalNumGenes){//if we find a match
        iterBestIndividual = individual;
        matchGen = generation + " generations";
        println(geneMutationRate + "," + populationSize + "," + generation);
        matchFound = true;
      }
    }
  }
  
  ArrayList<Individual> createMatingPool(Individual[] currentPopulation){
    ArrayList<Individual> matingPool = new ArrayList<Individual>();
    for (Individual individual : currentPopulation) {
      int scaledFitness = int(20*float(individual.getFitness()-iterWorstIndividual.getFitness())/float(iterBestIndividual.getFitness()-iterWorstIndividual.getFitness()));
      for (int i=0;i<scaledFitness;i++){
        matingPool.add(individual);
      }
    }
    return matingPool;
  }
  
  Individual[] reproduce(ArrayList<Individual> matingPool){
    int poolSize = matingPool.size();
    if (poolSize == 0){
      finish();
      return null;
    }
    Individual[] children = new Individual[2];
    Individual parent1 = matingPool.get(int(random(poolSize)));
    Individual parent2 = matingPool.get(int(random(poolSize)));
    if (random(1)<crossoverRate){//crossover
      children = parent1.crossover(parent2);
    } else {//clone
      children[0] = parent1.makeCopy();
      children[1] = parent2.makeCopy();
    }
    children[0].mutate(false);
    children[1].mutate(false);
    return children;
  }
}
