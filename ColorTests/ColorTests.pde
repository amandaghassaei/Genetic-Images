
//genetic parameters
int numPolygonsPerImage = 70;//number of polygons per image
int populationSize = 70;
//float childInheritsLongStrand = 0.30;
float newGeneMutationRate = 0.01;//replace an entire gene
float shapeMutationRate = 0.05;//change the size/location of a polygon
float colorMutationRate = 0.01;//change the color of a polygon
float crossoverRate = 0.50;//rate of crossover reproduction vs cloning

//polygon characteristics
float opacity = 70;//opacity of each polygon in image (between 0-255)
int shapeSizeMax = 400;
int shapeSizeMin = 100;

//image storage
String imageName = "gogh.jpg";
PImage image;//storage for image
PImage smallImage;

//amount of pixels to sample
int numPixelsToSkip = 10;//ex when = 10, we only test against the input image for one pixel in every 10x10px region
int sampleWidthRes;
int sampleHeightRes;

int generation = 0;//generation number

//global storage of best individual so far
int bestFitness = 0;
Individual bestIndividual;

Population population;

void setup(){
  image = loadImage(imageName);
  sampleWidthRes = int(image.width/numPixelsToSkip);
  sampleHeightRes = int(image.height/numPixelsToSkip);
  
  //downsampled version
  smallImage = loadImage(imageName);
  smallImage.resize(sampleWidthRes, sampleHeightRes);
  smallImage.loadPixels();
  
  size(image.width,image.height);
  noStroke();
  
  population = new Population();
}

void draw(){
  population.iter();
  println(generation++);
  print(population.iterWorstFitness);
  print(" - ");
  println(population.iterBestFitness);
}

void keyPressed() {
  if (key=='s'){//s saves and stops
    noLoop();
    bestIndividual.render();
    save("test"+(generation)+".jpg");
  } else if (key=='r'){//r resumes
    loop();
  }
}
  


  //void drawPixels(color[] pixelsToDraw){
  //  int iter=0;
  //  for (int i=0;i<sampleHeightRes;i++) {
  //    for (int j=0;j<sampleWidthRes;j++) {
  //      fill(opaqueColorFromColor(pixelsToDraw[j+i*sampleWidthRes]));
  //      rect(int(j*numPixelsToSkip), int(i*numPixelsToSkip), numPixelsToSkip, numPixelsToSkip);
  //    }
  //  }
  //}
  


