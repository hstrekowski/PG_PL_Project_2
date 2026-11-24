| naglowek probuj
  pokazowe
  doPrzystanku tramwajDoDworca pociagNaHel
  doFokarium rowerNaCypel rowerDoPortu
  tramwajWodnyDoGdyni doDworcaGdynia pociagDoGdanska tramwajDoDomu doDomu
  doDworca dojazd zwiedzanie powrot wycieczka
  planer w1Pociag w2Pociag w2Rower w3Pieszo w3Wodny w4Autobus w4Pieszo w4Wodny
  wariant1 wariant2 wariant3 wariant4 |

naglowek := [:tytul |
    Transcript cr; showCr: '#####################################################';
        showCr: '#  ', tytul;
        showCr: '#####################################################'].

probuj := [:opis :akcja |
    [akcja value.
     Transcript showCr: '  ', opis, ' -> brak błędu (nieoczekiwane!)']
        on: BladPodrozy
        do: [:e |
            Transcript showCr: '  ', opis, ' -> BŁĄD: ', e messageText.
            e return: nil]].

naglowek value: 'MODUŁ 1. Środki transportu i polimorfizm'.

Transcript showCr: 'Ten sam komunikat (czas, koszt, emisjaCO2) wysłany do odcinków'; showCr: 'różnych klas na tym samym dystansie 6 km:'.
pokazowe := OrderedCollection new.
pokazowe
    add: (Pieszo z: 'A' do: 'B' km: 6);
    add: (Rower z: 'A' do: 'B' km: 6);
    add: (Autobus z: 'A' do: 'B' km: 6);
    add: (Tramwaj z: 'A' do: 'B' km: 6);
    add: (Pociag z: 'A' do: 'B' km: 6);
    add: (TramwajWodny z: 'A' do: 'B' km: 6).
pokazowe do: [:odcinek |
    Transcript showCr: '  ', (Formatuj tekst: odcinek nazwa doSzerokosci: 15),
        (Formatuj tekst: (Formatuj min: odcinek czas) doSzerokosci: 9),
        (Formatuj tekst: (Formatuj zl: odcinek koszt) doSzerokosci: 10),
        (Formatuj co2: odcinek emisjaCO2)].

Transcript cr; showCr: 'Komunikat opis:'.
Transcript showCr: '  ', (Pociag z: 'Gdańsk Główny' do: 'Hel' km: 105) opis.

