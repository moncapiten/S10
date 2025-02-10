#include <Wire.h>
#include <SD.h>

#define MPU 0x68

#define PWR_MGMT1 0x6B
#define ACC_CONF 0x1C
#define GYR_CONF 0x1B

#define TEMP_H 0x41
#define TEMP_L 0x42

#define ACC_X_H 0x3B
#define ACC_X_L 0x3C
#define ACC_Y_H 0x3D
#define ACC_Y_L 0x3E
#define ACC_Z_H 0x3F
#define ACC_Z_L 0x40

#define GYR_X_H 0x43
#define GYR_X_L 0x44
#define GYR_Y_H 0x45
#define GYR_Y_L 0x46
#define GYR_Z_H 0x47
#define GYR_Z_L 0x48

#define g 9.80665


const int chipSelect = 10;
File myFile;

const int statusLED = 3;
int printing = 0;
int delayAmount = 100;

void setup() {
  pinMode(statusLED, OUTPUT);

  Wire.begin();
  Serial.begin(9600);

  regWrite(MPU, PWR_MGMT1, 0x00);
  regWrite(MPU, ACC_CONF, 0x00);
  regWrite(MPU, GYR_CONF, 0x08);

//  byte data = regRead(MPU, 0x75, 1);

//  Serial.print("\n\n\nWhoAmI: ");
  if(regRead(MPU, 0X75) != 104){
    Serial.println("\n\nMPU connection failed");
    while(true){
      delay(500);
      digitalWrite(statusLED, !digitalRead(statusLED));
    }
  } else {
    Serial.print("\n\nWhoAmI: ");
    Serial.println(regRead(MPU, 0x75));
  }
  Serial.println(regRead(MPU, 0x75), BIN);
  Serial.print("PWR_MGMT1: ");
  Serial.println(regRead(MPU, PWR_MGMT1), BIN);
  Serial.print("ACC_CONF: ");
  Serial.println(regRead(MPU, ACC_CONF), HEX);
  Serial.print("GYR_CONF: ");
  Serial.println(regRead(MPU, GYR_CONF), HEX);
  Serial.println("\n");
  


  if (!SD.begin(chipSelect)) {
    digitalWrite(statusLED, HIGH);
    Serial.println("SD initialization failed.");
    while (true);
  }
  Serial.println("SD initialization successful.");

  myFile = SD.open("datadump.txt", FILE_WRITE);
  if(myFile){
    myFile.print("\n\nNew Data Dump\n\n");
    myFile.println("PWR_MGM\tACC_CONF\tGYR_CONF\tSAM_RATE");
    myFile.print(regRead(MPU, PWR_MGMT1));
    myFile.print("\t");
    myFile.print(regRead(MPU, ACC_CONF));
    myFile.print("\t");
    myFile.print(regRead(MPU, GYR_CONF));
    myFile.print("\t");
    myFile.println(delayAmount);
    myFile.println("TEMP\tACCX\tACCY\tACCZ\tGYRX\tGYRY\tGYRZ");
    myFile.close();
  } else {
    Serial.println("error opening test.txt");
    while(true);
  }



}

