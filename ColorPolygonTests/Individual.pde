class Individual {//an individual stores information for several genes

  Gene[] genes;
  float fitness = -1;//initialize as nonsense so we know it needs to be calculated
  
  Individual(){
    genes = new Gene[currentNumGenes];
    for (int i=0;i<currentNumGenes;i++){
      genes[i] = new Gene();
    }
  }
  
  Individual(Gene[] initialGenes, boolean empty, boolean exactCopy){// empty is how we calculate worstPossibleIndividual, forces init of Individual with no genes
    if (empty) {
      genes = new Gene[0];
      return;
    }
    if (exactCopy){
      genes = new Gene[initialGenes.length];
      for (int i=0;i<initialGenes.length;i++){
        genes[i] = initialGenes[i].copy();
      }
    } else {
      genes = new Gene[currentNumGenes];
      for (int i=0;i<currentNumGenes;i++){
        if (i>=initialGenes.length){
          genes[i] = new Gene();
        } else {
          genes[i] = initialGenes[i].copy();
        }
      }
    }
  }
  
  void render(int row, int col) {//draw at particular place on grid
    pushMatrix();
    translate(col*image.width, row*image.height);
    for (Gene gene : genes){
      gene.render();
    }
    popMatrix();
  }
  
  float getFitness() {//used to render individual at a particular point on the grid
    if (fitness!=-1) {
      return fitness;//don't calculate fitness twice
    }
    return getFitness(0,0);    
  }
  
  float getFitness(int row, int col) {//used to render individual at a particular point on the grid
    if (fitness!=-1) {
      return fitness;//don't calculate fitness twice
    }
    if (renderOneAtATime) background(0);
    render(row, col);
    float scaledFitness = scaleFitness(calculateRawFitness(row, col));
    fitness = scaledFitness;
    return scaledFitness;    
  }
  
  void setFitness(float newFitness) {//only used in special circumstances
    fitness = newFitness;
  }
  
  float calculateRawFitness(int row, int col){
    int rawFitness = 0;
    for (int i=0;i<image.height;i++) {
      for (int j=0;j<image.width;j++) {
        color newColor = get(col*image.width+j,row*image.height+i);
        rawFitness += colorDistance(image.pixels[j+i*image.width], newColor);//pythagorean distance in RGB color space (LAB takes too much time)
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
    Gene[] childGenes = new Gene[mate.genes.length];
    int crossoverPoint = int(random(genes.length));
    for (int i=0;i<mate.genes.length;i++){
      if (i<=crossoverPoint && genes.length>i){//single point crossover
        childGenes[i] = genes[i].copy();
      } else {
        childGenes[i] = mate.genes[i].copy();
      }
    }
    return new Individual(childGenes, false, false);
  }
  
  Individual mutate(boolean forceMutation){
    //forceMutation ensures that at least one mutation happens (need this for hill climbing)
    //lastGeneMut forces a complete mutation of the last gene only - used when new gene added to get a positive addition
    if (genes.length==0) return this;
    boolean mutationHasOccurred = false;
    do {
      for (Gene gene : genes){
         boolean mutation = gene.mutate();
         if (mutation) mutationHasOccurred = true;
      }
    } while (!mutationHasOccurred && forceMutation);
    return this;
  }
  
  Individual copy(boolean exactCopy){
    return new Individual(genes, false, exactCopy);
  }
}
