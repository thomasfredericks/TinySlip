# TinySlip

TinyOSC is a minimal SLIP library for Arduino. The typical use case is to parse a raw buffer received directly from a stream. 

## Code Examples

```C
// Create a TinySlip instance
TinySlip slip;
```

### Receiving SLIP Data

First we define an input buffer:
```C
#define BUFFER_MAX_SIZE 256
unsigned char inputBuffer[BUFFER_MAX_SIZE];
```

Then in loop we can process received messages:
```C
void loop() {
// IF WE RECEIVED A PACKET
  while ( slip.parseStream( &Serial, inputBuffer, BUFFER_MAX_SIZE) ) {

    int packetLength = slip.available();

    // DO SOMETHING WITH THE DATA IN THE inputBuffer OF LENGTH packetLength
    
  }
}
```

### Sending SLIP Data

First we define an output buffer:
```C
#define BUFFER_MAX_SIZE 256
unsigned char outputBuffer[BUFFER_MAX_SIZE];
```

Then we but some data in the buffer and send it out:
```C
// ADDING THREE BYTES
outputBuffer[0] = 34;
outputBuffer[1] = 67;
outputBuffer[2] = 156;

// STREAM THE THREE BYTES
    slip.streamPacket(&Serial, outputBuffer, 3);
```
