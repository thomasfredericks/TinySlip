// CHECK https://github.com/thomasfredericks/OSC-logger


import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
ScrollableList serialDropDownList;
ScrollableList baudDropDownList;
Toggle openSerialToggle;

Serial serial = null;

String portName;
String[] portList;
int[] baudList = {9600, 57600, 115200};
int baudRate = -1;


void setup() {
  // clear();
  size(400, 200 );
  cp5 = new ControlP5(this);

  //PFont pfont = createFont("Arial",10,true); //Create a font
  //ControlFont font = new ControlFont(pfont,20); //font, font-size

  serialDropDownList = cp5.addScrollableList("serialddlist")
    .setPosition(5, 5)
    .setSize(390, 50)
    .setType(ControlP5.LIST)
    ;

  populateSerialList();

  baudDropDownList = cp5.addScrollableList("baudddlist")
    .setPosition(5, 60)
    .setSize(100, 50)
    .setType(ControlP5.LIST)
    ;
  baudDropDownList.getCaptionLabel().set("SERIAL BAUD");
  for ( int i=0; i < baudList.length; i++ ) {
    baudDropDownList.addItem(baudList[i]+"", 0);
  }
  //baudDropDownList.close();

  // create a toggle
  openSerialToggle = cp5.addToggle("openserialtoggle")
    .setPosition(115, 60)
    .setSize(50, 20)
    ;
  openSerialToggle.getCaptionLabel().set("OPEN SERIAL");


  //portName = Serial.list()[0]; //0 as default
  //serial = new Serial(this, portName, 9600);
}

void draw() {
  background(128);
}



void controlEvent(ControlEvent theEvent) { //when something in the list is selected

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } else if (theEvent.isController()) {
    //println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    String controllerName = theEvent.getController().getName();
    if ( controllerName == "serialddlist" ) {
      int v = (int) theEvent.getController().getValue() ;
      portName = portList[v];
    } else if ( controllerName == "baudddlist" ) {
      int v = (int) theEvent.getController().getValue() ;
      baudRate = baudList[v];
    } else if ( controllerName == "openserialtoggle" ) {
      int v = (int) theEvent.getController().getValue() ;
      if ( v > 0 ) openSerial();
      else closeSerial();
    }
    //println(theEvent.getController().getName() == "openserialtoggle");
  }


  /*
    serial.clear(); //delete the port
   serial.stop(); //stop the port
   if (theEvent.isController() && d1.isMouseOver()) {
   portName = Serial.list()[int(theEvent.getController().getValue())]; //port name is set to the selected port in the dropDownMeny
   serial = new Serial(this, portName, 9600); //Create a new connection
   println("Serial index set to: " + theEvent.getController().getValue());
   delay(2000); 
   }
   */
}


void populateSerialList() {
  portList = Serial.list();
  serialDropDownList.clear();

  for (int i=0; i<portList.length; i++) {
    serialDropDownList.addItem(portList[i], i); //add the items in the list
  }

  /*
   for (int i=0; i<10; i++) {
   serialDropDownList.addItem("COM"+i, i); //add the items in the list
   }
   */
  serialDropDownList.getCaptionLabel().set("SERIAL PORT"); //set PORT before anything is selected
  //serialDropDownList.close();
}

void openSerial() {

  closeSerial();

  if ( portName != null && baudRate > -1 ) {
    try {
     serial = new Serial(this, portName, baudRate); //Create a new connection
    }
    catch(Exception e) {
      //println("Port busy or not available");
      openSerialToggle.setValue(false);
       serial = null;
    }

    
  }

  println(serial);
}

void closeSerial() {
  if ( serial != null ) {
    serial.clear(); //delete the port
    serial.stop(); //stop the port
    serial = null;
  }
   
}
