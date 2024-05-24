---
title:  'WDWR projekt'
author: Jakub Ostrzołek
---

## Zadanie 1

### Założenia

Biorąc pod uwagę poniższe fakty:

* koszty pracy przedsiębiorstwa (magazynowania) są niezależne od zmiennej
  losowej $R$ (dochodów jednostkowych produktów),
* liczba produkowanych produktów jest niezależna od zmiennej losowej $R$,

można uprościć złożone zadanie poszukiwania wartości oczekiwanej łącznych zysków
z pracy przedsiębiorstwa. Zamiast tego wystarczy niezależnie obliczyć wartość
oczekiwaną zmiennej losowej $R$ i za pomocą przekształceń matematycznych uzyskać
wartość oczekiwaną zysków. Dzięki temu nie ma potrzeby generowania próbek z
rozkładu $R$ i uśredniania wyniku końcowego metodą numeryczną, a zamiast tego
można obliczyć analitycznie $\mathbb{E}(R)$ i użyć gotowej wartości przy
rozwiązywaniu zadania optymalizacji.

\begin{align}
\mathbb{E}(z) &= \mathbb{E}(d - k) \nonumber \\
              &= \mathbb{E}(d) - k \nonumber \\
              &= \sum\limits_{p \in P} \sum\limits_{n \in N} \mathbb{E}(x_{pn} \cdot R_p) - k \nonumber \\
              &= \sum\limits_{p \in P} \sum\limits_{n \in N} x_{pn} \cdot \mathbb{E}(R_p) - k \nonumber
\end{align}

gdzie:

* $z$ -- łączne zyski z pracy przedsiębiorstwa w rozważanym czasie [zł],
* $d$ -- łączne dochody z pracy przedsiębiorstwa w rozważanym czasie [zł],
* $k$ -- łączne koszty pracy przedsiębiorstwa w rozważanym czasie [zł],
* $x_{pn} \quad p \in P, n \in N$ -- liczba sprzedanych produktów $p$ w miesiącu $n$ [szt],
* $R_p \quad p \in P$ -- jednostkowy dochód za produkt $p$ (zmienna losowa) [zł/szt],
* $P = \{P1, P2, P3, P4\}$ -- produkty,
* $N = \{1, 2, 3\}$ -- rozpatrywane miesiące.

### Wyznaczanie średnich jednostkowych dochodów dla każdego z produktów

Rozkład t-Studenta jest ciągły, więc wartość oczekiwana na przedziale domkniętym
jest taka sama jak wartość oczekiwana na przedziale otwartym.

\begin{align}
R_1 &\sim Tt_{(5;12)}(9,16;4) \nonumber \\
R_2 &\sim Tt_{(5;12)}(8,9;4) \nonumber \\
R_3 &\sim Tt_{(5;12)}(7,4;4) \nonumber \\
R_4 &\sim Tt_{(5;12)}(6,1;4) \nonumber
\end{align}

<!-- $$\mathbb{E}(R_x) = \mu + \sigma \cdot \frac{\Gamma(3/2) \cdot ((4 + (a)^2)^{-3/2} - (4 + (b)^2)^{-3/2}) \cdot 4^2}{2(F_4(b) - F_4(a))\Gamma(2)\Gamma(1/2)}$$ -->
<!-- t_expected_value = lambda mean, std, a, b: mean + std * (math.gamma(3/2) * ((4 + a**2)**(-3/2) - (4 + b**2)**(-3/2)) * 4**2)/(2 * (stats.t.cdf(b, 4) - stats.t.cdf(a, 4)) * math.gamma(2) * math.gamma(1/2)) -->

