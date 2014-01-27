class Individual {//an individual stores information for several genes

  Gene[] genes = new Gene[currentNumGenes];
  float fitness = -1;//initialize as nonsense so we know it needs to be calculated
  
  Individual(){
    for (int i=0;i<currentNumGenes;i++){
      genes[i] = new Gene();
    }
  }
  
  Individual(Gene[] initialGenes) {
     for (int i=0;i<currentNumGenes;i++){
      if (i>=initialGenes.length){
        genes[i] = new Gene();
      } else {
        genes[i] = initialGenes[i].copy();
      }
    }
  }
  
  void render() {//draw
    background(0);//clear current image
    for (Gene gene : genes){
      gene.render();
    }
  }
  
  float getFitness() {
    if (fitness!=-1) return fitness;//don't calculate fitness twice
    render();
    int fitnessCalc = 0;
    for (int i=0;i<sampleHeightRes;i++) {
      for (int j=0;j<sampleWidthRes;j++) {
        color newColor = get(int((j+0.5)*numPixelsToSkip), int((i+0.5)*numPixelsToSkip));
        fitnessCalc += colorDistance(smallImage.pixels[j+i*sampleWidthRes], newColor);//standard deviation of LAB pixel by pixel http://en.wikipedia.org/wiki/Color_difference
      }
    }
    float scaledFitness = scaleFitness(fitnessCalc);
    fitness = scaledFitness;
    return scaledFitness;    
  }
  
  float scaleFitness(float totalColorDistance){
    float maxDeviation = 800000;//anything worse than this will not pass on its genes to the next generation
    float scaledNum = maxDeviation-totalColorDistance;
    if (scaledNum < 0){
      return 0;
    }
    scaledNum = scaledNum*100/maxDeviation;
    return scaledNum;
  }
  
  Individual crossover(Individual mate){
    Gene[] childGenes = new Gene[currentNumGenes];
    for (int i=0;i<currentNumGenes;i++){
      if (random(1)<0.5){//uniform crossover
        childGenes[i] = genes[i];
      } else {
        childGenes[i] = mate.genes[i];
      }
    }
    return new Individual(childGenes);
  }
  
  Individual mutate(boolean forceMutation){//forceMutation ensures that at least one mutation happens (need this for hill climbing)
    boolean mutationHasOccurred = false;
    while (!mutationHasOccurred && forceMutation){
      for (Gene gene : genes){
        mutationHasOccurred = gene.mutate();
      }
    }
    return this;
  }
  
  Individual copy(){
    return new Individual(genes);
  }
}
