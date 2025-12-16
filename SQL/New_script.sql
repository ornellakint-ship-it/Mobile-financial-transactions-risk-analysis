/*******************************************************************************
 * PROJET : Analyse exploratoire de comportements suspects sur les Transactions Mobiles financièrew
 * FICHIER : New_script.sql
 * DATE : 2025-12-16 (Dernière Mise à Jour)
 * AUTEUR : Ornella KINTOMONHO
 *
 * OBJECTIF GLOBAL :
 * Détecter et quantifier les signaux de fraude potentiels au sein des
 * transactions , en se concentrant spécifiquement sur les données du Bénin.
 * Les signaux sont basés sur des anomalies de montant, de temps, de volume et
 * d'appareils utilisés.
 *
 * TABLE ANALYSÉE :
 * - dataset_fraude_benin (créée à partir de dataset_fraude_momo, filtrée sur 'Benin')
 *
 * METHODOLOGIE CLÉS :
 * -------------------
 * 1. Détection de rapidité (Volume suspect dans un intervalle de 24h).
 * 2. Détection d'anomalie de montant (Méthode des 3 Écarts-Types / Z-Score).
 * 3. Détection d'activité inhabituelle + transfert de sommes importantes (Transactions nocturnes: 00h00 à 04h59).
 * 4. Détection de compromission de compte (Utilisation de > 5 appareils distincts).
 *
 * SEUILS UTILISÉS :
 * ----------------
 * - Seuil de rapidité : Moins de 300 secondes (5 minutes) entre transactions.
 * - Seuil de montant suspect : > 9221.55 (Déterminé par Mu + 3*Sigma).
 * - Seuil d'appareils : > 5 appareils par id_client.
 *
 * INSIGHTS CLÉS OBTENUS :
 * --------------------------------------------------
 * -- Nombre de clients utilisant > 5 appareils : 393 (6.14% des clients).
 * -- Nombre de transactions importantes/nocturnes : 1340 (20.93% des transactions nocturnes).
 * -- Montant maximum identifié comme outlier (Z > 3) : [9222 f]
 * -- Nombre de transactions rapides suspectes : 363
 * -- Nombre de transactions rapides suspectes par villes: Parakou: 61, Djougou: 57, Abomey-Calavi: 56, Bohicon: 54, Nati:51, Porto: 51, Cotonou:33
 * -- Pourcentage de transactions rapides suspectes : 5,67%
 * -- Nombre de transactions rapides suspectes par canal: USSD: 163, Appli mobiles: 121, API_partenaire: 60, agents: 19
 * -- Pourcentage de transactions suspectes rapides par canal: USSD: 44,90%, Applis: 33,33%, APIs: 16,52%, agents: 5,23%
 ******************************************************************************/

SELECT *
FROM dataset_fraude_momo
;

-- Création d'une table avec les entrées du Benin uniquement
CREATE TABLE dataset_fraude_benin AS
SELECT * 
FROM dataset_fraude_momo
WHERE pays = 'Benin'
;


-- Réattribution des types aux colonnes
-- Modifying the types of id_agent and id_client, from text to varchar
ALTER TABLE dataset_fraude_momo
MODIFY id_agent VARCHAR(10),
MODIFY id_client VARCHAR(10)
;

-- Same for timestamp_transaction
ALTER TABLE dataset_fraude_momo
MODIFY timestamp_transaction DATETIME
;

-- Same for id_appareil
ALTER TABLE dataset_fraude_momo
MODIFY id_appareil VARCHAR(10)
;



