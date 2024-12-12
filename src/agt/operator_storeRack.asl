/*
    Autor : Matheus Leitzke Pinto
    Data  : 12/12/2024 
*/


actualConveyorSpeed(0).
actualStatusLight("yellow").
actualCapacity([0,0]).
actualRobotXPosition(0).
actualRobotZPosition(0).
actualRobotClampStatus("false").
desirableConveyorSpeed(0.3).
actualRackPosition([0, 0]).
rackIsEmpty(false).

debugMode("off").

!start.

+!start <-
    !getTD("http://simulator:8080/storageRack") ;
    .at("now + 300 mseconds", {+!getStatusLight});
    .at("now + 300 mseconds", {+!getCapacity});
    .at("now + 300 mseconds", {+!getRobotXPosition});
    .at("now + 300 mseconds", {+!getRobotZPosition});
    .at("now + 300 mseconds", {+!getRobotClampStatus});
    .

+cupsToProduce(CN) <- 
    ?desirableConveyorSpeed(S);
    !setConveyorSpeed(S) ;
    .

+!getConveyorSpeed <-
    //?actualConveyorSpeed(Before); tirado por problema de condição de corrida (mecanismo de exclusão mutua?)
    //-actualConveyorSpeed(Before);
    !readProperty("tag:storageRack", conveyorSpeed, actualConveyorSpeed) ;
    .at("now + 300 mseconds", {+!getConveyorSpeed});
    .

+!pickNextCup[source(A)] <-
    ?actualRackPosition(P);
    ?actualCapacity(C);
    .nth(0, P, X);
    .nth(1, P, Z);
    .nth(0, C, N);

    if ( Z < N )
    {        
        if ( X < N ) {
            !pickItem([X, Z]);
            -+actualRackPosition([X+1, Z]);
        }
        else {
            if (Z+1 < N)
            {
                !pickItem([0, Z+1]);
            }
            -+actualRackPosition([1, Z+1]);
            
        }
    }
    else {
        -+rackIsEmpty(true);
        .broadcast(tell, rackIsEmpty(true));
    }
    .

+rackIsEmpty <-
    ?rackIsEmpty(ER);
    if(ER == true) {
        .print("Rack is Empty");
    }
    else {
        .print("Rack is Full");
    }
    .

+!setConveyorSpeed(S) <-
    !writeProperty("tag:storageRack", conveyorSpeed, S) ;
    .

+!getStatusLight <-
    ?actualStatusLight(Before);
    -actualStatusLight(Before);
    !readProperty("tag:storageRack", stackLightStatus, actualStatusLight) ;
    .at("now + 300 mseconds", {+!getStatusLight});
    .

// Possível solução para objetivo ser atomico => @{atomic}
+!getCapacity <-
    //?actualCapacity(Before);
    //-actualCapacity(Before); tirado por problema de condição de corrida (mecanismo de exclusão mutua?)
    !readProperty("tag:storageRack", capacity, actualCapacity) ;
    .at("now + 10000 mseconds", {+!getCapacity});
    .

+!getRobotXPosition <-
    ?actualRobotXPosition(Before);
    -actualRobotXPosition(Before);
    !readProperty("tag:storageRack", positionX, actualRobotXPosition) ;
    .at("now + 300 mseconds", {+!getRobotXPosition});
    .

+!getRobotZPosition <-
    ?actualRobotZPosition(Before);
    -actualRobotZPosition(Before);
    !readProperty("tag:storageRack", positionZ, actualRobotZPosition) ;
    .at("now + 300 mseconds", {+!getRobotZPosition});
    .

+!getRobotClampStatus <-
    ?actualRobotClampStatus(Before);
    -actualRobotClampStatus(Before);
    !readProperty("tag:storageRack", clampStatus, actualRobotClampStatus) ;
    .at("now + 300 mseconds", {+!getRobotClampStatus});
    .

+!pressEmergencyStop <-
    !invokeAction("tag:storageRack", pressEmergencyStop);
    .

+!pickItem(P) <-
    !invokeAction("tag:storageRack", pickItem, P);
    .

{ include("thing_description.asl") }
{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
{ include("$moise/asl/org-obedient.asl") }