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

--7. Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'

-- 8. Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village
-- gaulois'

-- 9. Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur
-- au plus petit).

-- 10. Nom de la bataille où le nombre de casques pris a été le plus important.

-- 11. Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par
-- nombre décroissant)

-- 12. Nom des potions dont un des ingrédients est le poisson frais.

-- 13. Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois.

-- 14. Nom des personnages qui n'ont jamais bu aucune potion.

-- 15. Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'.
