class Individual {//an individual stores information for several genes

  ArrayList<Gene> genes;
  int fitness;
  
  Individual(ArrayList<Gene> initialGenes) {
    if (initialGenes!=null){
      genes = initialGenes;
    } else {
      genes = new ArrayList<Gene>();
      genes.add(new Gene());
    }
  }
  
  void render() {//draw individual
    background(0);
    for (Gene gene : genes) {//draw all genes
      gene.render();
    }
  }
  
  int getFitness() {
    render();
    int fitnessCalc = 0;
    for (int i=0;i<sampleHeightRes;i++) {
      for (int j=0;j<sampleWidthRes;j++) {
        color newColor = get(int((j+0.5)*numPixelsToSkip), int((i+0.5)*numPixelsToSkip));
        fitnessCalc += colorDistance(smallImage.pixels[j+i*sampleWidthRes], newColor);//standard deviation of LAB pixel by pixel http://en.wikipedia.org/wiki/Color_difference
      }
    }
    int scaledFitness = scaleFitness(fitnessCalc);
    fitness = scaledFitness;
    return scaledFitness;    
  }
  
  int scaleFitness(float totalColorDistance){
    int maxDeviation = 800000;//anything worse than this will not pass on its genes tot he next generation
    int scaledNum = int(maxDeviation-totalColorDistance);
    if (scaledNum < 0){
      return 0;
    }
    scaledNum = scaledNum*100/maxDeviation;
    return scaledNum;
  }
  
  Individual crossover(Individual mate){
    ArrayList<Gene> childGenes = new ArrayList<Gene>();
    Individual shorterStrand;
    Individual longerStrand;
    
    if (mate.genes.size()<genes.size()){
      shorterStrand = mate;
      longerStrand = this;
    } else {
      shorterStrand = this;
      longerStrand = mate;
    }
    
    int crossoverPoint = int(random(shorterStrand.genes.size()));
    for (int i=0;i<chooseChildStrandLength(longerStrand,shorterStrand);i++){
      if (i<crossoverPoint){
        childGenes.add(shorterStrand.genes.get(i).copy());
      } else {
        childGenes.add(longerStrand.genes.get(i).copy());
      }
    }
    Individual child = new Individual(childGenes);
    println(childGenes.size());
    return child;
  }
  
  int chooseChildStrandLength(Individual parent1, Individual parent2){
    if (parent1.fitness>parent2.fitness){
      return parent1.genes.size();
    }
    return parent2.genes.size();
  }
  
  void mutate(){
    if (random(1)<newGeneMutationRate){//gene addition
      if (genes.size()<numPolygonsPerImage){
        genes.add(new Gene());
      }
    }
    for (int i=0;i<genes.size();i++){
      if (random(1)<newGeneMutationRate){//gene replacement
        Gene newGene = new Gene();
        genes.set(i,newGene);
      }
      if (random(1)<colorMutationRate){//gene modification
        Gene mutatedGene = genes.get(i).copy();
        mutatedGene.shapeColor = color(random(256), random(256), random(256), opacity);
        genes.set(i,mutatedGene);
      }
      if (random(1)<shapeMutationRate){//shape modification
        Gene mutatedGene = genes.get(i).copy();
        switch (int(random(2))){
          case 0:
          mutatedGene.size = new PVector(random(shapeSizeMin,shapeSizeMax), random(shapeSizeMin,shapeSizeMax));
          break;
          case 1:
          mutatedGene.centerCoord = new PVector(random(0, width), random(height));//random center coordinate
          break;  
        }
        genes.set(i,mutatedGene);
      }
    }
  }
}
