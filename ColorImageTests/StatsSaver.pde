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
    if (generation==nextLinearGenToSave || generation==nextLogGenToSave){
      return true;
    }
    return false;
  }
  
  void doSave(Population population) {
    statsOutput.print(generation);
    statsOutput.print(",");
    statsOutput.print(population.iterBestIndividual.getFitness());
    statsOutput.print(",");
    statsOutput.print(population.iterWorstIndividual.getFitness());
    statsOutput.print(",");
    statsOutput.println(currentNumGenes);
    linearSaves++;
    nextLinearGenToSave = int(linearSaves*saveMultiplier);
    logSaves++;
    nextLogGenToSave = pow(10,logSaves);
  }
  
  void finish() {
    statsOutput.flush();
    statsOutput.close();
  }
  
}
