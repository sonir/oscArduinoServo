/*
oscArduino is simple communication system with Processing 1.5 and Max6.
by Yuta Uozumi, Sonilab 2013.
*/

//For OSC 
import oscP5.*;
import netP5.*;  
OscP5 oscP5;
NetAddress myRemoteLocation;

//For Arduino 
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;


//SYSTEM VARIABLES
//Define the max number of the digital pin
int max_pin = 13;
//Define the max number of the analog pin
int max_pin_analog = 6;
//Initialize Pins by Sonilab
DigitalPin [] digitalPins;
//Initialize the array for analog pin values
float [] analogPins = new float [max_pin_analog];



//My Functions

//For Pin Initialization
void initThePin(int targetPin){ //Init the specified pin
  
        //Pin Mode Check 
        int the_pin_is_updated = 0;
          
        //Check is it INPUT
        for(int j = 0; j< inputPins.length; j++) {
          
            if(inputPins[j]==targetPin) { //If the pin set as input 
              //Send the command to arduino
              digitalPins[targetPin] = new DigitalPin(Arduino.INPUT, Arduino.LOW);
              the_pin_is_updated = 1;
              println("found input pin" + inputPins[j]);
              return;
            }        
          
        } 
        
      //Check is it servo
      for(int k = 0; k< servoPins.length; k++) {
        
          if(servoPins[k]==targetPin)
          {
            //Send the command to arduino
            digitalPins[targetPin] = new DigitalPin(Arduino.SERVO, 0.);
            the_pin_is_updated = 1;
            println("found servo pin" + servoPins[k]);
            return;
          }
        
      }
            
      //If the pin is not input or servo, set it as output.
     if (the_pin_is_updated!=1) digitalPins[targetPin] = new DigitalPin(Arduino.OUTPUT, Arduino.LOW);
  
}  

void initPins(){ //Set Pinmode based on setUp.pde
 
    for(int targetPin = 0; targetPin<= max_pin; targetPin++) initThePin(targetPin);
 
}



//Routines for Loop
void routineOutputPin (int targetPin) {
  
// <Code for OUTPUT Pin>    

      if(digitalPins[targetPin].value == 0. || digitalPins[targetPin].value == 1.) { //If the value is digital.       
      //< Code for DigitalOut >
          arduino.digitalWrite(targetPin, (int)digitalPins[targetPin].value);

         //DON'T REMOVE !! PWM Pin needs analogWrinte Constantly.          
         if(targetPin==3 || targetPin==4 || targetPin==5 || targetPin==6 || targetPin==9 || targetPin==10 || targetPin==11){ //check PWM pin or not according to arduino spec that used a pin as analogWrite atonce , it can not use as digital.
           float pwm_value = 255. * digitalPins[targetPin].value;
           arduino.analogWrite(targetPin, (int)pwm_value);           
         }
                      
          //Display Message//
          String mes = "pin" + targetPin + " (out): " + (int)digitalPins[targetPin].value;
          if((int)digitalPins[targetPin].value==0) fill(155, 0, 0);
          else fill(255, 0, 0);
          text( mes, 10, (11*targetPin)+20);
          fill(255, 255, 255);
       // </Code for DigitalOut>
      
      }else{
                      
        // <Code for PWM Pin>        
        if(targetPin==3 || targetPin==4 || targetPin==5 || targetPin==6 || targetPin==9 || targetPin==10 || targetPin==11){ //Check the pin is PWM pin or not
            
            //If the value is float, set thevalue as PWM.
            float pwm_value = 255. * digitalPins[targetPin].value;
            arduino.analogWrite(targetPin, (int)pwm_value);
            
            //Display Message
            fill(255, 255, 0);
            String mes = "pin" + targetPin + " (PWM): " + (int)pwm_value;
            text( mes, 10, (11*targetPin)+20);
            fill(255, 255, 255);
        }        
       // </Code for PWM Pin>         
     }        
// </Code for OUTPUT Pin>  
}  


//Routine for Servo
void routineServoPin (int targetPin) {
  
      // <Code for SERVO Pin>
    if(targetPin==3 || targetPin==4 || targetPin==5 || targetPin==6 || targetPin==9 || targetPin==10 || targetPin==11){ //Check the pin is PWM pin
        
        float angle = 180. * digitalPins[targetPin].value;
        arduino.servoWrite(targetPin, (int)angle);
        delay(50);
        
        fill(0, 255, 255);
        String mes = "pin" + targetPin + " (SERVO): " + (int)angle;
        text( mes, 10, (11*targetPin)+20);
        fill(255, 255, 255);
    }
  
}  

