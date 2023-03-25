CREATE SCHEMA zadanie23_1;

-- 1 Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko).
-- W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.
CREATE TABLE zadanie23_1.pracownik (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    imie VARCHAR(50),
    nazwisko VARCHAR(50),
    wyplata DOUBLE,
    data_urodzenia DATE,
    stanowisko VARCHAR(50)
);


-- 2 Wstawia do tabeli co najmniej 6 pracowników
INSERT INTO
    zadanie23_1.pracownik (imie, nazwisko, wyplata, data_urodzenia, stanowisko)
VALUES
    ('Jan', 'Kowalski', 4259.50, '1958-03-15', 'mechanik'),
    ('Paweł', 'Nowak', 4599.50, '1988-12-01', 'elektryk'),
    ('Artur', 'Lorens', 6250.00, '1990-03-17', 'automatyk'),
    ('Monika', 'Nowak', 6250.00, '1984-09-30', 'robotyk'),
    ('Jan', 'Michalski', 10125.50, '1975-09-24', 'kierownik'),
    ('Michał', 'Pawłowski', 4259.50, '1991-10-17', 'mechanik'),
    ('Nikodem', 'Schuster', 4599.50, '2000-11-29', 'elektryk')
;

-- 3 Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku
SELECT imie, nazwisko, wyplata, data_urodzenia, stanowisko FROM pracownik order by nazwisko;

-- 4 Pobiera pracowników na wybranym stanowisku
SELECT * FROM pracownik WHERE stanowisko LIKE 'elektryk';

-- 5 Pobiera pracowników, którzy mają co najmniej 30 lat
SELECT * FROM pracownik
WHERE
        (extract(year from curdate()) - 30) > extract(year from data_urodzenia)
   OR
    (
                (extract(year from curdate()) - 30) = extract(year from data_urodzenia)
            AND
                (
                            extract(month from data_urodzenia) > extract(month from curdate())
                        OR
                            (
                                        extract(month from data_urodzenia) = extract(month from curdate())
                                    AND
                                        extract(day from data_urodzenia) > extract(day from curdate())
                                )
                    )
        );

-- 6 Zwiększa wypłatę pracowników na wybranym stanowisku o 10%
UPDATE pracownik
SET
    wyplata = wyplata * 1.1
WHERE
    stanowisko LIKE 'elektryk';

-- 7 Pobiera najmłodszego pracowników
-- (uwzględnij przypadek, że może być kilku urodzonych tego samego dnia)
SELECT * FROM pracownik
WHERE
    data_urodzenia LIKE (SELECT max(data_urodzenia) from pracownik);

-- 8 Usuwa tabelę pracownik
DROP table pracownik;


-- 9 Tworzy tabelę stanowisko
-- (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE table stanowisko (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nazwa_stanowiska VARCHAR(50),
    opis VARCHAR(200),
    wyplata DOUBLE
);


-- 10 Tworzy tabelę adres
-- (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)
CREATE table adres (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    ulica VARCHAR(60),
    kod VARCHAR(6),
    miejscowosc VARCHAR(60)
);

-- 11 Tworzy tabelę pracownik (imię, nazwisko)
-- + relacje do tabeli stanowisko i adres
CREATE table pracownik (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    imie VARCHAR(50),
    nazwisko VARCHAR(50),
    adres_id BIGINT UNIQUE,
    stanowisko_id BIGINT,
    FOREIGN KEY (adres_id) REFERENCES adres(id),
    FOREIGN KEY (stanowisko_id) REFERENCES stanowisko (id)
);

-- 12 Dodaje dane testowe
-- (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)
INSERT INTO
    zadanie23_1.adres (ulica, kod, miejscowosc)
VALUES
    ('Brzozowa 15', '12-345', 'Krakow'),
    ('Wesoła 25/8', '23-456', 'Wieliczka'),
    ('Różana 3', '12-345', 'Krakow'),
    ('Miła 18', '45-678', 'Brzesko'),
    ('Wrocławska 38/250', '12-345', 'Krakow'),
    ('Sw. Mikolaja 65', '56-789', 'Balice'),
    ('Poznanska 36', '34-567', 'Bochnia')
;

INSERT INTO
    zadanie23_1.stanowisko (nazwa_stanowiska, opis, wyplata)
VALUES
    ('mechanik', 'Mechanik przemysłowy, utrzymanie ruchu', 4259.50),
    ('elektryk', 'Elektryk przemysłwy, utrzymane ruchu', 4599.50),
    ('automatyk', 'Programowanie PLC i wizualizacja, usprawnienia na liniach', 6250.00),
    ('robotyk', 'Programowanie robotów FANUC, KUKA i ABB', 6250.00),
    ('kierownik', 'Nadzór nad pracownikami oraz planowanie nowych projektów', 10125.50)
;

INSERT INTO
    zadanie23_1.pracownik (imie, nazwisko)
VALUES
    ('Jan', 'Kowalski'),
    ('Paweł', 'Nowak'),
    ('Artur', 'Lorens'),
    ('Monika', 'Nowak'),
    ('Jan', 'Michalski'),
    ('Michał', 'Pawłowski'),
    ('Nikodem', 'Schuster')
;

UPDATE pracownik SET stanowisko_id = 1 WHERE id IN (1, 6);
UPDATE pracownik SET stanowisko_id = 2 WHERE id IN (2, 7);
UPDATE pracownik SET stanowisko_id = 3 WHERE id = 3;
UPDATE pracownik SET stanowisko_id = 4 WHERE id = 4;
UPDATE pracownik SET stanowisko_id = 5 WHERE id = 5;

-- 13 Pobiera pełne informacje o pracowniku
-- (imię, nazwisko, adres, stanowisko)
SELECT imie, nazwisko, ulica, kod, miejscowosc, nazwa_stanowiska, opis, wyplata
    FROM
        pracownik
    RIGHT JOIN
        adres
    ON
        pracownik.id = adres.id
    RIGHT JOIN
        stanowisko
    ON
        pracownik.stanowisko_id = stanowisko.id;
;

-- 14 Oblicza sumę wypłat dla wszystkich pracowników w firmie
SELECT sum(wyplata) FROM pracownik
    JOIN
        stanowisko
    ON
        pracownik.stanowisko_id = stanowisko.id
;

-- 15 Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 12-345
SELECT imie, nazwisko, ulica, kod, miejscowosc from pracownik
    JOIN
        adres
    ON
        pracownik.id = adres.id
    WHERE
        kod LIKE '12-345'
;