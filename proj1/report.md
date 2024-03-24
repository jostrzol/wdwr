# MOM projekt 1

Autor: Jakub Ostrzołek

## Zadanie 1

### Model sieci przepływowej

Zadanie można przedstawić w postaci problemu wyznaczenia najtańszego przepływu o
przepływie zadanym równym sumie zapotrzebowań klientów.

$F_{zad} = Z_F + Z_G + Z_H = 35$

Struktura sieci dla tego problemu wygląda następująco.

```{.mermaid scale=2}
flowchart LR
    s((s))
    t((t))
    A((A))
    B((B))
    C((C))
    D((D))
    E((E))
    F((F))
    G((G))
    H((H))

    s -- [10] 0 --> A 
    s -- [13] 0 --> B
    s -- [17] 0 --> C

    A -- [15] 4 --> D
    A -- [10] 2 --> E
    B -- [4] 4 --> D
    B -- [9] 3 --> E
    B -- [9] 8 --> G
    C -- [20] 2 --> D
    C -- [10] 6 --> E
    D -- [10] 3 --> F
    D -- [3] 7 --> G
    D -- [2] 2 --> H
    E -- [20] 5 --> D
    E -- [5] 7 --> F
    E -- [5] 6 --> G
    E -- [5] 3 --> H

    F -- [15] 0 --> t 
    G -- [13] 0 --> t
    H -- [7] 0 --> t
```

Oznaczenia na łukach: `[przepustowość] koszt_jednostkowy`.

### Rozwiązanie

```{.mermaid scale=2}
flowchart LR
    s((s))
    t((t))
    A((A))
    B((B))
    C((C))
    D((D))
    E((E))
    F((F))
    G((G))
    H((H))

    s -- [10/10] 0 --> A
    s -- [10/13] 0 --> B
    s -- [15/17] 0 --> C

    A -- [0/15] 4 --> D
    A -- [10/10] 2 --> E
    B -- [0/4] 4 --> D
    B -- [5/9] 3 --> E
    B -- [5/9] 8 --> G
    C -- [15/20] 2 --> D
    C -- [0/10] 6 --> E
    D -- [10/10] 3 --> F
    D -- [3/3] 7 --> G
    D -- [2/2] 2 --> H
    E -- [0/20] 5 --> D
    E -- [5/5] 7 --> F
    E -- [5/5] 6 --> G
    E -- [5/5] 3 --> H

    F -- [15/15] 0 --> t 
    G -- [13/13] 0 --> t
    H -- [7/7] 0 --> t
```

Oznaczenia na łukach: `[przepływ/przepustowość] koszt_jednostkowy`.

A zatem plan wygląda następująco (planowany transport od wiersza do kolumny w
tyś. ton):

|   | D | E | F | G | H |
|---|---|---|---|---|---|
| A |   | 10|   |   |   |
| B |   | 5 |   | 5 |   |
| C | 15|   |   |   |   |
| D |   |   | 10| 3 | 2 |
| E |   |   | 5 | 5 | 5 |

Co odpowiada łącznemu kosztowi:

$10 \cdot 2 + 5 \cdot 3 + 5 \cdot 8 + 15 \cdot 2 + 10 \cdot 3 + 3 \cdot 7 + 2 \cdot 2 + 5 \cdot 7 + 5 \cdot 6 + 5 \cdot 3 = 240$

### Zadanie programowania liniowego

Parametry

- $V_{kop} = \{A, B, C\}$ -- kopalnie
- $V_{ele} = \{F, G, H\}$ -- elektrownie
- $V_{poś} = \{D, E\}$ -- stacje pośrednie
- $V_{wew} = V_{kop} \cup V_{ele} \cup V_{poś}$ -- węzły wewnętrzne sieci (bez startu i końca)
- $E_{wew} = \{(A, E), (B, E), ..., (E, G), (E, H)\}$ -- wewnętrzne krawędzie sieci
- $E = E_{wew} \cup \{\forall i \in V_{kop} : (s, i)\} \cup \{\forall i \in V_{ele} : (i, t)\}$ -- wszystkie krawędzie sieci
- $t^{wew}_{ij}$ dla $(i, j) \in E_{wew}$ -- przepustowość połączenia między węzłem $i$ a $j$ \[tys. ton\]
- $c^{wew}_{ij}$ dla $(i, j) \in E_{wew}$ -- jednostkowy koszt przesłania towaru między węzłem $i$ a $j$ \[jednostka nieznana\]
- $W_i$ dla $i \in V_{kop}$ -- zdolności wydobywcze kopalni $i$ \[tys. ton\]
- $Z_i$ dla $i \in V_{ele}$ -- średnie dobowe zużycie węgla elektrowni $i$ \[tys. ton\]

