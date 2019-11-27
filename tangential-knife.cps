/**
  Copyright (C) 2012-2013 by Autodesk, Inc.
  All rights reserved.

  Generic 2D post processor configuration.

  $Revision: 42473 905303e8374380273c82d214b32b7e80091ba92e $
  $Date: 2019-09-04 07:46:02 $
  
  FORKID {F2FA3EAF-E822-4778-A478-1370D795992E}
*/

description = "Tangential knife";
vendor = "Jejmule";
vendorUrl = "jejmule@gmail.com";
legal = "Copyright (C) 2012-2013 by Autodesk, Inc.";
certificationLevel = 2;

longDescription = "Tangemtial knife support based on the Autodesk generic ISO milling post for 2D.";

extension = "nc";
setCodePage("ascii");

capabilities = CAPABILITY_JET;
tolerance = spatial(0.002, MM);
minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = false;
allowedCircularPlanes = 1 << PLANE_XY;

// user-defined properties
properties = {
  useFeed: true, // enable to use F output
  hasZAxis: false, //is the machine has a Z motorized axis
  liftAtCorener: 5, //if the angle between two move is larger than 5° the knife is lift up, rotate
  hasVacuum: true, //turn on/off the vacuum pump
  vacuumOn: 'M54 P1', //Gcode to swicth on the vacuum pump
  vacuumOff: 'M55 P1', //Gcode to swicth off the vacuum pump
  tool2Offset: 0 //offset on second head
};

// user-defined property definitions
propertyDefinitions = {
  useFeed: {title:"Use feed", description:"Enable to use F output.", type:"boolean"},
  hasZAxis: {title:"Z axis", description:"Is the machine equipped with a Z motorized axis.", type:"boolean"},
  liftAtCorener:{title:"Lift at corner", description:"maximum angle at wich the knife is turned in the material, if the angle is larger the knife is lifted and rotated", type:"integer"},
  hasVacuum: {title:"Vacuum table", description:"Is the machine equipped with a vacuum table", type:"boolean"},
  vacuumOn: {title:"Vacuum on code", description:"code to swicth on the vaccum",type:"String"},
  vacuumOff: {title:"Vacuum off code", description:"code to swicth off the vaccum",type:"String"},
  tool2Offset: {title:"C offset on tool 2", description:"offset in degree on spindle 2",type:"Float"}
};

var WARNING_WORK_OFFSET = 0;
var WARNING_COOLANT = 1;

var gFormat = createFormat({prefix:"G", decimals:0, width:2, zeropad:true});
var mFormat = createFormat({prefix:"M", decimals:0});
var pFormat = createFormat({prefix:"P", decimals:1});

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var abcFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG});
var feedFormat = createFormat({decimals:(unit == MM ? 2 : 3)});

var xOutput = createVariable({prefix:"X"}, xyzFormat);
var yOutput = createVariable({prefix:"Y"}, xyzFormat);
if(properties.hasZAxis) {
  var zOutput = createVariable({prefix:"Z"}, xyzFormat);
}
var cOutput = createVariable({prefix:"C"}, abcFormat);
var iOutput = createReferenceVariable({prefix:"I"}, xyzFormat);
var jOutput = createReferenceVariable({prefix:"J"}, xyzFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91

var sequenceNumber = 0;

//specific section for tangential knife
var c_rad = 0;  // Current C axis position
var liftAtCorner_rad = toRad(properties.liftAtCorener);

/**
 Update C position for tangenmtial knife
 */
 function updateC(target_rad) {
  //check if we should rotate the head
  var delta_rad = (target_rad-c_rad) % (2*Math.PI)
  if (Math.abs(delta_rad) > liftAtCorner_rad) { //angle between segments is larger than max_angle : lift the knife, rotate and plunge back in material
    moveUp()
    gMotionModal.reset()
    writeBlock(gMotionModal.format(0), cOutput.format(target_rad));
    moveDown()
  }
  else if (delta_rad == 0){ //next segment is colinear with current segment : do nothing
  }
  else {  //angle between segments is smaller than max_angle : rotate knife in material
    writeBlock(gMotionModal.format(1), cOutput.format(target_rad));
  }
  c_rad = target_rad
 }

 function moveUp() {
   start = getCurrentPosition();
   param = "operation:clearanceHeight_value"
   if(properties.hasZAxis && hasParameter(param)){
     onRapid(start.x,start.y,getParameter(param))
   }
   else {
     onPower(false); //use on power to lift the knife
   }
 }

 function moveDown() {
  start = getCurrentPosition();
   if(properties.hasZAxis){
    onRapid(start.x,start.y,start.z)
   }
   else {
     onPower(true); //use on power to plunge with the knife
   }
 }

/**
  Writes the specified block.
*/
function writeBlock() {
  writeWords2("N" + sequenceNumber, arguments);
  sequenceNumber += 1;
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln("(" + text + ")");
}

/**
function writeCommentOnLine(text){
  write("(" + text + ")");
}*/

function onOpen() {
  if (!properties.useFeed) {
    feedOutput.disable();
  }
  
  if (programName) {
    writeComment(programName);
  }
  if (programComment) {
    writeComment(programComment);
  }

  writeBlock(gAbsIncModal.format(90));

  if (properties.hasVacuum){
    writeComment('Switch on vacuum table');
    writeBlock(properties.vacuumOn);
  }

  /** 
  var cAxis = createAxis({coordinate:Z, table:false, axis:[0, 0, 1], cyclic:true}); 
  machineConfiguration = new MachineConfiguration(cAxis);
  setMachineConfiguration(machineConfiguration);*/
}

function onComment(message) {
  writeComment(message);
}

function angleToMachine(angle) {
  var twopi = 2*Math.PI;
  if (angle<0) {
    angle = (angle + Math.PI) % twopi - Math.PI;
  }
  return angle;
}

function onSection() {

  if (!isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
    error(localize("Tool orientation is not supported."));
    return;
  }
  setRotation(currentSection.workPlane);

  if (currentSection.workOffset != 0) {
    warningOnce(localize("Work offset is not supported."), WARNING_WORK_OFFSET);
  }
  if (tool.coolant != COOLANT_OFF) {
    warningOnce(localize("Coolant not supported."), WARNING_COOLANT);
  }
  //select the right spindle
  //on my machine there are 4 spindles, selected by M90-91-92-93-94 G code
  var command;
  switch(tool.number) {
    case(1):
      command = 91;
      break;
    case(2):
      command = 92;
      break;
    case(3):
      command = 95;
      break;1
    case (4):
      command = 97;
      break;
    default :
      command = 90;
      break
  }
  writeComment('Select spindle #'+tool.number)
  writeBlock(mFormat.format(command))
  feedOutput.reset();
}

function onPower(power) {
  if(!properties.hasZAxis) {
    if(power) {
      writeComment('plunge knife and wait')
      writeBlock(mFormat.format(3)); //M3 switch on spindle, in this case move knife down
      writeBlock(gFormat.format(4),pFormat.format(0.2)); //wait 200ms the time for the knife to plunge

    }
    else {
      writeComment('lift knife and wait')
      writeBlock(mFormat.format(5)); //M5 siwtch off spindle, move up
      writeBlock(gFormat.format(4),pFormat.format(0.2)); //wait 200ms the time for the knife to lift

    }
  }
}

function onRapid(_x, _y, _z) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  //gext next record to avoid moving down and then up the head to rotate in the segment direction
  //writeComment(toString(getNextRecord()));
  //move the head in Z if there is a Z axis
  if(properties.hasZAxis){
    var z = zOutput.format(_z);
    if (x || y || z) {
      writeBlock(gMotionModal.format(0), x, y, z);
      feedOutput.reset();
    }
  }
  else {
    if (x || y) {
      writeBlock(gMotionModal.format(0), x, y);
      feedOutput.reset();
    }
  }
}

