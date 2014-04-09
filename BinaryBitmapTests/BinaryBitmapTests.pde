//binary bitmap test

import processing.pdf.*;

ArrayList<PVector> plotPoints = new ArrayList<PVector>();//storage for scatter plot

int imgHeight = 51;//px height of individual
int imgWidth = 51;//px width of individual
int totalNumGenes = imgWidth*imgHeight;

int populationSize = 1;//number of individuals in a population (keep this even to keep it simple)
int generation = 0;//generation number
int maxGens = 100000;//manually shut down sketch after we hit this many iterations and still no match (set to 0 to never stop)
int saveImgAtIncrement = 1000;//how often we should save an image for the movie (number of generations)

float geneMutationRate = 0.01;//change the value of a pixel
float crossoverRate = 1.0;//rate of crossover reproduction vs cloning
boolean hillClimb = true;

//run multiple trials at once
int trialsCol = 1;//how many columns of trials
int trialsRow = 1;//how many rows
int trialsSpacing = 3;//px spacing between trials in output img
int numTrials = trialsCol*trialsRow;
Population[] populations = new Population[numTrials];

PImage image;//storage for rendering
String imgName = "bitmap"+"_pop"+populationSize+"_mut"+geneMutationRate+"_numPix"+imgHeight*imgWidth;

void setup() {
  size(1000,500, PDF, imgName+".pdf");
  background(200);
  for (int i=0;i<numTrials;i++){
    populations[i] = new Population();
  }
  image = new PImage(imgWidth, imgHeight, ALPHA);
  image.loadPixels();
  
  noStroke();
}

void draw(){
  for (int i=0;i<numTrials;i++){
    Population population  = populations[i];
    if (!population.matchFound){
      population.iter();
      population.iterBestIndividual.render();
      image(image,(i%trialsCol)*(imgWidth+trialsSpacing),(i/trialsCol)*(imgHeight+trialsSpacing));
    }
  }
  if (generation%saveImgAtIncrement==0){
    PVector newPoint = new PVector(generation, populations[0].iterBestFitness);
    plotPoints.add(newPoint);
//    saveFrame(imgName+"/gen-##########.tif");
  }
  background(255);
  print(populations[0].iterBestFitness);
  print("  ");
  println(generation);
  generation++;
  if (allMatchesFound() || generation>maxGens && maxGens!=0) {
    saveScatterPlot();
//    drawResultsFrame();
    exit();
  }
}

boolean allMatchesFound(){
  for (Population population : populations){
    if (!population.matchFound) return false;
  }
  return true;
}

void drawResultsFrame(){
  save("finalFrame.png");
  PImage lastFrame = loadImage("finalFrame.png");
  frame.setResizable(true);
  float movScale = 20;//amount to scale up for movie
  size(width*int(movScale),height*int(movScale));
  lastFrame.resize(width,height);
  image(lastFrame,0,0);
  noStroke();
  fill(255,255,255,200);
  rect(0,0,width,height);
  for (int i=0;i<numTrials;i++){
    if (!populations[i].matchFound) println(geneMutationRate + "," + populationSize + "," + 10000);//print a very large number if we haven't found a match, use this in plot
    fill(0);
    textSize(24);
    textAlign(CENTER);
    text(populations[i].matchGen, ((i%trialsCol)*(imgWidth+trialsSpacing)+float(imgWidth)/2)*movScale-imgWidth*movScale/2,((i/trialsCol)*(imgHeight+trialsSpacing-1/2)+float(imgHeight)/2)*movScale-40, imgWidth*movScale, 80);  
  }
  saveFrame(imgName+"/gen-#####.tif");
}

void saveScatterPlot(){
  background(255);
  stroke(255, 0, 0);
  beginShape();
  for (PVector point : plotPoints){
    vertex(width*point.x/generation, height*(1-point.y/(imgHeight*imgWidth))); 
  }
  endShape();
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
