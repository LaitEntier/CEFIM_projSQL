# TP99 - location_ski

## Diagramme
![diagram](/img/99%20-%20diagram.svg)
```dbml
Table location_ski.clients {
  noCli integer [primary key, not null]
  nom varchar(30) [not null]
  prenom varchar(30)
  adresse varchar(120)
  cpo varchar(5) [not null]
  ville varchar(80) [not null]
}

Table location_ski.fiches {
  noFic integer [primary key, not null]
  noCli integer [not null]
  dateCrea datetime [not null]
  datePaye datetime
  etat enum [not null]
}

Table location_ski.lignesfic {
  noFic integer [primary key]
  noLig integer [not null]
  refart char(8) [not null]
  depart datetime [not null]
  retour datetime
}

Table location_ski.articles {
  refart char(5) [primary key]
  designation varchar(80) [not null]
  codeGam char(5)
  codeCate char(5)
}

Table location_ski.grilletarifs {
  codeGam char(5) [not null]
  codeCate char(5) [not null]
  codeTarif char(5)
}

Table location_ski.gammes {
  codeGam char(5) [not null]
  libelle varchar(45) [not null]
}

Table location_ski.categories {
  codeCate char(5) [not null]
  libelle varchar(30) [not null]
}

Table location_ski.tarifs {
  codeTarif char(5) [not null]
  libelle varchar(30) [not null]
  prixjour decimal(5) [not null]
}

Ref: "location_ski"."categories"."codeCate" < "location_ski"."grilletarifs"."codeCate"

Ref: "location_ski"."tarifs"."codeTarif" < "location_ski"."grilletarifs"."codeTarif"

Ref: "location_ski"."gammes"."codeGam" < "location_ski"."grilletarifs"."codeGam"

Ref: "location_ski"."grilletarifs"."codeGam" < "location_ski"."articles"."codeGam"

Ref: "location_ski"."grilletarifs"."codeCate" < "location_ski"."articles"."codeCate"

Ref: "location_ski"."articles"."refart" < "location_ski"."lignesfic"."refart"

Ref: "location_ski"."lignesfic"."noFic" > "location_ski"."fiches"."noFic"

Ref: "location_ski"."fiches"."noCli" > "location_ski"."clients"."noCli"
```

## Création BDD

