
class TinySlip {

  // Internal. SLIP reserved codes.
  // 192, 219, 220, 221
  final int SLIP_END  =   192;
  final int SLIP_ESC   =   219;
  final int SLIP_ESC_END =  220;
  final int SLIP_ESC_ESC =  221;

  final int TINY_PARSE_WAITING = 0;
  final int TINY_PARSE_BUILDING = 1;
  final int TINY_PARSE_ESCAPING = 2;

  private int parseStatus;
  private int parseIndex;
  private int length;

  TinySlip() {
    parseStatus = TINY_PARSE_WAITING;
    parseIndex= 0;
  };
  
  public int available() {
    return length;
  }

  public boolean parseStream( Serial serial, int[] buffer) {

    int maxLength = buffer.length;

    while ( serial.available()>0 ) {
      int streamByte = serial.read();

      // WAITING
      if ( parseStatus == TINY_PARSE_WAITING ) {
        // ONLY START PACKING ONCE WE GET A START/END MARKER
        if ( streamByte == SLIP_END ) {
          parseStatus = TINY_PARSE_BUILDING;
          length = parseIndex = 0;
        }
        // BUILDING OR ESCAPING
      } else {
        // END OF MESSAGE, RETURN NUMBER OF BYTES
        if ( streamByte == SLIP_END ) {
          parseStatus = TINY_PARSE_WAITING;

          length = parseIndex;
          
          return length>0;
          // MESSAGE DATA
        } else {
          // ESCAPING
          if ( parseStatus == TINY_PARSE_ESCAPING  ) {
            switch (streamByte) {
            case SLIP_ESC_END:
              buffer[parseIndex++]=SLIP_END;
              break;
            case SLIP_ESC_ESC:
              buffer[parseIndex++]=(SLIP_ESC);
              break;
            }
            parseStatus = TINY_PARSE_BUILDING;
          } else {
            // NON ESCAPING
            if ( streamByte == SLIP_ESC ) {
              parseStatus = TINY_PARSE_ESCAPING;
            } else {
              buffer[parseIndex++]=(streamByte);
            }
          }
        }

        // ERROR
        if ( parseIndex >= maxLength ) {
          parseStatus = TINY_PARSE_WAITING;

        }
      }
    }
    return false;
  }


  public void streamPacket (Serial stream, int[] buffer, int dataLength) {
    stream.write(SLIP_END);

    for (int i =0; i < dataLength; i++) {
      int value = buffer[i];
      switch (value) {
      case SLIP_END:
        stream.write(SLIP_ESC);
        stream.write(SLIP_ESC_END);
        break;
      case SLIP_ESC:
        stream.write(SLIP_ESC);
        stream.write(SLIP_ESC_ESC);
        break;
      default:
        stream.write(value);
      }
    }



    stream.write(SLIP_END);
  }
}

/*
// Internal. SLIP reserved codes.
 // 192, 219, 220, 221
 #define SLIP_END     0xC0
 #define SLIP_ESC     0xDB
 #define SLIP_ESC_END 0xDC
 #define SLIP_ESC_ESC 0xDD
 
 #define TINY_PARSE_WAITING 0
 #define TINY_PARSE_BUILDING 1
 #define TINY_PARSE_ESCAPING 2
 #define TINY_PARSE_ERROR -1
 
 #define tinystore(x) (buffer[parseIndex++]=(x))
 
 class TinySlip {
 
 private:
 int parseStatus = 0;
 size_t parseIndex=0;
 
 
 public:
 
 // THIS COULD BE OPTIMISED
 int parsePacket( Stream* stream, unsigned char *buffer, size_t maxLength) {
 
 while ( stream->available() ) {
 int streamByte = stream->read();
 
 // WAITING
 if ( parseStatus == TINY_PARSE_WAITING ) {
 // ONLY START PACKING ONCE WE GET A START/END MARKER
 if ( streamByte == SLIP_END ) {
 parseStatus = TINY_PARSE_BUILDING;
 }
 // BUILDING OR ESCAPING
 } else {
 // END OF MESSAGE, RETURN NUMBER OF BYTES
 if ( streamByte == SLIP_END ) {
 parseStatus = TINY_PARSE_WAITING;
 
 int length = parseIndex;
 parseIndex = 0;
 return length;
 // MESSAGE DATA
 } else {
 // ESCAPING
 if ( parseStatus == TINY_PARSE_ESCAPING  ) {
 switch (streamByte) {
 case SLIP_ESC_END:
 tinystore(SLIP_END);
 break;
 case SLIP_ESC_ESC:
 tinystore(SLIP_ESC);
 break;
 }
 parseStatus = TINY_PARSE_BUILDING;
 } else {
 // NON ESCAPING
 if ( streamByte == SLIP_ESC ) {
 parseStatus = TINY_PARSE_ESCAPING;
 } else {
 tinystore(streamByte);
 }
 }
 }
 
 // ERROR
 if ( parseIndex >= maxLength ) {
 parseStatus = TINY_PARSE_WAITING;
 return TINY_PARSE_ERROR;
 }
 
 
 
 }
 
 
 }
 return 0;
 }
 
 void streamPacket (Stream* stream, unsigned char *buffer, size_t length) {
 stream->write(SLIP_END);
 
 while (length--)
 
 {
 unsigned char value = *buffer++;
 switch (value)
 {
 case SLIP_END:
 stream->write(SLIP_ESC);
 stream->write(SLIP_ESC_END);
 break;
 case SLIP_ESC:
 stream->write(SLIP_ESC);
 stream->write(SLIP_ESC_ESC);
 break;
 default:
 stream->write(value);
 }
 }
 
 stream->write(SLIP_END);
 }
 
 
 };*/
