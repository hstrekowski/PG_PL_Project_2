# GoSmall – jednodniowa wycieczka z Gdańska na Hel

Scenariusz: wyjazd z domu w Gdańsku tramwajem na dworzec, pociągiem na Hel,
zwiedzanie (Fokarium, Cypel Helski) pieszo i rowerem, powrót tramwajem wodnym przez
Zatokę do Gdyni i pociągiem do Gdańska. Planer porównuje też 4 alternatywne sposoby
dojazdu z Gdańska na Hel.

## Wybrane moduły

- Moduły podstawowe: **1** (środki transportu i dziedziczenie), **2** (łączenie odcinków – komunikat `+`), **3** (trasa jako agregator)
- Moduły dodatkowe: **A** (opóźnienia), **C** (najszybsza trasa), **D** (najtańsza trasa), **E** (ekologia – emisja CO2)

## Uruchomienie (Linux / Fedora)

Do uruchomienia potrzebny jest interpreter GNU Smalltalk (`gst`). Fedora nie oferuje go
jako gotowego pakietu, dlatego skrypt pobiera go ze strony GNU i instaluje
(jednorazowo, ok. 2–3 min, wymaga `sudo`):

```bash
bash instaluj_gst.sh
```

Demonstracja wszystkich modułów:

```bash
bash uruchom.sh
```

Testy automatyczne:

```bash
bash uruchom.sh testy
```

Bez skryptu (z katalogu głównego projektu):

```bash
gst -g src/Pomocnicze.st src/Odcinki.st src/Trasa.st src/PlanerPodrozy.st src/main.st
```

Na Windowsie projekt działa w WSL (np. `wsl --install FedoraLinux-45`) tymi samymi poleceniami.

## Struktura

```
src/Pomocnicze.st     BladPodrozy (wyjątek), Formatuj (liczby po polsku: 4,80 zł)
src/Odcinki.st        hierarchia odcinków podróży
src/Trasa.st          Trasa – kolekcja odcinków, komunikat +
src/PlanerPodrozy.st  planer alternatywnych tras
src/main.st           demonstracja wszystkich modułów
src/testy.st          testy automatyczne
PDF/                  materiały z zajęć i treść zadania
```

## Hierarchia klas

```
OdcinekPodrozy              (abstrakcyjna) skad, dokad, dystans
├── Pieszo                  5 km/h, 0 zł, 0 g CO2/km
├── Rower                   15 km/h, 1 zł za każde rozpoczęte 30 min, 0 g CO2/km
└── OdcinekRozkladowy       (abstrakcyjna) + opoznienie, taryfa: stawka za km, min. cena biletu
    ├── Autobus             24 km/h, 0,25 zł/km (min. 4,80 zł), 70 g CO2/km
    ├── Tramwaj             20 km/h, 4,80 zł, 25 g CO2/km
    ├── Pociag              60 km/h, 0,25 zł/km (min. 4,80 zł), 30 g CO2/km
    └── TramwajWodny        30 km/h, 35 zł, 150 g CO2/km

Trasa                       uporządkowana kolekcja odcinków dowolnych klas
PlanerPodrozy               alternatywne trasy: najszybsza, najtansza, najekologiczniejsza
```

Prędkości, ceny, emisje i odległości są przyjęte w uproszczeniu.

## Plan wycieczki

**Dojazd**

| # | Transport | Skąd → dokąd | Dystans | Czas | Koszt |
|:-:|---|---|--:|--:|--:|
| 1 | Pieszo | Dom → Przystanek tramwajowy | 0,4 km | 5 min | 0,00 zł |
| 2 | Tramwaj | Przystanek tramwajowy → Gdańsk Główny | 3,0 km | 9 min | 4,80 zł |
| 3 | Pociąg | Gdańsk Główny → Hel | 105,0 km | 105 min | 26,25 zł |

**Zwiedzanie Helu**

| # | Transport | Skąd → dokąd | Dystans | Czas | Koszt |
|:-:|---|---|--:|--:|--:|
| 4 | Pieszo | Hel → Fokarium | 1,2 km | 14 min | 0,00 zł |
| 5 | Rower | Fokarium → Cypel Helski | 3,5 km | 14 min | 1,00 zł |
| 6 | Rower | Cypel Helski → Port Hel | 3,0 km | 12 min | 1,00 zł |

**Powrót**

| # | Transport | Skąd → dokąd | Dystans | Czas | Koszt |
|:-:|---|---|--:|--:|--:|
| 7 | Tramwaj wodny | Port Hel → Gdynia (Skwer Kościuszki) | 35,0 km | 70 min | 35,00 zł |
| 8 | Pieszo | Gdynia (Skwer Kościuszki) → Gdynia Główna | 1,5 km | 18 min | 0,00 zł |
| 9 | Pociąg | Gdynia Główna → Gdańsk Główny | 21,0 km | 21 min | 5,25 zł |
| 10 | Tramwaj | Gdańsk Główny → Przystanek tramwajowy | 3,0 km | 9 min | 4,80 zł |
| 11 | Pieszo | Przystanek tramwajowy → Dom | 0,4 km | 5 min | 0,00 zł |

> **Razem:** 177 km · 282 min (4 h 42 min) · 78,10 zł · 9,18 kg CO2
>
> **Moduł A:** pociąg na Hel +25 min i tramwaj wodny +10 min opóźnienia → 317 min (5 h 17 min)

### Planer – 4 warianty dojazdu Gdańsk Główny → Hel

| Wariant | Czas | Koszt | Emisja CO2 |
|---|--:|--:|--:|
| Pociąg bezpośredni | **105 min** (najszybsza) | 26,25 zł | 3,15 kg |
| Pociąg + rower (przez Władysławowo) | 210 min | **22,50 zł** (najtańsza) | **2,10 kg** (najmniejsza emisja) |
| Tramwaj wodny z Gdańska (z Motławy) | 132 min | 35,00 zł | 9,00 kg |
| Autobus + tramwaj wodny (przez Gdynię) | 148 min | 41,00 zł | 6,93 kg |

Gdy pociąg bezpośredni ma 40 min opóźnienia, najszybszy staje się tramwaj wodny (132 min).
