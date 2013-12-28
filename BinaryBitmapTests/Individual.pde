class Individual {//an individual stores information for several genes

  int[] genes;
  int fitness = 0;
  
  Individual(int[] initialGenes) {
    if (initialGenes!=null){
      genes = initialGenes;
    } else {
      genes = new int[totalNumGenes];
      for (int i=0;i<totalNumGenes;i++){
        genes[i] = pickRandomGene();
      }
    }
  }
  
  void render() {//draw
    color[] pixelsArray = new color[totalNumGenes];
    for (int i=0;i<totalNumGenes;i++){
      pixelsArray[i] = color(genes[i]);
    }
    image.pixels = pixelsArray;
    image.updatePixels();
  }
  
  int getFitness() {
    fitness = 0;
    for (int i=0;i<totalNumGenes;i++) {
      if (i%2==1){
        if (genes[i] == 255) {
          fitness++;
        }
      } else {
        if (genes[i] == 0) {
          fitness++;
        }
      }
    }
    return fitness;    
  }
  
  Individual crossover(Individual mate){
    int[] childGenes = new int[totalNumGenes];
    int crossoverPoint = int(random(totalNumGenes));
    for (int i=0;i<totalNumGenes;i++){
      if (i<crossoverPoint){
        childGenes[i] = genes[i];
      } else {
        childGenes[i] = mate.genes[i];
      }
    }
    Individual child = new Individual(childGenes);
    return child;
  }
  
  void mutate(){
    for (int i=0;i<totalNumGenes;i++){
      if (random(1)<geneMutationRate){//gene replacement
        genes[i] = pickRandomGene();
      }
    }
  }
  
  int pickRandomGene(){
    if (int(random(2))<1) return 255;
    return 0;
  }
}
