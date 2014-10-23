/*
oscArduino is simple communication system with Processing 1.5 and Max6.
by Yuta Uozumi, Sonilab 2013.
*/

class DigitalPin {
  int mode; //For storage the pin mode OUTPUT or INPUT
  float value; //

  // Contructor (required)
  DigitalPin(int imode, float fvalue) {

    mode = imode;
    value = fvalue;
        
  }
  
}
