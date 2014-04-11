class StatsSaver {
  
  int saveMultiplier = 10000;//save state every 10000 generations
  int linearSaves;
  int nextLinearGenToSave;
  int logSaves;
  int nextLogGenToSave;//also save every 10^n, in case we want to plot in log scale
  String statsFilename = fileName+"_stats.txt";
  PrintWriter statsOutput;
  
  StatsSaver() {
    linearSaves = 0;
    logSaves = -1;
    nextLinearGenToSave = 0;
    nextLogGenToSave = 0;
    statsOutput = createWriter(statsFilename);
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
    nextLogGenToSave = int(pow(10,logSaves));
  }
  
  void finish() {
    statsOutput.flush();
    statsOutput.close();
  }
  
}
