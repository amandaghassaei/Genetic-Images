color opaqueColorFromColor(color transColor) {
  int[] colorArray = intArrayFromColor(transColor);
  color opaqueColor = color(colorArray[0], colorArray[1], colorArray[2]);
  return opaqueColor;
}

int[] intArrayFromColor(color myColor){
  int[] colorArray = new int[3];
  colorArray[0] = (myColor >> 16) & 0xFF;// Faster way of getting red(argb)
  colorArray[1] = (myColor >> 8) & 0xFF;// Faster way of getting green(argb)
  colorArray[2] = myColor & 0xFF;// Faster way of getting blue(argb)
  return colorArray;
}

color colorFromIntArray(int[] colorArray){
  return (opacity<<24) | (colorArray[0]<<16) | (colorArray[1]<<8) | (colorArray[2]);
}

float colorDistance(color color1, color color2){//based on CIE76
  int[] color1Array = intArrayFromColor(color1);
  int[] color2Array = intArrayFromColor(color2);
  return sqrt(sq(color1Array[0]-color2Array[0]) + sq(color1Array[1]-color2Array[1]) + sq(color1Array[2]-color2Array[2]));
}

color getSimilarColor(color origColor){
  int[] origColorArray = intArrayFromColor(origColor);
  for (int i=0;i<3;i++){
    origColorArray[i] = int(constrain(origColorArray[i] + colorTol*(random(2)-1), 0, 255));
  }
//  //L in [0, 100]
//  origColorLAB[0] = constrain(origColorLAB[0], 0, 100);
//  //A in [-86.185, 98.254]
//  origColorLAB[1] = constrain(origColorLAB[1], -86.185, 98.254);
//  //B in [-107.863, 94.482]
//  origColorLAB[2] = constrain(origColorLAB[2], -107.863, 94.482);
//  int[] similarColor = LABtoRGB(origColorLAB);
  return colorFromIntArray(origColorArray);
}
