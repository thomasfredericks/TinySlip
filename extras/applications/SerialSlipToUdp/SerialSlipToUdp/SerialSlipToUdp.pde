import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
ScrollableList serialDropDownList;
ScrollableList baudDropDownList;
Toggle openSerialToggle;

Serial serial;

String portName;
int serialListIndex;

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
  baudDropDownList.addItem("9600",0);
  baudDropDownList.addItem("57600",1);
  baudDropDownList.addItem("115200",2);
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
  } 
  else if (theEvent.isController()) {
    //println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    String controllerName = theEvent.getController().getName();
    if ( controllerName == "serialddlist" ) {
      println( theEvent.getController().getValue() );
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
  String[] serialPortList = Serial.list();
  serialDropDownList.clear();
  /*
  for (int i=0; i<serialPortList.length; i++) {
    serialDropDownList.addItem(serialPortList[i], i); //add the items in the list
  }
  */
   for (int i=0; i<10; i++) {
    serialDropDownList.addItem("COM"+i, i); //add the items in the list
  }
  
  serialDropDownList.getCaptionLabel().set("SERIAL PORT"); //set PORT before anything is selected
  //serialDropDownList.close();
}
