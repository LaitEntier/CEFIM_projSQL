--Commentaire

-- Norme d'écriture
    -- Snake case
        -- ma_super_base_de_donnees
    -- Camel case
        -- maSuperBaseDeDonnees
    -- Pascal case
        -- MaSuperBaseDeDonnees
    -- Kebab case
        -- ma-super-base-de-donnees
        
-- Nom de la base
-- Nom des tables
-- Nom des champs

CREATE DATABASE videotheque CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- je selectionne ma database : videotheque
USE videotheque;

-- creation table film;
CREATE TABLE film (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    sortie DATE NOT NULL,
) ENGINE=InnoDB;

