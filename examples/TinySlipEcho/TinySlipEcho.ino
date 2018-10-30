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

  // IF WE RECEIVED A PACKET
  if ( packetLength > 0 ) {


    // FOR DEMONSTRATION PURPOSES,
    // COPY THE INPUT BUFFER TO THE OUTPUT BUFFER
    // AND THEN SEND IT BACK
    for ( int i=0; i < packetLength; i++) {
      outputBuffer[i] = inputBuffer[i];
    }
    slip.streamPacket(&Serial, outputBuffer, packetLength);
    


  }

}
