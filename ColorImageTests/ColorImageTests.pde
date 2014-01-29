
import processing.pdf.*;

//image to match:
String fileName = "teddy";

//hillclimb variables
boolean hillClimb = true;
int numPlateau = 250;//number of generations w/o a new best match before we add another gene into the mix

//global variablesq
int currentNumGenes = 0;//starting # genes per individual
int totalNumGenes = 1;//max number of genes (set to 0 for no max)
int maxGenerations = 1000000;//manually shut down sketch after we hit this many iterations (set to 0 to never stop searching)
int populationSize = 1;//number of individuals in a population (keep this even to keep it simple)

//storage globals
Population population = new Population();//storage for individuals
Saver saver = new Saver();//keeps track of when to save
int generation = 0;//generation number
String imageName = fileName + ".jpg";
PImage image;//storage for image
float maxColorDeviation;//baseline for worst fitness (calculated in setup)

void setup(){
  
  image = loadImage(imageName);
  image.loadPixels();
  
  size(image.width,image.height);
  noStroke();
  
  //set baseline for worst fitness
  Gene[] noGenes = new Gene[0];
  Individual worstIndividual = new Individual(noGenes);
  maxColorDeviation = worstIndividual.calculateRawFitness();
}

void draw(){
  
  population.iter();
  printStats();
  
  if (saver.shouldSave && saver.needsSave(generation)){
    saver.doSave(population.populationList[0]);
  }
  if (generation>maxGenerations && maxGenerations!=0) {
    saver.doSave(population.populationList[0]);
    exit();
  }
  
  generation++;
}

void keyPressed() {
  if (key=='q'){//manually quit
    saver.doSave(population.populationList[0]);
    exit();
  }
  if (key=='p'){//pause
    noLoop();
  }
  if (key=='r'){//resume
    loop();
  }
  if (key=='s'){//save
    saver.doSave(population.populationList[0]);
  }
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