$$\mathbb{E}(R_1) = 9 + 4 \cdot \frac{\Gamma(3/2) \cdot ((4 + (-1)^2)^{-3/2} - (4 + (\frac{3}{4})^2)^{-3/2}) \cdot 4^2}{2(F_4(\frac{3}{4}) - F_4(-1))\Gamma(2)\Gamma(1/2)} = 8,63$$
$$\mathbb{E}(R_2) = 8 + 3 \cdot \frac{\Gamma(3/2) \cdot ((4 + (-1)^2)^{-3/2} - (4 + (\frac{4}{3})^2)^{-3/2}) \cdot 4^2}{2(F_4(\frac{4}{3}) - F_4(-1))\Gamma(2)\Gamma(1/2)} = 8,30$$
$$\mathbb{E}(R_3) = 7 + 2 \cdot \frac{\Gamma(3/2) \cdot ((4 + (-1)^2)^{-3/2} - (4 + (\frac{5}{2})^2)^{-3/2}) \cdot 4^2}{2(F_4(\frac{5}{2}) - F_4(-1))\Gamma(2)\Gamma(1/2)} = 7,61$$
$$\mathbb{E}(R_4) = 6 + 1 \cdot \frac{\Gamma(3/2) \cdot ((4 + (-1)^2)^{-3/2} - (4 + (6)^2)^{-3/2}) \cdot 4^2}{2(F_4(6) - F_4(-1))\Gamma(2)\Gamma(1/2)} = 6,42$$

### Model rozwiązania

Zbiory:

* $P = \{P1, P2, P3, P4\}$ -- produkty
* $M = \{SZ, WV, WH, FR, TO\}$ -- maszyny (odpowiednio: szlifierki, wiertarki
    pionowe, wiertarki poziome, frezarki, tokarki)
* $G = \{G1, G2\}$ -- grupy produktów, z których tylko jedną można magazynować w
    danym miesiącu
* $GP = \{(G1, P1), (G1, P2), (G2, P3), (G2, P4)\}$ -- przypisania produktów do
    grup
* $N = \{1, 2, 3\}$ -- rozpatrywane miesiące

Parametry:

* $n_m \quad m \in M$ -- liczba dostępnych maszyn $m$ [brak jednostki]
* $t_{mp} \quad m \in M, p \in P$ -- jednostkowy czas produkcji produktu $p$ na
    maszynie $m$ [h/szt]
