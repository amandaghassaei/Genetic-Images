class StatsSaver {
  
  int saveMultiplier = 10000;//save state every 10000 generations
  int linearSaves;
  int nextLinearGenToSave;
  int logSaves;
  int nextLogGenToSave;//extra saves, in case we want to plot in log scale
  int logIncr;
  String statsFilename = fileName+"_stats.txt";
  PrintWriter statsOutput;
  
  //caclculate elapsed time - none of this has been lasting more than a day
  int startSec;
  int startMin;
  int startHr;
  
  StatsSaver() {
    linearSaves = 0;
    logSaves = -1;
    nextLinearGenToSave = 0;
    nextLogGenToSave = 0;
    logIncr = 1;
    statsOutput = createWriter(statsFilename);
    startSec = second();
    startMin = minute();
    startHr = hour();
  }
  
  boolean needsSave(int generation) {
    boolean shouldSave = false;
    if (generation==nextLinearGenToSave){
      linearSaves++;
      shouldSave = true;
    } if (generation==nextLogGenToSave){
      logSaves++;
      shouldSave = true;
    }
    return shouldSave;
  }
  
  void doSave(Population population) {
    statsOutput.print(generation);
    statsOutput.print(",");
    statsOutput.print(population.iterBestIndividual.getFitness());
    statsOutput.print(",");
    statsOutput.print(population.iterWorstIndividual.getFitness());
    statsOutput.print(",");
    statsOutput.println(currentNumGenes);
    nextLinearGenToSave = int(linearSaves*saveMultiplier);
    if (nextLogGenToSave==10) logIncr = 10;
    if (nextLogGenToSave==100) logIncr = 100;
    if (nextLogGenToSave==1000) logIncr = 1000;
    if (nextLogGenToSave==10000) logIncr = 10000;
    if (nextLogGenToSave==100000) logIncr = 100000;
    nextLogGenToSave += logIncr;
  }
  
  void finish() {
    statsOutput.print("elapsedTime");
    statsOutput.print(",");
    statsOutput.print(hour()-startHr);
    statsOutput.print(":");
    statsOutput.print(minute()-startMin);
    statsOutput.print(":");
    statsOutput.println(second()-startSec);
    statsOutput.flush();
    statsOutput.close();
  }
  
}