Transcript cr; showCr: 'Niepoprawne dane:'.
probuj value: 'Pieszo z: ''Dom'' do: ''Sklep'' km: -2' value: [Pieszo z: 'Dom' do: 'Sklep' km: -2].
probuj value: 'Rower z: ''Dom'' do: ''Sklep'' km: 0' value: [Rower z: 'Dom' do: 'Sklep' km: 0].
probuj value: 'Autobus z: ''Dom'' do: ''Sklep'' km: ''dużo''' value: [Autobus z: 'Dom' do: 'Sklep' km: 'dużo'].
probuj value: 'Tramwaj z: '''' do: ''Sklep'' km: 2' value: [Tramwaj z: '' do: 'Sklep' km: 2].
probuj value: 'Tramwaj z: ''Dom'' do: 42 km: 2' value: [Tramwaj z: 'Dom' do: 42 km: 2].
probuj value: 'Pociag z: ''Hel'' do: ''Hel'' km: 5' value: [Pociag z: 'Hel' do: 'Hel' km: 5].
probuj value: 'Pieszo new (bez danych)' value: [Pieszo new].
probuj value: 'OdcinekPodrozy z: ''A'' do: ''B'' km: 1' value: [OdcinekPodrozy z: 'A' do: 'B' km: 1].
probuj value: 'OdcinekRozkladowy z: ''A'' do: ''B'' km: 1' value: [OdcinekRozkladowy z: 'A' do: 'B' km: 1].

naglowek value: 'MODUŁ 2. Łączenie odcinków - komunikat +'.

doPrzystanku     := Pieszo  z: 'Dom' do: 'Przystanek tramwajowy' km: 0.4.
tramwajDoDworca  := Tramwaj z: 'Przystanek tramwajowy' do: 'Gdańsk Główny' km: 3.
pociagNaHel      := Pociag  z: 'Gdańsk Główny' do: 'Hel' km: 105.

doFokarium       := Pieszo z: 'Hel' do: 'Fokarium' km: 1.2.
rowerNaCypel     := Rower  z: 'Fokarium' do: 'Cypel Helski' km: 3.5.
rowerDoPortu     := Rower  z: 'Cypel Helski' do: 'Port Hel' km: 3.

tramwajWodnyDoGdyni := TramwajWodny z: 'Port Hel' do: 'Gdynia (Skwer Kościuszki)' km: 35.
doDworcaGdynia      := Pieszo  z: 'Gdynia (Skwer Kościuszki)' do: 'Gdynia Główna' km: 1.5.
pociagDoGdanska     := Pociag  z: 'Gdynia Główna' do: 'Gdańsk Główny' km: 21.
tramwajDoDomu       := Tramwaj z: 'Gdańsk Główny' do: 'Przystanek tramwajowy' km: 3.
doDomu              := Pieszo  z: 'Przystanek tramwajowy' do: 'Dom' km: 0.4.

doDworca := doPrzystanku + tramwajDoDworca.
dojazd := doDworca + pociagNaHel.
zwiedzanie := doFokarium + rowerNaCypel + rowerDoPortu.
powrot := tramwajWodnyDoGdyni + doDworcaGdynia + pociagDoGdanska + tramwajDoDomu + doDomu.
wycieczka := (dojazd + zwiedzanie + powrot) nazwana: 'Wycieczka na Hel'.

Transcript showCr: '1) odcinek + odcinek:  doPrzystanku + tramwajDoDworca'.
Transcript showCr: '   -> ', doDworca printString.
Transcript showCr: '2) trasa + odcinek:    doDworca + pociagNaHel'.
Transcript showCr: '   -> ', dojazd printString.
Transcript showCr: '3) trasa + trasa:      dojazd + zwiedzanie + powrot'.
Transcript showCr: '   -> ', wycieczka printString.
Transcript showCr: '4) odcinek + trasa:    doFokarium + (rowerNaCypel + rowerDoPortu)'.
Transcript showCr: '   -> ', (doFokarium + (rowerNaCypel + rowerDoPortu)) printString.

Transcript cr; showCr: 'Każdy wynik to nowy obiekt klasy Trasa, a łączone trasy się nie zmieniły:'.
Transcript showCr: '  klasa wyniku:         ', wycieczka class name.
Transcript showCr: '  wycieczka == dojazd:  ', (wycieczka == dojazd) printString.
Transcript showCr: '  doDworca:   ', doDworca printString.
Transcript showCr: '  dojazd:     ', dojazd printString.
Transcript showCr: '  zwiedzanie: ', zwiedzanie printString.
Transcript showCr: '  powrot:     ', powrot printString.

Transcript cr; showCr: 'Niedozwolone połączenia:'.
probuj value: 'wycieczka + ''taki sobie tekst''' value: [wycieczka + 'taki sobie tekst'].
probuj value: 'dojazd + 7' value: [dojazd + 7].
probuj value: 'doFokarium + nil' value: [doFokarium + nil].
probuj value: 'pociagNaHel + (3 @ 4)' value: [pociagNaHel + (3 @ 4)].

naglowek value: 'MODUŁ 3. Trasa jako agregator'.

Transcript showCr: 'Jedna kolekcja trasy zawiera odcinki różnych klas:'.
Transcript show: '  '.
wycieczka odcinki
    do: [:odcinek | Transcript show: odcinek class name]
    separatedBy: [Transcript show: ', '].
Transcript cr; cr.
wycieczka drukuj.

naglowek value: 'MODUŁ A. Opóźnienia'.

Transcript showCr: 'Czas wycieczki przed opóźnieniami: ', (Formatuj czas: wycieczka czas).
Transcript showCr: 'Pociąg na Hel ma 25 min opóźnienia, tramwaj wodny 10 min...'.
pociagNaHel opoznienie: 25.
tramwajWodnyDoGdyni opoznienie: 10.
Transcript showCr: 'Czas wycieczki po opóźnieniach:    ', (Formatuj czas: wycieczka czas).
Transcript showCr: 'Opóźnione odcinki:'.
wycieczka odcinkiOpoznione do: [:odcinek |
    Transcript showCr: '  ', odcinek nazwa, ': ', odcinek trasaOpis, ' +', (Formatuj min: odcinek opoznienie)].
Transcript cr.
wycieczka drukuj.

Transcript showCr: 'Opóźnienia odrobione (opoznienie: 0):'.
pociagNaHel opoznienie: 0.
tramwajWodnyDoGdyni opoznienie: 0.
Transcript showCr: 'Czas wycieczki: ', (Formatuj czas: wycieczka czas).