```mysql
-- liste des clients dont le nom commence par d
SELECT * FROM clients WHERE nom LIKE 'd%';

-- nom et prénoms de tout les clients
SELECT nom, prenom FROM clients;

-- liste des fiches(n°, etat) pour les clients(nom,  prenom) qui habitent en Loire Atlantique (44)
SELECT fiches.noFic, fiches.etat, clients.nom, clients.prenom 
FROM fiches
JOIN clients ON fiches.noCli = clients.noCli
WHERE clients.cpo LIKE '44%'; 

-- details de la fiche n°1002
SELECT * FROM fiches WHERE noFic = 1002;

-- prix journalier moyen de location par gamme
SELECT gammes.libelle, AVG(tarifs.prixJour) AS prix_moyen
FROM gammes
JOIN grilletarifs ON gammes.codeGam = grilletarifs.codeGam
JOIN tarifs ON grilletarifs.codeTarif = tarifs.codeTarif
GROUP BY gammes.codeGam;

-- liste des articles qui ont été loués au moins 3 fois
SELECT articles.refart, articles.designation, COUNT(lignesfic.refart) AS nb_locations
FROM articles
JOIN lignesfic ON articles.refart = lignesfic.refart
GROUP BY articles.refart
HAVING nb_locations >= 3;

-- détail de la fiche n°1002 avec le total, si il n'y a pas de date retour, alors on calcule le total jusqu'à aujourd'hui
SELECT fiches.noFic, fiches.etat, clients.nom, clients.prenom, lignesfic.depart, lignesfic.retour, DATEDIFF(IFNULL(lignesfic.retour, CURRENT_DATE), lignesfic.depart) AS nb_jours, SUM(tarifs.prixJour) AS total_par_jour, SUM(tarifs.prixJour) * DATEDIFF(IFNULL(lignesfic.retour, CURRENT_DATE), lignesfic.depart) AS total
FROM fiches
JOIN clients ON fiches.noCli = clients.noCli
JOIN lignesfic ON fiches.noFic = lignesfic.noFic
JOIN articles ON lignesfic.refart = articles.refart
JOIN grilletarifs ON articles.codeGam = grilletarifs.codeGam AND articles.codeCate = grilletarifs.codeCate
JOIN tarifs ON grilletarifs.codeTarif = tarifs.codeTarif
WHERE fiches.noFic = 1002
GROUP BY lignesfic.refart

-- grille des tarifs
SELECT gammes.libelle AS gamme, categories.libelle AS categorie, tarifs.libelle AS tarif, tarifs.prixJour
FROM gammes
JOIN grilletarifs ON gammes.codeGam = grilletarifs.codeGam
JOIN categories ON grilletarifs.codeCate = categories.codeCate
JOIN tarifs ON grilletarifs.codeTarif = tarifs.codeTarif;

-- liste des locations de la catégorie SURF
SELECT fiches.noFic, articles.designation, lignesfic.depart, lignesfic.retour
FROM fiches
JOIN lignesfic ON fiches.noFic = lignesfic.noFic
JOIN articles ON lignesfic.refart = articles.refart
JOIN categories ON articles.codeCate = categories.codeCate
WHERE categories.libelle = 'SURF';

-- calcul du nombre moyen d'articles loués par fiche de location
SELECT AVG(nb_articles) AS nb_moyen_article_par_fiche
FROM (
    SELECT noFic, COUNT(refart) AS nb_articles
    FROM lignesfic
    GROUP BY noFic
) AS nb_articles_par_fiche;

-- calcul du nombre de fiches de location établies pour les catégories de location Ski alpin, Surf, Patinette
SELECT categories.libelle, COUNT(fiches.noFic) AS nb_fiches
FROM fiches
JOIN lignesfic ON fiches.noFic = lignesfic.noFic
JOIN articles ON lignesfic.refart = articles.refart
JOIN categories ON articles.codeCate = categories.codeCate
WHERE categories.libelle IN ('Ski alpin', 'Surf', 'Patinette')
GROUP BY categories.libelle;

-- calcul du montant moyen des fiches de location
SELECT AVG(total) AS montant_moyen_par_fiche
FROM (
    SELECT fiches.noFic, SUM(tarifs.prixJour) AS total
    FROM fiches
    JOIN lignesfic ON fiches.noFic = lignesfic.noFic
    JOIN articles ON lignesfic.refart = articles.refart
    JOIN grilletarifs ON articles.codeGam = grilletarifs.codeGam AND articles.codeCate = grilletarifs.codeCate
    JOIN tarifs ON grilletarifs.codeTarif = tarifs.codeTarif
    GROUP BY fiches.noFic
) AS total_par_fiche;

-- liste des clients (nom, prénom, adresse, code postal, ville) ayant au moins une fiche de location en cours
SELECT DISTINCT clients.nom, clients.prenom, clients.adresse, clients.cpo, clients.ville
FROM clients
JOIN fiches ON clients.noCli = fiches.noCli
WHERE fiches.etat = 'EC';

-- détail de la fiche de location de M. Dupond Jean de Paris (avec la désignation des articles loués, la date de départ et de retour)
SELECT fiches.noFic, articles.designation, lignesfic.depart, lignesfic.retour
FROM fiches
JOIN lignesfic ON fiches.noFic = lignesfic.noFic
JOIN articles ON lignesfic.refart = articles.refart
JOIN clients ON fiches.noCli = clients.noCli
WHERE clients.nom = 'Dupond' AND clients.prenom = 'Jean' AND clients.ville = 'Paris';

-- liste de tous les articles (référence, désignation et libellé de la catégorie) dont le libellé de la catégorie contient ski
SELECT articles.refart, articles.designation, categories.libelle
FROM articles
JOIN categories ON articles.codeCate = categories.codeCate
WHERE categories.libelle LIKE '%ski%';

-- calcul du montant de chaque fiche soldée et du montant total des fiches
SELECT fiches.noFic, SUM(tarifs.prixJour) AS total
FROM fiches
JOIN lignesfic ON fiches.noFic = lignesfic.noFic
JOIN articles ON lignesfic.refart = articles.refart
JOIN grilletarifs ON articles.codeGam = grilletarifs.codeGam AND articles.codeCate = grilletarifs.codeCate
JOIN tarifs ON grilletarifs.codeTarif = tarifs.codeTarif
WHERE fiches.etat = 'SO'
GROUP BY fiches.noFic
WITH ROLLUP;

-- calcul du nombre d’articles actuellement en cours de location
SELECT COUNT(*) AS nb_articles_en_location
FROM lignesfic
WHERE retour IS NULL;

-- calcul du nombre d’articles loués, par client
SELECT clients.nom, clients.prenom, COUNT(lignesfic.refart) AS nb_articles_loues
FROM clients
JOIN fiches ON clients.noCli = fiches.noCli
JOIN lignesfic ON fiches.noFic = lignesfic.noFic
GROUP BY clients.noCli;

-- liste des clients qui ont effectué (ou sont en train d’effectuer) plus de 200€ de location
SELECT clients.noCli, clients.nom, clients.prenom, SUM(tarifs.prixJour) AS cout_total
FROM clients
JOIN fiches ON clients.noCli = fiches.noCli
JOIN lignesfic ON fiches.noFic = lignesfic.noFic
JOIN articles ON lignesfic.refart = articles.refart
JOIN grilletarifs ON articles.codeGam = grilletarifs.codeGam AND articles.codeCate = grilletarifs.codeCate
JOIN tarifs ON grilletarifs.codeTarif = tarifs.codeTarif
HAVING SUM(tarifs.prixJour) > 200;

-- liste des articles qui ont été loués au moins 3 fois
SELECT articles.refart, articles.designation, COUNT(lignesfic.refart) AS nb_locations
FROM articles
JOIN lignesfic ON articles.refart = lignesfic.refart
GROUP BY articles.refart
HAVING nb_locations >= 3
ORDER BY nb_locations DESC;

-- liste des fiches (n°, nom, prénom) de moins de 150€
SELECT fiches.noFic, clients.nom, clients.prenom, SUM(tarifs.prixJour) AS total
FROM fiches
JOIN clients ON fiches.noCli = clients.noCli
JOIN lignesfic ON fiches.noFic = lignesfic.noFic
JOIN articles ON lignesfic.refart = articles.refart
JOIN grilletarifs ON articles.codeGam = grilletarifs.codeGam AND articles.codeCate = grilletarifs.codeCate
JOIN tarifs ON grilletarifs.codeTarif = tarifs.codeTarif
GROUP BY fiches.noFic
HAVING total < 150;

-- calcul de la moyenne des recettes de location de surf (combien peut-on espérer gagner pour une location d'un surf ?)
SELECT AVG(tarifs.prixJour) AS recette_moyenne
FROM articles
JOIN grilletarifs ON articles.codeGam = grilletarifs.codeGam AND articles.codeCate = grilletarifs.codeCate
JOIN tarifs ON grilletarifs.codeTarif = tarifs.codeTarif
WHERE articles.codeCate = 'SURF';

-- calcul de la durée moyenne d'une location d'une paire de skis (en journées entières)
SELECT ROUND(AVG(DATEDIFF(lignesfic.retour, lignesfic.depart))) AS duree_moyenne_arrondie
FROM lignesfic
JOIN articles ON lignesfic.refart = articles.refart
JOIN grilletarifs ON articles.codeGam = grilletarifs.codeGam AND articles.codeCate = grilletarifs.codeCate
JOIN tarifs ON grilletarifs.codeTarif = tarifs.codeTarif
WHERE articles.codeCate = 'FOA' OR articles.codeCate = 'FOP' OR articles.codeCate = 'SA';
```
