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
  
  void printPolygons(){//save all polygons to PDF
    beginRecord(PDF, fileName+"_gen"+generation+"_polyCount"+genes.length+".pdf");
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
  
  void setFitness(float newFitness) {//only used in special circumstances
    fitness = newFitness;
  }
  
  float calculateRawFitness(){
    render();
    int rawFitness = 0;
    for (int i=0;i<height;i++) {
      for (int j=0;j<width;j++) {
        color newColor = get(j,i);
        rawFitness += colorDistance(image.pixels[j+i*width], newColor);//pythagorean distance in RGB color space (LAB takes too much time)
      }
    }
    return rawFitness;
  }
  
  float scaleFitness(float totalColorDistance){
    float diff = maxColorDeviation-totalColorDistance;
    if (diff<0) return 0;//in case we actually made something worse than an all black screen
    return diff*100/maxColorDeviation;
  }
  
  Individual crossover(Individual mate){
    Gene[] childGenes = new Gene[currentNumGenes];
    int crossoverPoint = random(genes.length);
    for (int i=0;i<currentNumGenes;i++){
      if (i<crossoverPoint){//single point crossover
        childGenes[i] = genes[i].copy();
      } else {
        if (i<mate.genes.length){
          childGenes[i] = mate.genes[i].copy();
        } else {
          childGenes[i] = new Gene();
        }
      }
    }
    return new Individual(childGenes);
  }
  
  Individual mutate(boolean forceMutation, boolean lastGeneMut){
    //forceMutation ensures that at least one mutation happens (need this for hill climbing)
    //lastGeneMut forces a mutation of the last gene only - used when new gene added
    if (genes.length==0) return this;
    boolean mutationHasOccurred = false;
    do {
      if (lastGeneMut) {
        mutationHasOccurred = genes[genes.length-1].mutate();
      } else {
        for (Gene gene : genes){
           boolean mutation = gene.mutate();
           if (mutation) mutationHasOccurred = true;
        }
      }
    } while (!mutationHasOccurred || !forceMutation);
    return this;
  }
  
  Individual copy(){
    return new Individual(genes);
  }
}