Zmienne decyzyjne

- $f_{ij}$ -- przepływ między węzłem $i$ a $j$ \[tys. ton\]

Zmienne pomocnicze

- $t_{ij}$ dla $(i, j) \in E$ -- przepustowość połączenia między węzłem $i$ a $j$ \[tys. ton\]
- $c_{ij}$ dla $(i, j) \in E$ -- jednostkowy koszt przesłania towaru między węzłem $i$ a $j$ \[jednostka nieznana\]

Funkcja celu

- $min \sum_{(i,j) \in E} f_{ij} \cdot c_{ij}$ -- minimalizacja całkowitego
  kosztu

Ograniczenia

- $\forall (i,j) \in E : 0 \le f_{ij} \le t_{ij}$ -- ograniczenie przepustowości
  na węzłach
- $\forall j \in V_{wew} : \sum_{(i, j) \in E} = \sum_{(j, k) \in E}$ -- cały
  towar wchodzący do węzła wewnętrznego musi z niego wyjść
- $\forall i \in V_{ele} : f_{it} = Z_i$ -- trzeba spełnić zapotrzebowanie
  kopalń

Ograniczenia zmiennych pomocniczych:

- $\forall (i,j) \in E_{wew} : t_{ij} = t^{wew}_{ij}$
- $\forall i \in V_{kop} : t_{si} = W_i$
- $\forall i \in V_{ele} : t_{it} = Z_i$
- $\forall (i,j) \in E_{wew} : c_{ij} = c^{wew}_{ij}$
- $\forall i \in V_{kop} : c_{si} = 0$
- $\forall i \in V_{ele} : c_{it} = 0$

### Wąskie gardło

Problem można sprowadzić do zadania wyznaczenia największego przepływu w sieci.
Rozwiązanie podzieli węzły na dwa rozłączne zbiory $S$ i $T$, między którymi
nie będzie już możliwości transportu dodatkowych towarów. Zbiór krawędzi
łączących te 2 zbiory będzie przekrojem o minimalnej przepustowości.

Należy wprowadzić kilka modyfikacji do wcześniejszego grafu:

- usunięcie kosztów (niepotrzebne do tego zadania),
- zmiana $Z_i$ dla każdej z elektrowni na liczbę $N$, większą od przepustowości
  każdego przekroju (dzięki temu zapotrzebowanie elektrowni nie będzie
  ograniczać rozwiązania)
- zmiana $W_i$ dla każdej z kopalń na liczbę $N$, większą od przepustowości
  każdego przekroju (dzięki temu produkcja kopalń nie będzie ograniczać
  rozwiązania)

Poniżej omawiana sieć dla $N = 100$ wraz z wyznaczonymi przepływami.

```{.mermaid scale=2}
flowchart LR
    s((s))
    t((t))
    A((A))
    B((B))
    C((C))
    D((D))
    E((E))
    F((F))
    G((G))
    H((H))

    s -- [25/100] --> A 
    s -- [14/100] --> B
    s -- [0/100] --> C

    A -- [15/15] --> D
    A -- [10/10] --> E
    B -- [0/4] --> D
    B -- [5/9] --> E
    B -- [9/9] --> G
    C -- [0/20] --> D
    C -- [0/10] --> E
    D -- [10/10] --> F
    D -- [3/3] --> G
    D -- [2/2] --> H
    E -- [0/20] --> D
    E -- [5/5] --> F
    E -- [5/5] --> G
    E -- [5/5] --> H

    F -- [15/100] --> t 
    G -- [17/100] --> t
    H -- [7/100] --> t
```

A zatem $S = \{s, A, B, C, D, E\}$, $T = \{F, G, H\}$, czyli poszukiwany
przekrój to $\{(D, F), (D, G), (D, H), (B, G), (E, F), (E, G), (E, H)\}$ o
przepustowości równej $10 + 3 + 2 + 9 + 5 \cdot 3 = 39$. Wartość ta jest
jednocześnie równa maksymalnemu przepływowi w sieci (nieograniczonemu
zapotrzebowaniem ani produkcją towaru).

Maksymalny przepływ $F < N$. Gdyby było inaczej, oznaczałoby to, że wybrane $N$
jest zbyt małe i trzeba powtórzyć obliczenia z większym $N$.
