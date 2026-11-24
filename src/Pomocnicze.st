Error subclass: BladPodrozy [
    BladPodrozy class >> sprawdzTekst: tekst opis: co [
        ((tekst isString or: [tekst isSymbol]) and: [tekst asString trimSeparators notEmpty]) ifFalse: [
            ^self new signal: co, ' musi być niepustym tekstem, a podano: ', tekst printString].
        ^tekst asString
    ]
]

Object subclass: Formatuj [
    Formatuj class >> liczba: x miejsca: n [
        | mnoznik calosc reszta |
        x < 0 ifTrue: [^'-', (self liczba: x negated miejsca: n)].
        mnoznik := 10 raisedTo: n.
        calosc := (x * mnoznik) rounded.
        n = 0 ifTrue: [^calosc printString].
        reszta := (calosc \\ mnoznik) printString.
        [reszta size < n] whileTrue: [reszta := '0', reszta].
        ^(calosc // mnoznik) printString, ',', reszta
    ]

    Formatuj class >> km: kilometry [
        ^(self liczba: kilometry miejsca: 1), ' km'
    ]

    Formatuj class >> min: minuty [
        ^minuty printString, ' min'
    ]

    Formatuj class >> czas: minuty [
        minuty < 60 ifTrue: [^self min: minuty].
        ^(self min: minuty), ' (', (minuty // 60) printString, ' h ',
            (minuty \\ 60) printString, ' min)'
    ]

    Formatuj class >> zl: kwota [
        ^(self liczba: kwota miejsca: 2), ' zł'
    ]

    Formatuj class >> co2: gramy [
        gramy < 1000 ifTrue: [^(self liczba: gramy miejsca: 0), ' g CO2'].
        ^(self liczba: gramy / 1000 miejsca: 2), ' kg CO2'
    ]

    Formatuj class >> szerokosc: tekst [
        ^tekst inject: 0 into: [:suma :znak |
            (znak value between: 128 and: 191)
                ifTrue: [suma]
                ifFalse: [suma + 1]]
    ]

    Formatuj class >> tekst: tekst doSzerokosci: n [
        ^tekst, (String new: ((n - (self szerokosc: tekst)) max: 0) withAll: $ )
    ]

    Formatuj class >> linia: n [
        ^String new: n withAll: $-
    ]
]
