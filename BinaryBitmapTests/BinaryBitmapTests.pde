//binary bitmap test

int imgHeight = 7;//px height of individual
int imgWidth = 7;//px width of individual
int totalNumGenes = imgWidth*imgHeight;

int populationSize = 50;//number of individuals in a population
int generation = 0;//generation number
int maxGens = 5000;//manually shut down sketch after we hit this many iterations and still no match

float geneMutationRate = 0.005gene;//change the value of a pixel
float crossoverRate = 1.0;//rate of crossover reproduction vs cloning

//run multiple trials at once
int trialsCol = 4;//how many columns of trials
int trialsRow = 3;//how many rows
int trialsSpacing = 3;//px spacing between trials in output img
int numTrials = trialsCol*trialsRow;
Population[] populations = new Population[numTrials];

PImage image;//storage for rendering
String imgName = "bitmap";

void setup() {
  size(imgWidth*trialsCol+trialsSpacing*(trialsCol-1),imgHeight*trialsRow+trialsSpacing*(trialsRow-1));
  background(200);
  for (int i=0;i<numTrials;i++){
    populations[i] = new Population();
  }
  image = new PImage(imgWidth, imgHeight, ALPHA);
  image.loadPixels();
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
  saveFrame(imgName+"_pop"+populationSize+"_mut"+geneMutationRate+"/gen-#####.tif");
  generation++;
  if (allMatchesFound() || generation>maxGens) {
    drawResultsFrame();
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
  saveFrame(imgName+"_pop"+populationSize+"_mut"+geneMutationRate+"/gen-#####.tif");
}

void keyPressed() {
  if (key=='q'){//manually quit
    generation = maxGens;
  }
}
