class Gene {//a gene specifies a shape and a color

  color geneColor;
  int numCorners = 3;//all genes are triangles
  PVector[] corners = new PVector[numCorners];
  int opacity = 50;
  
  //mutation variables
  float colorTol = 20;
  float coordMutationDistance = 30;
  
  Gene() {//init random new gene
    geneColor = color(random(256), random(256), random(256), opacity);//initialize random color
    corners[0] = new PVector(random(width), random(height));//random initial coordinate
    if (initializeSmallTriangles){
      for (int i=1;i<numCorners;i++){
        corners[i] = new PVector(getNearbyNumber(corners[0].x, 0, width, 20), getNearbyNumber(corners[0].y, 0, height, 20));
      }
    } else {
      for (int i=1;i<numCorners;i++){
        corners[i] = new PVector(random(width), random(height));//random initial coordinate
      }
    }
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
  
  float getNearbyNumber(float orig, int minValue, int maxValue, float disp){
    orig += disp*(random(2) - 1);
    return constrain(orig, minValue, maxValue);
  }
  
  boolean mutate() {
    float geneColorMutationRate = 0.02/(currentNumGenes/100+1);//avg of 2 color mutations per Individual mutation for higher numGenes
    float geneCoordMutationRate = 0.01/(currentNumGenes/100+1);//avg of 1 coordinate mutations per Individual mutation for higher numGenes
    boolean mutationHasOccurred = false;
    if (random(1)<geneColorMutationRate){
      geneColor = getSimilarColor(geneColor);
      mutationHasOccurred = true;
    }
    if (random(1)<geneCoordMutationRate){
      int coordinateNum = int(random(3));
      corners[coordinateNum].x = getNearbyNumber(corners[coordinateNum].x, 0, width, coordMutationDistance);
      corners[coordinateNum].y = getNearbyNumber(corners[coordinateNum].y, 0, height, coordMutationDistance);
      mutationHasOccurred = true;
    }
    return mutationHasOccurred;
  }
  
  color getSimilarColor(color origColor){
    int[] origColorArray = intArrayFromColor(origColor);
    for (int i=0;i<3;i++){
      origColorArray[i] = int(constrain(origColorArray[i] + colorTol*(random(2)-1), 0, 255));
    }
    return colorFromIntArray(origColorArray);
  }
  
  Gene copy(){
    return new Gene(geneColor, corners);
  }
  
  color colorFromIntArray(int[] colorArray){
    return (opacity<<24) | (colorArray[0]<<16) | (colorArray[1]<<8) | (colorArray[2]);
  }
}
