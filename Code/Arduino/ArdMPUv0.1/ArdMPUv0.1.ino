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
  
/*
  Wire.beginTransmission(MPU);
  byte commanda[2] = {PWR_MGMT1, 0x00};
  Wire.write(commanda, 3);
  Wire.write(PWR_MGMT1);
  Wire.write(0x00);
  byte commandb[2] = {ACCEL_CONF, 0x00};
  Wire.write(commandb, 2);
  byte commandc[2] = {GYRO_CONF, 0x08};
  Wire.write(commandc, 2);

  Wire.endTransmission();
*/

  Wire.beginTransmission(MPU);
  Wire.write(0x75);
  Wire.endTransmission();

  Wire.requestFrom(MPU, 1);

  while(Wire.available()) {
    byte c = Wire.read();    // Receive a byte as character
    Serial.println(c);         // Print the character
  }

  Serial.println("We did out best bois");


}

int counter = 0;
void loop() {
/*
  delay(100);
  counter++;

  Wire.beginTransmission(MPU);
  Wire.write(TEMP_OUT_H);
  int th = Wire.read();
  Wire.write(TEMP_OUT_L);
  int tl = Wire.read();
  Wire.endTransmission();

  float tt = (th *256 ) + tl;

  tt /= 340;
  tt += 36.53;
  Serial.println("------------------");
  Serial.println(counter);
  Serial.println(tt);
  // put your main code here, to run repeatedly:
*/
}
