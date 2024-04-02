-- clear table
DELETE FROM inv_personne;

-- insertion des données
INSERT INTO inv_personne (prenom,nom,age,inscription,status_validation,type_,description_ins,salaire_annuel) VALUES
('Brad', 'PITT', 60, '1970-01-01', TRUE, 'non membre', 'aussi vieux que jean castex', 2000000),
('George', 'CLOONEY', 62, '1999-01-01', TRUE, 'membre', 'juste beau', 4000000),
('Jean','DUJARDIN', 51, '1994-01-01', FALSE, 'membre', 'brice de nice', 1000000);

-- afficher le plus gros salaire (avec MAX)
SELECT MAX(salaire_annuel) FROM inv_personne;

-- afficher le plus petit salaire (avec MIN)
SELECT MIN(salaire_annuel) FROM inv_personne;

-- afficher le nom de la personne du plus petit salaire
SELECT nom FROM inv_personne WHERE salaire_annuel = (SELECT MIN(salaire_annuel) FROM inv_personne);

-- afficher le nom de la personne du plus gros salaire
SELECT nom FROM inv_personne WHERE salaire_annuel = (SELECT MAX(salaire_annuel) FROM inv_personne);

-- afficher le salaire moyen
SELECT AVG(salaire_annuel) FROM inv_personne;

-- afficher le nombre de client
SELECT COUNT(*) FROM inv_personne;

-- proposer une requete avec BETWEEN
SELECT * FROM inv_personne WHERE age BETWEEN 50 AND 60;

-- proposer une requete avec UCASE(), UPPER(),LCASE(),LOWER()
SELECT UCASE(prenom), UPPER(nom), LCASE(description_ins), LOWER(type_) FROM inv_personne;

-- proposer une requete avec LIKE '%..%'
SELECT * FROM inv_personne WHERE description_ins LIKE '%brice%';

-- Trier par age les membres
SELECT * FROM inv_personne WHERE type_ = 'membre' ORDER BY age;