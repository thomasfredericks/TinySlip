import processing.serial.*;


/*
*  ___ __  __ ___  ___  ___ _____ _   _  _ _____
* |_ _|  \/  | _ \/ _ \| _ \_   _/_\ | \| |_   _|
*  | || |\/| |  _/ (_) |   / | |/ _ \| .` | | |
* |___|_|  |_|_|  \___/|_|_\ |_/_/ \_\_|\_| |_|
*
*Lorsque vous demarrez ce code, les noms de tous les ports series
*sont affichés dans les messages de debogage de la fenetre Processing.
*Vous devez changer la valeur de la variable "portName"
*pour qu'elle corresponde au nom du port serie de l'Arduino.
*/

// Choisir le port serie.
String portName = "COM4";

// Declarer une instance de la classe Serial:
Serial serial;

TinySlip slip = new TinySlip();

int inputBuffer[] = new int[256];
int outputBuffer[] = new int[256];

void setup() {
        size(256, 256);
        
          println(Serial.list()); // Affiche les noms des ports.

        // Creer une instance de la classe Serial avec
        // un baud de 57600 et le port choisi.
        serial = new Serial(this, portName, 57600);

}

void draw() {
  
  int packetLength = 0;
  
  while ( ( packetLength = slip.parsePacket( serial , inputBuffer) ) > 0 ) {
    println("Received a SLIP packet with the following contents @"+millis()+"ms:");
    for (int i =0; i < packetLength; i++) {
      print(inputBuffer[i]+" ");
    }
    println();
  }

}

void mousePressed() {
  
  
    outputBuffer[0] = (int)random(256);
    outputBuffer[1] = (int)random(256);
    outputBuffer[2] = (int)random(256);
    outputBuffer[3] = (int)random(256);
    outputBuffer[4] = (int)random(256);
    slip.streamPacket(serial, outputBuffer, 5);
    
    println("Sending the following SLIP packet @"+millis()+"ms:");
    for (int i =0; i < 5; i++) {
      print(outputBuffer[i]+" ");
    }
    println();
    
  
}
