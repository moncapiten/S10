#include <Wire.h>

#define MPU 0x68
#define dis 0x3c

#define PWR_MGMT1 0x6B
#define ACCEL_CONF 0x1C
#define GYRO_CONF 0x1B

#define TEMP_OUT_H 0x41
#define TEMP_OUT_L 0x42



void setup() {
  Wire.begin();
  Serial.begin(9600);

  regWrite(MPU, PWR_MGMT1, 0x00);
  delay(1000);
//  regWrite(MPU, ACCEL_CONF, 0x00);
//  regWrite(MPU, GYRO_CONF, 0x08);

//  byte data = regRead(MPU, 0x75, 1);

  Serial.print("WhoAmI: ");
  Serial.println(regRead(MPU, 0x75, 1), BIN);
  Serial.print("PWR_MGMT1: ");
  Serial.println(regRead(MPU, PWR_MGMT1, 1), BIN);
  Serial.print("TEMP_OUT_H: ");
  Serial.println(regRead(MPU, TEMP_OUT_H, 1), HEX);
  Serial.print("TEMP_OUT_L: ");
  Serial.println(regRead(MPU, TEMP_OUT_L, 1), HEX);
  
}

void loop() {
  int16_t rawTemp = (regRead(MPU, TEMP_OUT_H) << 8) | regRead(MPU, TEMP_OUT_L);
  float temperature = (rawTemp / 340.0) + 36.53;

//  Serial.print("Temperature (°C): ");
  Serial.println(temperature);

  delay(100); // Wait 1 second before reading again
}


void regWrite(byte deviceAddress, byte registerAddress, byte dataToWrite){
  Wire.beginTransmission(deviceAddress);
  Wire.write(registerAddress);
  Wire.write(dataToWrite);
  Wire.endTransmission();
  return;
}

int regRead(byte deviceAddress, byte registerAddress, int numBytes){
  int data;
  Wire.beginTransmission(deviceAddress);
  Wire.write(registerAddress);
  Wire.endTransmission(false);
  delay(2);
  Wire.requestFrom(deviceAddress, numBytes);
  while (Wire.available()) {
      data = Wire.read();
      //Serial.println(data);
      // Process data
  }
  return data;
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