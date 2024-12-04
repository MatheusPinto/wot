//+json(Val)[source(URI)]  <- .print("new json ", Val, " for ",URI).


+!getTD(TD)
    <-
    !prepareForm(F) ;
    get(TD, F) ;
    ?thing(T) ;
    !debugPrint("Found Thing with URI ", T) .

+!listProperties(T) 
   <- for (hasProperty(T, P)) { 
         if (hasForm(T, P, F) & hasTargetURI(F, URI)) {
            !prepareForm(Fp);
            get(URI, Fp) ;
            ?(json(Val)[source(URI)]) ;
            !debugPrint(P, Val);
            //.print(P, " = ", Val) ;
         } else {
            !debugPrint(P);
            //.print(P)
         } 
      }
   .
+!readProperty(T, P, S) : hasForm(T, P, F) & hasTargetURI(F, URI)
    <-
    !prepareForm(Fp) ;
    //.print("URI=",URI," Fp=",Fp);
    get(URI, Fp) ;
    ?(json(Val)[source(URI)]) ;
    NewBel =.. [S, [Val], []];  // Construir predicado dinamicamente
    +NewBel;                    // Adicionar nova crença
    !debugPrint(P, Val) .



+!writeProperty(T, P, Val) : hasForm(T, P, F) & hasTargetURI(F, URI)
    <-
    !prepareForm(Fp) ;
    put(URI, [json(Val)], Fp) .

+!invokeAction(T, A, In) : hasForm(T, A, F) & hasTargetURI(F, URI)
    <-
    !prepareForm(Fp) ;
    post(URI, [json(In)], Fp) .

+!prepareForm(F) : credentials(User, Pw)
    <-
    h.basic_auth_credentials(User, Pw, H) ;
    F = [kv("urn:hypermedea:http:authorization", H)] .

thing(T)
    :-
    json(TD) & .list(TD) &
    //.member(kv("@type", "Thing"), TD) &
    .member(kv(id, T), TD) .

hasProperty(T, P)
    :-
    json(TD) & .list(TD) &
    //.member(kv("@type", "Thing"), TD) &
    .member(kv(id, T), TD) &
    .member(kv(properties, Ps), TD) &
    .member(kv(P, _), Ps) .

hasForm(T, PAE, F)
    :-
    json(TD) & .list(TD) &
    .member(kv(id, T), TD) &
    (
        .member(kv(properties, PAEs),  TD) |
        .member(kv(actions, PAEs),  TD) |
        .member(kv(events, PAEs),  TD)
    ) &
    .member(kv(PAE, Def), PAEs) &
    .member(kv(forms, Fs), Def) &
    .member(F, Fs) .

hasTargetURI(F, URI) :- .member(kv(href, URI), F) .


+!debugPrint(P, Val) 
    <-
    if (debugMode(D) & D == "on")
    {
        .print(P, " = ", Val) ;       
    }
    .

+!debugPrint(P)
    <-
    if (debugMode(D) & D == "on")
    {
        .print(P) ;       
    }
    .