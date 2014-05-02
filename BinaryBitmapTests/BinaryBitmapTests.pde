//binary bitmap test

import processing.pdf.*;

String fileName = "escher";
String imageOrigName = fileName + ".jpg";
PImage imageOrig;//storage for image

int totalNumGenes;

int populationSize = 1;//number of individuals in a population (keep this even to keep it simple)
int generation = 0;//generation number
int maxGens = 1000000;//manually shut down sketch after we hit this many iterations and still no match (set to 0 to never stop)
int saveImgAtIncrement = 100;//how often we should save an image for the movie (number of generations)

float geneMutationRate = 0.01;//change the value of a pixel
float crossoverRate = 1.0;//rate of crossover reproduction vs cloning
boolean hillClimb = true;

//run multiple trials at once
Population population;

PImage image;//storage for rendering
String imgName = "bitmap"+"_pop"+populationSize+"_mut"+geneMutationRate;

StatsSaver saver;
boolean forceQuit = false;


void setup() {
  
  imageOrig = loadImage(imageOrigName);
  imageOrig.loadPixels();
  
  size(imageOrig.width,imageOrig.height);
  background(0);
  
  totalNumGenes = imageOrig.width*imageOrig.height;
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
  
  if (forceQuit || allMatchesFound() || generation>maxGens && maxGens!=0) {
    population.iterBestIndividual.render();
    saveFrame(imgName+"/gen-##########.tif");
    saver.doSave(population);
    saver.finish();
    exit();
  }
  
  print(100*population.iterBestFitness/float(totalNumGenes));
  print("  ");
  println(generation);
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
