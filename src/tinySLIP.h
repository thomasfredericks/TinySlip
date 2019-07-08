
#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif

#include "UDP.h"

// Internal. SLIP reserved codes.
// 192, 219, 220, 221
#define SLIP_END     0xC0
#define SLIP_ESC     0xDB
#define SLIP_ESC_END 0xDC
#define SLIP_ESC_ESC 0xDD

#ifndef TINYSLIP_BUFFER_SIZE 
#define TINYSLIP_BUFFER_SIZE 512
#endif

class TinySlip : UDP {

 private:
	
	size_t length =0;
	size_t parseIndex=0;
	bool error = false;
	bool escaping =false;
    Stream* serial;
    unsigned char buffer[TINYSLIP_BUFFER_SIZE];
	
	public:
      TinySlip( Stream* serial ) {
      	this->serial = serial;
      }
		

		size_t available() {
			return length;
		}

		// THIS COULD BE OPTIMISED
		bool parseStream( ) {


		    while ( serial->available()>0 ) {
		      int streamByte = serial->read();

		
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
		        parseIndex =0;
		          error = true;
		        }
		      }
		    }

    return false;

				
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


};