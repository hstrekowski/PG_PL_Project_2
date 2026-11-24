Object subclass: OdcinekPodrozy [
    | skad dokad dystans |

    OdcinekPodrozy class >> jestAbstrakcyjna [
        ^self == OdcinekPodrozy
    ]

    OdcinekPodrozy class >> z: poczatek do: koniec km: kilometry [
        | skadTekst dokadTekst |
        self jestAbstrakcyjna ifTrue: [
            ^BladPodrozy new signal: 'Klasa ', self name,
                ' jest abstrakcyjna - wybierz konkretny środek transportu'].
        skadTekst := BladPodrozy sprawdzTekst: poczatek opis: 'Punkt początkowy'.
        dokadTekst := BladPodrozy sprawdzTekst: koniec opis: 'Punkt końcowy'.
        skadTekst = dokadTekst ifTrue: [
            ^BladPodrozy new signal: 'Punkt początkowy i końcowy nie mogą być takie same: ', skadTekst].
        (kilometry isNumber and: [kilometry > 0]) ifFalse: [
            ^BladPodrozy new signal: 'Dystans musi być liczbą dodatnią, a podano: ',
                kilometry printString].
        ^self basicNew ustawSkad: skadTekst dokad: dokadTekst dystans: kilometry
    ]

    OdcinekPodrozy class >> new [
        ^BladPodrozy new signal: 'Odcinek tworzy się komunikatem ', self name,
            ' z: poczatek do: koniec km: dystans'
    ]

    ustawSkad: poczatek dokad: koniec dystans: kilometry [
        skad := poczatek.
        dokad := koniec.
        dystans := kilometry
    ]

    skad [ ^skad ]
    dokad [ ^dokad ]
    dystans [ ^dystans ]

    nazwa [ ^self subclassResponsibility ]
    predkosc [ ^self subclassResponsibility ]
    koszt [ ^self subclassResponsibility ]
    wspolczynnikCO2 [ ^self subclassResponsibility ]

    czasPrzejazdu [
        ^((dystans / self predkosc * 60) rounded) max: 1
    ]

    czas [
        ^self czasPrzejazdu
    ]

    emisjaCO2 [
        ^dystans * self wspolczynnikCO2
    ]

    opoznienie [
        ^0
    ]

    opoznienie: minuty [
        ^BladPodrozy new signal: self nazwa,
            ' nie kursuje według rozkładu - nie można ustawić opóźnienia'
    ]

    trasaOpis [
        ^skad, ' -> ', dokad
    ]

    szczegoly [
        ^(Formatuj km: dystans), ' | ', (Formatuj min: self czas), ' | ',
            (Formatuj zl: self koszt), ' | ', (Formatuj co2: self emisjaCO2)
    ]

    opis [
        ^self nazwa, ': ', self trasaOpis, ' (', self szczegoly, ')'
    ]

    printOn: aStream [
        aStream nextPutAll: self opis
    ]

    + drugi [
        ^(Trasa zOdcinkami: (OrderedCollection with: self)) + drugi
    ]
]

OdcinekPodrozy subclass: Pieszo [
    nazwa [ ^'Pieszo' ]
    predkosc [ ^5 ]
    koszt [ ^0 ]
    wspolczynnikCO2 [ ^0 ]
]

OdcinekPodrozy subclass: Rower [
    nazwa [ ^'Rower' ]
    predkosc [ ^15 ]
    wspolczynnikCO2 [ ^0 ]
    cenaZaPolGodziny [ ^1 ]

    koszt [
        ^(self czasPrzejazdu / 30) ceiling * self cenaZaPolGodziny
    ]
]

OdcinekPodrozy subclass: OdcinekRozkladowy [
    | opoznienie |

    OdcinekRozkladowy class >> jestAbstrakcyjna [
        ^self == OdcinekRozkladowy
    ]

    ustawSkad: poczatek dokad: koniec dystans: kilometry [
        super ustawSkad: poczatek dokad: koniec dystans: kilometry.
        opoznienie := 0
    ]

    cenaBiletu [ ^self subclassResponsibility ]
    stawkaZaKm [ ^self subclassResponsibility ]

    koszt [
        ^(dystans * self stawkaZaKm) max: self cenaBiletu
    ]

    opoznienie [ ^opoznienie ]

    opoznienie: minuty [
        (minuty isInteger and: [minuty >= 0]) ifFalse: [
            ^BladPodrozy new signal: 'Opóźnienie musi być nieujemną liczbą całkowitą minut, a podano: ',
                minuty printString].
        opoznienie := minuty
    ]

    czas [
        ^super czas + opoznienie
    ]

    szczegoly [
        opoznienie = 0 ifTrue: [^super szczegoly].
        ^super szczegoly, ' | w tym opóźnienie +', (Formatuj min: opoznienie)
    ]
]

OdcinekRozkladowy subclass: Autobus [
    nazwa [ ^'Autobus' ]
    predkosc [ ^24 ]
    cenaBiletu [ ^4.80 ]
    stawkaZaKm [ ^0.25 ]
    wspolczynnikCO2 [ ^70 ]
]

OdcinekRozkladowy subclass: Tramwaj [
    nazwa [ ^'Tramwaj' ]
    predkosc [ ^20 ]
    cenaBiletu [ ^4.80 ]
    stawkaZaKm [ ^0 ]
    wspolczynnikCO2 [ ^25 ]
]

OdcinekRozkladowy subclass: Pociag [
    nazwa [ ^'Pociąg' ]
    predkosc [ ^60 ]
    cenaBiletu [ ^4.80 ]
    stawkaZaKm [ ^0.25 ]
    wspolczynnikCO2 [ ^30 ]
]

OdcinekRozkladowy subclass: TramwajWodny [
    nazwa [ ^'Tramwaj wodny' ]
    predkosc [ ^30 ]
    cenaBiletu [ ^35 ]
    stawkaZaKm [ ^0 ]
    wspolczynnikCO2 [ ^150 ]
]
