class Individual {//an individual stores information for several genes

  int[] genes;
  int fitness = -1;
  
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
    image(image,0,0);
  }
  
  int getFitness() {
    if (fitness != -1) return fitness;//if we've already calculated this parameter
    fitness = 0;
    for (int i=0;i<totalNumGenes;i++) {
      if (genes[i] == (imageOrig.pixels[i]&0xFF)){
        fitness++;
      }
    }
    return fitness;    
  }
  
  Individual[] crossover(Individual mate){
    int[] child1Genes = new int[totalNumGenes];
    int[] child2Genes = new int[totalNumGenes];
    for (int i=0;i<totalNumGenes;i++){//uniform crossover
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
  
  Individual mutate(boolean forceMutation){
    boolean mutationOccurred = false;
    for (int i=0;i<totalNumGenes;i++){
      if (random(1)<geneMutationRate){//gene replacement
        if (genes[i] == 0){
          genes[i] = 255;
        } else {
          genes[i] = 0;
        }
        mutationOccurred = true;
      }
    }
    if (mutationOccurred || forceMutation == false){
      return this;
    } else {
      return this.mutate(true);
    }
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
