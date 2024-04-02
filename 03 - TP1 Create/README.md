# Correction

```mysql
DROP DATABASE IF EXISTS invitation;

CREATE DATABASE invitation CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE invitation;

CREATE TABLE inv_personne (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    prenom VARCHAR(255) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    inscription DATE NOT NULL,
    status_validation BOOLEAN NOT NULL DEFAULT TRUE,
    type_ ENUM('membre', 'non membre') NOT NULL DEFAULT 'non membre',
    description_ins TEXT,
    salaire_annuel INT NOT NULL
) ENGINE=InnoDB;
```
