Object subclass: PlanerPodrozy [
    | nazwa trasy |

    PlanerPodrozy class >> new [
        ^self nazwa: 'Planer podróży'
    ]

    PlanerPodrozy class >> nazwa: tekst [
        ^self basicNew ustawNazwe: (BladPodrozy sprawdzTekst: tekst opis: 'Nazwa planera')
    ]

    ustawNazwe: tekst [
        nazwa := tekst.
        trasy := OrderedCollection new
    ]

    nazwa [ ^nazwa ]
    trasy [ ^trasy copy ]
    liczbaTras [ ^trasy size ]

    dodaj: trasa [
        (trasa isKindOf: Trasa) ifFalse: [
            ^BladPodrozy new signal: 'Planer przyjmuje tylko trasy, a otrzymał obiekt klasy ',
                trasa class name].
        trasa jestPusta ifTrue: [
            ^BladPodrozy new signal: 'Nie można dodać do planera pustej trasy'].
        (trasy includes: trasa) ifTrue: [
            ^BladPodrozy new signal: 'Trasa ', trasa nazwa, ' jest już w planerze'].
        trasy add: trasa.
        ^trasa
    ]

    najlepszaWg: kryterium [
        trasy isEmpty ifTrue: [
            ^BladPodrozy new signal: 'Brak tras w planerze: ', nazwa].
        ^trasy inject: trasy first into: [:najlepsza :trasa |
            (kryterium value: trasa) < (kryterium value: najlepsza)
                ifTrue: [trasa]
                ifFalse: [najlepsza]]
    ]

    najszybsza [ ^self najlepszaWg: [:trasa | trasa czas] ]
    najtansza [ ^self najlepszaWg: [:trasa | trasa koszt] ]
    najekologiczniejsza [ ^self najlepszaWg: [:trasa | trasa emisjaCO2] ]

    ranking: kryterium [
        ^trasy asSortedCollection: [:a :b | (kryterium value: a) <= (kryterium value: b)]
    ]

    drukujPorownanie [
        | szer |
        szer := 26.
        Transcript
            showCr: '========== ', nazwa, ' ==========';
            showCr: (Formatuj tekst: 'Wariant' doSzerokosci: szer),
                (Formatuj tekst: 'Czas' doSzerokosci: 10),
                (Formatuj tekst: 'Koszt' doSzerokosci: 11),
                'Emisja';
            showCr: (Formatuj linia: szer + 35).
        trasy do: [:trasa |
            Transcript showCr: (Formatuj tekst: trasa nazwa doSzerokosci: szer),
                (Formatuj tekst: (Formatuj min: trasa czas) doSzerokosci: 10),
                (Formatuj tekst: (Formatuj zl: trasa koszt) doSzerokosci: 11),
                (Formatuj co2: trasa emisjaCO2)].
        Transcript
            showCr: (Formatuj linia: szer + 35);
            showCr: 'Najszybsza:          ', self najszybsza nazwa;
            showCr: 'Najtańsza:           ', self najtansza nazwa;
            showCr: 'Najekologiczniejsza: ', self najekologiczniejsza nazwa
    ]

    drukujRanking: tytul wedlug: kryterium format: formatowanie [
        Transcript showCr: tytul.
        (self ranking: kryterium) keysAndValuesDo: [:miejsce :trasa |
            Transcript showCr: '  ', miejsce printString, '. ',
                (Formatuj tekst: trasa nazwa doSzerokosci: 26),
                (formatowanie value: (kryterium value: trasa))]
    ]
]