-- Identification de transactions multiples et rapides dans un court délai de temps, ici 5 mins, par agent et par ville
WITH Transactions_Consecutive AS (
    SELECT id_agent, timestamp_transaction, ville,  -- Récupère la date de la transaction PRÉCÉDENTE pour le même agent
        LAG(timestamp_transaction, 1, timestamp_transaction) OVER (PARTITION BY id_agent ORDER BY timestamp_transaction
        ) AS date_precedente
    FROM dataset_fraude_benin
),
Transactions_Suspectes AS (
    SELECT
        id_agent, ville, -- Calcule le temps écoulé entre les transactions consécutives
        TIMESTAMPDIFF(SECOND, date_precedente, timestamp_transaction) AS temps_ecoule_secondes
    FROM Transactions_Consecutive
    WHERE
        -- Filtre les cas où l'intervalle est > 0 et < 300 secondes (5 minutes)
        TIMESTAMPDIFF(SECOND, date_precedente, timestamp_transaction) > 0
        AND TIMESTAMPDIFF(SECOND, date_precedente, timestamp_transaction) < 300
)
SELECT id_agent, ville, 
COUNT(*) AS Nombre_Transactions_Rapides_Suspectes
FROM Transactions_Suspectes
GROUP BY id_agent, ville
ORDER BY Nombre_Transactions_Rapides_Suspectes DESC
;

-- Identification de transactions multiples et rapides dans un court délai de temps, ici 5 mins, par canal
WITH Transactions_Consecutive AS (
    SELECT id_agent, timestamp_transaction, canal,   -- Récupère le canal
        LAG(timestamp_transaction, 1, timestamp_transaction) OVER (PARTITION BY id_agent ORDER BY timestamp_transaction
        ) AS date_precedente
    FROM dataset_fraude_benin
),
Transactions_Suspectes AS (
    SELECT
        id_agent, canal, 
        TIMESTAMPDIFF(SECOND, date_precedente, timestamp_transaction) AS temps_ecoule_secondes -- Calcule le temps écoulé entre les transactions consécutives
    FROM Transactions_Consecutive
    WHERE
        -- Filtre les cas où l'intervalle est > 0 et < 300 secondes (5 minutes)
        TIMESTAMPDIFF(SECOND, date_precedente, timestamp_transaction) > 0
        AND TIMESTAMPDIFF(SECOND, date_precedente, timestamp_transaction) < 300
)
SELECT id_agent, canal, 
COUNT(*) AS Nombre_Transactions_Rapides_Suspectes
FROM Transactions_Suspectes
GROUP BY id_agent, canal
ORDER BY Nombre_Transactions_Rapides_Suspectes DESC
;


-- Identification des transactions faites à des heures inhabituelles, de 00h à 05h

SELECT id_agent,
COUNT(*) AS Nombre_Transactions_Nocturnes
FROM dataset_fraude_benin
WHERE HOUR(timestamp_transaction) < 5 OR HOUR(timestamp_transaction) >= 23
GROUP BY id_agent
ORDER BY Nombre_Transactions_Nocturnes DESC
;

-- Identification des transactions importantes  faites à des heures inhabituelles, de 00h à 05h 

-- Calcul du seuil suspect pour les transactions
-- La méthode des 3 écarts types au dessus de la moyenne m'a permis de déterminer que le seuil suspect est de 9222 f
SELECT
AVG(montant) AS Moyenne_Mu,
STDDEV(montant) AS Ecart_Type_Sigma
FROM dataset_fraude_benin
;

-- Le seuil suspect de transaction est de 9222f

SELECT id_transaction,
COUNT(*) AS Nombre_Transactions_Nocturnes
FROM dataset_fraude_benin
WHERE HOUR(timestamp_transaction) < 5 OR HOUR(timestamp_transaction) >= 00
AND montant > 9222
GROUP BY id_transaction
ORDER BY Nombre_Transactions_Nocturnes DESC
;


SELECT 
COUNT(*) AS Nombre_Transactions_Nocturnes
FROM dataset_fraude_benin
WHERE HOUR(timestamp_transaction) < 5 OR HOUR(timestamp_transaction) >= 00
AND montant > 9222
-- GROUP BY id_transaction
-- ORDER BY Nombre_Transactions_Nocturnes DESC
;


-- Montants élevés ou outliers
-- Pour trouver les outliers, il faut utiliser une méthode de détection des valeurs aberrantes (outliers) basée sur le Z-score.
-- Le Z-score permet de déterminer à quel point un montant de transaction s'éloigne de la moyenne générale, mesuré en unités d'écart-type 

WITH Stats AS (
    -- Calcul de la moyenne  et de l'écart-type (Sigma) pour le Bénin
    SELECT
	AVG(montant) AS Moyenne,
	STDDEV(montant) AS Sigma
    FROM dataset_fraude_benin
)
SELECT
    t.id_agent,
    t.timestamp_transaction,
    t.montant,
    
    -- Calcul du Z-score : (Montant - Mu) / Sigma
    ABS((t.montant - s.Moyenne) / s.Sigma) AS Z_Score
FROM dataset_fraude_benin t 
CROSS JOIN Stats s
WHERE ABS((t.montant - s.Moyenne) / s.Sigma) > 3  --  on ne garde que les transactions à plus de 3 écarts-types de la moyenne
ORDER BY Z_Score DESC
;



-- Clients utilisant trop d'appareils différents pour faire des transactions
-- C'est le signe d'un compte compromis utilisé à des fins de fraudes

SELECT id_client, 
COUNT(DISTINCT id_appareil) AS Num_appareils
FROM dataset_fraude_benin
GROUP BY id_client
HAVING COUNT(DISTINCT id_appareil) > 5
ORDER BY COUNT(DISTINCT id_appareil) DESC
;

-- Nombre de clients utilisant plus de 5 appareils différents pour faire des transactions
WITH Clients_Suspects AS (
    SELECT id_client
    FROM dataset_fraude_benin
    GROUP BY id_client
    HAVING COUNT(DISTINCT id_appareil) > 5
)
SELECT
COUNT(*) AS Nombre_Clients_Plus_De_5_Appareils
FROM Clients_Suspects
;

-- Nombre d'appareil moyen par abonné
WITH Nombre_Appareils_Par_Client AS (
    -- 1. Compter le nombre d'appareils distincts pour chaque id_client
    SELECT
        COUNT(DISTINCT id_appareil) AS total_appareils
    FROM
        dataset_fraude_benin
    GROUP BY
        id_client -- On groupe pour obtenir une ligne par client
)
SELECT
    -- 2. Calculer la moyenne de ces totaux
    AVG(total_appareils) AS Moyenne_Appareils_Par_Client
FROM
    Nombre_Appareils_Par_Client;

-- Clients qui remplissent toutes les conditions de  -- Aucun
WITH stats AS (
    SELECT 
        AVG(montant) AS avg_montant,
        STDDEV_SAMP(montant) AS std_montant
    FROM dataset_fraude_benin
),
clients_multi_devices AS (
    SELECT id_client
    FROM dataset_fraude_benin
    GROUP BY id_client
    HAVING COUNT(DISTINCT id_appareil) > 5
),
base AS (
    SELECT
        t.*,
        (t.montant - s.avg_montant) / NULLIF(s.std_montant, 0) AS z_score_calc,
        COUNT(*) OVER (
            PARTITION BY t.id_client
            ORDER BY t.timestamp_transaction
            RANGE BETWEEN INTERVAL 5 MINUTE PRECEDING AND CURRENT ROW
        ) AS tx_5min
    FROM dataset_fraude_benin t
    CROSS JOIN stats s
)
SELECT
    id_transaction, id_client, id_agent, id_appareil, timestamp_transaction, montant,
    ROUND(z_score_calc, 3) AS z_score,
    tx_5min
FROM base
WHERE
    ABS(z_score_calc) >= 3
    AND HOUR(timestamp_transaction) BETWEEN 0 AND 4
    AND montant >= 9222
    AND id_client IN (SELECT id_client FROM clients_multi_devices)
    AND tx_5min >= 3
ORDER BY timestamp_transaction
;







