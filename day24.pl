:- use_module(library(clpfd)).

problem(D) :-
    D0 in 1..9,
    D1 in 1..9,
    D2 in 1..9,
    D3 in 1..9,
    D4 in 1..9,
    D5 in 1..9,
    D6 in 1..9,
    D7 in 1..9,
    D8 in 1..9,
    D9 in 1..9,
    D10 in 1..9,
    D11 in 1..9,
    D12 in 1..9,
    D13 in 1..9,
    Z0 #= 0,
    W1 #= D0,
    X1 #= Z0,
    X2 #= X1 rem 26,
    X3 #= X2 + 11,
    X4 #<==>  X3 #= W1,
    X5 #<==>  X4 #= 0,
    Y1 #= 25,
    Y2 #= Y1 * X5,
    Y3 #= Y2 + 1,
    Z1 #= Z0 * Y3,
    Y4 #= W1,
    Y5 #= Y4 + 6,
    Y6 #= Y5 * X5,
    Z2 #= Z1 + Y6,
    W2 #= D1,
    X6 #= Z2,
    X7 #= X6 rem 26,
    X8 #= X7 + 11,
    X9 #<==>  X8 #= W2,
    X10 #<==>  X9 #= 0,
    Y7 #= 25,
    Y8 #= Y7 * X10,
    Y9 #= Y8 + 1,
    Z3 #= Z2 * Y9,
    Y10 #= W2,
    Y11 #= Y10 + 12,
    Y12 #= Y11 * X10,
    Z4 #= Z3 + Y12,
    W3 #= D2,
    X11 #= Z4,
    X12 #= X11 rem 26,
    X13 #= X12 + 15,
    X14 #<==>  X13 #= W3,
    X15 #<==>  X14 #= 0,
    Y13 #= 25,
    Y14 #= Y13 * X15,
    Y15 #= Y14 + 1,
    Z5 #= Z4 * Y15,
    Y16 #= W3,
    Y17 #= Y16 + 8,
    Y18 #= Y17 * X15,
    Z6 #= Z5 + Y18,
    W4 #= D3,
    X16 #= Z6,
    X17 #= X16 rem 26,
    Z7 #= Z6 div 26,
    X18 #= X17 + -11,
    X19 #<==>  X18 #= W4,
    X20 #<==>  X19 #= 0,
    Y19 #= 25,
    Y20 #= Y19 * X20,
    Y21 #= Y20 + 1,
    Z8 #= Z7 * Y21,
    Y22 #= W4,
    Y23 #= Y22 + 7,
    Y24 #= Y23 * X20,
    Z9 #= Z8 + Y24,
    W5 #= D4,
    X21 #= Z9,
    X22 #= X21 rem 26,
    X23 #= X22 + 15,
    X24 #<==>  X23 #= W5,
    X25 #<==>  X24 #= 0,
    Y25 #= 25,
    Y26 #= Y25 * X25,
    Y27 #= Y26 + 1,
    Z10 #= Z9 * Y27,
    Y28 #= W5,
    Y29 #= Y28 + 7,
    Y30 #= Y29 * X25,
    Z11 #= Z10 + Y30,
    W6 #= D5,
    X26 #= Z11,
    X27 #= X26 rem 26,
    X28 #= X27 + 15,
    X29 #<==>  X28 #= W6,
    X30 #<==>  X29 #= 0,
    Y31 #= 25,
    Y32 #= Y31 * X30,
    Y33 #= Y32 + 1,
    Z12 #= Z11 * Y33,
    Y34 #= W6,
    Y35 #= Y34 + 12,
    Y36 #= Y35 * X30,
    Z13 #= Z12 + Y36,
    W7 #= D6,
    X31 #= Z13,
    X32 #= X31 rem 26,
    X33 #= X32 + 14,
    X34 #<==>  X33 #= W7,
    X35 #<==>  X34 #= 0,
    Y37 #= 25,
    Y38 #= Y37 * X35,
    Y39 #= Y38 + 1,
    Z14 #= Z13 * Y39,
    Y40 #= W7,
    Y41 #= Y40 + 2,
    Y42 #= Y41 * X35,
    Z15 #= Z14 + Y42,
    W8 #= D7,
    X36 #= Z15,
    X37 #= X36 rem 26,
    Z16 #= Z15 div 26,
    X38 #= X37 + -7,
    X39 #<==>  X38 #= W8,
    X40 #<==>  X39 #= 0,
    Y43 #= 25,
    Y44 #= Y43 * X40,
    Y45 #= Y44 + 1,
    Z17 #= Z16 * Y45,
    Y46 #= W8,
    Y47 #= Y46 + 15,
    Y48 #= Y47 * X40,
    Z18 #= Z17 + Y48,
    W9 #= D8,
    X41 #= Z18,
    X42 #= X41 rem 26,
    X43 #= X42 + 12,
    X44 #<==>  X43 #= W9,
    X45 #<==>  X44 #= 0,
    Y49 #= 25,
    Y50 #= Y49 * X45,
    Y51 #= Y50 + 1,
    Z19 #= Z18 * Y51,
    Y52 #= W9,
    Y53 #= Y52 + 4,
    Y54 #= Y53 * X45,
    Z20 #= Z19 + Y54,
    W10 #= D9,
    X46 #= Z20,
    X47 #= X46 rem 26,
    Z21 #= Z20 div 26,
    X48 #= X47 + -6,
    X49 #<==>  X48 #= W10,
    X50 #<==>  X49 #= 0,
    Y55 #= 25,
    Y56 #= Y55 * X50,
    Y57 #= Y56 + 1,
    Z22 #= Z21 * Y57,
    Y58 #= W10,
    Y59 #= Y58 + 5,
    Y60 #= Y59 * X50,
    Z23 #= Z22 + Y60,
    W11 #= D10,
    X51 #= Z23,
    X52 #= X51 rem 26,
    Z24 #= Z23 div 26,
    X53 #= X52 + -10,
    X54 #<==>  X53 #= W11,
    X55 #<==>  X54 #= 0,
    Y61 #= 25,
    Y62 #= Y61 * X55,
    Y63 #= Y62 + 1,
    Z25 #= Z24 * Y63,
    Y64 #= W11,
    Y65 #= Y64 + 12,
    Y66 #= Y65 * X55,
    Z26 #= Z25 + Y66,
    W12 #= D11,
    X56 #= Z26,
    X57 #= X56 rem 26,
    Z27 #= Z26 div 26,
    X58 #= X57 + -15,
    X59 #<==>  X58 #= W12,
    X60 #<==>  X59 #= 0,
    Y67 #= 25,
    Y68 #= Y67 * X60,
    Y69 #= Y68 + 1,
    Z28 #= Z27 * Y69,
    Y70 #= W12,
    Y71 #= Y70 + 11,
    Y72 #= Y71 * X60,
    Z29 #= Z28 + Y72,
    W13 #= D12,
    X61 #= Z29,
    X62 #= X61 rem 26,
    Z30 #= Z29 div 26,
    X63 #= X62 + -9,
    X64 #<==>  X63 #= W13,
    X65 #<==>  X64 #= 0,
    Y73 #= 25,
    Y74 #= Y73 * X65,
    Y75 #= Y74 + 1,
    Z31 #= Z30 * Y75,
    Y76 #= W13,
    Y77 #= Y76 + 13,
    Y78 #= Y77 * X65,
    Z32 #= Z31 + Y78,
    W14 #= D13,
    X66 #= Z32,
    X67 #= X66 rem 26,
    Z33 #= Z32 div 26,
    X68 #<==>  X67 #= W14,
    X69 #<==>  X68 #= 0,
    Y79 #= 25,
    Y80 #= Y79 * X69,
    Y81 #= Y80 + 1,
    Z34 #= Z33 * Y81,
    Y82 #= W14,
    Y83 #= Y82 + 7,
    Y84 #= Y83 * X69,
    Z35 #= Z34 + Y84,
    Z35 #= 0,
    D #= D0 * 10000000000000 * D1 * 1000000000000 * D2 * 100000000000 * D3 * 10000000000 * D4 * 1000000000 * D5 * 100000000 * D6 * 10000000 * D7 * 1000000 * D8 * 100000 * D9 * 10000 * D10 * 1000 * D11 * 100 * D12 * 10 * D13 * 1.