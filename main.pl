:- dynamic explorado/1.
:- dynamic seguro/1.
:- dynamic processado/1.
:- dynamic monstro/1.
:- dynamic fedida/1.

%------------------------------------------
% Posiciona o monstro e marca salas adjacentes com fedor
coloca_monstro(Sala) :-
    assertz(monstro(Sala)),
    Vizinha1 is Sala - 1,
    Vizinha2 is Sala + 1,
    Vizinha3 is Sala + 4,
    Vizinha4 is Sala - 4,
    marca_sala_fedida(Vizinha1),
    marca_sala_fedida(Vizinha2),
    marca_sala_fedida(Vizinha3),
    marca_sala_fedida(Vizinha4).

%------------------------------------------
% Marca uma sala adjacente como contendo fedor
marca_sala_fedida(Sala) :-
    Sala > 0,
    Sala < 17,
    \+ fedida(Sala),
    assertz(fedida(Sala)).

%------------------------------------------
% Define se uma sala é segura
verifica_segura :-
    % Pega a próxima sala marcada como explorada e ainda não processada
    explorado(Sala),
    not(processado(Sala)),
    (
        % Se a sala tem fedor, considera como segura, mas não explora adjacentes
        fedida(Sala) ->
        format("Sala ~w contém fedor. Marcando como segura sem explorar adjacentes.~n", [Sala]),
        assertz(seguro(Sala)),
        assertz(processado(Sala)),
        verifica_segura;

        % Se a sala não tem fedor, marca como segura e explora adjacentes
        not(fedida(Sala)) ->
        format("Sala ~w é segura. Explorando adjacentes...~n", [Sala]),
        explora_adjacentes(Sala),
        assertz(seguro(Sala)),
        assertz(processado(Sala)),
        verifica_segura
    ).

%------------------------------------------
% Marca salas adjacentes para exploração
explora_adjacentes(Sala) :-
    Adjacente1 is Sala - 1,
    Adjacente2 is Sala + 1,
    Adjacente3 is Sala - 4,
    Adjacente4 is Sala + 4,
    marca_para_explorar(Adjacente1),
    marca_para_explorar(Adjacente2),
    marca_para_explorar(Adjacente3),
    marca_para_explorar(Adjacente4).

%------------------------------------------
% Marca uma sala para exploração
marca_para_explorar(Sala) :-
    Sala < 1; Sala > 16.
marca_para_explorar(Sala) :-
    Sala > 0,
    Sala < 17,
    (not(explorado(Sala)) -> assertz(explorado(Sala)); true).

%------------------------------------------
% Inicia o jogo
inicia :-
    coloca_monstro(12), % Posiciona o monstro na sala 12
    marca_para_explorar(1), % Marca a sala 1 para começar a investigação
    verifica_segura. % Inicia o processo de verificação
