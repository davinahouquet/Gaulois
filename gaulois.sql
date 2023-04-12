-- SQL Gaulois

-- 1. Nom des lieux qui finissent par 'um'

SELECT *
FROM bataille
WHERE nom_bataille LIKE '%um'

-- 2. Nombre de personnages par lieu

SELECT adresse_personnage, COUNT(*)
FROM personnage
GROUP BY adresse_personnage
ORDER BY COUNT(*) DESC

-- 3. Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom
-- de personnage.

SELECT nom_personnage, adresse_personnage, id_specialite
FROM personnage
ORDER BY adresse_personnage, nom_personnage

-- 4. Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de
-- personnages décroissant).

SELECT id_specialite, COUNT(*)
FROM personnage
GROUP BY id_specialite
ORDER BY COUNT(*) DESC

-- 5. Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées
-- au format jj/mm/aaaa).

SELECT *, DATE_FORMAT(date_bataille,'%d-%m-%Y')
FROM bataille
ORDER BY date_bataille DESC

-- 6. Nom des potions + coût de réalisation de la potion (trié par coût décroissant).
----------------FAUX--------------------------------
SELECT potion.nom_potion, ingredient.cout_ingredient
	FROM potion
	JOIN ingredient
		ON cout_ingredient DESC
----------------------------------------------------

SELECT potion.nom_potion, COUNT(composer.id_ingredient), SUM(ingredient.cout_ingredient*composer.qte) AS 'cout total'
FROM potion
INNER JOIN composer
ON composer.id_potion = potion.id_potion
INNER JOIN ingredient
ON composer.id_ingredient = ingredient.id_ingredient
GROUP BY potion.id_potion

--7. Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'

SELECT potion.nom_potion, COUNT(composer.id_ingredient) AS 'Nombre ingredients', SUM(ingredient.cout_ingredient*composer.qte) AS 'cout total'
FROM potion
INNER JOIN composer
ON composer.id_potion = potion.id_potion
INNER JOIN ingredient
ON composer.id_ingredient = ingredient.id_ingredient
WHERE potion.id_potion = 3
GROUP BY potion.id_potion



-- 8. Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village
-- gaulois'
SELECT personnage.nom_personnage, bataille.nom_bataille, SUM(pc.qte) AS 'casque pris'
FROM prendre_casque AS pc
INNER JOIN bataille
ON pc.id_bataille = bataille.id_bataille
INNER JOIN personnage
ON pc.id_personnage = personnage.id_personnage
WHERE pc.id_bataille = 1
GROUP BY personnage.id_personnage

-- 9. Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur
-- au plus petit).


----------------FAUX--------------------------------
SELECT personnage.nom_personnage, boire.id_potion, COUNT(boire.dose_boire) AS 'qte_bue'
FROM boire
INNER JOIN personnage 
ON boire.id_personnage = personnage.id_personnage
INNER JOIN potion
ON boire.id_potion = potion.id_potion
GROUP BY personnage.nom_personnage
----------------------------------------------------

SELECT personnage.nom_personnage, COUNT(boire.dose_boire) AS 'qte_bue'
FROM boire
INNER JOIN personnage 
ON boire.id_personnage = personnage.id_personnage
INNER JOIN potion
ON boire.id_potion = potion.id_potion
GROUP BY personnage.nom_personnage


-- 10. Nom de la bataille où le nombre de casques pris a été le plus important.

-- Affiche les batailles + nombre de casques pris du plus grand au plus petit
SELECT bataille.nom_bataille AS 'Bataille', MAX(prendre_casque.qte) AS 'Quantité de casque pris'
FROM prendre_casque
INNER JOIN bataille
ON prendre_casque.id_bataille = bataille.id_bataille
GROUP BY bataille.nom_bataille

-- Affiche la bataille où le nombre de casques pris a été le plus important

SELECT bataille.nom_bataille AS 'Bataille', MAX(prendre_casque.qte) AS 'Quantité de casque pris'
FROM prendre_casque
INNER JOIN bataille
ON prendre_casque.id_bataille = bataille.id_bataille
GROUP BY bataille.nom_bataille
ORDER BY MAX(prendre_casque.qte) DESC
LIMIT 1

-- 11. Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par
-- nombre décroissant)

SELECT casque.id_type_casque AS 'Type de casque', COUNT(casque.id_casque) AS 'Nombre de casque', SUM(casque.cout_casque) AS 'Coût total'
FROM casque
INNER JOIN type_casque
 ON type_casque.id_type_casque = casque.id_type_casque
 GROUP BY casque.id_type_casque
 ORDER BY COUNT(casque.id_type_casque) DESC

-- 12. Nom des potions dont un des ingrédients est le poisson frais.

-- 13. Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois.

-- 14. Nom des personnages qui n'ont jamais bu aucune potion.

-- 15. Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'.
