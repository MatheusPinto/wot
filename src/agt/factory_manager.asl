/*
    Autor : Matheus Leitzke Pinto
    Data  : 12/12/2024 
*/


actualDeliveryBook([]).
actualShippingBook([]).

debugMode("on").

!start(3).

+!start(CN) <-
    .wait(5000);
    !getTD("http://simulator:8080/dairyProductProvider") ;
    !getTD("http://simulator:8080/cupProvider") ;
    !getTD("http://simulator:8080/factory") ;

    !resetFactory;
    .wait(6000); // Espera tempo suficiente para a fabrica ser reiniciada
    .broadcast(tell, cupsToProduce(CN));

    .at("now + 200 mseconds", {+!getDeliveryBook});
    .at("now + 200 mseconds", {+!getShippingBook});
    .

+rackIsEmpty(ER) <-
    if(ER == true) {
        //.send(operator_storeRack, ask, getCapacity);
        !orderCups(20);
        -rackIsEmpty(true);
    }
    .
    

+!getDeliveryBook <-
    !readProperty("tag:factory", deliveryBook, actualDeliveryBook) ;
    .at("now + 1000 mseconds", {+!getDeliveryBook});
    .

+!getShippingBook <-
    !readProperty("tag:factory", shippingBook, actualShippingBook) ;
    .at("now + 1000 mseconds", {+!getShippingBook});
    .

+!resetFactory <-
    !invokeAction("tag:factory", reset, []) ;
    .

+!orderCups(N) <-
    !invokeAction("tag:cupProvider", order, N) ;
    .

+!orderPackages(N) <-
    !invokeAction("tag:cupProvider", orderPackages, N) ;
    .

+!orderDairyProducts(N) <-
    !invokeAction("tag:dairyProductProvider", order, N) ;
    .


{ include("thing_description.asl") }
{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
{ include("$moise/asl/org-obedient.asl") }