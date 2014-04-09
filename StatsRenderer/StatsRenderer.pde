//render one or many sets of stats in one pdf graph

import processing.pdf.*;

//files to render (make sure they are loaded in current directory)
String file1 = "teddy_stats.txt";
//String file2 = "file2.txt";
//String file2 = "file3.txt";

//insets for drawing graph
int vInset = 50;
int hInset = 70;

String[] allFiles = {file1};//{file1, file2, file3};

void setup() {
  
  size(1000, 700);
  background(255);
  beginRecord(PDF, file1+"_finalStats.pdf"); 
   
  for (String filename : allFiles){
    render(filename);
  }
  
  drawAxes(); 

  endRecord();
  
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
  line(hInset, vInset, hInset, height-vInset);
  textAlign(RIGHT);
  for (int i=0;i<5;i++){
    line(hInset, vInset+i*(height-2*vInset)/5, hInset-tickLength, vInset+i*(height-2*vInset)/5);
    text((5-i)*20+"%", hInset-tickLength-txtOffset, vInset+i*(height-2*vInset)/5+txtSize/2);
  }
  textAlign(CENTER);
  line(hInset, height-vInset, width-hInset, height-vInset);
  for (int i=1;i<=10;i++){
    line(hInset+i*(width-2*hInset)/10, height-vInset, hInset+i*(width-2*hInset)/10, height-vInset+tickLength);
    if (i==10) {
      text("1M", hInset+i*(width-2*hInset)/10, height-vInset+tickLength+txtOffset+txtSize);
    } else {
      text(i*100+"K", hInset+i*(width-2*hInset)/10, height-vInset+tickLength+txtOffset+txtSize);
    }
  }
  
}

void render(String filename) {
  String lines[] = loadStrings(filename);
  float data[] = float(lines[0].split(","));
  float lastGen = data[0];
  float lastMax = data[1];
  float lastMin = data[2];
  if ((lastMax-lastMin)<0.5) lastMax = lastMin+0.5;//cheat so the line shows up in the graph
  fill(255, 0, 0, 70);
  noStroke();
  for (String line : lines){
    data = float(line.split(","));
    float generation = data[0];
    float max = data[1];
    float min = data[2];
    float polygonCount = data[3];
    if ((max-min)<0.5) max = min+0.5;//cheat so the line shows up in the graph
    quad(hInset+lastGen/1000000*(width-2*hInset), vInset+(height-2*vInset)*(100-lastMin)/100, hInset+lastGen/1000000*(width-2*hInset),  vInset+(height-2*vInset)*(100-lastMax)/100, hInset+generation/1000000*(width-2*hInset),  vInset+(height-2*vInset)*(100-max)/100, hInset+generation/1000000*(width-2*hInset),  vInset+(height-2*vInset)*(100-min)/100);
    lastGen = generation;
    lastMax = max;
    lastMin = min;
  }
}
