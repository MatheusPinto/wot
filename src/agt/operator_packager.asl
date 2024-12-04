//plantTDFound(false).

actualConveyorSpeed(0).
actualStatusLight("yellow").
actualConveyorHeadStatus([0,0]).
actualPackageBufferNum(0).
actualPackageSensorStatus("false").
actualContainerSensor1Status("false").
actualContainerSensor2Status("false").

debugMode("on").

!start.

+!start <-
    !getTD("http://simulator:8080/packagingWorkshop") ;
    .at("now + 5 seconds", {+!getConveyorSpeed});
    .at("now + 5 seconds", {+!getStatusLight});
    .at("now + 5 seconds", {+!getConveyorHeadStatus});
    .at("now + 5 seconds", {+!getPackageBufferNum});
    .at("now + 5 seconds", {+!getPackageSensorStatus});
    .at("now + 5 seconds", {+!getContainerSensor1Status});
    .at("now + 5 seconds", {+!getContainerSensor2Status});
    .

// fazer uma operação de falha, caso não seja possivel pegar o TD
//+!start <-

+!getConveyorSpeed <-
    !readProperty("tag:packagingWorkshop", conveyorSpeed, actualConveyorSpeed) ;
    .at("now + 1000 mseconds", {+!getConveyorSpeed});
    .

+!setConveyorSpeed(S) <-
    !writeProperty("tag:packagingWorkshop", conveyorSpeed, S) ;
    .

+!getStatusLight <-
    !readProperty("tag:packagingWorkshop", stackLightStatus, actualStatusLight) ;
    .at("now + 1000 mseconds", {+!getStatusLight});
    .

+!getConveyorHeadStatus <-
    !readProperty("tag:packagingWorkshop", conveyorHeadStatus, actualConveyorHeadStatus) ;
    .at("now + 1000 mseconds", {+!getConveyorHeadStatus});
    .

+!getPackageBufferNum <-
    !readProperty("tag:packagingWorkshop", packageBuffer, actualPackageBufferNum) ;
    .at("now + 1000 mseconds", {+!getPackageBufferNum});
    .

+!getPackageSensorStatus <-
    !readProperty("tag:packagingWorkshop", opticalSensorPackage, actualPackageSensorStatus) ;
    .at("now + 1000 mseconds", {+!getPackageSensorStatus});
    .

+!getContainerSensor1Status <-
    !readProperty("tag:packagingWorkshop", opticalSensorContainer1, actualContainerSensor1Status) ;
    .at("now + 1000 mseconds", {+!getContainerSensor1Status});
    .

+!getContainerSensor2Status <-
    !readProperty("tag:packagingWorkshop", opticalSensorContainer2, actualContainerSensor2Status) ;
    .at("now + 1000 mseconds", {+!getContainerSensor2Status});
    .

+!pressEmergencyStop <-
    !invokeAction("tag:packagingWorkshop", pressEmergencyStop);
    .


{ include("thing_description.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }