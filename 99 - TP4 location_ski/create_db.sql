DROP DATABASE IF EXISTS location_skis;

CREATE DATABASE IF NOT EXISTS location_skis;

USE location_skis;

CREATE TABLE clients (
    noCli INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(30) NOT NULL,
    prenom VARCHAR(30),
    adresse VARCHAR(120),
    cpo VARCHAR(5) NOT NULL,
    ville VARCHAR(80) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE fiches (
    noFic INT AUTO_INCREMENT PRIMARY KEY,
    noCli INT NOT NULL,
    dateCrea DATETIME NOT NULL,
    datePaye DATETIME,
    etat ENUM('SO', 'EC', 'RE') NOT NULL,
    FOREIGN KEY (noCli) REFERENCES clients(noCli)
) ENGINE=InnoDB;

CREATE TABLE gammes (
    codeGam CHAR(5) PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE categories (
    codeCate CHAR(5) PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tarifs (
    codeTarif CHAR(5) PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL,
    prixJour FLOAT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE grilletarifs (
    codeGam CHAR(5),
    codeCate CHAR(5) NOT NULL,
    codeTarif CHAR(5),
    FOREIGN KEY (codeGam) REFERENCES gammes(codeGam),
    FOREIGN KEY (codeTarif) REFERENCES tarifs(codeTarif),
    FOREIGN KEY (codeCate) REFERENCES categories(codeCate)
) ENGINE=InnoDB;

CREATE TABLE articles (
    refart CHAR(8) PRIMARY KEY,
    designation VARCHAR(80) NOT NULL,
    codeGam CHAR(5),
    codeCate CHAR(5),
    FOREIGN KEY (codeGam) REFERENCES gammes(codeGam),
    FOREIGN KEY (codeCate) REFERENCES categories(codeCate)
) ENGINE=InnoDB;

CREATE TABLE lignesfic (
    noFic INT,
    noLig INT,
    refart CHAR(8) NOT NULL,
    depart DATETIME NOT NULL,
    retour DATETIME,
    FOREIGN KEY (noFic) REFERENCES fiches(noFic),
    FOREIGN KEY (refart) REFERENCES articles(refart)
) ENGINE=InnoDB;