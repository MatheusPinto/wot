//plantTDFound(false).

actualConveyorSpeed(0).
actualStatusLight("yellow").
actualConveyorHeadStatus(false).
actualMagneticValveStatus("false").
actualOpticalSensorStatus("false").
actualTankLevel(0).
actualTankXPosition(0).
desirableConveyorSpeed(0.3).
tankPositionError(0.3).
tankEmptyLevelError(0.2).

debugMode("on").

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


+cupsToProduce(CN) <- 
    ?desirableConveyorSpeed(S);
    !setConveyorSpeed(S) ;
    !askForCup;
    .


+!askForCup <-
    //?actualTankXPosition(P);
    //?tankPositionError(E);
    //if (P > E) (.at("now + 300 mseconds", {+!askForCup});)
    //else{}
    .send(operator_storeRack, achieve, pickNextCup);
    .

+!askForMoveCup <-
    .send(operator_robotArm, achieve, moveCup);
    //.print("Copo no final da esteira");
    .

+!getConveyorSpeed <-
    !readProperty("tag:fillingWorkshop", conveyorSpeed, actualConveyorSpeed) ;
    .at("now + 300 mseconds", {+!getConveyorSpeed});
    .

+!setConveyorSpeed(S) <-
    !writeProperty("tag:fillingWorkshop", conveyorSpeed, S) ;
    .

+!getStatusLight <-
    ?actualStatusLight(Before);
    -actualStatusLight(Before);
    !readProperty("tag:fillingWorkshop", stackLightStatus, actualStatusLight) ;
    ?actualConveyorSpeed(S);
    if(S == 0) {
        ?actualStatusLight(L);
        if (L == "green")
        {
            ?desirableConveyorSpeed(DS);
            !setConveyorSpeed(DS);
        }
    }

    .at("now + 300 mseconds", {+!getStatusLight});
    .

+!getConveyorHeadStatus <-
    ?actualConveyorHeadStatus(Before);
    -actualConveyorHeadStatus(Before);
    !readProperty("tag:fillingWorkshop", conveyorHeadStatus, actualConveyorHeadStatus) ;
    ?actualConveyorHeadStatus(Actual);
    if(Before \== Actual) {
        //.print("\n\n\n\n\n\n\nACTUAL <- ", Actual, " BEFORE <- ", Before, "\n\n\n\n\n\n\n\n\n");
        !signalConveyorHeadStatusChange(Actual);
    }
    .at("now + 200 mseconds", {+!getConveyorHeadStatus});
    .

+!signalConveyorHeadStatusChange(S) <-
    if(S == true) {
        !askForMoveCup;
    }
    else {
        !askForCup
    }
    .

+!getMagneticValveStatus <-
    ?actualMagneticValveStatus(Before);
    -actualMagneticValveStatus(Before);
    !readProperty("tag:fillingWorkshop", magneticValveStatus, actualMagneticValveStatus) ;
    .at("now + 300 mseconds", {+!getMagneticValveStatus});
    .

+!getOpticalSensorStatus <-
    !readProperty("tag:fillingWorkshop", opticalSensorStatus, actualOpticalSensorStatus) ;
    .at("now + 300 mseconds", {+!getOpticalSensorStatus});
    .

+!getTankLevel <-
    ?actualTankLevel(Before);
    -actualTankLevel(Before);
    !readProperty("tag:fillingWorkshop", tankLevel, actualTankLevel) ;
    ?actualTankLevel(Actual);
    ?tankEmptyLevelError(E);
    if (Actual < E) {
        .send(factory_manager, achieve, orderDairyProducts(3)); // pede 3 litros de iougurte
    }
    .at("now + 300 mseconds", {+!getTankLevel});
    .

+!getTankXPosition <-
    !readProperty("tag:fillingWorkshop", positionX, actualTankXPosition) ;
    .at("now + 300 mseconds", {+!getTankXPosition});
    .

+!pressEmergencyStop <-
    !invokeAction("tag:fillingWorkshop", pressEmergencyStop);
    .


{ include("thing_description.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }