//helper functions to convert between RGB and LAB color space, this is mostly copied from:
//http://rsbweb.nih.gov/ij/plugins/download/Color_Space_Converter.java

float [][] M = {{0.4124, 0.3576,  0.1805},
                {0.2126, 0.7152,  0.0722},
                {0.0193, 0.1192,  0.9505}};
                
float[] whitePoint = {95.0429, 100.0, 108.8900};
                
float[] RGBtoLAB(int[] RGB) {
  return XYZtoLAB(RGBtoXYZ(RGB[0], RGB[1], RGB[2]));
}

float[] RGBtoLAB(int R, int G, int B) {
  return XYZtoLAB(RGBtoXYZ(R, G, B));
}

float[] RGBtoXYZ(int R, int G, int B) {

  // convert 0..255 into 0..1
  float r = R / 255.0;
  float g = G / 255.0;
  float b = B / 255.0;

  // assume sRGB
  if (r <= 0.04045) {
    r = r / 12.92;
  }
  else {
    r = pow(((r + 0.055) / 1.055), 2.4);
  }
  if (g <= 0.04045) {
    g = g / 12.92;
  }
  else {
    g = pow(((g + 0.055) / 1.055), 2.4);
  }
  if (b <= 0.04045) {
    b = b / 12.92;
  }
  else {
    b = pow(((b + 0.055) / 1.055), 2.4);
  }

  r *= 100.0;
  g *= 100.0;
  b *= 100.0;
  
  float[] result = new float[3];

  // [X Y Z] = [r g b][M]
  result[0] = (r * M[0][0]) + (g * M[0][1]) + (b * M[0][2]);
  result[1] = (r * M[1][0]) + (g * M[1][1]) + (b * M[1][2]);
  result[2] = (r * M[2][0]) + (g * M[2][1]) + (b * M[2][2]);

  return result;
}

public float[] RGBtoXYZ(int[] RGB) {
  return RGBtoXYZ(RGB[0], RGB[1], RGB[2]);
}

public float[] XYZtoLAB(float X, float Y, float Z) {

  float x = X / whitePoint[0];
  float y = Y / whitePoint[1];
  float z = Z / whitePoint[2];

  if (x > 0.008856) {
    x = pow(x, 1.0 / 3.0);
  }
  else {
    x = (7.787 * x) + (16.0 / 116.0);
  }
  if (y > 0.008856) {
    y = pow(y, 1.0 / 3.0);
  }
  else {
    y = (7.787 * y) + (16.0 / 116.0);
  }
  if (z > 0.008856) {
    z = pow(z, 1.0 / 3.0);
  }
  else {
    z = (7.787 * z) + (16.0 / 116.0);
  }

  float[] result = new float[3];

  result[0] = (116.0 * y) - 16.0;
  result[1] = 500.0 * (x - y);
  result[2] = 200.0 * (y - z);

  return result;
}

public float[] XYZtoLAB(float[] XYZ) {
  return XYZtoLAB(XYZ[0], XYZ[1], XYZ[2]);
}
