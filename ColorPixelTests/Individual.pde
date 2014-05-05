class Individual {//an individual stores information for several genes

  color[] genes;
  float fitness = -1;
  
  Individual(color[] initialGenes) {
    if (initialGenes!=null){
      genes = initialGenes;
    } else {
      genes = new color[totalNumGenes];
      for (int i=0;i<totalNumGenes;i++){
        genes[i] = pickRandomGene();
      }
    }
  }
  
  void render() {//draw
    image.pixels = genes;
    image.updatePixels();
    image(image,0,0);
  }
  
  float getFitness() {
    if (fitness != -1) return fitness;//if we've already calculated this parameter
    fitness = 0;
    for (int i=0;i<totalNumGenes;i++) {
      fitness += 1-colorDistance(genes[i],imageOrig.pixels[i])/441.0;
    }
    return fitness;    
  }
  
  float colorDistance(color color1, color color2){
    int[] color1Array = intArrayFromColor(color1);
    int[] color2Array = intArrayFromColor(color2);
    return sqrt(sq(color1Array[0]-color2Array[0]) + sq(color1Array[1]-color2Array[1]) + sq(color1Array[2]-color2Array[2]));
  }
  
  int[] intArrayFromColor(color myColor){
    int[] colorArray = new int[3];
    colorArray[0] = (myColor >> 16) & 0xFF;// Faster way of getting red(argb)
    colorArray[1] = (myColor >> 8) & 0xFF;// Faster way of getting green(argb)
    colorArray[2] = myColor & 0xFF;// Faster way of getting blue(argb)
    return colorArray;
  }
  
  Individual[] crossover(Individual mate){
    color[] child1Genes = new int[totalNumGenes];
    color[] child2Genes = new int[totalNumGenes];
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
        genes[i] = pickRandomGene();
        mutationOccurred = true;
      }
    }
    if (mutationOccurred || forceMutation == false){
      return this;
    } else {
      return this.mutate(true);
    }
  }
  
  color pickRandomGene(){
    return color(random(256), random(256), random(256));
  }
  
  Individual makeCopy(){
    int[] genesCopy = new int[totalNumGenes];
    arrayCopy(genes, genesCopy);
    return new Individual(genesCopy);
  }
}
