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
(
    # AttributsName    Datentyp       Bedingung
    ID                 INT            AUTO_INCREMENT,
    Vorname            VARCHAR(50)    NULL,
    Nachname           VARCHAR(50)    NOT NULL, # NOT NULL = Pflichtfeld/-attribut
    GebDatum           DATE           NULL,
    Groesse            DOUBLE         NULL,
    PLZ                VARCHAR(10)    NULL,
    City               VARCHAR(128)   DEFAULT 'Karlsruhe',
    LogDate            TIMESTAMP,
    CreatedAt          DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,


    PRIMARY KEY(ID)
)
Engine=InnoDB;

CREATE TABLE Bestellungen
(
    # AttributsName    Datentyp       Bedingung
    Bnr                 INT             AUTO_INCREMENT,
    KNr                 INT             NOT NULL,
    Datum               DATE            NULL,
    PRIMARY KEY(Bnr),
    FOREIGN KEY(Knr) REFERENCES Kunden(ID) ON DELETE CASCADE ON UPDATE RESTRICT # wie kann ich eine referenzielle Integrität sicherstellen?
                                                                                # Ist immer gewahrt, solang man RESTRICT oder CASCADE schreibt
)
Engine=InnoDB;