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