Transcript cr; showCr: 'Niepoprawne opóźnienia:'.
probuj value: 'doFokarium opoznienie: 5 (pieszo)' value: [doFokarium opoznienie: 5].
probuj value: 'rowerNaCypel opoznienie: 5 (rower)' value: [rowerNaCypel opoznienie: 5].
probuj value: 'pociagNaHel opoznienie: -10' value: [pociagNaHel opoznienie: -10].
probuj value: 'pociagNaHel opoznienie: 2.5' value: [pociagNaHel opoznienie: 2.5].

naglowek value: 'MODUŁY C, D, E. Planer - alternatywne trasy z Gdańska na Hel'.

w1Pociag := Pociag z: 'Gdańsk Główny' do: 'Hel' km: 105.
wariant1 := (Trasa new + w1Pociag) nazwana: 'Pociąg bezpośredni'.

w2Pociag := Pociag z: 'Gdańsk Główny' do: 'Władysławowo' km: 70.
w2Rower  := Rower  z: 'Władysławowo' do: 'Hel' km: 35.
wariant2 := (w2Pociag + w2Rower) nazwana: 'Pociąg + rower'.

w3Pieszo := Pieszo       z: 'Gdańsk Główny' do: 'Przystań Motława' km: 1.
w3Wodny  := TramwajWodny z: 'Przystań Motława' do: 'Hel' km: 60.
wariant3 := (w3Pieszo + w3Wodny) nazwana: 'Tramwaj wodny z Gdańska'.

w4Autobus := Autobus      z: 'Gdańsk Główny' do: 'Gdynia Główna' km: 24.
w4Pieszo  := Pieszo       z: 'Gdynia Główna' do: 'Gdynia (Skwer Kościuszki)' km: 1.5.
w4Wodny   := TramwajWodny z: 'Gdynia (Skwer Kościuszki)' do: 'Hel' km: 35.
wariant4 := (w4Autobus + w4Pieszo + w4Wodny) nazwana: 'Autobus + tramwaj wodny'.

planer := PlanerPodrozy nazwa: 'Gdańsk Główny -> Hel'.
planer dodaj: wariant1; dodaj: wariant2; dodaj: wariant3; dodaj: wariant4.

planer drukujPorownanie.

Transcript cr; showCr: '--- MODUŁ C. Najszybsza trasa ---'.
planer najszybsza drukuj.

Transcript cr; showCr: '--- MODUŁ D. Najtańsza trasa ---'.
planer drukujRanking: 'Porównanie kosztów (od najtańszej):'
    wedlug: [:trasa | trasa koszt]
    format: [:kwota | Formatuj zl: kwota].
Transcript cr.
planer najtansza drukuj.

Transcript cr; showCr: '--- MODUŁ E. Ekologia ---'.
planer drukujRanking: 'Porównanie emisji CO2 (od najmniejszej):'
    wedlug: [:trasa | trasa emisjaCO2]
    format: [:gramy | Formatuj co2: gramy].
Transcript showCr: 'Najekologiczniejsza: ', planer najekologiczniejsza nazwa.

Transcript cr; showCr: '--- Moduły A + C razem: pociąg bezpośredni ma 40 min opóźnienia ---'.
w1Pociag opoznienie: 40.
planer drukujRanking: 'Ranking czasu przejazdu po opóźnieniu:'
    wedlug: [:trasa | trasa czas]
    format: [:minuty | Formatuj min: minuty].
Transcript showCr: 'Teraz najszybsza jest: ', planer najszybsza nazwa.
w1Pociag opoznienie: 0.

Transcript cr; showCr: 'Niepoprawne operacje na planerze:'.
probuj value: 'planer dodaj: ''Hel'' (tekst)' value: [planer dodaj: 'Hel'].
probuj value: 'planer dodaj: w1Pociag (odcinek, nie trasa)' value: [planer dodaj: w1Pociag].
probuj value: 'planer dodaj: Trasa new (pusta trasa)' value: [planer dodaj: Trasa new].
probuj value: 'planer dodaj: wariant1 (drugi raz)' value: [planer dodaj: wariant1].
probuj value: 'PlanerPodrozy new najszybsza (pusty planer)' value: [PlanerPodrozy new najszybsza].
probuj value: 'PlanerPodrozy new najtansza (pusty planer)' value: [PlanerPodrozy new najtansza].

Transcript cr; showCr: 'Koniec demonstracji.'.
