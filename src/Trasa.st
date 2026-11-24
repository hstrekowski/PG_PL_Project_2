Object subclass: Trasa [
    | odcinki nazwa |

    Trasa class >> new [
        ^self zOdcinkami: #()
    ]

    Trasa class >> zOdcinkami: kolekcja [
        ^self zOdcinkami: kolekcja nazwa: 'Trasa'
    ]

    Trasa class >> zOdcinkami: kolekcja nazwa: tekst [
        | nazwaTekst |
        nazwaTekst := BladPodrozy sprawdzTekst: tekst opis: 'Nazwa trasy'.
        (kolekcja isKindOf: Collection) ifFalse: [
            ^BladPodrozy new signal: 'Trasę tworzy się z kolekcji odcinków, a otrzymano obiekt klasy ',
                kolekcja class name].
        kolekcja do: [:element |
            (element isKindOf: OdcinekPodrozy) ifFalse: [
                ^BladPodrozy new signal: 'Trasa może zawierać tylko odcinki podróży, a otrzymano obiekt klasy ',
                    element class name]].
        ^self basicNew ustawOdcinki: (OrderedCollection new addAll: kolekcja; yourself) nazwa: nazwaTekst
    ]

    ustawOdcinki: kolekcja nazwa: tekst [
        odcinki := kolekcja.
        nazwa := tekst
    ]

    odcinki [
        ^odcinki copy
    ]

    nazwa [ ^nazwa ]

    nazwana: tekst [
        ^Trasa zOdcinkami: odcinki nazwa: tekst
    ]

    liczbaOdcinkow [ ^odcinki size ]
    jestPusta [ ^odcinki isEmpty ]
    poczatek [ ^odcinki isEmpty ifTrue: [nil] ifFalse: [odcinki first skad] ]
    koniec [ ^odcinki isEmpty ifTrue: [nil] ifFalse: [odcinki last dokad] ]

    + drugi [
        | wynik |
        wynik := OrderedCollection new.
        wynik addAll: odcinki.
        (drugi isKindOf: OdcinekPodrozy) ifTrue: [
            wynik add: drugi.
            ^Trasa zOdcinkami: wynik].
        (drugi isKindOf: Trasa) ifTrue: [
            wynik addAll: drugi odcinki.
            ^Trasa zOdcinkami: wynik].
        ^BladPodrozy new signal: 'Nie można dodać do trasy obiektu klasy ',
            drugi class name, ' (oczekiwano odcinka lub trasy)'
    ]

    suma: wartosc [
        ^odcinki inject: 0 into: [:suma :odcinek | suma + (wartosc value: odcinek)]
    ]

    dystans [ ^self suma: [:odcinek | odcinek dystans] ]
    czas [ ^self suma: [:odcinek | odcinek czas] ]
    koszt [ ^self suma: [:odcinek | odcinek koszt] ]
    emisjaCO2 [ ^self suma: [:odcinek | odcinek emisjaCO2] ]
    opoznienie [ ^self suma: [:odcinek | odcinek opoznienie] ]

    odcinkiOpoznione [
        ^odcinki select: [:odcinek | odcinek opoznienie > 0]
    ]

    printOn: aStream [
        aStream nextPutAll: nazwa; nextPutAll: ' ('.
        odcinki isEmpty
            ifTrue: [aStream nextPutAll: 'pusta']
            ifFalse: [aStream nextPutAll: self poczatek; nextPutAll: ' -> '; nextPutAll: self koniec].
        aStream nextPutAll: ', odcinki: '; print: odcinki size; nextPutAll: ')'
    ]

    drukuj [
        Transcript showCr: '--------- ', nazwa, ' ---------'.
        odcinki isEmpty ifTrue: [Transcript showCr: '(pusta trasa)'].
        odcinki keysAndValuesDo: [:nr :odcinek |
            Transcript
                showCr: nr printString, '. ', odcinek nazwa;
                showCr: '    ', odcinek trasaOpis;
                showCr: '    ', odcinek szczegoly].
        Transcript
            showCr: (Formatuj linia: 40);
            showCr: 'Dystans:    ', (Formatuj km: self dystans);
            showCr: 'Czas:       ', (Formatuj czas: self czas).
        self opoznienie > 0 ifTrue: [
            Transcript showCr: '  w tym opóźnienia: ', (Formatuj min: self opoznienie)].
        Transcript
            showCr: 'Koszt:      ', (Formatuj zl: self koszt);
            showCr: 'Emisja:     ', (Formatuj co2: self emisjaCO2);
            showCr: (Formatuj linia: 40)
    ]
]
