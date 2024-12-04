!start.

//plantTDFound(false).

actualDeliveryBook([]).
actualShippingBook([]).

debugMode("on").

!start.

+!start <-
    .wait(10000);
    .print("OK! Iniciei...");
    //.send(operator_storeRack, achieve, pickItem([1,3]));
    //.send(operator_robotArm, achieve, moveToPackageWorkshop);
    //.send(operator_wksFiller, achieve, setConveyorSpeed(0.3));

    !getTD("http://simulator:8080/dairyProductProvider") ;
    !getTD("http://simulator:8080/cupProvider") ;
    !getTD("http://simulator:8080/Factory") ;

    .at("now + 5 seconds", {+!getDeliveryBook});
    .at("now + 5 seconds", {+!getShippingBook});
    .

// fazer uma operação de falha, caso não seja possivel pegar o TD
//+!start <-

+!getDeliveryBook <-
    !readProperty("tag:Factory", deliveryBook, actualDeliveryBook) ;
    .at("now + 1000 mseconds", {+!getDeliveryBook});
    .

+!getShippingBook <-
    !readProperty("tag:Factory", shippingBook, actualShippingBook) ;
    .at("now + 1000 mseconds", {+!getShippingBook});
    .

+!resetFactory <-
    !invokeAction("tag:Factory", reset) ;
    .

+!orderCups(N) <-
    !invokeAction("tag:cupProvider", order, N) ;
    .

+!orderPackages(N) <-
    !invokeAction("tag:cupProvider", orderPackages, N) ;
    .

+!orderDairyProducts(N) <-
    !invokeAction("tag:ProductProvider", order, N) ;
    .


{ include("thing_description.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }






{ include("$jacamoJar/templates/common-cartago.asl") }