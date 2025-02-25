# Datenbasis erstellen
DROP DATABASE IF EXISTS test;   # DB löschen, wenn sie schon existiert
CREATE DATABASE test;           # DB anlegen

# an die Datenbasis anschließen / nutze die genannte Datenbank
USE test;

# Datentypen
# Zahlen: INT (ganze Zahlen), DOUBLE(Kommazahlen)
# Text: VARCHAR(länge)
# Datum: DATE

# Tabelle anlegen
CREATE TABLE Kunden
    # AttributsName    Datentyp       Bedingung
(
    ID                 INT            AUTO_INCREMENT,
    SVNr               VARCHAR(50)    NOT NULL,
    Vorname            VARCHAR(50)    NULL,
    Nachname           VARCHAR(50)    NOT NULL, # NOT NULL = Pflichtfeld/-attribut
    GebDatum           DATE           NULL,
    Groesse            DOUBLE         NULL,
    PLZ                VARCHAR(10)    NULL,
    City               VARCHAR(128)   DEFAULT 'Karlsruhe',
    LogDateC           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    LogDateU           DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX(Nachname), # wird indiziert und separat in einer Indextabelle gespeichert, wird beim Löschen aber neu indexiert
    UNIQUE(SVNr),    # UNIQUE und PRIMARY KEY sind beides Möglichkeiten einen Schlüssel einzigartig zu machen.
    # Tabellen die die 1er Kardinalität haben, müssen zuerst angelegt werden, damit die Abhänigkeiten beim Erstellen gewahrt werden.
    PRIMARY KEY(ID)
)
    Engine=InnoDB;

CREATE TABLE Bestellungen
    # AttributsName    Datentyp       Bedingung
(
    Bnr                 INT             AUTO_INCREMENT,
    KNr                 INT             NOT NULL,
    Datum               DATE            NULL,
    #PRIMARY KEY(Bnr),
    #FOREIGN KEY(Knr) REFERENCES Kunden(ID) ON DELETE CASCADE ON UPDATE CASCADE # wie kann ich eine referenzielle Integrität sicherstellen?
    # REFERENCES Table(Attr) stellt referenzielle Integrität sicher
    # Delete und Cascade wirkt auf die Tabelle Kunden
)
    Engine=InnoDB;

# Tabellen ändern
ALTER TABLE Bestellungen
ADD COLUMN Versanddatum     DATE        NULL;

# Attribut löschen
ALTER TABLE Bestellungen
DROP COLUMN Datum;

# Attribut ändern
ALTER TABLE Kunden
CHANGE COLUMN SVNr  SozVersNr   VARCHAR(20);

# Index hinzufügen
ALTER TABLE Kunden
ADD INDEX(Nachname);

ALTER TABLE Bestellungen
ADD PRIMARY KEY(Bnr);


SELECT max(LENGTH(Vorname))
from Kunden;
ALTER TABLE Bestellungen
ADD FOREIGN KEY(KNr) REFERENCES Kunden(ID) ON DELETE CASCADE;