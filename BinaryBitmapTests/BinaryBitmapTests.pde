//binary bitmap test

int imgHeight = 7;//px height of individual
int imgWidth = 7;//px width of individual
int totalNumGenes = imgWidth*imgHeight;

int populationSize = 50;//number of individuals in a population
int generation = 0;//generation number

float geneMutationRate = 0.05;//change the value of a pixel
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
  save(imgName+"_pop"+populationSize+"_mut"+geneMutationRate+"/gen"+generation+".png");
  generation++;
  if (allMatchesFound()) exit();
}

boolean allMatchesFound(){
  for (Population population : populations){
    if (!population.matchFound) return false;
  }
  return true;
}