* $\mathbb{E}(R_p) \quad p \in P$ -- średni jednostkowy dochód za produkt $p$ [zł/szt]
    (wartości obliczone [powyżej](#wyznaczanie-średnich-jednostkowych-dochodów-dla-każdego-z-produktów))
* $x^{max}_{pn} \quad p \in P, n \in N$ -- maksymalna sprzedaż produktu $p$ w
    miesiącu $n$ [szt]
* $c^{mag} = 1$ -- cena magazynowania jednostki produktu przez miesiąc [zł/szt]
* $m^{max} = 200$ -- maksymalna liczba zmagazynowanych jednostek danego produktu
    na miesiąc [szt]
* $m^{start}_{p} \quad p \in P$ -- liczba zmagazynowanych produktów $p$ na start
    (na koniec grudnia) [szt]
* $h^{rob} = 24 \cdot 8 \cdot 2 = 348$ -- liczba godzin roboczych w miesiącu [h]

Zmienne:

* $x_{pn} \in \mathbb{Z} \quad p \in P, n \in N$ -- liczba sprzedanych produktów $p$ w miesiącu $n$ [szt]
* $p_{pn} \in \mathbb{Z} \quad p \in P, n \in N$ -- liczba wyprodukowanych produktów $p$ w miesiącu $n$ [szt]
* $m_{pn} \in \mathbb{Z} \quad p \in P, n \in (\{0\} \cup N)$ -- liczba
    zmagazynowanych produktów $p$ na koniec miesiąca $n$ [szt]
* $u_{gn} \in \{0, 1\} \quad g \in G, n \in N$ -- czy grupa produktów $g$ jest
    magazynowana w miesiącu $n$ (0 -- nie, 1 -- tak)

Ograniczenia:

* $x_{pn} \ge 0 \quad \forall p \in P, n \in N$ -- sprzedaż nieujemna
* $p_{pn} \ge 0 \quad \forall p \in P, n \in N$ -- produkcja nieujemna
* $m_{pn} \ge 0 \quad \forall p \in P, n \in N$ -- stan magazynu nieujemny
* $\sum\limits_{p  \in P} p_{pn} \cdot t_{mp} \le h^{rob} \cdot n_m \quad \forall m \in M, n \in N$
    -- łączny czas użycia maszyny $m$ w miesiącu $n$ nie przekracza liczby roboczych godzin
* $x_{pn} \le x^{max}_{pn} \quad \forall p \in P, n \in N$ -- sprzedaż produktu $p$
    nie przekracza rynkowego limitu na miesiąc $n$
* $m_{p0} = m^{start}_{p} \quad \forall p \in P$ -- początkowy stan magazynu dla
    produktu $p$
* $\sum\limits_{g \in G} u_{gn} \le 1 \quad \forall n \in N$ -- w miesiącu $n$ może być
    wybrana maksymalnie jedna grupa produktów $g$ do magazynowania
* $\sum\limits_{\{p : (g, p) \in GP\}} m_{pn} \le m^{max} \cdot u_{gn} \quad \forall g \in G, n \in N$
    -- produkt $p$ należący do grupy $g$ może być magazynowany maksymalnie w
    liczbie $c^{max}$ szt, jeśli grupa $g$ jest wybrana do magazynowania, lub w
    liczbie 0 szt w przeciwnym wypadku
* $p_{pn} + m_{p(n-1)} = x_{pn} + m_{pn} \quad \forall p \in P, n \in N$
    -- dla każdego miesiąca $n$ i produktu $p$ sztuki wyprodukowane i pozostałe
    w magazynach z poprzedniego miesiąca muszą zostać sprzedane lub
    powtórnie zmagazynowane

Cel:

* $\max \ \sum\limits_{n \in N} \sum\limits_{p \in P} (x_{pn} \cdot \mathbb{E}(R_p) - m_{pn} \cdot c^{mag})$
    -- maksymalizacja łącznego zysku, czyli różnicy dochodu ze sprzedaży
    produktów i wydatków na magazynowanie produktów na przestrzeni rozpatrywanych
    miesięcy (koszty magazynowania na miesiąc grudzień pominięte)

### Wyniki działania modelu

Powyższy model został zaimplementowany w języku AMPL i uruchomiony przy użyciu
solwera CPLEX. Implementacja znajduje się w plikach: `src/z1.{dat,mod,run}`.
Poniżej wyniki działania.

Wartość funkcji celu:

$$\sum\limits_{n \in N} \sum\limits_{p \in P} (x_{pn} \cdot \mathbb{E}(R_p) - m_{pn} \cdot c^{mag}) = 14531 \ [zł]$$

* $x_{pn}, p_{pn}, m_{pn} \quad p \in P, n \in N$ -- liczba sprzedanych,
  wyprodukowanych i zmagazynowanych produktów $p$ w miesiącu $n$ [szt]

  * $n = 1$ (styczeń)

    | $p$ | $x_{p1}$ | $p_{p1}$ | $m_{p1}$ |
    |-----|----------|----------|----------|
    | P1  |      200 |      200 |        0 |
    | P2  |        0 |        0 |        0 |
    | P3  |       50 |      100 |        0 |
    | P4  |      150 |      200 |        0 |

  * $n = 2$ (luty)

    | $p$ | $x_{p2}$ | $p_{p2}$ | $m_{p2}$ |
    |-----|----------|----------|----------|
    | P1  |      300 |      300 |        0 |
    | P2  |      100 |      100 |        0 |
    | P3  |      200 |      200 |        0 |
    | P4  |      200 |      200 |        0 |

  * $n = 3$ (marzec)

    | $p$ | $x_{p3}$ | $p_{p3}$ | $m_{p3}$ |
    |-----|----------|----------|----------|
    | P1  |        0 |        0 |        0 |
    | P2  |      300 |      300 |        0 |
    | P3  |      100 |      100 |        0 |
    | P4  |      200 |      200 |        0 |

* $u_{gn} \quad g \in G, n \in N$ -- czy grupa produktów $g$ jest magazynowana
    w miesiącu $n$ (zmienna binarna: 0 -- nie, 1 -- tak)

  | $g$ \\ $n$ | 1 | 2 | 3 |
  |------------|---|---|---|
  | G1         | 0 | 0 | 0 |
  | G2         | 1 | 1 | 1 |

### Wnioski z wyników

* Ograniczenia na maksymalny obrót produktem zostały w całości wykorzystane.
* Żadne z ograniczeń na maksymalny czas użycia maszyn nie miało znaczenia,
  rzeczywiste wykorzystanie maszyn było zawsze dużo mniejsze niż limit.
* Z poprzedniego punktu wynika, że magazynowanie było zbędne (nie licząc stanu
  magazynu na koniec grudnia). Sama produkcja wysyciła limit na obrót każdym z
  produktów, więc nie było sensu dopłacać za magazynowanie produktów.
* Koszty produkcji są zerowe (brak magazynowania; koszty materiałów nie są
  rozważane w zadaniu).

## Zadanie 2

### Założenia

Tym razem model będzie rozważał również miarę ryzyka przy generacji rozwiązań.
Nie uda się zatem uniknąć generacji próbek (scenariuszy) z rozkładu zmiennej
losowej $R$ jak w przypadku pierwszego zadania, bo nie byłoby sposobu na
obliczenie wartości miary ryzyka.

Rozwiązywane zadanie jest wielokryterialne, należy zatem zastosować jedną z
metod generacji rozwiązań efektywnych dla zadań wielokryterialnych.

Początkowym moim pomysłem było podejście progowe (ograniczenie ryzyka do
kolejnych konkretnych wartości i maksymalizowanie wartości oczekiwanej zysków).
Niestety takie podejście, o ile w tym przypadku zdawało się dawać zadowalające
wyniki, to nie gwarantuje generacji wyłącznie rozwiązań efektywnych. Wynika to z
faktu, że nic nie stoi na przeszkodzie, żeby wygenerowany punkt nie był
zdominowany przez inny punkt o takiej samej wartości oczekiwanej profitu, ale
nieco mniejszym ryzyku.

W związku z powyższym, w końcowym rozwiązaniu zastosowałem zamiast tego metodę
punktu odniesienia. Ma ona tę wadę, że parametry końcowego rozwiązania będą
się z dużym prawdopodobieństwem nieco różnić od zadanych progów, jednak w zamian
wygenerowane rozwiązanie będzie z pewnością rozwiązaniem efektywnym.

Do implementacji metody punktu odniesienia użyłem ,,inżynierskiej'' wersji
maksymalizacji leksykograficznej. Parametr $\epsilon$ reguluje wagę drugiego
kryterium (sumy) w tej metodzie.

### Model rozwiązania

Rdzeń modelu rozwiązania będzie identyczny jak w przypadku zadania 1. Zmiany będą dotyczyły:

* obliczania wartości oczekiwanej dochodów,
* dodania elementów związanych z ryzykiem,
* zmiany funkcji celu na taką zgodną z metodą punktu odniesienia dla
  kryteriów: zysku i ryzyka.

Zbiory:

* $S = \{1, 2, ..., 5000\}$ -- scenariusze
* $V = \{Z, R\}$ -- kryteria do optymalizacji (zyski i ryzyko)

Parametry:

* usunięto: $\mathbb{E}(R_p) \quad p \in P$
* $R_{ps} \quad p \in P, s \in S$ -- jednostkowy dochód za produkt $p$ dla
  scenariusza $s$ [zł/szt]
* $\epsilon$ -- waga drugiego kryterium (sumy) w metodzie punktu odniesienia
  [brak jednostki]
* $\beta$ -- waga dla wartości przekraczających aspiracje w metodzie punktu
  odniesienia [brak jednostki]
* $a_v \quad v \in V$ -- wartość aspiracji kryterium $v$ w metodzie punktu
  odniesienia [zł]
* $\lambda_v \quad v \in V$ -- waga kryterium $v$ w metodzie punktu odniesienia
  [brak jednostki]

Zmienne:

* $r_s \quad s \in S$ -- odchylenie zysków ze scenariusza $s$ od średniej [zł]
* $r_s^+, r_s^- \quad s \in S$ -- odpowiednio ,,nadmiar'' i ,,niedobór'' zysków
  ze scenariusza $s$ w stosunku do średniej [zł]; służą do obliczenia wartości
  bezwzględnej we wzorze na odchylenie przeciętne
* $r^{śr}$ -- wartość odchylenia przeciętnego zysków (miara ryzyka) [zł]
* $z_s \quad s \in S$ -- łączny zysk dla scenariusza $s$ [zł]
* $z^{śr}$ -- wartość oczekiwana łącznego zysku [zł]
* $f_v \quad v \in V$ -- wartości do maksymalizacji w metodzie punktu odniesienia
* $f^{min}$ -- minimum z wartości do maksymalizacji w metodzie punktu odniesienia

Ograniczenia:

* $r_s^+, r_s^- \ge 0 \quad \forall s \in S$ -- ,,nadmiary'' i ,,niedobory''
  zysków są nieujemne
* $r_s = r_s^+ - r_s^- \quad \forall s \in S$ -- odchylenie zysków ze scenariusza $s$ od średniej
  składa się z ,,nadmiaru'' i ,,niedoboru''
* $r_s = z^{śr} - z_s \quad \forall s \in S$ -- obliczanie odchylenia zysków ze
  scenariusza $s$ od średniej
* $r^{śr} = \sum\limits_{s \in S} (r_s^+ + r_s^-) \cdot \frac{1}{|S|}$ --
  obliczanie odchylenia przeciętnego; zakładam, że prawdopodobieństwa
  scenariuszy są jednakowe, dlatego we wzorze występuje dzielenie przez liczność
  scenariuszy
* $z_s = \sum\limits_{n \in N} \sum\limits_{p \in P} (x_{pn} \cdot R_{ps} - m_{pn} \cdot c^{mag}) \quad \forall s \in S$
  -- obliczanie łącznego zysku dla scenariusza $s$; analogicznie jak funkcja
  celu w zadaniu 1, jednak zamiast wartości oczekiwanej zmiennej losowej $R$
  jest wartość konkretnej próbki
* $z^{śr} = \sum\limits_{s \in S} z_s \cdot \frac{1}{|S|}$ -- obliczanie
  średniego łącznego zysku względem wszystkich scenariuszy
* ograniczenia z metody punktu odniesienia:
  * $f_Z \le \lambda_Z (z^{śr} - a_Z)$ -- obliczanie $f_Z$ dla zysku poniżej
    aspiracji
  * $f_Z \le \beta \lambda_Z (z^{śr} - a_Z)$ -- obliczanie $f_Z$ dla zysku powyżej
    aspiracji
  * $f_R \le -\lambda_R (r^{śr} - a_R)$ -- obliczanie $f_R$ dla zysku poniżej
    aspiracji (znak minus, ponieważ minimalizujemy ryzyko)
  * $f_R \le -\beta \lambda_R (r^{śr} - a_R)$ -- obliczanie $f_R$ dla zysku
    powyżej aspiracji (znak minus, ponieważ minimalizujemy ryzyko)
  * $f^{min} \le f_v \quad \forall v \in V$ -- minimalna z wartości do
    maksymalizacji mniejsza od każdej z tych wartości

Cel:

* $lexmax \ (f^{min}, \epsilon \sum\limits_{v \in V} f_v)$ -- funkcja celu dla metody punktu odniesienia: maksymalizacja w pierwszej kolejności minimum z wartości, a w drugiej kolejności sumy wszystkich wartości. Funkcja $lexmax$ jest realizowana metodą ,,inżynierską'' w następujący sposób:

  $$\max \ f^{min} + \epsilon \sum\limits_{v \in V} f_v$$

### Generacja scenariuszy

W celu otrzymania próbek zmiennej losowej $R$ dla poszczególnych scenariuszy,
znalazłem bibliotekę [_Truncated Normal and Student's t-distribution
toolbox_](https://www.mathworks.com/matlabcentral/fileexchange/53796-truncated-normal-and-student-s-t-distribution-toolbox?s_tid=prof_contriblnk)
do programu _MatLab_, która pozwala na generację próbek z wielowymiarowego
rozkładu t-Studenta z ograniczoną dziedziną. Kod generujący próbki znajduje się
w pliku `src/generate_samples.m`, a wynik jego działania jest w plikach
`out/z2-samples.csv`.

Próbki należało również przekształcić do formatu `.dat` w celu odczytania przez
AMPL, dlatego napisałem też skrypt `src/samples_to_dat.py`, który na podstawie
pliku `.csv` generowanego z _MatLaba_ tworzy plik `.dat`.

### Wyniki działania modelu

Powyższy model został zaimplementowany w języku AMPL i uruchomiony przy użyciu
solwera CPLEX. Implementacja znajduje się w plikach: `src/z2.{dat,mod,run}`.
Dodatkowo pliki `src/z2-a.run` i `src/z2-c.run` uruchamiają model dla kilku
wartości aspiracji $a_R$ na potrzeby podpunktów _a_ i _c_. Ze względu na dużą
liczbę scenariuszy, generacja rozwiązań efektywnych może zająć trochę czasu. Na
mojej maszynie jest to ok. 30-40 min.

Nastawy parametrów metody punktu odniesienia z wyjątkiem $a_R$ są dla każdego uruchomienia stałe i równe:

* $\epsilon = 0.0001$ -- wyznaczony eksperymentalnie tak, by drugie kryterium nie
  zakłócało działania pierwszego
* $\beta = 0.001$ -- w moim zastosowaniu nie ma dużo znaczenia, bo i tak zawsze
  wartości aspiracji są nieosiągalne
* $\lambda_R = 1000$, $\lambda_Z = 0.001$ -- większa waga dla miary
  ryzyka zapewnia, że ustawiona wartość aspiracji odchylenia przeciętnego będzie
  bardzo blisko faktycznej wartości odchylenia przeciętnego dla rozwiązania
* $a_Z = 100000$ -- nieosiągalna wartość zysków, dzięki czemu algorytm będzie
  maksymalizował zyski dla ustalonego ryzyka

#### Zbiór rozwiązań efektywnych

W celu wyznaczenia zbioru rozwiązań efektywnych w przestrzeni ryzyko-zysk,
uruchomiłem model dla różnych wartości aspiracji $a_R$. Wyniki dla $a_R \ge 765$
zaczynają się powtarzać, co oznacza że w tym przypadku średni zysk osiągnął już
swoją maksymalną wartość.

| $a_R$ | $r^{śr}$ | $z^{śr}$  | | $a_R$ | $r^{śr}$ | $z^{śr}$  |
|-------|----------|-----------|-|-------|----------|-----------|
| 0     |   0.00   |  -300.0   | | 630   | 629.33   | 12990.7   |
| 15    |  15.00   |  229.82   | | 645   | 644.71   | 13144.7   |
| 30    |  30.02   |  691.63   | | 660   | 659.80   | 13289.0   |
| 45    |  44.92   | 1109.61   | | 675   | 675.04   | 13432.1   |
| 60    |  60.05   | 1533.73   | | 690   | 689.56   | 13559.5   |
| 75    |  75.02   | 1953.56   | | 705   | 704.56   | 13686.8   |
| 90    |  89.96   | 2373.05   | | 720   | 719.76   | 13806.8   |
| 105   | 104.93   | 2792.86   | | 735   | 735.06   | 13933.0   |
| 120   | 119.76   | 3209.00   | | 750   | 749.36   | 14043.3   |
| 135   | 134.95   | 3634.97   | | 765   | 752.70   | 14068.8   |
| ...   | 149.96   | 4054.83   | | 780   | 752.70   | 14068.8   |

<!--
| 0     |   0.00   |  -300.0   |
| 15    |  15.00   |  229.82   |
| 30    |  30.02   |  691.63   |
| 45    |  44.92   | 1109.61   |
| 60    |  60.05   | 1533.73   |
| 75    |  75.02   | 1953.56   |
| 90    |  89.96   | 2373.05   |
| 105   | 104.93   | 2792.86   |
| 120   | 119.76   | 3209.00   |
| 135   | 134.95   | 3634.97   |
| ...   | 149.96   | 4054.83   |
        | 165.00   | 4471.02   |
        | 179.87   | 4878.72   |
        | 194.90   | 5288.76   |
        | 209.98   | 5698.28   |
        | 224.68   | 6097.11   |
        | 239.94   | 6511.27   |
        | 255.04   | 6900.18   |
        | 269.62   | 7233.75   |
        | 284.87   | 7552.70   |
        | 299.93   | 7847.14   |
        | 314.86   | 8126.48   |
        | 329.87   | 8398.99   |
        | 344.86   | 8664.67   |
        | 359.75   | 8921.86   |
        | 374.97   | 9179.05   |
        | 390.05   | 9428.23   |
        | 404.82   | 9668.92   |
        | 419.70   | 9909.13   |
        | 434.84   | 10151.0   |
        | 449.70   | 10385.6   |
        | 464.64   | 10618.9   |
        | 479.72   | 10852.3   |
        | 494.92   | 11086.4   |
        | 509.65   | 11311.8   |
        | 524.43   | 11537.1   |
        | 539.81   | 11770.5   |
        | 554.80   | 11996.6   |
        | 569.89   | 12223.1   |
        | 584.72   | 12441.8   |
        | 600.00   | 12651.2   |
        | 614.66   | 12829.4   |
| 630   | 629.33   | 12990.7   |
| 645   | 644.71   | 13144.7   |
| 660   | 659.80   | 13289.0   |
| 675   | 675.04   | 13432.1   |
| 690   | 689.56   | 13559.5   |
| 705   | 704.56   | 13686.8   |
| 720   | 719.76   | 13806.8   |
| 735   | 735.06   | 13933.0   |
| 750   | 749.36   | 14043.3   |
| 765   | 752.70   | 14068.8   |
| 780   | 752.70   | 14068.8   |
-->

Następnie otrzymane wyniki naniosłem na wykres. Na wykresie odwróciłem oś OX,
żeby kierunek optymalizacji był skierowany intuicyjnie, w stronę pierwszej
ćwiartki układu współrzędnych (ryzyko jest minimalizowane).

![Zbiór rozwiązań efektywnych zadania w przestrzeni ryzyko-zysk](./out/z2-a-plot.png)

Widać, że żadne z wyliczonych rozwiązań nie dominuje żadnego innego, co
sugeruje, że zadanie się udało.

#### Rozwiązanie maksymalnego zysku

znajduje się na wykresie na lewym krańcu zbioru. Posiada ono wartość średniego
zysku $z^{śr} = 14068.8$ zł zbliżoną do wyniku z pierwszego zadania, co sugeruje
poprawność wykonania obu zadań. Wtedy ryzyko wynosi ok. $r^{śr} = 752.70$ zł.

#### Rozwiązanie minimalnego ryzyka

znajduje się na wykresie na prawym krańcu zbioru. Posiada ono ujemną wartość
średniego zysku $z^{śr} = -300$ zł przy zerowym ryzyku. Oznacza to, że dla każdego
ze scenariuszy zysk wynosi $-300$ zł. Takie rozwiązane, o ile efektywne w
zadanym problemie wielokryterialnym, jest oczywiście całkowicie niedopuszczalne
dla każdego rozsądnego decydenta i zdominowane w sensie FSD przez wiele innych
rozwiązań. Prawdopodobnie w wyznaczonym zbiorze istnieje więcej takich
problematycznych przypadków.

#### Analiza dominacji FSD

została przeprowadzona dla 3 rozwiązań. Ich punkty aspiracji ryzyka to: $100$,
$400$ i $740$. Rozwiązania oznaczę odpowiednio $R1$, $R2$ i $R3$. Dzięki
analizie FSD można sprawdzić, czy któreś z nich jest zdominowane przez inne.

Poniżej fragment tabeli posortowanych niemalejąco ocen dla wybranych rozwiązań.

| $R1$    | $R2$    | $R3$    |
|---------|---------|---------|
| 2246.26 | 7904.41 | 10159.3 |
| 2247.94 | 7928.13 | 10203.0 |
| 2266.48 | 8058.30 | 10280.3 |
| 2269.86 | 8061.10 | 10313.1 |
| 2289.78 | 8079.48 | 10375.5 |
| 2298.24 | 8092.72 | 10441.8 |
| ...     | ...     | ...     |
| 3052.70 | 11078.6 | 14975.6 |
| 3058.01 | 11137.9 | 15000.1 |
| 3070.03 | 11210.5 | 15167.0 |
| 3070.12 | 11240.9 | 15279.7 |
| 3077.59 | 11479.9 | 15386.3 |
| 3097.90 | 11484.4 | 15412.4 |

Po przeanalizowaniu całości tabeli widać, że $R1 \prec_a R2 \prec_a R3$, bo $y_{R1} \le y_{R2} \le y_{R3}$.
Jako że zadanie jest sprowadzalne do problemu wyboru jednakowo prawdopodobnych
loterii, to można wywnioskować, że również $R1 \prec_{FSD} R2 \prec_{FSD} R3$,
jednak poniższy wykres dystrybuanty zysków pokazuje to lepiej.

![Dystrybuanta zysków wybranych rozwiązań efektywnych zadania](./out/z2-c-plot.png)

Dystrybuanta również jednoznacznie pokazuje, że $R1 \prec_{FSD} R2 \prec_{FSD}
R3$. Aby otrzymywać jedynie rozwiązania FSD-efektywne, należałoby zmienić
podejście generacji rozwiązań lub w jakiś sposób odfiltrować rozwiązania
nie-FSD-efektywne.
