class Gene {//a gene specifies a shape and a color

  color shapeColor;
  PVector size;
  PVector centerCoord;
  
  Gene() {
    shapeColor = color(random(256), random(256), random(256), opacity);//initialize random color
    centerCoord = new PVector(random(0, width), random(height));//random center coordinate
    size  = new PVector(random(shapeSizeMin,shapeSizeMax), random(shapeSizeMin,shapeSizeMax));//random size
  }
  
  void render() {//draw the gene's polygon in the gene's color
    fill(shapeColor);
    rect(centerCoord.x-size.x/2, centerCoord.y-size.y/2, size.x, size.y);
  }
  
  Gene copy(){
    Gene newGene = new Gene();
    newGene.shapeColor = shapeColor;
    newGene.size = size;
    newGene.centerCoord = centerCoord;
    return newGene;
  }
}
