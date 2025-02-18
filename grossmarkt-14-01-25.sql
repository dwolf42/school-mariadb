grossmarktgrossmarkt# STRG SHIFT F9

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

# wie viele Einzelartikel gibt es PRO bestellung
SELECT bestellnr, SUM(anzhl) AS AnzahlArtikel
FROM POSITION
GROUP BY bestellnr;

#-------------------------------------------------

#Was kostet der billigste Artikel
SELECT MIN(preis)
FROM artikel;

SELECT preis AS 'Preis des Billigsten'
From artikel
ORDER BY preis ASC
LIMIT 0, 1;


# Welches ist der billigste Artikel
SELECT `name` # ideale lösung, da es mehrere Artikel mit dem nierdrigsten Preis geben kann und die nur in dem Statement berücksichtigt werden!
FROM artikel
WHERE preis = (SELECT MIN(preis)
					FROM artikel);

SELECT artikelnr, `name`, preis
FROM artikel
ORDER BY preis ASC
LIMIT 0, 1;

# wie hoch sind die Frachtkosten PRO Kunde
# SELECT kunden.`name, SUM(bestellungen.Frachtkosten) AS Frachkosten
# FROM kunden JOIN bestellungen
# ON(kunden.KundenNr = bestellungen.KundenNr)
# GROUP BY kunden.`name`, kunden.kundenNr; # hier muss nach Primärschlüssel kunden.Name grupiert werden, um Kunden mit gleichem Namen einzubeziehen. Außerdem nach Kunden.KundenNr, um die Kundennamen dann zuzuordnen

# LÖSCHEN von Datensätzen


# Lösche den Kunden Ernst Handel
# Löschen immer aus den multiplen information_schemainformation_schemaTabellen
SELECT @KNR := kunden.kundenNr
FROM kunden
WHERE `name` = 'Ernst Handel';

#zuerst in Tabelle Positionen löschen
SELECT *
FROM positionen
WHERE bestellnr IN(SELECT bestellnr # bei denen die BestellNr in Bestellungen vorkommt, bei denen wiederrum die Kundennummer KNR entspricht -> ist wie ein JOIN
						FROM bestellungen
						WHERE kundennr = @KNR);
						
# dann in der Tabelle Bestellungen
SELECT * 
FROM bestellungen
WHERE kundennr = @KNR;

# und dann erst in Kunden löschen
SELECT *
FROM kunden
WHERE kundennr = @KNR;

-----

# löschen von Attributswerten!! ist immer ein auf Null setzen

# Anonymisieren eines Kunden
UPDATE kunden
SET `name` = NULL
WHERE `name` = 'Ernst Handel';


# ändern von Attributswerten

# alle Artikel sollen 10% teurer werden
UPDATE artikel
SET preis = preis * 1.1;

# Erhöhung rückgängig machen
UPDATE artikel
SET preis = preis / 1.1;

# alle Gewürze sollen 10% teurer werden
UPDATE artikel
SET preis = round(preis * 1.1, 2)
WHERE kategorieNr = (SELECT Kategorienr
							FROM kategorien
							WHERE `name` = 'gewürze');
			

# alle Gewürze sollen wieder 10% billiger werden			
UPDATE artikel
SET preis = ROUND(preis / 1.1, 2)
WHERE kategorieNr = (SELECT Kategorienr
							FROM kategorien
							WHERE `name` = 'gewürze');

# ACHTUNG beim Ändern von Keys
# Vater-Datensatz
UPDATE kunden
SET kundennr = 2000
WHERE kundennr = 1000;

# Kinder-Datenatz
UPDATE bestellungen
SET kundennr = 2000
WHERE kundennr = 1000;

# Rückgängig machen
UPDATE kunden
SET kundennr = 1000
WHERE kundennr = 2000;

# Kinder-Datenatz
UPDATE bestellungen
SET kundennr = 1000
WHERE kundennr = 2000;


# die zwei Kunden Alfreds Futterkiste auf den mit der Kundennr 1000 umsetzen
SELECT @KNR := kundennr
FROM kunden
WHERE `name` = 'alfreds futterkiste'
		AND
		kundennr <> 1000;
		
UPDATE bestellungen
SET kundennr = 1000
WHERE kundennr = @KNR;

DELETE 
FROM kunden
WHERE kundennr = @KNR;

# für alle Artikel, deren Lagerbestand unter dem Mindestbestand liegen
# den Lagerbestand auf Mindestbestand + 20% setzen
SELECT *
FROM artikel
WHERE langerbestand < mindestbestand;

UPDATE artikel
SET lagerbestand = round(mindestbestand * 1.2, 0) # rund 0, damit INT rauskommt
WHERE lagerbestand < mindestbestand;

# alle Kunden löschen, die keine Bestellungen haben
SELECT *
FROM kunden
WHERE kundennr NOT in (SELECT kundennr 
								FROM bestellungen);
								
DELETE FROM kunden
WHERE kundennr NOT IN (SELECT kundennr
								FROM bestellungen);
								

# anlegen eines neuen Datensatzes

# einen neuen Kunden anlegen
INSERT INTO kunden(Land, `Name`)
VALUES('Deutschland', 'Müller');

# zwei neue Kunden anlegen
INSERT INTO kunden(Land, `Name`)
VALUES('Deutschland', 'Müller'),
		('Italien', 'Giovanni');