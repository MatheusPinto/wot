//plantTDFound(false).

actualDeliveryBook([]).
actualShippingBook([]).

debugMode("on").

!start(5).

+!start(CN) <-
    .wait(5000);
    !getTD("http://simulator:8080/dairyProductProvider") ;
    !getTD("http://simulator:8080/cupProvider") ;
    !getTD("http://simulator:8080/factory") ;

    !resetFactory;
    .wait(6000); // Espera tempo suficiente para a fabrica ser reiniciada
    .broadcast(tell, cupsToProduce(CN));

    //DESCOMENTAR
    //.at("now + 200 mseconds", {+!getDeliveryBook});
    //.at("now + 200 mseconds", {+!getShippingBook});
    .


/*
+!start(CN)
   <- 
      .concat("sch_for_",CN,SchName);                 // Cria um nome para o esquema para CN copos
      createScheme(SchName, yogurt_production, SchArtId);    // Cria o esquema organizacional, cujo id é "yogurt_production" e definido do arquivo .xml, recuperando o Id do esquema criado (ScHArtId)
      // Abaixo, seta o único argumento para o objetivo "make_yogurt_cup" do esquema SchArtId ("yogurt_production"): o número de copos para a produção (cupsNumber)
      .concat("C_", CN, ArtArg);
      setArgumentValue(make_yogurt_cup, "cupsNumber", ArtArg)[artifact_id(SchArtId)];
      .my_name(Me); setOwner(Me)[artifact_id(SchArtId)];  // Define o agente atual como dono
      focus(SchArtId);                                  // Centraliza a atenção no esquema
      addScheme(SchName);                               // Associa o esquema ao grupo
      // Inicia a missão de gerenciador da fabrica
      // É importante notar que apenas essa missão fica em vigor, mas todas as outras não estão ativadas
      // Para que as outras missões sejam ativadas, é necessário inicilizar o esquema.
      // O esquema será inicializado no primeiro objetivo dessa missão: startProduction.
      // Note ainda que o objetivo startProduction foi inicializado antes do esquema ser inicializado,
      // porém seu termino será contabilizado como concluído quando o esquema continuar.
      commitMission(mfactory_manager)[artifact_id(SchArtId)]. 
*/

/*
+!startProduction[scheme(Sch)] <-
    !getTD("http://simulator:8080/dairyProductProvider") ;
    !getTD("http://simulator:8080/cupProvider") ;
    !getTD("http://simulator:8080/factory") ;
    // Unifica em CN o argumento "cupsNumber" do objetivo "make_yogurt_cup", do esquema unificado em Sch
    ?goalArgument(Sch, make_yogurt_cup, "cupsNumber", CN);
    .print("Start scheme ", Sch, " for production cups.");

    // Cria o artefato relacionado ao esquema criado.
    // Esse "artefato" será responsável pela comunicação entre os agentes do esquema.
    //.concat("art_", CN, ArtName);
    //makeArtifact(ArtName, "factory_env.FactoryArtifact", [], ArtId);
    // Relaciona o artefato ao esquema criado.
    //Sch::focus(ArtId);
    // Inicia o esquema.
    Sch::start(CN);

    //.wait(10000);
    //.print("OK! Iniciei...");
    
    
    //.send(operator_storeRack, achieve, pickItem([1,3]));
    //.send(operator_robotArm, achieve, moveToPickCup);
    //.send(operator_wksFiller, achieve, setConveyorSpeed(0.3));

    //.at("now + 5 seconds", {+!getDeliveryBook});
    //.at("now + 5 seconds", {+!getShippingBook});
    .
*/

// fazer uma operação de falha, caso não seja possivel pegar o TD
//+!start <-

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