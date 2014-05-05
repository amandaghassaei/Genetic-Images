int[] intArrayFromColor(color myColor){
  int[] colorArray = new int[3];
  colorArray[0] = (myColor >> 16) & 0xFF;// Faster way of getting red(argb)
  colorArray[1] = (myColor >> 8) & 0xFF;// Faster way of getting green(argb)
  colorArray[2] = myColor & 0xFF;// Faster way of getting blue(argb)
  return colorArray;
}

float colorDistance(color color1, color color2){
  int[] color1Array = intArrayFromColor(color1);
  int[] color2Array = intArrayFromColor(color2);
  return sqrt(sq(color1Array[0]-color2Array[0]) + sq(color1Array[1]-color2Array[1]) + sq(color1Array[2]-color2Array[2]));
}


