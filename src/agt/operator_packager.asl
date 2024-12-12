/*
    Autor : Matheus Leitzke Pinto
    Data  : 12/12/2024 
*/


//plantTDFound(false).

actualConveyorSpeed(0).
actualStatusLight("yellow").
actualConveyorHeadStatus([0,0]).
actualPackageBufferNum(0).
actualPackageSensorStatus("false").
actualContainerSensor1Status("false").
actualContainerSensor2Status("false").
desirableConveyorSpeed(0.3).

debugMode("on").

!start.

+!start <-
    !getTD("http://simulator:8080/packagingWorkshop") ;
    .at("now + 300 mseconds", {+!getConveyorSpeed});
    .at("now + 300 mseconds", {+!getStatusLight});
    .at("now + 300 mseconds", {+!getConveyorHeadStatus});
    .at("now + 300 mseconds", {+!getPackageBufferNum});
    .at("now + 300 mseconds", {+!getPackageSensorStatus});
    .at("now + 300 mseconds", {+!getContainerSensor1Status});
    .at("now + 300 mseconds", {+!getContainerSensor2Status});
    .

+cupsToProduce(CN) <- 
    ?desirableConveyorSpeed(S);
    !setConveyorSpeed(S) ;
    .

+!getConveyorSpeed <-
    ?actualConveyorSpeed(Before);
    -actualConveyorSpeed(Before);
    !readProperty("tag:packagingWorkshop", conveyorSpeed, actualConveyorSpeed) ;
    .at("now + 300 mseconds", {+!getConveyorSpeed});
    .

+!setConveyorSpeed(S) <-
    !writeProperty("tag:packagingWorkshop", conveyorSpeed, S) ;
    .

+!getStatusLight <-
    ?actualStatusLight(Before);
    -actualStatusLight(Before);
    !readProperty("tag:packagingWorkshop", stackLightStatus, actualStatusLight) ;
    .at("now + 300 mseconds", {+!getStatusLight});
    .

+!getConveyorHeadStatus <-
    ?actualConveyorHeadStatus(Before);
    -actualConveyorHeadStatus(Before);
    !readProperty("tag:packagingWorkshop", conveyorHeadStatus, actualConveyorHeadStatus) ;
    .at("now + 300 mseconds", {+!getConveyorHeadStatus});
    .

+!getPackageBufferNum <-
    ?actualPackageBufferNum(Before);
    -actualPackageBufferNum(Before);
    !readProperty("tag:packagingWorkshop", packageBuffer, actualPackageBufferNum) ;
    ?actualPackageBufferNum(Actual);
    if ( Actual == 0 ) {
        .send(factory_manager, achieve, orderPackages(5));
    }
    .at("now + 1000 mseconds", {+!getPackageBufferNum});
    .

+!getPackageSensorStatus <-
    ?actualPackageSensorStatus(Before);
    -actualPackageSensorStatus(Before);
    !readProperty("tag:packagingWorkshop", opticalSensorPackage, actualPackageSensorStatus) ;
    .at("now + 300 mseconds", {+!getPackageSensorStatus});
    .

+!getContainerSensor1Status <-
    ?actualContainerSensor1Status(Before);
    -actualContainerSensor1Status(Before);
    !readProperty("tag:packagingWorkshop", opticalSensorContainer1, actualContainerSensor1Status) ;
    .at("now + 300 mseconds", {+!getContainerSensor1Status});
    .

+!getContainerSensor2Status <-
    ?actualContainerSensor2Status(Before);
    -actualContainerSensor2Status(Before);
    !readProperty("tag:packagingWorkshop", opticalSensorContainer2, actualContainerSensor2Status) ;
    .at("now + 300 mseconds", {+!getContainerSensor2Status});
    .

+!pressEmergencyStop <-
    !invokeAction("tag:packagingWorkshop", pressEmergencyStop);
    .


{ include("thing_description.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }