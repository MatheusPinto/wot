//plantTDFound(false).

actualConveyorSpeed(0).
actualStatusLight("yellow").
actualConveyorHeadStatus([0,0]).
actualMagneticValveStatus("false").
actualOpticalSensorStatus("false").
actualTankLevel(0).
actualTankXPosition(0).

debugMode("off").

!start.

+!start <-
    !getTD("http://simulator:8080/fillingWorkshop") ;
    .at("now + 5 seconds", {+!getConveyorSpeed});
    .at("now + 5 seconds", {+!getStatusLight});
    .at("now + 5 seconds", {+!getConveyorHeadStatus});
    .at("now + 5 seconds", {+!getMagneticValveStatus});
    .at("now + 5 seconds", {+!getOpticalSensorStatus});
    .at("now + 5 seconds", {+!getTankLevel});
    .at("now + 5 seconds", {+!getTankXPosition});
    .

// fazer uma operação de falha, caso não seja possivel pegar o TD
//+!start <-

+!getConveyorSpeed <-
    !readProperty("tag:fillingWorkshop", conveyorSpeed, actualConveyorSpeed) ;
    .at("now + 1000 mseconds", {+!getConveyorSpeed});
    .

+!setConveyorSpeed(S) <-
    !writeProperty("tag:fillingWorkshop", conveyorSpeed, S) ;
    .

+!getStatusLight <-
    !readProperty("tag:fillingWorkshop", stackLightStatus, actualStatusLight) ;
    .at("now + 1000 mseconds", {+!getStatusLight});
    .

+!getConveyorHeadStatus <-
    !readProperty("tag:fillingWorkshop", conveyorHeadStatus, actualConveyorHeadStatus) ;
    .at("now + 1000 mseconds", {+!getConveyorHeadStatus});
    .

+!getMagneticValveStatus <-
    !readProperty("tag:fillingWorkshop", magneticValveStatus, actualMagneticValveStatus) ;
    .at("now + 1000 mseconds", {+!getMagneticValveStatus});
    .

+!getOpticalSensorStatus <-
    !readProperty("tag:fillingWorkshop", opticalSensorStatus, actualOpticalSensorStatus) ;
    .at("now + 1000 mseconds", {+!getOpticalSensorStatus});
    .

+!getTankLevel <-
    !readProperty("tag:fillingWorkshop", tankLevel, actualTankLevel) ;
    .at("now + 1000 mseconds", {+!getTankLevel});
    .

+!getTankXPosition <-
    !readProperty("tag:fillingWorkshop", positionX, actualTankXPosition) ;
    .at("now + 1000 mseconds", {+!getTankXPosition});
    .

+!pressEmergencyStop <-
    !invokeAction("tag:fillingWorkshop", pressEmergencyStop);
    .


{ include("thing_description.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }