# STRG SHIFT F9

SELECT *			# *  -> alle Attribute
FROM kunden;   # aus der Tabelle Kunden

# Zeige nzr das Land und den Namen aller Kunden an
SELECT land, name
FROM kunden;

# zeige die LÃ¤nder an, aus denen die Kunden kommen
# gib jedes Land nur einmal aus
SELECT DISTINCT land
FROM kunden;

# ordne nach LÃ¤ndern aufsteigend
SELECT DISTINCT land
FROM kunden
ORDER BY land ASC; # ASC - Ascending -> Aufsteigend

# Ordne nach LÃ¤ndern absteigend
SELECT DISTINCT land
FROM kunden
ORDER BY land DESC; # DESC - Descending -> Absteigend

SELECT `name`, land
FROM kunden
ORDER BY	land, `name` DESC; # ACHTUNG! Default ist ASC (fÃ¼r land), am besten immer dahiner schreiben

# zeige Name und Preis aller Artikel an
# preis soll mit Alias Netto angezeigt werden
# eine weitere Spalte mit gerundetem und in brutto umgerechneten Wert fÃ¼r Preis
SELECT `name`, preis AS Netto, round(preis * 1.19, 2) AS Brutto
FROM artikel
LIMIT 0, 10; # zeigt von AB 0 - WEITERE 10 an oder AB 10, WEIETE 10

# gib alle Artikel aus, die weniger als 10â‚¬ kosten
SELECT `name`, preis
FROM artikel
WHERE preis <= 10
ORDER BY preis ASC;

# alle Artikel zwischen 10â‚¬ und 20â‚¬ kosten
SELECT `name`, preis
FROM artikel
WHERE preis >= 10
		AND
		preis <= 20
ORDER BY preis ASC;

# oder so
SELECT `name`, preis
FROM artikel
WHERE preis BETWEEN 10 AND 20
ORDER BY preis ASC;

# alle Kunden aus Deutland ausgeben
SELECT `name`, land
FROM kunden
WHERE land = 'deutschland';

# alle Kunden aus Deutschland und Italien ausgeben
SELECT `name`, land
FROM kunden
WHERE land = 'deutschland'
		OR
		land = 'italien';

# oder einfacher
SELECT `name`, land
FROM kunden
WHERE land IN('deutschland', 'frankreich', 'italien' 'spanien');

# alle LÃ¤nder die mit D beginnen
SELECT DISTINCT land
FROM kunden
WHERE land LIKE 'd%'; # % ist ein Wildcard, ebenso wie _

# 01.10.24
# Alle Bestellungen von 1.9.1994
SELECT bestellnr, bestelldatum
FROM `bestellungen`
WHERE bestelldatum = '1994-09-01';

# Datumsfunktionen
SELECT CURDATE(), NOW(),
		 YEAR(NOW()),
		 MONTH(NOW()),
		 DAY(NOW()),
		 QUARTER(NOW()),
		 WEEKDAY(NOW());

# Alle Bestellungen von 1994
SELECT bestellnr, bestelldatum
FROM `bestellungen`
WHERE YEAR(bestelldatum) = 1994;

# Alle Bestellungen vom aktuellen Jahr
SELECT bestellnr, bestelldatum
FROM `bestellungen`
WHERE YEAR(bestelldatum) = YEAR(NOW());

# Alle Bestellungen von Jan. 1995
SELECT bestellnr, bestelldatum
FROM `bestellungen`
WHERE YEAR(bestelldatum) = 1995
	AND
	 MONTH(bestelldatum) = 1;


# Alle Bestellungen vom 2. Halbjahr 1995
SELECT bestellnr, bestelldatum
FROM bestellungen
WHERE YEAR(bestelldatum) = 1995
	AND
	MONTH(bestelldatum) > 6;

# Alle Bestellungen vom 2. Quartal 1995
SELECT `bestellnr`, `bestelldatum`
FROM bestellungen
WHERE YEAR(bestelldatum) = 1995
		AND
		(MONTH(bestelldatum) = 4
		OR
		MONTH(bestelldatum) = 5
		OR
		MONTH(bestelldatum) = 6);

# oder einfacher
SELECT bestellnr, bestelldatum
FROM bestellungen
WHERE YEAR(bestelldatum) = 1995
		AND
		QUARTER(bestelldatum) = 2;

# Wochentage ausgeben
SELECT WEEKDAY('1985-09-24'); # Mo -> 0, Di -> 1 ...

# Welche Bestellungen sind am Wochenende eingegangen
SELECT bestellnr, bestelldatum
FROM bestellungen
WHERE WEEKDAY(bestelldatum) > 4;
SELECT DATEDIFF(NOW(),'1985-09-24');

# wie lang dauert Vorgang von Bestelldatum bis Lieferdarum?
SELECT bestellnr, bestelldatum, lieferdatum, DATEDIFF(lieferdatum, bestelldatum) AS Lieferzeit
FROM bestellungen
ORDER BY lieferzeit DESC;

# ------------------------

# wer hat die Bestellung 10248 bestellt?
# ~ mit 2 Statements
SELECT @KNR := kundennr # Variablen beginnen immer mit @
FROM bestellungen
WHERE bestellnr = 10248;

SELECT *
FROM kunden
WHERE kundennr = @KNR;

# ~ in einem Statement (Substatement)
SELECT *
FROM kunden
WHERE kundennr = (SELECT kundennr
						FROM bestellungen
						WHERE bestellnr = 10248);

# welche bestellung gehÃ¶rt welchem Kunden?
SELECT *
FROM bestellungen INNER JOIN kunden
	ON(bestellungen.KundenNr = kunden.Kundennr);

# welche Kunden haben noch nichts bestellt
SELECT `name`
FROM kunden
WHERE kundennr NOT IN (SELECT DISTINCT kundennr
								FROM bestellungen); # im subsatement here suche alle Kundennummern aus Bestellungen und lege mit DISTINCT fest, dass sie einzigartig sein mÃ¼ssen.


# welcher Artikel wurde noch nie bestellt?
SELECT `name`
FROM artikel
WHERE artikelnr NOT IN (SELECT artikelnr
								FROM positionen);

# welcher Kunde hat welche Artikel bestellt?
SELECT kunden.Name, artikel.Name
FROM bestellungen
INNER JOIN kunden
	ON(bestellungen.KundenNr = kunden.KundenNr)
INNER JOIN positionen
	ON(bestellungen.BestellNr = positionen.BestellNr)
INNER JOIN artikel
	ON(artikel.ArtikelNr = positionen.ArtikelNr);

# welche Artikel hat 'Around the Horn' 1995 bestellt?
SELECT kunden.Name, artikel.Name
FROM bestellungen
INNER JOIN kunden
	ON(bestellungen.KundenNr = kunden.KundenNr)
INNER JOIN positionen
	ON(bestellungen.BestellNr = positionen.BestellNr)
INNER JOIN artikel
	ON(artikel.ArtikelNr = positionen.ArtikelNr)
WHERE year(bestellungen.Bestelldatum) = 1995
	AND
	kunden.Name = 'around the horn';

# welcher Lieferant liefert GewÃ¼rze?
SELECT lieferanten.Name
FROM lieferanten
INNER JOIN artikel
	ON(artikel.LieferantenNr = lieferanten.LieferantenNr)
INNER JOIN kategorien
	ON(kategorien.KategorieNr = artikel.KategorieNr)
WHERE kategorien.Name = 'gewÃ¼rze';

SELECT kunden.KundenNr, bestellungen.BestellNr
FROM kunden LEFT JOIN bestellungen
ON kunden.KundenNr = bestellungen.KundenNr;

SELECT kunden.KundenNr, bestellungen.BestellNr
FROM kunden
INNER JOIN bestellungen
ON kunden.KundenNr = bestellungen.KundenNr;

# alle Bestellungen die von Verandfirma 1 ausgeliefert wurden

SELECT bestellungen.Lieferdatum, versandfirmen.`Name`
FROM bestellungen LEFT JOIN versandfirmen
ON bestellungen.VersandFirmenNr = versandfirmen.VersandFirmenNr
WHERE bestellungen.VersandFirmenNr IS NULL;

# welche Artikel wurden von SpeedyExpress versendet?

