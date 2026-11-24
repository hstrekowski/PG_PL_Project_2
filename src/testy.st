| sprawdz zglaszaBlad bledy pieszo rower autobus a b c d lewa prawa calosc pociag trasa
  planer szybka autobusowa rowerowa |

bledy := 0.
sprawdz := [:warunek :opis |
    warunek
        ifTrue: [Transcript showCr: '[OK]    ', opis]
        ifFalse: [bledy := bledy + 1. Transcript showCr: '[BŁĄD]  ', opis]].
zglaszaBlad := [:blok | [blok value. false] on: BladPodrozy do: [:e | e return: true]].

Transcript showCr: '--- Moduł 1: środki transportu ---'.
pieszo := Pieszo z: 'A' do: 'B' km: 6.
rower := Rower z: 'A' do: 'B' km: 6.
autobus := Autobus z: 'A' do: 'B' km: 6.
sprawdz value: pieszo czas = 72 value: 'pieszo 6 km = 72 min'.
sprawdz value: rower czas = 24 value: 'rower 6 km = 24 min'.
sprawdz value: autobus czas = 15 value: 'autobus 6 km = 15 min'.
sprawdz value: pieszo koszt = 0 value: 'pieszo za darmo'.
sprawdz value: (autobus koszt - 4.80) abs < 0.001 value: 'autobus: bilet 4,80 zł'.
sprawdz value: (zglaszaBlad value: [Pieszo z: 'A' do: 'B' km: -1]) value: 'ujemny dystans = błąd'.
sprawdz value: (zglaszaBlad value: [OdcinekPodrozy z: 'A' do: 'B' km: 1]) value: 'klasa abstrakcyjna = błąd'.

Transcript showCr: '--- Moduł 2: komunikat + ---'.
a := Pieszo z: 'A' do: 'B' km: 1.
b := Rower z: 'B' do: 'C' km: 2.
c := Autobus z: 'C' do: 'D' km: 3.
d := Pociag z: 'D' do: 'E' km: 4.
lewa := a + b.
prawa := c + d.
calosc := lewa + prawa.
sprawdz value: (lewa isKindOf: Trasa) value: 'odcinek + odcinek daje Trasę'.
sprawdz value: (lewa + c) odcinki asArray = (Array with: a with: b with: c) value: 'trasa + odcinek'.
sprawdz value: calosc odcinki asArray = (Array with: a with: b with: c with: d) value: 'trasa + trasa'.
sprawdz value: lewa odcinki asArray = (Array with: a with: b) value: 'lewa trasa niezmieniona'.
sprawdz value: prawa odcinki asArray = (Array with: c with: d) value: 'prawa trasa niezmieniona'.
sprawdz value: (zglaszaBlad value: [calosc + 'taki sobie tekst']) value: 'trasa + tekst = błąd'.
sprawdz value: (zglaszaBlad value: [lewa + 7]) value: 'trasa + liczba = błąd'.

Transcript showCr: '--- Moduł 3: trasa jako agregator ---'.
sprawdz value: (calosc dystans - 10) abs < 0.001 value: 'dystans trasy = suma dystansów'.
sprawdz value: calosc czas = (a czas + b czas + c czas + d czas) value: 'czas trasy = suma czasów'.
sprawdz value: (calosc koszt - (a koszt + b koszt + c koszt + d koszt)) abs < 0.001 value: 'koszt trasy = suma kosztów'.

Transcript showCr: '--- Moduł A: opóźnienia ---'.
pociag := Pociag z: 'B' do: 'C' km: 60.
trasa := a + pociag.
pociag opoznienie: 20.
sprawdz value: pociag czas = 80 value: 'opóźnienie wydłuża czas odcinka'.
sprawdz value: trasa czas = (a czas + 80) value: 'opóźnienie zmienia czas całej trasy'.
sprawdz value: (zglaszaBlad value: [a opoznienie: 5]) value: 'pieszo nie może mieć opóźnienia'.

Transcript showCr: '--- Moduły C, D, E: planer ---'.
szybka := (Pociag z: 'A' do: 'B' km: 100) + (Tramwaj z: 'B' do: 'C' km: 1).
autobusowa := (Autobus z: 'A' do: 'C' km: 50) + (Pieszo z: 'C' do: 'D' km: 1).
rowerowa := (Rower z: 'A' do: 'C' km: 90) + (Pieszo z: 'C' do: 'D' km: 1).
planer := PlanerPodrozy nazwa: 'test'.
planer dodaj: szybka; dodaj: autobusowa; dodaj: rowerowa.
sprawdz value: planer najszybsza == szybka value: 'najszybsza trasa (moduł C)'.
sprawdz value: planer najtansza == rowerowa value: 'najtańsza trasa (moduł D)'.
sprawdz value: planer najekologiczniejsza == rowerowa value: 'najmniejsza emisja CO2 (moduł E)'.
sprawdz value: (Pociag z: 'A' do: 'B' km: 20) emisjaCO2 = (2 * (Pociag z: 'A' do: 'B' km: 10) emisjaCO2)
    value: 'emisja zależy od dystansu'.
sprawdz value: (zglaszaBlad value: [PlanerPodrozy new najszybsza]) value: 'pusty planer = błąd'.
sprawdz value: (zglaszaBlad value: [planer dodaj: 'Hel']) value: 'dodanie tekstu do planera = błąd'.

Transcript cr.
bledy = 0
    ifTrue: [Transcript showCr: 'OK - wszystkie testy zaliczone']
    ifFalse: [Transcript showCr: 'Niezaliczone testy: ', bledy printString].
