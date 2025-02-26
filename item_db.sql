DROP DATABASE IF EXISTS item_db;
CREATE DATABASE item_db;

USE item_db;

DROP TABLE IF EXISTS item_db_usable;

CREATE TABLE item_db_usable
(
    usable_id           INT             AUTO_INCREMENT,
    aegis_name          VARCHAR(256),
    `name`              VARCHAR(256),
    `type`              VARCHAR(256),
    buy                 INT,
    weight              INT,
    script              VARCHAR(1024),
        PRIMARY KEY(usable_id)
);


INSERT INTO item_db_usable
(
    aegis_name, `name`, `type`, buy, weight, script
)
VALUES # that the attributes should have
('Red_potion', 'Red Potion', 'Healing', 50, 70, 'itemheal rand(45,65),0'),
('Orange_Potion', 'Orange Potion', 'Healing', 200, 100, 'itemheal rand(105,145),0');


INSERT INTO item_db_usable
(
    aegis_name, `name`, `type`, buy, weight, script
)
VALUES # that the attributes should have
('Yellow_Potion', 'Yellow Potion', 'Healing', 550, 130, 'itemheal rand(175,235),0'),
('White_Potion', 'White Potion', 'Healing', 1200, 150, 'itemheal rand(325,405), 0');

INSERT INTO item_db_usable
(
    aegis_name, `name`, `type`, buy, weight, script
)
VALUES # that the attributes should have
('Blue_Potion', 'Blue Potion', 'Healing', 5000, 150, 'iemheal 0, rand(40,60), 0');




DROP TABLE IF EXISTS item_db_equip;

CREATE TABLE item_db_equip
(
    equip_id            INT             AUTO_INCREMENT,
    PRIMARY KEY(equip_id),
    aegis_name          VARCHAR(256)    NOT NULL,
    `name`              VARCHAR(256),
    `type`              VARCHAR(256)    NOT NULL,
    sub_type            VARCHAR(256),
    buy                 INT,
    weight              INT             NOT NULL,
    attack            INT             NOT NULL,
    `range`             INT,
    locations           VARCHAR(256),
    weapon_level        INT,
    equip_level_min     INT,
    refinable           BOOLEAN,
    script              VARCHAR(1024)
);

INSERT INTO item_db_equip
(
    aegis_name, `name`, `type`, sub_type, buy, weight, attack, `range`, locations, weapon_level, equip_level_min, refinable, script
)
VALUES # that the attributes should have
('Balmung', 'Balmung', 'Weapon', '2hSword', 20, 1000, 200, 1, 'Both_Hand', 4, 48, true, 'bonus bUnbreakableWeapon, bonus bAtkEle,Ele_Holy');

INSERT INTO item_db_equip
(   aegis_name, `name`, `type`, sub_type, buy, weight, attack, `range`, locations, weapon_level, equip_level_min, refinable, script)
VALUES
('Sleipnir', 'Sleipnir', 'Armor', 20, 3500, 5, 0, 0, 'Chest', 5, 94, true, "bonus bMdef,10, bonus bMaxHPrate,20");


DROP TABLE IF EXISTS item_db_etc;

CREATE TABLE item_db_etc
(
    etc_id              INT             AUTO_INCREMENT,
    PRIMARY KEY(etc_id),
    aegis_name          VARCHAR(256)    NOT NULL,
    `name`              VARCHAR(256)    NOT NULL,
    `type`              VARCHAR(256)    NOT NULL,
    buy                 VARCHAR(256)    NOT NULL,
    weight              INT             NOT NULL,
    flags               VARCHAR(256)    NOT NULL
);


SELECT * FROM item_db_equip
ORDER BY `type` DESC;

SELECT `name`, `type`, buy
FROM item_db_usable
WHERE buy > 200;