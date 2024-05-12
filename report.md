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
* $MP = \{(SZ, P1), (WV, P1), (WH, P1), (FR, P1), (SZ, P2), ...\}$ -- maszyny
    wymagane do produkcji danego produktu
* $G = \{G1, G2\}$ -- grupy produktów, z których tylko jedną można magazynować w
    danym miesiącu
* $GP = \{(G1, P1), (G1, P2), (G2, P3), (G2, P4)\}$ -- przypisania produktów do
    grup
* $N = \{1, 2, 3\}$ -- rozpatrywane miesiące

Parametry:

* $n_m \quad m \in M$ -- liczba dostępnych maszyn $m$ [brak jednostki]
* $t_{mp} \quad (m, p) \in MP$ -- jednostkowy czas produkcji produktu $p$ na
    maszynie $m$ [h/szt]
* $R_p \quad p \in P$ -- średni jednostkowy dochód za produkt $p$ [zł/szt]
    (wartości obliczone [powyżej](#wyznaczanie-średnich-jednostkowych-dochodów-dla-każdego-z-produktów))
* $x^{max}_{pn} \quad p \in P, n \in N$ -- maksymalna sprzedaż produktu $p$ w
    miesiącu $n$ [szt]
* $c^{mag} = 1$ -- cena magazynowania jednostki produktu przez miesiąc [zł/szt]
* $m^{max} = 200$ -- maksymalna liczba zmagazynowanych jednostek danego produktu
    na miesiąc [szt]
* $m^{start}_{p}$ -- liczba zmagazynowanych produktów $p$ na start (na koniec
    grudnia) [szt]
* $h^{rob} = 24 \cdot 8 \cdot 2 = 348$ -- liczba godzin roboczych w miesiącu [h]

Zmienne decyzyjne:

* $x_{pn} \quad p \in P, n \in N$ -- liczba sprzedanych produktów $p$ w miesiącu $n$ [szt]
* $p_{pn} \quad p \in P, n \in N$ -- liczba wyprodukowanych produktów $p$ w miesiącu $n$ [szt]
* $m_{pn} \quad p \in P, n \in (\{0\} \cup N)$ -- liczba zmagazynowanych
    produktów $p$ na koniec miesiąca $n$ [szt]
* $u_{gn} \quad g \in G, n \in N$ -- czy grupa produktów $g$ jest magazynowana
    w miesiącu $m$ (zmienna binarna: 0 -- nie, 1 -- tak)

Ograniczenia:

* $x_{pn} \ge 0 \quad \forall p \in P, n \in N$ -- sprzedaż nieujemna
* $p_{pn} \ge 0 \quad \forall p \in P, n \in N$ -- produkcja nieujemna
* $m_{pn} \ge 0 \quad \forall p \in P, n \in N$ -- stan magazynu nieujemny
* $u_{gn} \in \{0, 1\} \quad \forall g \in G, n \in N$ -- zmienna binarna
* $\sum\limits_{\{p \: : \: (m, p) \in MP\}} p_{pn} \cdot t_{mp} \le h^{rob} \cdot n_m \quad \forall m \in M, n \in N$
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
    zmagazynowane

Cel:

* $max \ \sum\limits_{n \in N} \sum\limits_{p \in P} (x_{pn} \cdot R_p - m_{pn} \cdot c^{mag})$
    -- maksymalizacja łącznego zysku, czyli różnicy dochodu ze sprzedaży
    produktów i wydatków na magazynowanie produktów na przestrzeni rozpatrywanych
    miesięcy (koszty magazynowania na miesiąc grudzień pominięte)
