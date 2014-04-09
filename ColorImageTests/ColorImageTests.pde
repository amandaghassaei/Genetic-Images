
import processing.pdf.*;

//image to match:
String fileName = "teddy";

//hillclimb variables
boolean hillClimb = true;

//global variablesq
int currentNumGenes = 0;//starting # genes per individual
int totalNumGenes = 0;//max number of genes (set to 0 for no max)
int maxGenerations = 1000000;//manually shut down sketch after we hit this many iterations (set to 0 to never stop searching)
int populationSize = 1;//number of individuals in a population (keep this even to keep it simple, or if we are doing hillclimb, must set this to 1)
int numPlateau = 250;//number of generations w/o a new best match before we add another gene into the mix

//storage globals
Population population = new Population();//storage for individuals
Saver imgSaver = new Saver();//keeps track of when to save imgs
StatsSaver statsSaver;//keeps track of when to save stats to txt file
int generation = 0;//generation number
String imageName = fileName + ".jpg";
PImage image;//storage for image
float maxColorDeviation;//baseline for worst fitness (calculated in setup), use to scale raw img color deviation into something usable

void setup(){
  
  image = loadImage(imageName);
  image.loadPixels();
  
  size(image.width,image.height);
  noStroke();
  
  statsSaver = new StatsSaver();//this has to be in setup();
  
  //set baseline for worst fitness
  Gene[] noGenes = new Gene[0];
  Individual worstPossibleIndividual = new Individual(noGenes);//all black - no polygons
  maxColorDeviation = worstPossibleIndividual.calculateRawFitness();
}

void draw(){
  
  population.iter();
  printStats();
  
  if (imgSaver.needsSave(generation)){
    imgSaver.doSave(population.populationList[0]);
  }
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
    imgSaver.doSave(population.populationList[0]);
    statsSaver.doSave(population);
  }
}

void complete() {
  imgSaver.doSave(population.populationList[0]);
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
  println(population.populationList[0].getFitness());
}
