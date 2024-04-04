---
title:  'WDWR projekt'
author: Jakub Ostrzołek
---

## Zadanie 1

### Wyznaczanie średnich dochodów dla każdego z produktów

Rozkład t-Studenta jest ciągły, wiec wartość oczekiwana na przedziale domkniętym
jest taka sama jak wartość oczekiwana na przedziale otwartym.

$$R_1 \sim Tt_{(5;12)}(9,16;4)$$
$$R_2 \sim Tt_{(5;12)}(8,9;4)$$
$$R_3 \sim Tt_{(5;12)}(7,4;4)$$
$$R_4 \sim Tt_{(5;12)}(6,1;4)$$

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
* $N = \{1, 2, ..., m\}$ -- rozpatrywane miesiące ($m = 3$)

Parametry:

* $n_m$ dla $m \in M$ -- liczba dostępnych maszyn $m$ [brak jednostki]
* $t_{mp}$ dla $(m, p) \in MP$ -- jednostkowy czas produkcji produktu $p$ na
    maszynie $m$ [h/szt]
* $R_p$ dla $p \in P$ -- średni jednostkowy dochód za produkt $p$ [zł/szt]
    (wartości obliczone [powyżej](#wyznaczanie-średnich-dochodów-dla-każdego-z-produktów))
* $x^{max}_{pn}$ dla $p \in P, n \in N$ -- maksymalna sprzedaż produktu $p$ w
    miesiącu $n$ [szt]
* $c^{mag} = 1$ -- cena magazynowania jednostki produktu przez miesiąc [zł/szt]
* $m^{max} = 200$ -- maksymalna liczba zmagazynowanych jednostek danego produktu
    na miesiąc [szt]
* $h^{rob} = 24 \cdot 8 \cdot 2 = 348$ -- liczba godzin roboczych w miesiącu [h]
* $m^{start}_{p}$ -- liczba zmagazynowanych produktów $p$ na start (na koniec
    grudnia) [szt]

Zmienne decyzyjne:

* $x_{pn}$ dla $p \in P, n \in N$ -- sprzedaż produktu $p$ w miesiącu $n$ [szt]
* $p_{pn}$ dla $p \in P, n \in N$ -- produkcja produktu $p$ w miesiącu $n$ [szt]
* $m_{pn}$ dla $p \in P, n \in \{0, 1, ..., m\}$ -- liczba zmagazynowanych
    produktów $p$ na koniec miesiąca $m$ [szt]

Ograniczenia:

* $\forall p \in P, n \in N : x_{pn} \ge 0$ -- sprzedaż nieujemna
* $\forall p \in P, n \in N : p_{pn} \ge 0$ -- produkcja nieujemna
* $\forall p \in P, n \in N : m_{pn} \ge 0$ -- stan magazynu nieujemny
* $\forall m \in M, n \in N : \sum_{\{p \: : \: (m, p) \in MP\}} p_{pn} \cdot t_{mp} \le h^{rob} \cdot n_m$
    -- łączny czas użycia maszyny $m$ w miesiącu $n$ nie przekracza liczby roboczych godzin
* $\forall p \in P, n \in N : x_{pn} \le x^{max}_{pn}$ -- sprzedaż produktu $p$
    nie przekracza rynkowego limitu na miesiąc $n$
* $\forall p \in P : m_{p0} = m^{start}_{p}$ -- początkowy stan magazynu dla
    produktu $p$
* $\forall p \in P, n \in N : m_{pn} \le m^{max}$ -- stan magazynu dla produktu
    $p$ nie przekracza limitu na każdy produkt w miesiącu $n$
* $\forall n \in N : (m_{P1n} + m_{P2n}) \cdot (m_{P3n} + m_{P4n}) = 0$
    -- w miesiącu $n$ nie są składowane jednocześnie produkty z grupy $(P1, P2)$
    i $(P3, P4)$
* $\forall n \in N : \sum_{p \in P} p_{pn} + m_{p(n-1)} = \sum_{p \in P} x_{pn} + m_{pn}$
    -- dla każdego miesiąca $n$ produkty wyprodukowane i pozostałe w magazynach
    muszą zostać sprzedane lub zmagazynowane

Cel:

* $max \ \sum_{n \in N}(\sum_{p \in P} (x_{pn} \cdot R_p - m_{pn} \cdot c^{mag}))$
    -- maksymalizacja łącznego zysku, czyli różnicy dochodu ze sprzedaży
    produktów i wydatków na magazynowanie produktów na przestrzeni rozpatrywanych
    miesięcy (koszty magazynowania na miesiąc grudzień pominięte)
