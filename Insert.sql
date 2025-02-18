Insert into Kunden(Nachname)
VALUES('Müller');

UPDATE Kunden
SET GebDatum = '2000-01-05';

INSERT INTO Bestellungen(KNr, Datum)
Values (LAST_INSErt_id(), curdate());

delete from Kunden