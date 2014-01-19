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
  
  Individual[] crossover(Individual mate){
    int[] child1Genes = new int[totalNumGenes];
    int[] child2Genes = new int[totalNumGenes];
    for (int i=0;i<totalNumGenes;i++){
      if (random(1)<0.5){
        child1Genes[i] = genes[i];
        child2Genes[i] = mate.genes[i];
      } else {
        child1Genes[i] = mate.genes[i];
        child2Genes[i] = genes[i];
      }
    }
    Individual[] children = new Individual[2];
    children[0] = new Individual(child1Genes);
    children[1] = new Individual(child2Genes);
    return children;
  }
  
  Individual mutate(){
    for (int i=0;i<totalNumGenes;i++){
      if (random(1)<geneMutationRate){//gene replacement
        genes[i] = pickRandomGene();
      }
    }
    return this;
  }
  
  int pickRandomGene(){
    if (int(random(2))<1) return 255;
    return 0;
  }
  
  Individual makeCopy(){
    int[] genesCopy = new int[totalNumGenes];
    arrayCopy(genes, genesCopy);
    return new Individual(genesCopy);
    
  }
}
