class StatsSaver {
  
  int saveMultiplier = 10000;//save state every 10000 generations
  int numSavedPoints;
  int nextGenToSave;
  String statsFilename = fileName+"_stats.txt";
  PrintWriter statsOutput;
  
  StatsSaver() {
    numSavedPoints = 0;
    nextGenToSave = int(numSavedPoints*saveMultiplier);
    statsOutput = createWriter(statsFilename);
  }
  
  boolean needsSave(int generation) {
    if (generation==nextGenToSave){
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
    numSavedPoints++;
    nextGenToSave = nextGenToSave = int(numSavedPoints*saveMultiplier);
  }
  
  void finish() {
    statsOutput.flush();
    statsOutput.close();
  }
  
}