//Routine for Input
void routineInputPin (int targetPin) {
  
   //Check the pin is INPUT
   if ( digitalPins[targetPin].mode != Arduino.INPUT) return;  
  
    //WHEN THE PIN IS SET AS INPUT DO AS FOLLOWS,
    digitalPins[targetPin].value = arduino.digitalRead(targetPin); //If the pin is INPUT, set the value into disitalPins array
    //Display Message
    if((int)digitalPins[targetPin].value==0) fill(0, 0, 155);
        else fill(100, 100, 255);
            
            String mes = "pin" + targetPin + " (INPUT): " + (int)digitalPins[targetPin].value;
            text( mes, 150, (11*targetPin)+20);
  
}  

//Get Analog Pin Values
void getAnalogPinValues () {
  
    //Get analogPin Values
   for(int i=0; i<max_pin_analog; i++){
     analogPins[i] = (float)arduino.analogRead(i) / 1023.;
     //Display Message
     fill(0, 255, 0); 
     String mes = "Analog-IN" + i + ": " + arduino.analogRead(i); 
     text( mes, 10, (11*i)+200);
     if(i==max_pin_analog-1)text ("range: 0-1024", 10, ((11*(max_pin_analog))+200));
     fill(255, 255, 255); 
   }  
  
}


//Do All Routines for I/O from Pin 
void pinRoutines () {
  
   for(int i=0; i<=max_pin; i++){
     
      if(digitalPins[i].mode == Arduino.SERVO) routineServoPin(i);
      else if(digitalPins[i].mode == Arduino.OUTPUT) routineOutputPin(i);
      else routineInputPin(i);
   }

  getAnalogPinValues();
  
}



//Basic Flow

void setup() {

  //Basic Setup  
  size(400, 400);
  frameRate(12);

  /// OSC Setup ///
  /* Setup input port */
  oscP5 = new OscP5(this, 57111);
  //Set the destination IP Adress and its port.
  myRemoteLocation = new NetAddress("127.0.0.1", 57110);

  /// Arduino Setup ////

  //Indicate the list of serial ports
  println(Arduino.list());
  //Set the serial port connected with Arduino
  arduino = new Arduino(this, Arduino.list()[2], 57600);  
  
  ///Create Array for digitalPin with default setting ///
  digitalPins = new DigitalPin[max_pin+1]; //The index number must include "0".
  
  //Init with default value  
  initPins();
  println(digitalPins[11].mode);
  
  //Initialize the pin modes of DigitalPins
  for(int i=0; i<=max_pin; i++) arduino.pinMode(i, digitalPins[i].mode);
      
}



void draw() {
  
  background(0); 
  
  /// Arduino Section ///
  pinRoutines();
  
  /// OSC Section ///
  OscMessage digitalPinStates = new OscMessage("/digitalPinStates");  
  for(int i=0; i<=max_pin; i++) digitalPinStates.add(digitalPins[i].value); /* add an int to the osc message */
  /* send the message */
  oscP5.send(digitalPinStates, myRemoteLocation);
  
  OscMessage analogPinValues = new OscMessage("/analogPinValues");  
  for(int i=0; i<max_pin_analog; i++) analogPinValues.add(analogPins[i]); /* add an int to the osc message */
  /* send the message */
  oscP5.send(analogPinValues, myRemoteLocation);
  
}

void mousePressed() {


}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

  /* print the address pattern and the typetag of the received OscMessage */
  if(theOscMessage.checkAddrPattern("/digitalPinStates")==true)
  {
    //If get the digitalPinStates, update them      
    for(int i=0; i<= max_pin; i++){
     //Write the value to OUTPUT pin only
     if(digitalPins[i].mode != arduino.INPUT) digitalPins[i].value =  theOscMessage.get(i).floatValue();
     
    }   
    
    /* Examples of getting messages from OSC
      int firstValue = theOscMessage.get(0).intValue();  // get the first osc argument
      float secondValue = theOscMessage.get(1).floatValue(); // get the second osc argument
      String thirdValue = theOscMessage.get(2).stringValue();
    */

  }
  
  
}