function onLinear(_x, _y, _z, feed) {
  var start = getCurrentPosition();
  var target = new Vector(_x,_y,_z);
  var direction = Vector.diff(target,start);
  //compute orientation of the upcoming segment
  var orientation_rad = direction.getXYAngle();
  //add offset on tool 2
  var offset = 0
  if(tool.number==2){
    offset = toRad(properties.tool2Offset);
  }
  orientation_rad += offset;
  //orientation_rad = angleToMachine(orientation_rad)
  //orientation_rad = orientation_rad % (2*Math.PI);
  //compute C orientation
  updateC(orientation_rad);
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);; 
  if (x || y) {
    writeBlock(gMotionModal.format(1), x, y, feedOutput.format(feed));
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (isHelical()) {
    var t = tolerance;
    if (hasParameter("operation:tolerance")) {
      t = getParameter("operation:tolerance");
    }
    linearize(t);
    return;
  }

  // one of X/Y and I/J are required and likewise


  switch (getCircularPlane()) {
  case PLANE_XY:
    var start = getCurrentPosition();
    var center = new Vector(cx,cy,cz);
    var start_center = Vector.diff(start,center);
    var up = new Vector(0,0,1);
    var start_dir = Vector.cross(start_center,up);
    var start_angle = start_dir.getXYAngle();
    var end = new Vector(x,y,z);
    var end_center = Vector.diff(end,center);
    var end_dir = Vector.cross(end_center,up);
    var end_angle = end_dir.getXYAngle();
    //add offset on tool 2
    var offset = 0
    writeComment(start_angle)
    writeComment(end_angle)
    writeComment(c_rad)
    if(tool.number==2){
      offset = toRad(properties.tool2Offset);
    }
    start_angle += offset;
    //start_angle = angleToMachine(start_angle);
    end_angle += offset;
    //end_angle = angleToMachine(end_angle);
    if(clockwise) {
      writeComment('clockwise')
      if(end_angle -start_angle > c_rad) {
        end_angle -= 2*Math.PI;
      }
    }
    else {
      if(end_angle <= c_rad){
        end_angle += 2*Math.PI;
      }
    }
    updateC(start_angle);
    c_rad = end_angle;
    writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), cOutput.format(end_angle), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), feedOutput.format(feed));
    break;
  default:
    var t = tolerance;
    if (hasParameter("operation:tolerance")) {
      t = getParameter("operation:tolerance");
    }
    linearize(t);
  }
}
/*
function onSectionEnd() {
  //move the head up
  moveUp();
}*/

function onCommand(command) {
}

function onClose() {
  if (properties.hasVacuum){
    writeComment('Switch off vacuum table');
    writeBlock(properties.vacuumOff);
  }
  writeComment('select spindle 0');
  writeBlock(mFormat.format(90)); //Set back spindle 0
  writeComment('go to corner')
  writeBlock(gMotionModal.format(30)) //Move to parking position 2
}
