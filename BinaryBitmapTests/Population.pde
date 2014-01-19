class Population{
  
  Individual[] populationList = new Individual[populationSize];
  boolean matchFound = false;//once we've found a match, set this to true
  String matchGen = "no matches found";//record the gen number where match was found
  int iterBestFitness;//the best fitness for one iteration
  Individual iterBestIndividual;
  
  Population(){
    for (int i=0;i<populationSize;i++){//initialize random inidividuals
      populationList[i] = new Individual(null);
    }
  }
  
  void iter() {//perform fitness test on all indivduals and create the next generation
    iterBestFitness=0;
    Individual[] nextGeneration = new Individual[populationSize];
    if (hillClimb){
      for (int i=0;i<populationSize;i++){
        Individual parent = populationList[i];
        Individual mutant = parent.makeCopy().mutate();
        int mutantFitness = mutant.getFitness();
        int parentFitness = parent.getFitness();
        if (mutantFitness>iterBestFitness){
          iterBestFitness = mutantFitness;
          iterBestIndividual = mutant;
        }
        if (parentFitness>iterBestFitness){
          iterBestFitness = parentFitness;
          iterBestIndividual = parent;
        }
        if (mutantFitness>parentFitness){
          nextGeneration[i] = mutant;
        } else {
          nextGeneration[i] = parent;
        }
      }
    } else {
      ArrayList<Individual> matingPool = createMatingPool(populationList);
      for (int i=0;i<populationSize/2;i++){
        Individual[] children = reproduce(matingPool);
        nextGeneration[i] = children[0];
        nextGeneration[i+1] = children[1];
      }
    }
    println(iterBestFitness);
    arrayCopy(nextGeneration, populationList);
  }
  
  ArrayList<Individual> createMatingPool(Individual[] currentPopulation){
    ArrayList<Individual> matingPool = new ArrayList<Individual>();
    for (Individual individual : currentPopulation) {
      int fitness = individual.getFitness();
      if (fitness>iterBestFitness){
        iterBestFitness = fitness;
        iterBestIndividual = individual;
      }
      if (fitness==totalNumGenes){//if we find a match
        iterBestIndividual = individual;
        matchGen = generation + " generations";
        println(geneMutationRate + "," + populationSize + "," + generation);
        matchFound = true;
      }
      for (int i=0;i<fitness;i++){
        matingPool.add(individual);
      }
    }
    return matingPool;
  }
  
  Individual[] reproduce(ArrayList<Individual> matingPool){
    int poolSize = matingPool.size();
    Individual[] children = new Individual[2];
    Individual parent1 = matingPool.get(int(random(poolSize)));
    Individual parent2 = matingPool.get(int(random(poolSize)));
    if (random(1)<crossoverRate){//crossover
      children = parent1.crossover(parent2);
    } else {//clone
      children[0] = new Individual(parent1.genes);
      children[1] = new Individual(parent2.genes);
    }
    children[0].mutate();
    children[1].mutate();
    return children;
  }
}
