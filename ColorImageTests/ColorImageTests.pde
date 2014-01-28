
import processing.pdf.*;

boolean hillClimb = true;
int numPlataeu = 500;//number of generations w/o a new best match before we add another gene into the mix
int stagGenNum = numPlataeu;//number of generations since a child was more fit than parent
boolean stableGeneAdded = true;

float maxDeviation;

int opacity = 70;

int currentNumGenes = 0;
int totalNumGenes = 1;

int generation = 0;//generation number
int maxGens = 0;//manually shut down sketch after we hit this many iterations and still no match (set to 0 to never stop)

float crossoverRate = 1.0;//rate of crossover reproduction vs cloning
int populationSize = 1;//number of individuals in a population (keep this even to keep it simple)

boolean shouldSave = false;
int saveImgAtIncrement = 100;//how often we should save an image for the movie (number of generations)

//image storage
String imageName = "amanda.jpg";
PImage image;//storage for image
PImage smallImage;

//amount of pixels to sample
int numPixelsToSkip = 1;//ex when = 10, we only test against the input image for one pixel in every 10x10px region
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
  
  //set baseline for worst fitness
  Gene[] noGenes = new Gene[0];
  Individual worstIndividual = new Individual(noGenes);
  maxDeviation = worstIndividual.calculateRawFitness();
  println(maxDeviation);
  
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
  if (key=='s'){//save
    population.populationList[0].printPolygons();
  }
}

void printStats() {
  print("gens = ");
  print(generation);
  print("  poly = ");
  print(currentNumGenes);
  print("  stag = ");
  print(stagGenNum);
  print("  fit = ");
  println(population.populationList[0].getFitness());
}
