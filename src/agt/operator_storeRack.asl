//plantTDFound(false).

actualConveyorSpeed(0).
actualStatusLight("yellow").
actualCapacity([0,0]).
actualRobotXPosition(0).
actualRobotZPosition(0).
actualRobotClampStatus("false").

debugMode("off").

!start.

+!start <-
    !getTD("http://simulator:8080/storageRack") ;
    .at("now + 5 seconds", {+!getStatusLight});
    .at("now + 5 seconds", {+!getCapacity});
    .at("now + 5 seconds", {+!getRobotXPosition});
    .at("now + 5 seconds", {+!getRobotZPosition});
    .at("now + 5 seconds", {+!getRobotClampStatus});
    //!getConveyorSpeed |&| !getStatusLight |&| !getCapacity;
    //-+plantTDFound(true);
    .

// fazer uma operação de falha, caso não seja possivel pegar o TD
//+!start <-

+!getConveyorSpeed <-
    !readProperty("tag:storageRack", conveyorSpeed, actualConveyorSpeed) ;
    .at("now + 1000 mseconds", {+!getConveyorSpeed});
    .

+!setConveyorSpeed(S) <-
    !writeProperty("tag:storageRack", conveyorSpeed, S) ;
    .

+!getStatusLight <-
    !readProperty("tag:storageRack", stackLightStatus, actualStatusLight) ;
    .at("now + 1000 mseconds", {+!getStatusLight});
    .

+!getCapacity <-
    !readProperty("tag:storageRack", capacity, actualCapacity) ;
    .at("now + 1000 mseconds", {+!getCapacity});
    .

+!getRobotXPosition <-
    !readProperty("tag:storageRack", positionX, actualRobotXPosition) ;
    .at("now + 1000 mseconds", {+!getRobotXPosition});
    .

+!getRobotZPosition <-
    !readProperty("tag:storageRack", positionZ, getRobotZPosition) ;
    .at("now + 1000 mseconds", {+!getRobotZPosition});
    .

+!getRobotClampStatus <-
    !readProperty("tag:storageRack", clampStatus, getRobotClampStatus) ;
    .at("now + 1000 mseconds", {+!getRobotClampStatus});
    .

+!pressEmergencyStop <-
    !invokeAction("tag:storageRack", pressEmergencyStop);
    .

+!pickItem(P) <-
    !invokeAction("tag:storageRack", pickItem, P);
    .

{ include("thing_description.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }