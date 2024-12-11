//plantTDFound(false).

actualConveyorSpeed(0).
actualStatusLight("yellow").
actualCapacity([0,0]).
actualRobotXPosition(0).
actualRobotZPosition(0).
actualRobotClampStatus("false").
desirableConveyorSpeed(1).
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
    !readProperty("tag:storageRack", stackLightStatus, actualStatusLight) ;
    .at("now + 300 mseconds", {+!getStatusLight});
    .

+!getCapacity <-
    !readProperty("tag:storageRack", capacity, actualCapacity) ;
    .at("now + 10000 mseconds", {+!getCapacity});
    .

+!getRobotXPosition <-
    !readProperty("tag:storageRack", positionX, actualRobotXPosition) ;
    .at("now + 300 mseconds", {+!getRobotXPosition});
    .

+!getRobotZPosition <-
    !readProperty("tag:storageRack", positionZ, actualRobotZPosition) ;
    .at("now + 300 mseconds", {+!getRobotZPosition});
    .

+!getRobotClampStatus <-
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