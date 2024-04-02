SELECT * FROM film;

SELECT id,titre FROM film;

SELECT 
id as numero,
titre as nom
FROM film;

SELECT 
    id,titre,sortie
    FROM film
    WHERE id=1;

SELECT 
    id,titre,sortie
    FROM film
    LIMIT 2;

SELECT
    id,titre,sortie
    FROM film
    ORDER BY titre;
