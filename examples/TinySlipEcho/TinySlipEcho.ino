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
  

  // IF WE RECEIVED A PACKET
  while ( slip.parseStream( &Serial, inputBuffer, BUFFER_MAX_SIZE) ) {

    int packetLength = slip.available();

    // FOR DEMONSTRATION PURPOSES,
    // COPY THE INPUT BUFFER TO THE OUTPUT BUFFER
    // AND THEN SEND IT BACK
    for ( int i=0; i < packetLength; i++) {
      outputBuffer[i] = inputBuffer[i];
    }
    slip.streamPacket(&Serial, outputBuffer, packetLength);
    
  }

}
