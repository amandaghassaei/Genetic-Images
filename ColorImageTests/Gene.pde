class Gene {//a gene specifies a shape and a color

  color geneColor;
  int numCorners = 3;
  float polyMaxInitSize = 20;
  PVector[] corners = new PVector[numCorners];
  
  Gene() {//init random new gene
    geneColor = color(random(256), random(256), random(256), opacity);//initialize random color
    corners[0] = new PVector(random(0, width), random(height));//random initial coordinate
    for (int i=1;i<numCorners;i++){
      corners[i] = new PVector(getNearbyCoord(corners[0].x, width, polyMaxInitSize), getNearbyCoord(corners[0].y, height, polyMaxInitSize));
    }
  }
  
  float getNearbyCoord(float origCoord, int maxValue, float distance){
    origCoord += distance*(random(2) - 1);
    return constrain(origCoord, 0, maxValue);
  }
  
  Gene(color initColor, PVector[] initCorners){//init with default parameters
    geneColor = initColor;
    for (int i=0;i<3;i++){
      corners[i] = new PVector(initCorners[i].x, initCorners[i].y);
    }
  }
  
  void render() {//draw the gene's polygon in the gene's color
    fill(geneColor);
    triangle(corners[0].x, corners[0].y, corners[1].x, corners[1].y, corners[2].x, corners[2].y);
  }
  
  boolean mutate() {
    boolean mutationHasOccurred = false;
    if (random(1)<geneColorMutationRate){
      geneColor = getSimilarColor(geneColor);
      mutationHasOccurred = true;
    }
    if (random(1)<geneCoordMutationRate){
      int coordinateNum = int(random(3));
      corners[coordinateNum].x = getNearbyCoord(corners[coordinateNum].x, width, coordMutationDistance);
      corners[coordinateNum].y = getNearbyCoord(corners[coordinateNum].y, height, coordMutationDistance);
      mutationHasOccurred = true;
    }
    return mutationHasOccurred;
  }
  
  Gene copy(){
    return new Gene(geneColor, corners);
  }
}
