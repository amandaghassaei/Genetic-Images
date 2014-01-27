
boolean hillClimb = true;
int stagGenNum = 0;//number of generations since a child was more fit than parent
int numPlataeu = 500;//number of generations w/o a new best match before we add another gene into the mix
boolean stableGeneAdded = false;

float crossoverRate = 1.0;//rate of crossover reproduction vs cloning

int opacity = 30;
int totalNumGenes = 1;
int currentNumGenes = 1;

float geneColorMutationRate = 0.01;
float colorTol = 10;
float geneCoordMutationRate = 0.01;
float coordMutationDistance = 50;

int populationSize = 1;//number of individuals in a population (keep this even to keep it simple)
int generation = 0;//generation number
int maxGens = 0;//manually shut down sketch after we hit this many iterations and still no match (set to 0 to never stop)
boolean shouldSave = false;
int saveImgAtIncrement = 100;//how often we should save an image for the movie (number of generations)

//image storage
String imageName = "amanda.jpg";
PImage image;//storage for image
PImage smallImage;

//amount of pixels to sample
int numPixelsToSkip = 10;//ex when = 10, we only test against the input image for one pixel in every 10x10px region
int sampleWidthRes;
int sampleHeightRes;

Population population;//storage

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
//  
  if (shouldSave && generation%saveImgAtIncrement==0){
////    saveFrame(imgName+"/gen-##########.tif");
  }
  generation++;
  printStats();
  if (generation>maxGens && maxGens!=0) {
    exit();
  }
}

void keyPressed() {
  if (key=='q'){//manually quit
    generation = maxGens;
  }
  if (key=='p'){//pause
    noLoop();
  }
  if (key=='r'){//resume
    loop();
  }
}

void printStats() {
  print("gens = ");
  print(generation);
  print("  poly = ");
  print(currentNumGenes);
  print("  stag = ");
  println(stagGenNum);
}
