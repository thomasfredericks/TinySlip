
#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram."
#endif

// Internal-> SLIP reserved codes->
// 192, 219, 220, 221
#define SLIP_END     0xC0
#define SLIP_ESC     0xDB
#define SLIP_ESC_END 0xDC
#define SLIP_ESC_ESC 0xDD



class TinySlip {

 private:
	
	size_t length =0;
	size_t parseIndex=0;
	bool error = false;
	bool escaping =false;
    Stream* stream;
	unsigned char* buffer;
	size_t bufferSize;

	public:

	TinySlip(Stream* stream) {
		this->stream = stream;
		this->buffer = buffer;
		this->bufferSize = bufferSize;

	}

	// THIS COULD BE OPTIMISED
	size_t  parsePacket(unsigned char *buffer, size_t bufferSize) {
			 while ( stream->available()>0 ) {
		      int streamByte = stream->read();

		
		      // END OF MESSAGE, RETURN NUMBER OF BYTES
		      if ( streamByte == SLIP_END ) {

		        length = parseIndex;
		        parseIndex = 0;
		        error = false;

		        return length;
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
		        if ( parseIndex >= bufferSize ) {
		        parseIndex =0;
		          error = true;
		        }
		      }
		    }

    return 0;

				/*
			while ( stream->available() ) {
				int streamByte = stream->read();
				
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
				}

				

			}

			
		}
		return 0;
		*/
		}

	void write(unsigned char  value) {
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

	void beginPacket() {
		stream->write(SLIP_END);
	}
    
    void endPacket() {
    	stream->write(SLIP_END);
    }


	void write (unsigned char *outputBuffer, size_t outputBufferLength) {
			while (outputBufferLength--) {
				unsigned char value = *outputBuffer++;
				write(value);
			}

	}


};