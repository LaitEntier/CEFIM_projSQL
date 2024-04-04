# TP3 - CRM Customer Relationship Management

## Diagramme
![diagram](/img/11%20-%20diagram.svg)
```dbml
Table client {
  id integer [primary key]
  nom varchar(255) [not null]
}

Table projet {
  id integer [primary key]
  client_id integer [not null]
  nom varchar(255) [not null]
}

Table devis {
  id integer [primary key]
  version int [not null]
  reference varchar(10) [not null]
  prix float [not null]
  projet_id int [not null]
}

Table facture {
  id integer [primary key]
  reference varchar(10) [not null]
  info varchar(255) [not null]
  total float [not null]
  date_crea date [not null]
  date_paiement date
  devis_id int [not null]
}

Ref: client.id < projet.client_id
Ref: projet.id < devis.projet_id
Ref: devis.id < facture.devis_id
```

## Création de la BDD
```mysql
DROP DATABASE IF EXISTS CRM;

CREATE DATABASE CRM;

USE CRM;

CREATE TABLE client (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE projet (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    client_id INT,
    FOREIGN KEY (client_id) REFERENCES client(id)
) ENGINE=InnoDB;

CREATE TABLE devis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    version INT NOT NULL,
    reference VARCHAR(10) NOT NULL,
    prix FLOAT NOT NULL,
    projet_id INT,
    FOREIGN KEY (projet_id) REFERENCES projet(id)
) ENGINE=InnoDB;

CREATE TABLE facture (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reference VARCHAR(10) NOT NULL,
    info VARCHAR(255) NOT NULL,
    total FLOAT NOT NULL,
    date_crea DATE NOT NULL,
    date_paiement DATE,
    devis_id INT,
    FOREIGN KEY (devis_id) REFERENCES devis(id)
) ENGINE=InnoDB;
```

## Insertion des données
```mysql
DELETE FROM client;
DELETE FROM projet;
DELETE FROM devis;
DELETE FROM facture;

INSERT INTO client (nom) VALUES 
	('Mairie de Rennes'),
	('Neo Soft'),
	('Sopra'),
	('Accenture'),
	('Amazon');

INSERT INTO projet (nom, client_id) VALUES
	('Création de site internet', 1),
	('Creationde site internet', 1),
	('Logiciel CRM', 2),
	('Logiciel de devis', 3),
	('Site internet e-commerce', 4),
	('Logiciel ERP', 2),
	('Logicielgestion de stock',4);

    
INSERT INTO devis (version,reference, prix, projet_id) VALUES
	('1','DEV2100A', 3000, 1),
	('2','DEV2100B', 5000, 2),
	('1','DEV2100C', 5000, 3),
	('1','DEV2100D', 3000, 4),
	('1','DEV2100E', 5000, 5),
	('1','DEV2100F', 2000, 6),
	('1','DEV2100G', 1000, 7);

INSERT INTO facture (reference,info,total,devis_id,date_crea,date_paiement)	
    VALUES
	('FA001', 'site internet partie 1', 1500, 1, '2023-09-01','2023-10-01'),
	('FA002', 'site internet partie 2', 1500, 1, '2023-09-20',null),
	('FA003', 'logiciel CRM', 5000, 2, '2024-02-01',null),
	('FA004', 'logiciel devis', 3000, 3, '2024-03-03','2024-04-03'),
	('FA005', 'site ecommerce', 5000, 4, '2024-04-01',null),
	('FA006', 'logiciel ERP', 2000, 2, '2024-04-01',null);
```

## Requêtes
```mysql
-- afficher toutes les factures avec le nom des clients
SELECT facture.*, client.nom AS nom_client
FROM facture
JOIN devis ON facture.devis_id = devis.id
JOIN projet ON devis.projet_id = projet.id
JOIN client ON projet.client_id = client.id;

-- afficher le nombre de factures par client, afficher 0 factures s'il n'ya pas de factures
SELECT client.nom AS nom_client, COUNT(facture.id) AS nombre_factures
FROM client
LEFT JOIN projet ON client.id = projet.client_id
LEFT JOIN devis ON projet.id = devis.projet_id
LEFT JOIN facture ON devis.id = facture.devis_id
GROUP BY client.id;

-- afficher le chiffre d'affaire par client
SELECT SUM(facture.total) AS chiffre_affaire, client.nom AS nom_client
FROM facture
JOIN devis ON facture.devis_id = devis.id
JOIN projet ON devis.projet_id = projet.id
JOIN client ON projet.client_id = client.id
GROUP BY client.id;

-- afficher le CA total
SELECT SUM(facture.total) AS chiffre_affaire_total
FROM facture;

-- afficher la somme des factures en attente de paiement
SELECT SUM(facture.total) AS total_factures_en_attente
FROM facture
WHERE facture.date_paiement IS NULL;

-- afficher les factures en retard de paiment 30 jours max avec le nombre de jours de retard
SELECT facture.*, DATEDIFF(CURRENT_DATE, facture.date_crea) AS retard
FROM facture
WHERE facture.date_crea IS NOT NULL
AND DATEDIFF(CURRENT_DATE, facture.date_crea) <= 30;
```
