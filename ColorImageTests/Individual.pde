class Individual {//an individual stores information for several genes

  Gene[] genes;
  float fitness = -1;//initialize as nonsense so we know it needs to be calculated
  
  Individual(){
    genes = new Gene[currentNumGenes];
    for (int i=0;i<currentNumGenes;i++){
      genes[i] = new Gene();
    }
  }
  
  Individual(Gene[] initialGenes, boolean empty) {//empty flag is how we calculate worstPossibleIndividual, forces init of Individual with no genes
    if (empty) {
      genes = new Gene[0];
      return;
    }
    genes = new Gene[currentNumGenes];
    for (int i=0;i<currentNumGenes;i++){
      if (i>=initialGenes.length){
        genes[i] = new Gene();
      } else {
        genes[i] = initialGenes[i].copy();
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
    return getFitness(0,0);    
  }
  
  float getFitness(int row, int col) {//used to render individual at a particular point on the grid
    if (fitness!=-1) {
      return fitness;//don't calculate fitness twice
    }
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
    Gene[] childGenes = new Gene[currentNumGenes];
    int crossoverPoint = int(random(genes.length));
    for (int i=0;i<currentNumGenes;i++){
      if (i<=crossoverPoint && genes.length>i){//single point crossover
        childGenes[i] = genes[i].copy();
      } else {
        if (i<mate.genes.length){
          childGenes[i] = mate.genes[i].copy();
        } else {
          childGenes[i] = new Gene();
        }
      }
    }
    return new Individual(childGenes, false);
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
    } while (!mutationHasOccurred && forceMutation);
    return this;
  }
  
  Individual copy(){
    return new Individual(genes, false);
  }
}
