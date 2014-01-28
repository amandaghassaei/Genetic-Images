class Individual {//an individual stores information for several genes

  Gene[] genes = new Gene[currentNumGenes];
  float fitness = -1;//initialize as nonsense so we know it needs to be calculated
  
  Individual(){
    for (int i=0;i<currentNumGenes;i++){
      println("here");
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
  
  void printPolygons(){//save all polygons to PDF
    beginRecord(PDF, "gen"+generation+".pdf");
    render(); 
    endRecord();
  }
  
  float getFitness() {
    if (fitness!=-1) return fitness;//don't calculate fitness twice
    float scaledFitness = scaleFitness(calculateRawFitness());
    fitness = scaledFitness;
    return scaledFitness;    
  }
  
  float calculateRawFitness(){
    render();
    int rawFitness = 0;
    for (int i=0;i<sampleHeightRes;i++) {
      for (int j=0;j<sampleWidthRes;j++) {
        color newColor = get(int((j+0.5)*numPixelsToSkip), int((i+0.5)*numPixelsToSkip));
        rawFitness += colorDistance(smallImage.pixels[j+i*sampleWidthRes], newColor);//standard deviation of LAB pixel by pixel http://en.wikipedia.org/wiki/Color_difference
      }
    }
    return rawFitness;
  }
  
  float scaleFitness(float totalColorDistance){
    float scaledNum = maxDeviation-totalColorDistance;
    scaledNum = constrain(scaledNum*100/maxDeviation, 0, 100);
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
      if (genes.length==0) return this;
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