//render one or many sets of stats in one pdf graph

import processing.pdf.*;

//files to render (make sure they are loaded in current directory)
String file1 = "teddy_stats.txt";
String file2 = "teddy_stats2.txt";
String file3 = "teddy_stats3.txt";

//insets for drawing graph
int vInset = 50;
int hInset = 70;

//opacity of plots (for comparisons)
int opacity = 170;

//scale for axes
boolean logX = false;
boolean logY = true;

void setup() {
  
  size(1000, 700);
  background(255);
  beginRecord(PDF, file1+"_finalStats.pdf"); 
   
  color red = color(255, 0, 0, opacity);
  render(file1, red);
  color blue = color(0, 0, 255, opacity);
  render(file2, blue);
  color black = color(0, 0, 0, opacity);
  render(file3, black);
  
  drawAxes(); 

  endRecord();
  exit();
}

void loop() {
}

void drawAxes(){
  int tickLength = 5;
  int txtOffset = 5;
  int txtSize = 15;
  stroke(0);
  fill(0);
  textSize(txtSize);
  strokeWeight(2);
//  line(hInset, vInset, hInset, height-vInset);
  textAlign(RIGHT);
  if (logY){
    for (int i=0;i<4;i++){
      line(hInset, vInset+i*(height-2*vInset)/4, hInset-tickLength, vInset+i*(height-2*vInset)/4);
      String percent = 100-int(pow(100,i/4.0)) +"%";
      if (i==0) percent = "100%";
      text(percent, hInset-tickLength-txtOffset, vInset+i*(height-2*vInset)/4.0+txtSize/2);
    }
  } else {
    for (int i=0;i<5;i++){
      line(hInset, vInset+i*(height-2*vInset)/5, hInset-tickLength, vInset+i*(height-2*vInset)/5);
      text((5-i)*20+"%", hInset-tickLength-txtOffset, vInset+i*(height-2*vInset)/5+txtSize/2);
    }
  }
  textAlign(CENTER);
  line(hInset, height-vInset, width-hInset, height-vInset);
  if (logX) {
    for (int i=1;i<=7;i++){
      line(hInset+i*(width-2*hInset)/7, height-vInset, hInset+i*(width-2*hInset)/7, height-vInset+tickLength);
      String power = "";
      if ((i-1)/3 == 1) power = "K";
      if ((i-1)/3 == 2) power = "M";
      int val = 1;
      if ((i-1)%3 == 1) val = 10;
      if ((i-1)%3 == 2) val = 100;
      text(val+power, hInset+i*(width-2*hInset)/7, height-vInset+tickLength+txtOffset+txtSize);
    }
  } else {
    for (int i=1;i<=10;i++){
      line(hInset+i*(width-2*hInset)/10, height-vInset, hInset+i*(width-2*hInset)/10, height-vInset+tickLength);
      if (i==10) {
        text("1M", hInset+i*(width-2*hInset)/10, height-vInset+tickLength+txtOffset+txtSize);
      } else {
        text(i*100+"K", hInset+i*(width-2*hInset)/10, height-vInset+tickLength+txtOffset+txtSize);
      }
    }
  }
  
}

void render(String filename, color plotColor) {
  String lines[] = loadStrings(filename);
  fill(plotColor);
  noStroke();
  float data[] = float(lines[0].split(","));
  float lastGeneration = data[0];
  float lastMax = data[1];
  float lastMin = data[2];
  beginShape(QUAD_STRIP);
  for (String line : lines){
    data = float(line.split(","));
    float generation = data[0];
    float max = data[1];
    float min = data[2];
    float polygonCount = data[3];
    if ((max-min)<0.5) {
      stroke(plotColor);
      strokeWeight(2);
      line(hInset+scaleX(lastGeneration)*(width-2*hInset),  vInset+(height-2*vInset)*scaleY(lastMax), hInset+scaleX(generation)*(width-2*hInset),  vInset+(height-2*vInset)*scaleY(max));
      noStroke();
    }
    vertex(hInset+scaleX(generation)*(width-2*hInset),  vInset+(height-2*vInset)*scaleY(max));
    vertex(hInset+scaleX(generation)*(width-2*hInset),  vInset+(height-2*vInset)*scaleY(min));
    lastGeneration = generation;
    lastMax = max;
    lastMin = min;
  }
  endShape();
}

float scaleX(float x) {
  if (logX) return scaleToLogX(x);
  return scaleLinearX(x);
}

float scaleLinearX(float x) {
  return x/1000000.0;
}

float scaleToLogX(float x) {
  if (x==0) return 0;
  return (log10(x)+1)/7.0;
}

float scaleY(float y) {
  if (logY) return scaleToLogY(y);
  return scaleLinearY(y);
}

float scaleLinearY(float y) {
  return 1-y/100.0;
}

float scaleToLogY(float y) {
  if (y>99) return 0;
  if (y==0) return 1;
  return (log10(100-y)+1)/4.0;
}

float log10 (float x) {
  return (log(x) / log(10));
}
