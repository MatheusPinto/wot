//plantTDFound(false).

actualInMovement("false").
actualStatusLight("yellow").
actualGrasping("false").

debugMode("on").

!start.

+!start <-
    !getTD("http://simulator:8080/robotArm") ;
    .at("now + 5 seconds", {+!getStatusLight});
    .at("now + 5 seconds", {+!verifyIfIsInMovement});
    .at("now + 5 seconds", {+!getGraspingStatus});
    .

// fazer uma operação de falha, caso não seja possivel pegar o TD
//+!start <-

+!getStatusLight <-
    !readProperty("tag:robotArm", stackLightStatus, actualStatusLight) ;
    .at("now + 300 mseconds", {+!getStatusLight});
    .

+!verifyIfIsInMovement <-
    !readProperty("tag:robotArm", inMovement, actualInMovement) ;
    .at("now + 300 mseconds", {+!verifyIfIsInMovement})
    .

+!getGraspingStatus <-
    !readProperty("tag:robotArm", grasping, actualGrasping) ;
    .at("now + 300 mseconds", {+!getGraspingStatus});
    .

+!pressEmergencyStop <-
    !invokeAction("tag:robotArm", pressEmergencyStop);
    .

// Lançado erro ao tentar chamar esse objetivo
+!moveToPickCup <-  
    DEVOLVER = [kv("x", 2.2), kv("y", 0), kv("z", 1)];
    !invokeAction("tag:robotArm", moveTo, DEVOLVER) ;
    .

// Lançado erro ao tentar chamar esse objetivo
+!moveToPackageWorkshop <-
    DEVOLVER = [kv("x", 3.2), kv("y", 0), kv("z", 1)];
    !invokeAction("tag:robotArm", moveTo, DEVOLVER) ;
    .

+!moveCup <-
    !moveToPickCup;
    !grasp;
/*    ?actualGrasping(G);
    // Verifica se item foi realmente pego (ou seja, tinha item para a garra pegar)
    while(G \== true) {
        .wait(300);
        ?actualGrasping(G);
        !grasp;
    }
    */
    !moveToPackageWorkshop;
    !release;
    .

+!grasp <-
    !invokeAction("tag:robotArm", grasp, []) ;
    .

+!release <-
    !invokeAction("tag:robotArm", release, []) ;
    .


{ include("thing_description.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }