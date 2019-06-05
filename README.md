# TinySlip

TinyOSC is a minimal SLIP library for Arduino. The typical use case is to parse a raw buffer received directly from a stream. 

## Code Examples

### Initialisation 


```C
// INSTANTIATE A TinySlip INSTANCE LINKED TO Serial
TinySlip slip( &Serial );
```

### Receiving SLIP Data

First we define an array to receive the data:
```C
#define BUFFER_MAX_SIZE 256
unsigned char inputBuffer[BUFFER_MAX_SIZE];
```

Then in loop we can process received messages:
```C
void loop() {
// SEE IF A PACKET WAS PARSED
    int packetLength = slip.parsePacket(inputBuffer, BUFFER_MAX_SIZE);

      // IF WE RECEIVED A PACKET, packetLength WILL BE BIGGER THAN 0
  if ( packetLength > 0 ) {
     
     // THE RECEIVED DATA WILL HAVE BEEN COPIED TO inputBuffer
  	 // THE LENGTH OF THE DATA WILL BE EQUAL TO packetLength
    
  }
}
```

### Sending SLIP Data

### Sending data one by one

```C
// START THE PACKET
slip.beginPacket();
// WRITE THE THREE BYTES
slip.write(34);
slip.write(67);
slip.write(156);
// END THE PACKET
slip.endPacket();
```

#### Sending an array

First we define an output buffer of size 3:
```C
unsigned char outputBuffer[3];
```

Then we add some data to the buffer and send it out:
```C
// ADDING THREE BYTES
outputBuffer[0] = 34;
outputBuffer[1] = 67;
outputBuffer[2] = 156;

// START THE PACKET
slip.beginPacket();
// WRITE THE THREE BYTES
slip.write(outputBuffer, 3);
// END THE PACKET
slip.endPacket();
```
