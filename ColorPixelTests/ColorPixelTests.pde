//binary bitmap test

import processing.pdf.*;

String fileName = "teddy";
String imageOrigName = fileName + ".jpg";
PImage imageOrig;//storage for image

int totalNumGenes;

int populationSize = 100;//number of individuals in a population (keep this even to keep it simple)
int generation = 0;//generation number
int maxGens = 100000;//manually shut down sketch after we hit this many iterations and still no match (set to 0 to never stop)
int saveImgAtIncrement = 100;//how often we should save an image for the movie (number of generations)

float geneMutationRate;//change the value of a pixel
float crossoverRate = 1.0;//rate of crossover reproduction vs cloning
boolean hillClimb = false;

Population population;

PImage image;//storage for rendering
String imgName;

StatsSaver saver;
boolean forceQuit = false;

void setup() {
  
  imageOrig = loadImage(imageOrigName);
  imageOrig.loadPixels();
  
  size(imageOrig.width,imageOrig.height);
  background(0);
  
  totalNumGenes = imageOrig.width*imageOrig.height;
  geneMutationRate = 1/float(totalNumGenes);
  
  imgName = "grey"+"_pop"+populationSize+"_mut"+geneMutationRate;
  
  population = new Population();
  
  image = new PImage(imageOrig.width, imageOrig.height, ALPHA);
  image.loadPixels();
  
  noStroke();
  
  saver = new StatsSaver();
}

void draw(){
  if (!population.matchFound){
    population.iter();    
  }
  if (generation%saveImgAtIncrement==0){
    population.iterBestIndividual.render();
    saveFrame(imgName+"/gen-##########.tif");
  }
  
  if (saver.needsSave(generation)){
    saver.doSave(population);
  }
  
  print(100*population.iterBestIndividual.getFitness()/float(totalNumGenes));
  print("  ");
  print(100*population.iterWorstIndividual.getFitness()/float(totalNumGenes));
  print("  ");
  println(generation);
  
  if (forceQuit || allMatchesFound() || generation>maxGens && maxGens!=0) {
    population.iterBestIndividual.render();
    saveFrame(imgName+"/gen-##########.tif");
    saver.doSave(population);
    saver.finish();
    exit();
  }
  
  generation++;
}

boolean allMatchesFound(){
  if (!population.matchFound) return false;
  return true;
}

void keyPressed() {
  if (key=='q'){//manually quit
    forceQuit = true;
  }
  if (key=='p'){//pause
    noLoop();
  }
  if (key=='r'){//resume
    loop();
  }
}
