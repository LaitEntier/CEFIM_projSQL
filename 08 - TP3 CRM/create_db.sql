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