void loop() {
// reading temperature
//  int16_t rawTemp = (regRead(MPU, TEMP_H) << 8) | regRead(MPU, TEMP_L);
  int16_t rawTemp = readRaw(MPU, TEMP_H);
  float temperature = (rawTemp / 340.0) + 36.53;

// reading acceleration
  int16_t rawAccX = readRaw(MPU, ACC_X_H);
  int16_t rawAccY = readRaw(MPU, ACC_Y_H);
  int16_t rawAccZ = readRaw(MPU, ACC_Z_H);
  
  float accX = rawAccX / 16384.0 * g;
  float accY = rawAccY / 16384.0 * g;
  float accZ = rawAccZ / 16384.0 * g;

// reading gyroscopes
  int16_t rawGyrX = readRaw(MPU, GYR_X_H);
  int16_t rawGyrY = readRaw(MPU, GYR_Y_H);
  int16_t rawGyrZ = readRaw(MPU, GYR_Z_H);

  float gyrX = rawGyrX/32.768;
  float gyrY = rawGyrY/32.768;
  float gyrZ = rawGyrZ/32.768;



  myFile = SD.open("datadump.txt", FILE_WRITE);
  if(myFile){
    myFile.print(rawTemp);
    myFile.print("\t");
    myFile.print(rawAccX);
    myFile.print("\t");
    myFile.print(rawAccY);
    myFile.print("\t");
    myFile.print(rawAccZ);
    myFile.print("\t");
    myFile.print(rawGyrX);
    myFile.print("\t");
    myFile.print(rawGyrY);
    myFile.print("\t");
    myFile.println(rawGyrZ);
    myFile.close();
  } else {
    Serial.println("error opening test.txt");
    while(true);
  }




// printing whichever is requested
  switch(printing){
    case 0:
      Serial.println(temperature);
      break;
    case 1:
      Serial.println(accX);
      break;
    case 2:
      Serial.println(accY);
      break;
    case 3:
      Serial.println(accZ);
      break;
    case 4:
      Serial.println(gyrX);
      break;
    case 5:
      Serial.println(gyrY);
      break;
    case 6:
      Serial.println(gyrZ);
      break;
  }



// Serial communication
  int incoming;
  if( Serial.available()>0 ) {
    //Serial.print("WE RECEIVING STUFF BOIIIIIIIIIIIIIIIIIIIIIIIIII");
    incoming = Serial.read() - 48;
    //Serial.println(incoming);
  }
  if(incoming >= 0 && incoming <= 6){
    Serial.print("Printing mode switch from ");
    Serial.print(printing);
    Serial.print(" to ");
    Serial.println(incoming);
    printing = incoming;
  }

  if(incoming == 7 || incoming == 8){
    if(incoming == 7) delayAmount /= 2;
    if(incoming == 8) delayAmount *= 2;


    if(delayAmount <= 1 || delayAmount >= 30000) delayAmount *= 2;
    Serial.print("Reading interval is now ");
    if(delayAmount <1000){
      Serial.print(delayAmount);
      Serial.println(" ms");
    } else {
      Serial.print(delayAmount/1000);
      Serial.println(" s");
    }

    myFile = SD.open("datadump.txt", FILE_WRITE);
    if(myFile){
      myFile.print("Conf Change");
      myFile.print(regRead(MPU, PWR_MGMT1));
      myFile.print("\t");
      myFile.print(regRead(MPU, ACC_CONF));
      myFile.print("\t");
      myFile.print(regRead(MPU, GYR_CONF));
      myFile.print("\t");
      myFile.println(delayAmount);
      myFile.close();
    } else {
      Serial.println("error opening test.txt");
      while(true);
    }


  }

/*
  if(incoming == 72-48 || incoming == 104-48){
    Serial.println("\n\nThis device provides a communication channel through the Serial Port to an MPU6050 gyroscope and accelerometer.\nIt can be used to read data from the device, there are 7 reporting mode, each providing a different data, in order:\n - temperature in Celsius\n - acceleration on the X, Y and Z axis of the device\n - gyroscope measurement on the X, Y and Z axis\n each mode is accessible sending a specific number ( 0 to 6) in this communication channel.\nSending 7 and 8 it is possible to modify the Sampling Rate of the device, and 9 is used to turn on and off the data Saave feature on the SD card(WORK IN PROGRES)\n\n");
  }  
*/

  digitalWrite(statusLED, !digitalRead(statusLED));
  delay(delayAmount); // Wait .1 second before reading again
}
















int16_t readRaw(byte deviceAddress, byte firstRegisterAddress){
  // reads two registers in a row and combines the contents in a single signed int variable
  int16_t data = (regRead(deviceAddress, firstRegisterAddress) << 8) | regRead(deviceAddress, firstRegisterAddress+1);
  return data;
}


void regWrite(byte deviceAddress, byte registerAddress, byte dataToWrite){
  Wire.beginTransmission(deviceAddress);
  Wire.write(registerAddress);
  Wire.write(dataToWrite);
  Wire.endTransmission();
  return;
}


int regRead(byte deviceAddress, byte registerAddress){
  int data;
  Wire.beginTransmission(deviceAddress);
  Wire.write(registerAddress);
  Wire.endTransmission(false);
  delay(2);
  Wire.requestFrom(deviceAddress, 1);
  while (Wire.available()) {
      data = Wire.read();
      //Serial.println(data);
      // Process data
  }
  return data;
}