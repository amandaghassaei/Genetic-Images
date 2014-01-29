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
    beginRecord(PDF, fileName+"_gen"+generation+".pdf");
    noStroke();
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
    for (int i=0;i<height;i++) {
      for (int j=0;j<width;j++) {
        color newColor = get(j+0.5,i+0.5);
        rawFitness += colorDistance(image.pixels[j+i*width], newColor);//pythagorean distance in RGB color space (LAB takes too much time)
      }
    }
    return rawFitness;
  }
  
  float scaleFitness(float totalColorDistance){
    float diff = maxColorDeviation-totalColorDistance;
    if (diff<0) return 0;
    return diff*100/maxColorDeviation;
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
  
  Individual mutate(boolean forceMutation, boolean lastGeneMut){//forceMutation ensures that at least one mutation happens (need this for hill climbing)
    if (genes.length==0) return this;
    boolean mutationHasOccurred = false;
    while (!mutationHasOccurred && forceMutation){
      if (lastGeneMut) {
        mutationHasOccurred = genes[genes.length-1].mutate();
      } else {
        for (Gene gene : genes){
          mutationHasOccurred = gene.mutate();
        }
      }
    }
    return this;
  }
  
  Individual copy(){
    return new Individual(genes);
  }
}