SELECT DISTINCT versandfirmen.`name` AS Versender, artikel.`name` AS Artikel
FROM versandfirmen JOIN bestellungen
ON bestellungen.VersandFirmenNr = versandfirmen.VersandFirmenNr
JOIN positionen
ON positionen.BestellNr = bestellungen.BestellNr
JOIN artikel
ON artikel.ArtikelNr = positionen.ArtikelNr;


# Aggregatsfunktionen

# Anzahl der Kunden
SELECT COUNT(*) # zÃ¤hlt DatensÃ¤tze
FROM kunden;

# Anzahl der Deutschen Kunden
SELECT COUNT(*)
FROM kunden
WHERE land = 'Deutschland';

SELECT COUNT(*)
FROM kunden LEFT JOIN bestellungen
	ON(kunden.KundenNr = bestellungen.KundenNr);

# Variationen von count()
# Anzahl der Kunden mit Fax
SELECT COUNT(telefax)
FROM kunden;

# wie viele LÃ¤nder gibt es in der Tabelle Kundne
SELECT COUNT(DISTINCT land) AS 'Verschiedene LÃ¤nder'
FROM kunden;

# wie viele Bestellungen gab es im Jahr 1995
SELECT COUNT(*)
FROM bestellungen
WHERE YEAR(bestelldatum) = 1995;

# wie viele Bestellungen hat der Kunden Around the Horn im Jahr 1995 getÃ¤tigt?
SELECT COUNT(*)
FROM bestellungen JOIN kunden
ON bestellungen.KundenNr = kunden.KundenNr
WHERE kunden.`Name` = 'Around the Horn'
AND YEAR(bestellungen.Bestelldatum) = 1995;

# Anzahl der Kunden PRO Land (immer wenn PRO/FÃœR JEDES/JEDEN etc. steht, muss ein GROUP BY verwendet werden)
SELECT land, COUNT(*) # land hier ist nur erlaubt, wenn ich GROUP BY verwende
FROM kunden
GROUP BY land;

# wie viele Bestellungen gibt es PRO Kunde?
# gib nur die Top10 der Kunden aus
SELECT kunden.`Name`, COUNT(*) AS Anzahl
FROM kunden JOIN bestellungen
	ON bestellungen.KundenNr = kunden.KundenNr
GROUP BY kunden.KundenNr, kunden.`Name` # bei Grupierung nach Kunden, immer die Kundennummer ins GROUP BY mitaufnehmen
ORDER BY COUNT(*) DESC
LIMIT 10;

# wie viele Bestellungen gibt es PRO Kunde?
# gib nur die Top10 der Kunden aus dem Jahr 1995 aus
SELECT kunden.`Name`, COUNT(*) AS Anzahl
FROM kunden JOIN bestellungen
	ON bestellungen.KundenNr = kunden.KundenNr
WHERE YEAR(bestellungen.Bestelldatum) = 1995 # im WHERE niemals nach Aggregatfunktion aufÃ¼hren
GROUP BY kunden.KundenNr, kunden.`Name` # bei Grupierung nach Kunden, immer die Kundennummer ins GROUP BY mitaufnehmen
ORDER BY COUNT(*) DESC
LIMIT 10;


SELECT kunden.`Name`, COUNT(*) AS Anzahl
FROM kunden JOIN bestellungen
ON bestellungen.KundenNr = kunden.KundenNr
# WHERE											# WHERE -> Filter auf Attributswerte
GROUP BY kunden.KundenNr, kunden.`Name` # es wird zuerst nach dem Gruppenwert sortiert, dann gruppiert
HAVING COUNT(*) >= 15						# HAVING Filter auf Aggregatfunktion
ORDER BY COUNT(*) DESC;

# wie viele Bestellungen gibt es PRO Jahr
SELECT YEAR(bestelldatum), COUNT(*)
FROM bestellungen
GROUP BY YEAR(bestelldatum);

# wie viele Bestellungen gibt es PRO Jahr und Quartal
SELECT YEAR(bestelldatum), QUARTER(bestelldatum), COUNT(*)
FROM bestellungen
GROUP BY YEAR(bestelldatum), QUARTER(bestelldatum);

