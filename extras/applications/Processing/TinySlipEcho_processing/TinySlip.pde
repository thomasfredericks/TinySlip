
class TinySlip {

  // Internal. SLIP reserved codes.
  // 192, 219, 220, 221
  final int SLIP_END  =   192;
  final int SLIP_ESC   =   219;
  final int SLIP_ESC_END =  220;
  final int SLIP_ESC_ESC =  221;

  private boolean escaping;
  private boolean error;

  private int parseIndex;
  private int length;

  TinySlip() {
    error=false;
    escaping= false;
    parseIndex= 0;
  };

  public int available() {
    return length;
  }

  public boolean parseStream( Serial serial, int[] buffer) {

    int maxLength = buffer.length;

    while ( serial.available()>0 ) {
      int streamByte = serial.read();

      //print(streamByte+"/"+parseIndex+" ");


      // END OF MESSAGE, RETURN NUMBER OF BYTES
      if ( streamByte == SLIP_END ) {

        length = parseIndex;
        parseIndex = 0;
        error = false;

        return length>0;
        // MESSAGE DATA
      } else if ( error == false ) {
        // ESCAPING
        if ( escaping ) {
          switch (streamByte) {
          case SLIP_ESC_END:
            buffer[parseIndex++]=SLIP_END;
            break;
          case SLIP_ESC_ESC:
            buffer[parseIndex++]=(SLIP_ESC);
            break;
          }
          escaping = false;
        } else {
          // NON ESCAPING
          if ( streamByte == SLIP_ESC ) {
            escaping = true;
          } else {
            buffer[parseIndex++]=(streamByte);
          }
        }
        // ERROR
        if ( parseIndex >= maxLength ) {
          error = true;
          parseIndex =0;
        }
      }
    }

    return false;
  }


  public void streamPacket (Serial stream, int[] buffer, int dataLength) {

    stream.write(SLIP_END);
    //print(SLIP_END);print(" ");

    for (int i =0; i < dataLength; i++) {
      int value = buffer[i];
      switch (value) {
      case SLIP_END:
        stream.write(SLIP_ESC);
        // print(SLIP_ESC);print(" ");
        stream.write(SLIP_ESC_END);
        //print(SLIP_ESC_END);print(" ");
        break;
      case SLIP_ESC:
        stream.write(SLIP_ESC);
        //print(SLIP_ESC);print(" ");
        stream.write(SLIP_ESC_ESC);
        //print(SLIP_ESC_ESC);print(" ");
        break;
      default:
        stream.write(value);
        //print(value);print(" ");
      }
    }
    println();


    stream.write(SLIP_END);
    //print(SLIP_END);
    //print(" ");
  }
}
