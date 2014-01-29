class Saver {
  
  boolean shouldSave = true;
  int pow = 4;//images saves at equal increments along the x-axis of a power function - this variable sets the degree
  int numSavedImgs;
  int nextGenToSave;
  
  Saver() {
    numSavedImgs = 0;
    nextGenToSave = int(pow(numSavedImgs, pow));
  }
  
  boolean needsSave(int generation) {
    if (generation==nextGenToSave){
      return true;
    }
    return false;
  }
  
  void doSave(Individual individual) {
    individual.printPolygons();
    numSavedImgs++;
    nextGenToSave = int(pow(numSavedImgs, pow));
  }
  
}
