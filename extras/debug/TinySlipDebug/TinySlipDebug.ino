#include <TinySlip.h>

#define BUFFER_MAX_SIZE 256
unsigned char inputBuffer[BUFFER_MAX_SIZE];

#define BUFFER_MAX_SIZE 256
unsigned char outputBuffer[BUFFER_MAX_SIZE];

TinySlip slip;

void setup() {
  Serial.begin(57600);
  
}

void loop() {
  int packetLength = slip.parsePacket( &Serial, inputBuffer, BUFFER_MAX_SIZE);
  
  if ( packetLength > 0 ) {

    // USE THE SAME BUFFER TO ECHO
    slip.streamPacket( &Serial, inputBuffer, packetLength);
    
     //ASCII ECHO FOR TESTING
     /*
    for ( int i=0; i < packetLength; i++) {
      Serial.print(i);
      Serial.print(" : ");
      
      Serial.println((byte)inputBuffer[i]);
    }
    */
  }

}
