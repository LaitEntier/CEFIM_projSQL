/*
Créer une base de donnée : invitation Créer une table : personne rajouter le prefixe "inv" à votre table

Nou allons créer une liste d'invités pour des soirées VIP

Chaque personne a :

    un prénom
    un nom
    un age
    la date de sont inscription
    un status : Valide ou NON Valide (un booléen)
    un type : membre ou non membre (une énumération)
    une description
    salaire annuel

Créer un fichier SQL

    on efface la base si elle existe
    avec création de la base
    tester votre fichier en l'important dans PhpMyadmin
    uploader votre travail sur GIT
*/

DROP DATABASE IF EXISTS invitation;

CREATE DATABASE invitation CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE invitation;

CREATE TABLE inv_personne (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    prenom VARCHAR(255) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    inscription DATE NOT NULL,
    status_validation BOOLEAN NOT NULL,
    type_ ENUM('membre', 'non membre') NOT NULL,
    description_ins TEXT NOT NULL,
    salaire_annuel DECIMAL(10, 0) NOT NULL
) ENGINE=InnoDB;