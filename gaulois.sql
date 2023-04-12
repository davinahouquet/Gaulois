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

SELECT potion.nom_potion AS 'Nom de la potion', ingredient.nom_ingredient AS 'Ingrédient'
FROM potion
INNER JOIN ingredient
 ON ingredient.id_ingredient = id_ingredient
INNER JOIN composer
 ON composer.id_potion = potion.id_potion
 WHERE ingredient.id_ingredient = 24

-- 13. Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois.

SELECT lieu.nom_lieu AS 'Lieu', COUNT(personnage.adresse_personnage) AS 'Nombre habitants'
FROM personnage
INNER JOIN lieu
 ON personnage.id_lieu = lieu.id_lieu
 GROUP BY lieu.nom_lieu
 ORDER BY COUNT(personnage.adresse_personnage) DESC
LIMIT 1, 11;

-- 14. Nom des personnages qui n'ont jamais bu aucune potion.

SELECT personnage.nom_personnage AS 'Nom personnage', boire.dose_boire AS 'Dose 0'
FROM boire
INNER JOIN personnage
 ON boire.id_personnage = personnage.id_personnage
WHERE boire.dose_boire = 0;

-- 15. Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'.

SELECT personnage.nom_personnage AS 'Potion interdite pour :'
FROM personnage
WHERE personnage.nom_personnage NOT IN (
	SELECT personnage.nom_personnage AS 'Potion autorisée pour:'
	FROM personnage
	INNER JOIN autoriser_boire
	ON autoriser_boire.id_personnage = personnage.id_personnage
	INNER JOIN potion
	ON autoriser_boire.id_potion = potion.id_potion
	WHERE potion.id_potion = 1
	)

--En écrivant toujours des requêtes SQL, modifiez la base de données comme suit :
-- A. Ajoutez le personnage suivant : Champdeblix, agriculteur résidant à la ferme Hantassion de Rotomagus.

--EXISTE DEJA--Ajout d'un nouveau personnage



-- B. Autorisez Bonemine à boire de la potion magique, elle est jalouse d'Iélosubmarine...

--EXISTE DEJA--

-- C Supprimez les casques grecs qui n'ont jamais été pris lors d'une bataille

DELETE FROM type_casque
WHERE id_type_casque = 2 AND NOT IN (

	SELECT type_casque.nom_type_casque AS 'Casques utilisés'
	FROM type_casque
	INNER JOIN casque
	ON casque.id_type_casque = type_casque.id_type_casque
	INNER JOIN prendre_casque
	ON prendre_casque.id_casque = casque.id_casque
	INNER JOIN bataille
	ON bataille.id_bataille = prendre_casque.id_bataille
	
	)

-- D. Modifiez l'adresse de Zérozérosix : il a été mis en prison à Condate.

UPDATE personnage
SET adresse_personnage = 'nouvelle adresse'
WHERE id_personnage = 23

-- E. La potion 'Soupe' ne doit plus contenir de persil.

--Pour afficher qu'elle en contient bien 
SELECT potion.nom_potion, ingredient.nom_ingredient
FROM potion
INNER JOIN composer
ON composer.id_potion = potion.id_potion
INNER JOIN ingredient
ON composer.id_ingredient = ingredient.id_ingredient

--Pour supprimer le persil de la potion 'Soupe'
DELETE FROM composer
WHERE composer.id_ingredient = 19;

-- F. Obélix s'est trompé : ce sont 42 casques Weisenau, et non Ostrogoths, qu'il a pris lors de la bataille 'Attaque de la banque postale'. Corrigez son erreur !
UPDATE prendre_casque
SET id_casque = 10, qte = 42
WHERE id_bataille = 9