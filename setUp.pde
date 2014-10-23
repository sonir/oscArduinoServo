/*
oscArduino is simple communication system with Processing 1.5 and Max6.
by Yuta Uozumi, Sonilab 2013.
*/





//Define the "Pin Names" of digital pins
int switch1 = 2;
int switch2 = 5;
int switch3 = 7;

//Write down the pin names for input use (Default is set as OUTPUT).
int [] inputPins = {switch1, switch2, switch3};

//DIGITAL PINS : SetServoPins (Don't duplicate other pin above.)
int servoPin1 = 11;
//int servoPin2 = 10; ...

//Set the servo pins
int [] servoPins = {servoPin1 /*,servoPin2*/};

//Caution :: Arduino UNO has two groups of PWM pins that 3~ , 5~, 6~ and 9~-11~.
//           If you can only use servo or PWM for each group. 
//           In other words, each groups can not have both of PWM and Servo. 
