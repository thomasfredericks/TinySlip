#include <TinySlip.h>

#define BUFFER_MAX_SIZE 256
unsigned char parsedSlipBuffer[BUFFER_MAX_SIZE];


TinySlip slip( &Serial );

void setup() {
  Serial.begin(57600);

}

void loop() {

  int packetLength = slip.parsePacket(parsedSlipBuffer, BUFFER_MAX_SIZE);

  // IF WE RECEIVED A PACKET
  if ( packetLength > 0 ) {

    slip.beginPacket();
    
    slip.write(parsedSlipBuffer , packetLength);

    slip.endPacket();
  }

}
