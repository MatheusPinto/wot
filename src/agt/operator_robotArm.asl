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
    .at("now + 1000 mseconds", {+!getStatusLight});
    .

+!verifyIfIsInMovement <-
    !readProperty("tag:robotArm", inMovement, actualInMovement) ;
    .at("now + 1000 mseconds", {+!verifyIfIsInMovement})
    .

+!getGraspingStatus <-
    !readProperty("tag:robotArm", grasping, actualGrasping) ;
    .at("now + 1000 mseconds", {+!getGraspingStatus});
    .

+!pressEmergencyStop <-
    !invokeAction("tag:robotArm", pressEmergencyStop);
    .

// Lançado erro ao tentar chamar esse objetivo
+!moveToPickCup <-
    !invokeAction("tag:robotArm", moveTo, [2.2, 0, 1]) ;
    .

// Lançado erro ao tentar chamar esse objetivo
+!moveToPackageWorkshop <-
    !invokeAction("tag:robotArm", moveTo, [3.2, 0, 1]) ;
    .

+!grasp <-
    !invokeAction("tag:robotArm", grasp) ;
    .

+!release <-
    !invokeAction("tag:robotArm", release) ;
    .


{ include("thing_description.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }