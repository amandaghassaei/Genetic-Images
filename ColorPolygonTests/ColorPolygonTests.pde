
import processing.pdf.*;

//image to match:
String fileName = "teddy";
String imageName = fileName + ".jpg";
PImage image;//storage for image

//global variables
int currentNumGenes = 0;//starting # genes per individual
int totalNumGenes = 0;//max number of genes (set to 0 for no max)
int maxGenerations = 1000000;//manually shut down sketch after we hit this many iterations (set to 0 to never stop searching)
int numPlateau = 500;//number of generations w/o a new best match before we add another gene into the mix, doesn't matter if currentNumGenes == totalNumGenes
boolean initializeSmallTriangles = true;//set to true to initialize each new gene as a very small triangle, this might help to more easily introduce it into the gene pool bc it will affect less pixels
boolean hillClimb = true;//if you are running this in hill climbing mode, you probably want to set the populationSize variable to 1, otherwise you will hillclimb a population on n individuals in parallel, they will not mix with eachother

int populationSize = 1;//number of individuals in a population
//display options
boolean renderOneAtATime = false;//ability to render all individuals of a generation at once if false, be careful you don't try to do too much though, it may crash
int numCols = 1;//for best results, numCols*numRows = populationSize;
int numRows = 1;

//storage globals
Population population;//storage for individuals
int generation = 0;//generation number
float maxColorDeviation;//baseline for worst fitness (calculated in setup), use to scale raw img color deviation into something usable
Saver imgSaver;//keeps track of when to save imgs
StatsSaver statsSaver;//keeps track of when to save stats to txt file

Individual bestIndividualSoFar;

void setup(){
  
  image = loadImage(imageName);
  image.loadPixels();
  
  if (renderOneAtATime){
    size(image.width,image.height);
  } else {
    if (numCols*numRows<populationSize) {
      println("you need to set numCols and numRows so that numCols*numRows >= populationSize");
      println("error");
      println("quitting");
      exit();
    }
    size(image.width*numCols,image.height*numRows);
  }
  background(0);
  
  population = new Population();
  imgSaver = new Saver();
  statsSaver = new StatsSaver();
  
  noStroke();
  
  //set baseline for worst fitness
  Gene[] noGenes = new Gene[0];
  Individual worstPossibleIndividual = new Individual(noGenes, true);//all black - no polygons
  maxColorDeviation = worstPossibleIndividual.calculateRawFitness(0,0);
  
  bestIndividualSoFar = new Individual();
}

void draw(){
  
  if (imgSaver.needsSave(generation)){
    imgSaver.doSave(population);
  }
  
  population.iter();
  printStats();
  
  if (statsSaver.needsSave(generation)){
    statsSaver.doSave(population);
  }
  if (generation>maxGenerations && maxGenerations!=0) {
    complete();
    exit();
  }
  generation++;
}

void keyPressed() {
  if (key=='q'){//manually quit
    complete();
    exit();
  }
  if (key=='p'){//pause
    noLoop();
  }
  if (key=='r'){//resume
    loop();
  }
  if (key=='s'){//save
    imgSaver.doSave(population);
    statsSaver.doSave(population);
  }
}

void complete() {
  imgSaver.doSave(population);
  statsSaver.doSave(population);
  statsSaver.finish();  
} 

void printStats() {
  print("gens = ");
  print(generation);
  print("  poly = ");
  print(currentNumGenes);
  print("  stag = ");
  print(population.stagGenNum);
  print("  fit = ");
  println(population.iterBestIndividual.getFitness());
}
