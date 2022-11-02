--R11:
--le nom et le prénom des employés qui travaillent dans le camping ‘Les Flots Bleus’. Les employés doivent être classés par rapport à leur salaire (du mieux payé au moinscbien payé).

SELECT nomEmploye, prenomEmploye
FROM EMPLOYES e
JOIN CAMPINGS c ON e.idCamping = c.idCamping
WHERE nomCamping = 'Les Flots Bleus'
ORDER BY salaireEmploye DESC;

--R12:
--l'identifiant, le nom et le prénom des clients qui ont effectué au moins une location dans un camping qui se trouve à Palavas.

SELECT DISTINCT c.idClient, nomClient, prenomClient
FROM CLIENTS c
JOIN LOCATIONS l ON c.idClient = l.idClient
JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
JOIN CAMPINGS ca ON b.idCamping = ca.idCamping
WHERE villeCamping = 'Palavas';

--R13:
--le nom des clients qui ont loué au moins un bungalow dont la superficie est inférieure à 40m2. Les clients doivent être triés par ordre alphabétique.

SELECT nomClient
FROM CLIENTS c
WHERE EXISTS (SELECT * FROM LOCATIONS l
			JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
			WHERE l.idClient = c.idClient AND superficieBungalow < 40)
ORDER BY nomClient;

--R14:
--le nom et le prénom des clients qui habitent dans une ville où il y a un camping.

SELECT nomClient, prenomClient
FROM CLIENTS c
WHERE EXISTS(SELECT * FROM CAMPINGS ca
WHERE c.villeClient = ca.villeCamping

--R15:
--le nom et le prénom des subordonnés de Gaspard Alizan (c’est à dire des employés qui ont pour chef Gaspard Alizan).

SELECT e.nomEmploye, e.prenomEmploye
FROM EMPLOYES e
JOIN EMPLOYES chef ON e.idEmployeChef = chef.idEmploye
WHERE chef.nomEmploye = 'Alizan' AND chef.prenomEmploye = 'Gaspard';

--R16:
--l'identifiant, le nom et le prénom des clients qui étaient dans le camping ‘Les Flots Bleus’ le 14 juillet 2021 (c'est-à-dire qui ont une location qui couvre le 14 juillet 2021).

SELECT c.idClient, nomClient, prenomClient
FROM CLIENTS c
JOIN LOCATIONS l ON c.idClient = l.idClient
JOIN BUNGALOWS b ON b.idBungalow = l.idBungalow
JOIN CAMPINGS ca ON ca.idCamping = b.idCamping
WHERE nomCamping = 'Les Flots Bleus' AND dateDebut <= '14/07/2021' AND dateFin >= '14/07/2021';

--R17:
--le nom et le prénom des clients qui ont été dans le camping ‘Les Flots Bleus’ en juillet 2021.

SELECT nomClient, prenomClient
FROM CLIENTS c
WHERE EXISTS (SELECT * FROM LOCATIONS l
JOIN BUNGALOWS b ON b.idBungalow = l.idBungalow
JOIN CAMPINGS ca ON ca.idCamping = b.idCamping
WHERE nomCamping = 'Les Flots Bleus' AND dateDebut < '01/08/2021' AND dateFin >= '01/07/2021' AND c.idClient = l.idClient);

--R18:
--le nombre de services proposés par le bungalow ‘Le Titanic’.

SELECT COUNT(*)
FROM BUNGALOWS b
JOIN PROPOSER p ON b.idBungalow = p.idBungalow
WHERE nomBungalow = 'Le Titanic';

--R19:
--le salaire de l’employé le mieux payé du camping ‘Les Flots Bleus’.

SELECT MAX(salaireEmploye)
FROM EMPLOYES e
JOIN CAMPINGS c ON e.idCamping = c.idCamping
WHERE nomCamping = 'Les Flots Bleus';

--R20:
--le nombre de campings dans lesquels la cliente Agathe Zeblouse a séjourné.

SELECT COUNT(DISTINCT idCamping)
FROM CLIENTS c
JOIN LOCATIONS l ON c.idClient = l.idClient
JOIN BUNGALOWS b ON b.idBungalow = l.idBungalow
WHERE nomClient = 'Zeblouse' AND prenomClient = 'Agathe';

--R21:
--le nom du plus grand bungalow.

SELECT nomBungalow
FROM BUNGALOWS
WHERE superficieBungalow = (SELECT MAX(superficieBungalow) FROM BUNGALOWS);

--R22:
--le nom et prénom de l’employé le plus mal payé du camping ‘Les Flots Bleus’.

SELECT nomEmploye, prenomEmploye
FROM EMPLOYES e
JOIN CAMPINGS c ON e.idCamping = c.idCamping
WHERE nomCamping = 'Les Flots Bleus' AND salaireEmploye = (SELECT MIN (salaireEmploye)
FROM EMPLOYES e
JOIN CAMPINGS c ON e.idCamping = c.idCamping
WHERE nomCamping = 'Les Flots Bleus');

--R23:
--le nom des bungalows qui ne proposent pas de service.

SELECT nomBungalow
FROM BUNGALOWS b
WHERE NOT EXISTS (SELECT * FROM PROPOSER p
				WHERE p.idBungalow = b.idBungalow);

--R24:
--le nom et prénom des employés qui n’ont pas de subordonné.

SELECT nomEmploye, prenomEmploye
FROM EMPLOYES e
WHERE NOT EXISTS (SELECT * FROM EMPLOYES ee
				WHERE e.idEmploye = ee.idEmployeChef);

--R25:
--l'identifiant et le nom des bungalows qui se trouvent dans le camping 'La Décharge Monochrome' ainsi que les bungalows qui proposent le service 'Kit de Bain'.

SELECT b.idBungalow, nomBungalow
FROM BUNGALOWS b
JOIN CAMPINGS c ON b.idCamping = c.idCamping
WHERE nomCamping = 'La Décharge Monochrome'
UNION
SELECT b.idBungalow, nomBungalow
FROM BUNGALOWS b
JOIN PROPOSER p ON b.idBungalow = p.idBungalow
JOIN SERVICES s ON s.idService = p.idService
WHERE nomService = 'Kit de Bain';

--R26:
--le nom des bungalows qui ne proposent ni le service ‘Climatisation’ ni le service ‘TV’

SELECT nomBungalow
FROM BUNGALOWS
WHERE idBungalow NOT IN (SELECT idBungalow FROM PROPOSER p
						JOIN SERVICES s ON s.idService = p.idService
						WHERE nomService = 'Climatisation'
						UNION
						SELECT idBungalow FROM PROPOSER p
						JOIN SERVICES s ON s.idService = p.idService
						WHERE nomService = 'TV');

--R27a:
--le nom et le prénom des clients qui ont effectué une location (au moins) dans le camping ‘Les Flots Bleus’ et dans le camping ‘La Décharge Monochrome’. Les clients doivent être classés dans l’ordre lexicographique de leur nom (et de leur prénom s’ils ont le même nom).

SELECT nomClient, prenomClient
FROM CLIENTS
WHERE idClient IN (SELECT idClient FROM LOCATIONS l
					JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
					JOIN CAMPINGS c ON c.idCamping = b.idCamping
					WHERE nomCamping = 'Les Flots Bleus'
					INTERSECT
					SELECT idClient FROM LOCATIONS l
					JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
					JOIN CAMPINGS c ON c.idCamping = b.idCamping
					WHERE nomCamping = 'La Décharge Monochrome')
ORDER BY nomClient, prenomClient;

--R27b:
--le nom et le prénom des clients qui ont effectué une location (au moins) dans le camping ‘Les Flots Bleus’ ou dans le camping ‘La Décharge Monochrome’. Les clients doivent être classés dans l’ordre lexicographique de leur nom (et de leur prénom s’ils ont le même nom).

SELECT nomClient, prenomClient
FROM CLIENTS
WHERE idClient IN (SELECT idClient FROM LOCATIONS l
					JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
					JOIN CAMPINGS c ON c.idCamping = b.idCamping
					WHERE nomCamping = 'Les Flots Bleus'
					UNION
					SELECT idClient FROM LOCATIONS l
					JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
					JOIN CAMPINGS c ON c.idCamping = b.idCamping
					WHERE nomCamping = 'La Décharge Monochrome')
ORDER BY nomClient, prenomClient;

--R28:
--pour chacun des employés de la table Employés, le nom, le prénom de l’employé ainsi que le nom du camping dans lequel il travaille. Les employés doivent être classés par ordre lexicographique de leur nom.

SELECT nomEmploye, prenomEmploye, nomCamping
FROM EMPLOYES e
LEFT JOIN CAMPINGS c ON e.idCamping = c.idCamping
ORDER BY nomEmploye;

--R29:
--le nom et le prénom des clients qui ont pu croiser Judas Bricot dans un camping (c'est-à-dire que pendant au moins une journée, ils ont eu une location dans le même camping que Judas Bricot).

SELECT nomClient, prenomClient 
FROM CLIENTS
WHERE idClient IN (SELECT c.idClient
                    FROM CLIENTS c 
                    JOIN LOCATIONS l ON c.idClient=l.idClient
                    JOIN BUNGALOWS b ON l.idBungalow=b.idBungalow
                    JOIN CLIENTS c2 ON c.idClient!=c2.idClient 
                    JOIN LOCATIONS l2 ON c2.idClient=l2.idClient
                    JOIN BUNGALOWS b2 ON l2.idBungalow=b2.idBungalow
                    WHERE c2.nomClient='Bricot' 
                    AND c2.prenomClient='Judas' 
                    AND b.idCamping=b2.idCamping 
                    AND ((l.dateDebut=l2.dateFin) 
                    OR (l.dateDebut>=l2.dateDebut
                    AND l2.dateFin>=l.dateFin) 
                    OR (l.dateDebut<l2.dateDebut 
                    AND l.dateFin>l2.dateDebut)));

--R30A:
--le nom et le prénom des employés qui n’ont pas de chef.

SELECT nomEmploye, prenomEmploye
FROM EMPLOYES e
WHERE NOT EXISTS (SELECT * FROM EMPLOYES ee
				WHERE e.idEmployeChef = ee.idEmploye);

--R30B:
--le nom des bungalows qui n’ont jamais été loués.

SELECT nomBungalow
FROM BUNGALOWS b
WHERE NOT EXISTS (SELECT * FROM LOCATIONS l WHERE l.idBungalow = b.idBungalow);

SELECT nomBungalow
FROM BUNGALOWS
WHERE idBungalow NOT IN (SELECT idBungalow FROM LOCATIONS);

SELECT nomBungalow
FROM BUNGALOWS
WHERE idBungalow IN (SELECT idBungalow FROM BUNGALOWS MINUS SELECT idBungalow FROM LOCATIONS);

--R30:
--le nom des campings qui n’ont pas d’employé.

SELECT nomCamping
FROM CAMPINGS c
WHERE NOT EXISTS (SELECT * FROM EMPLOYES e WHERE e.idCamping = c.idCamping);

SELECT nomCamping
FROM CAMPINGS
WHERE idCamping NOT IN (SELECT idCamping FROM EMPLOYES WHERE idCamping IS NOT NULL);

SELECT nomCamping
FROM CAMPINGS
WHERE idCamping IN (SELECT idCamping FROM CAMPINGS MINUS SELECT idCamping FROM EMPLOYES);

--R31:
--le nombre de bungalows qui ne proposent pas de service.

SELECT COUNT(*)
FROM BUNGALOWS b
WHERE NOT EXISTS (SELECT * FROM PROPOSER p WHERE b.idBungalow = p.idBungalow);

--R32:
--le nom des clients qui ont réalisé des locations, mais jamais dans des bungalows de moins de 58 m2.

SELECT nomClient
FROM CLIENTS
WHERE idClient IN (SELECT idClient FROM LOCATIONS
				MINUS
					SELECT idClient FROM LOCATIONS l
					JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
					WHERE superficieBungalow < 58);

--R33:
--le nom des campings où tous les employés ont un salaire supérieur ou égal à 1 000 €.

SELECT nomCamping
FROM CAMPINGS c
JOIN EMPLOYES e ON c.idCamping = e.idCamping
GROUP BY nomCamping, c.idCamping
HAVING MIN(salaireEmploye) >= 1000;

--R34:
--le nom des clients montpelliérains qui n’ont jamais réalisé de location dans un bungalow qui ne propose pas de service.

SELECT nomClient
FROM CLIENTS c
WHERE NOT EXISTS (SELECT * FROM LOCATIONS l
JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
WHERE c.idClient = l.idClient AND NOT EXISTS (SELECT * FROM PROPOSER p WHERE p.idBungalow = b.idBungalow))
AND villeClient ='Montpellier';

--R35:
--le nom et le prénom des clients qui n’ont pas de location.

SELECT nomClient, prenomClient
FROM CLIENTS c
WHERE NOT EXISTS (SELECT * FROM LOCATIONS l WHERE l.idCLient = c.idClient);

SELECT nomClient, prenomClient
FROM CLIENTS
WHERE idClient NOT IN (SELECT idClient FROM LOCATIONS);

SELECT nomClient, prenomClient
FROM CLIENTS
WHERE idClient IN (SELECT idClient FROM CLIENTS
MINUS
				SELECT idClient FROM LOCATIONS);


--R36:
--le nom des campings qui n’ont pas de bungalow de plus de 50 m2.

SELECT nomCamping
FROM CAMPINGS c
WHERE NOT EXISTS (SELECT * FROM BUNGALOWS b WHERE superficieBungalow > 50 AND c.idCamping = b.idCamping);

--R37:
--le nombre de clients qui ont réalisé que des locations qui ont couté moins de 990 €.

SELECT COUNT(*)
FROM CLIENTS 
WHERE idClient IN (SELECT idClient FROM LOCATIONS
				MINUS
					SELECT idClient FROM LOCATIONS
					WHERE montantLocation >= 990);

--R38:
--le nom des clients dont le prénom commence par un ‘J’ et qui habitent dans une ville où il n’y a pas de camping.

SELECT nomClient
FROM CLIENTS
WHERE prenomClient LIKE 'J%' AND villeClient NOT IN (SELECT villeCamping FROM CAMPINGS);

--R39
--les catégories de service qui ne sont pas proposées dans les bungalows du camping de ‘La Décharge Monochrome’.

SELECT categorieService FROM SERVICES
MINUS
SELECT categorieService FROM SERVICES s
JOIN PROPOSER p ON s.idService = p.idService
JOIN BUNGALOWS b ON b.idBungalow = p.idBungalow
JOIN CAMPINGS c ON c.idCamping = b.idCamping
WHERE nomCamping = 'La Décharge Monochrome';

--R40:
--l’identifiant, le nom et le prénom des clients qui ont réalisé une location (au moins) dans un camping qui se trouve dans la ville où ils habitent.

SELECT DISTINCT c.idClient, nomClient, prenomClient
FROM CLIENTS c
JOIN LOCATIONS l On c.idClient = l.idClient
JOIN BUNGALOWS b ON b.idBungalow = l.idBungalow
JOIN CAMPINGS ca On ca.idCamping = b.idCamping AND ca.villeCamping = c.villeClient;

--R41:
--le nom et le prénom des clients qui n’ont jamais réalisé de location dans le camping ‘Les Flots Bleus’.

SELECT nomClient, prenomClient
FROM CLIENTS c
WHERE NOT EXISTS (SELECT * FROM LOCATIONS l
				JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
				JOIN CAMPINGS ca ON ca.idCamping = b.idCamping
				WHERE nomCamping = 'Les Flots Bleus' AND c.idClient = l.idClient);

--R42:
--le nombre de bungalows du camping ‘La Décharge Monochrome’ qui ont été loués par le client Agathe Zeblouse.

SELECT COUNT(*)
FROM CLIENTS c
JOIN LOCATIONS l ON c.idClient = l.idClient
JOIN BUNGALOWS b ON b.idBungalow = l.idBungalow
JOIN CAMPINGS ca On ca.idCamping = b.idCamping
WHERE nomCamping = 'La Décharge Monochrome' ANd nomClient = 'Zeblouse' AND prenomClient = 'Agathe';

--R43:
--pour chacun des employés de la table Employés, le nom, le prénom de l’employé ainsi que le nom de son chef. Les employés doivent être classés par ordre lexicographique de leur nom.

SELECT e.nomEmploye, e.prenomEmploye, chef.nomEmploye
FROM EMPLOYES e 
LEFT JOIN EMPLOYES chef ON e.idEmployeChef = chef.idEmploye
ORDER BY e.nomEmploye;

--R44:
--le nom des bungalows qui ne proposent pas de services de la catégorie ‘Loisir’.

SELECT nomBungalow
FROM BUNGALOWS
WHERE idBungalow IN (SELECT idBungalow FROM BUNGALOWS
				MINUS
					SELECT idBungalow FROM PROPOSER p
					JOIN SERVICES s On p.idService = s.idService
					WHERE categorieService = 'Loisir');

--R45:
--le numéro de la location du camping ‘The White Majestic’ qui a duré le plus de temps.

SELECT idLocation
FROM LOCATIONS l
JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
JOIN CAMPINGS c ON c.idCamping = b.idCamping
WHERE nomCamping = 'The White Majestic' AND dateFin-dateDebut = (SELECT MAX(dateFin - dateDebut)
FROM LOCATIONS l
JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
JOIN CAMPINGS c ON c.idCamping = b.idCamping
WHERE nomCamping = 'The White Majestic');

--R46:
--les villes dans lesquelles résident des clients mais où il n’y a pas de camping.

SELECT DISTINCT villeClient
FROM CLIENTS c
WHERE NOT EXISTS (SELECT * FROM CAMPINGS ca
WHERE ca.villeCamping = c.villeClient);

--R47:
--le nom et le prénom du dernier client qui a loué le bungalow ‘La Poubelle’.

SELECT nomClient, prenomClient
FROM CLIENTS c
JOIN LOCATIONS l ON c.idClient = l.idClient
JOIN BUNGALOWS b On l.idBungalow = b.idBungalow
WHERE nomBungalow = 'La Poubelle' AND dateDebut = (SELECT MAX(dateDebut)
FROM LOCATIONS l JOIN BUNGALOWS b On l.idBungalow = b.idBungalow
WHERE nomBungalow = 'La Poubelle');

--R48:
--le nom et le prénom des clients pour lesquels toutes les locations ont duré au moins 10 jours.

SELECT nomClient, prenomClient
FROM CLIENTS
WHERE idCLient IN (SELECT idClient FROM LOCATIONS
				WHERE dateFin - dateDebut > 10);

--R49:
--le nom et le prénom des clients qui ont effectué une location (au moins) dans le camping ‘Les Flots Bleus’ ou une location (au moins) dans le camping ‘La Décharge Monochrome’ mais pas dans les deux.

SELECT nomClient, prenomClient
FROM CLIENTS
WHERE idClient IN ((SELECT idClient FROM LOCATIONS l
					JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
					JOIN CAMPINGS c ON c.idCamping = b.idCamping
					WHERE nomCamping = 'Les Flots Bleus'
					UNION
					SELECT idClient FROM LOCATIONS l
					JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
					JOIN CAMPINGS c ON c.idCamping = b.idCamping
					WHERE nomCamping = 'La Décharge Monochrome')
					MINUS
					(SELECT idClient FROM LOCATIONS l
					JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
					JOIN CAMPINGS c ON c.idCamping = b.idCamping
					WHERE nomCamping = 'Les Flots Bleus'
					INTERSECT
					SELECT idClient FROM LOCATIONS l
					JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
					JOIN CAMPINGS c ON c.idCamping = b.idCamping
					WHERE nomCamping = 'La Décharge Monochrome'));


--R50:
--le nom des employés qui ne sont pas affectés à un camping.

SELECT nomEmploye
FROM EMPLOYES
WHERE idCamping IS NULL;

--R51:
--le nom et le prénom des employés dont un des subordonnés (au moins) possède lui- même un ou plusieurs subordonnés.

SELECT nomEmploye, prenomEmploye
FROM EMPLOYES e
WHERE EXISTS (SELECT * FROM EMPLOYES ee
			WHERE e.idEmploye = ee.idEmployeChef AND EXISTS (SELECT * FROM EMPLOYES eee
				WHERE ee.idEmploye = eee.idEmployeChef))

--R52:
--le nom des services qui ne sont proposés par aucun bungalow de plus de 60 m2.

SELECT nomService
FROM SERVICES
MINUS
SELECT nomService FROM SERVICES s
JOIN PROPOSER p ON s.idService = p.idService
JOIN BUNGALOWS b ON b.idBungalow = p.idBungalow
WHERE superficieBungalow > 60;

--R53:
--le nom du camping de la ville de Palavas qui possède le plus d’étoiles.

SELECT nomCamping
FROM CAMPINGS
WHERE villeCamping = 'Palavas' AND nbEtoilesCamping = (SELECT MAX(nbEtoilesCamping) FROM CAMPINGS WHERE villeCamping = 'Palavas');

--R54:
--le nom des bungalows qui proposent les services ‘Chaine Hi-Fi’ et ‘Climatisation’.

SELECT nomBungalow
FROM BUNGALOWS
WHERE idBungalow IN (SELECT idBungalow FROM PROPOSER p
					JOIN SERVICES s ON p.idService = s.idService
					WHERE nomService = 'Chaine Hi-Fi'
					INTERSECT
					SELECT idBungalow FROM PROPOSER p
					JOIN SERVICES s ON p.idService = s.idService
					WHERE nomService = 'Climatisation');

--R55:
--le nom des services qui sont dans la catégorie Loisir ou bien qui ne sont proposés dans aucun bungalow du camping ‘The White Majestic’.

SELECT nomService
FROM SERVICES
WHERE categorieService = 'Loisir'
UNION
SELECT nomService
FROM SERVICES s
WHERE NOT EXISTS (SELECT * FROM PROPOSER p
				JOIN BUNGALOWS b On p.idBungalow = b.idBungalow
				JOIN CAMPINGS c ON c.idCamping = b.idCamping
				WHERE nomCamping = 'The White Majestic' AND p.idService = s.idService);

--R56:
--le nom des clients qui ont réalisé des locations dans le camping ‘La Décharge Monochrome’.

SELECT nomClient
FROM CLIENTS cl
WHERE EXISTS (SELECT * FROM LOCATIONS l
			JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
			JOIN CAMPINGS c On c.idCamping = b.idCamping
			WHERE l.idClient = cl.idClient AND noMCamping = 'La Décharge Monochrome');

--R57:
--le nom du plus petit des bungalows qui n’a pas eu de location.

SELECT noMBungalow
FROM BUNGALOWS b
WHERE superficieBungalow = (SELECT MIN(superficieBungalow) FROM BUNGALOWS b WHERE NOT EXISTS (SELECT * FROM LOCATIONS l
					WHERE b.idBungalow = l.idBungalow))
AND NOT EXISTS (SELECT * FROM LOCATIONS l
					WHERE b.idBungalow = l.idBungalow);

--R58:
--le nom des campings dans lesquels il n'y a pas de bungalow qui ne propose pas de service.

SELECT nomCamping
FROM CAMPINGS c
WHERE NOT EXISTS (SELECT * FROM BUNGALOWS b
				WHERE b.idCamping = c.idCamping AND NOT EXISTS (SELECT * FROM PROPOSER p WHERE p.idBungalow = b.idBungalow));

--R59:
--pour chacun des bungalows du camping qui a l’identifiant 'CAMP1', le nom des services de Luxe qui ne sont pas proposés.

SELECT nomBungalow, nomService
FROM BUNGALOWS b
CROSS JOIN SERVICES s
WHERE idCamping = 'CAMP1' AND categorieService = 'Luxe'
MINUS
SELECT nomBungalow, nomService
FROM BUNGALOWS b
JOIN PROPOSER p ON b.idBungalow = p.idBungalow
JOIN SERVICES s ON s.idService = p.idService
WHERE idCamping = 'CAMP1' AND categorieService = 'Luxe';

--R60A:
--pour chaque catégorie de service, le nombre de services.

SELECT categorieService, COUNT(*)
FROM SERVICES
GROUP BY categorieService;

--R60B:
--le nom des villes pour lesquelles on a au moins trois clients.

SELECT villeClient
FROM CLIENTS
GROUP BY villeClient
HAVING COUNT(*) >= 3;

--R60C:
--pour chacun des campings pour lesquels on a au moins un employé, indiquer le salaire moyen des employés qui travaillent dans le camping.

SELECT nomCamping, AVG(salaireEmploye)
FROM EMPLOYES e
JOIN CAMPINGS c ON e.idCamping = c.idCamping
GROUP BY nomCamping;

--R60D:
--le nom des campings qui possèdent plus de 3 employés.

SELECT nomCamping
FROM CAMPINGS c
JOIN EMPLOYES e ON c.idCamping = e.idCamping
GROUP BY nomCamping, c.idCamping
HAVING COUNT(*) > 3;

--R60:
--pour chacun des clients qui a réalisé au moins une location, indiquer son nom, son prénom et le nombre de ses locations (les clients doivent être classées par ordre décroissant du nombre de locations). Il n’est pas demandé de faire apparaître les clients qui n’ont pas réalisé de location.

SELECT nomClient, prenomClient, COUNT(*)
FROM CLIENTS c
JOIN LOCATIONS l ON c.idClient = l.idClient
GROUP BY nomClient, prenomClient, c.idClient
ORDER BY COUNT(*) DESC;

--R61:
--le nom des campings dont le salaire moyen des employés est supérieur à 1 400€.

SELECT nomCamping
FROM CAMPINGS c
JOIN EMPLOYES e ON c.idCamping = e.idCamping
GROUP BY nomCamping, c.idCamping
HAVING AVG(salaireEmploye) > 1400;

--R62:
--le nom et le prénom des clients qui ont réalisé des locations dans 2 campings.

SELECT nomClient, prenomClient
FROm CLIENTS 
WHERE idClient IN (SELECT idClient
				FROM LOCATIONS l 
				JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
				GROUP BY idClient
				HAVING COUNT(DISTINCT idCamping) = 2);

--R63:
--le nombre de services proposés par chacun des bungalows ; on veut également afficher les bungalows qui ne proposent pas de service. Les bungalows doivent être classés par rapport au nombre de services proposés.

SELECT nomBungalow, COUNT(idService) AS nb_services
FROM BUNGALOWS b
LEFT JOIN PROPOSER p ON p.idBungalow = b.idBungalow
GROUP BY noMBungalow, b.idBungalow
ORDER BY nb_services DESC;

--R64:
--la liste des campings, classés par rapport au nombre de bungalows de moins de 65 m2 qu’ils possèdent (de celui qui en a le moins à celui qui en a le plus).

SELECT nomCamping
FROM CAMPINGS c
JOIN BUNGALOWS b ON c.idCamping = b.idCamping
WHERE superficieBungalow < 65
GROUP BY nomCamping, c.idCamping
ORDER BY COUNT(*);

--R65:
--le nom des campings où tous les employés ont un salaire supérieur ou égal à 1 000 €.

SELECT nomCamping
FROM CAMPINGS c
JOIN EMPLOYES e ON c.idCamping = e.idCamping
GROUP BY nomCamping, c.idCamping
HAVING MIN(salaireEmploye) >=1000;

--R66:
--le nom des bungalows qui proposent le même nombre de services que le bungalow qui se nomme ‘Le Royal’ (il n’y a qu’un seul Bungalow ‘Le Royal’).

SELECT nomBungalow
FROM BUNGALOWS b
JOIN PROPOSER p ON b.idBungalow = p.idBungalow
GROUP BY noMBungalow, b.idBungalow
HAVING COUNT(*) = (SELECT COUNT(*)
				FROM BUNGALOWS b
				JOIN PROPOSER p ON b.idBungalow = p.idBungalow
				WHERE nomBungalow = 'Le Royal'
				GROUP BY noMBungalow, b.idBungalow);

--R67:
--pour chacun des bungalows du camping ‘La Décharge Monochrome’, indiquer le nom du bungalow ainsi que le nombre de locations qui concernent le bungalow. Les bungalows doivent être classées par rapport à leur nombre de locations.

SELECT nomBungalow, COUNT(idLocation) AS nb_locations
FROM BUNGALOWS b
LEFT JOIN LOCATIONS l ON b.idBungalow = l.idBungalow
JOIN CAMPINGS c ON b.idCamping = c.idCamping
WHERE nomCamping = 'La Décharge Monochrome'
GROUP BY noMBungalow, b.idBungalow
ORDER BY nb_locations DESC;

--R68:
--le nom et le prénom des clients qui ont plusieurs locations et dont la moyenne des montants de ces locations est supérieure à 1100 €.

SELECT nomClient, prenomClient
FROM CLIENTS c
JOIN LOCATIONS l ON c.idClient = l.idClient
GROUP BY nomClient, prenomClient, c.idClient
HAVING COUNT(*) > 1 AND AVG(montantLocation) > 1100;

--R69:
--le bungalow qui propose le plus de services.

SELECT nomBungalow
FROM BUNGALOWS b
JOIN PROPOSER p ON b.idBungalow = p.idBungalow
GROUP BY noMBungalow, b.idBungalow
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
					FROM BUNGALOWS b
					JOIN PROPOSER p ON b.idBungalow = p.idBungalow
					GROUP BY noMBungalow, b.idBungalow);

--R70:
--le nombre de campings de chaque ville.

SELECT villeCamping, COUNT(*)
FROM CAMPINGS
GROUP BY villeCamping;

--R71:
--le nom des campings qui possèdent plus de 3 employés.

SELECT nomCamping
FROM CAMPINGS c
JOIN EMPLOYES e ON c.idCamping = e.idCamping
GROUP BY nomCamping, c.idCamping
HAVING COUNT(*) > 3;

--R72:
--pour chaque camping, indiquer le nom du camping ainisi que le nombre d’employés affectés au camping. Les campings doivent être classées par rapport au nombre d’employés qu’ils possèdent.

SELECT nomCamping, COUNT(idEmploye) AS nbEmployes
FROM CAMPINGS c
LEFT JOIN EMPLOYES e ON c.idCamping = e.idCamping
GROUP BY nomCamping, c.idCamping
ORDER BY nbEmployes DESC;

--R73:
--pour chaque service de la catégorie Luxe, indiquer le nom du service ainsi que le nombre de campings dans lesquels un ou plusieurs bungalows proposent ce service.

SELECT nomService, COUNT(DISTINCT idCamping)
FROM SERVICES s
JOIN PROPOSER p ON s.idService = p.idService
JOIN BUNGALOWS b ON b.idBungalow = p.idBungalow
WHERE categorieService = 'Luxe'
GROUP BY nomService, s.idService;

--R74:
--le nom et le prénom du client qui a le plus de locations.

SELECT nomClient, prenomClient
FROM CLIENTS c
JOIN LOCATIONS l ON c.idClient = l.idClient
GROUP BY nomClient, prenomClient, c.idClient
HAVING COUNT(*) = (SELECT (MAX(COUNT(*)))
					FROM CLIENTS c
					JOIN LOCATIONS l ON c.idClient = l.idClient
					GROUP BY nomClient, prenomClient, c.idClient);

--R80:
--le nom des bungalows qui proposent le service "Kit de Bain" et qui ont été loués.

SELECT nomBungalow
FROM BUNGALOWS b
WHERE EXISTS (SELECT * FROM LOCATIONS l WHERE b.idBungalow = l.idBungalow)
AND EXISTS (SELECT * FROM PROPOSER p 
			JOIN SERVICES s ON p.idService = s.idService
			WHERE nomService = 'Kit de Bain' AND b.idBungalow = p.idBungalow);

--R81:
--le nom des bungalows qui ont été loués plus de quatre fois.

SELECT nomBungalow
FROM BUNGALOWS b
JOIN LOCATIONS l ON b.idBungalow = l.idBungalow
GROUP BY noMBungalow, b.idBungalow
HAVING COUNT(*) > 4;

--R82:
--le nombre de clients qui habitent dans une ville où il n’y a pas de camping.

SELECT COUNT(*)
FROM CLIENTS c
WHERE NOT EXISTS(SELECT * FROM CAMPINGS ca WHERE c.villeClient = ca.villeCamping);

--R83:
--le nombre de services proposés par chacun des bungalows du camping ‘La Décharge Monochrome’.

SELECT nomBungalow, COUNT(idService)
FROM BUNGALOWS b
LEFT JOIN PROPOSER p ON b.idBungalow = p.idBungalow
JOIN CAMPINGS c ON c.idCamping = b.idCamping
WHERE nomCamping = 'La Décharge Monochrome'
GROUP BY noMBungalow, b.idBungalow;

--R84:
--le nom du plus petit bungalow du camping ‘Les Flots Bleus’.

SELECT nomBungalow 
FROM BUNGALOWS b
JOIN CAMPINGS c ON b.idCamping = c.idCamping
WHERE nomCamping = 'Les Flots Bleus' AND superficieBungalow = (SELECT MIN(superficieBungalow)
																FROM BUNGALOWS b
																JOIN CAMPINGS c ON b.idCamping = c.idCamping
																WHERE nomCamping = 'Les Flots Bleus');

--R85:
--le nom des bungalows qui proposent plusieurs services et qui ont été loués plus de 2 fois.

SELECT nomBungalow
FROM BUNGALOWS
WHERE idBungalow IN (SELECT idBungalow
					FROM PROPOSER 
					GROUP BY idBungalow
					HAVING COUNT(idService) > 1
					INTERSECT
					SELECT idBungalow
					FROM LOCATIONS
					GROUP BY idBungalow
					HAVING COUNT(idLocation) > 2);

--R86:
--le nom des bungalows qui n’ont pas été loués en août 2021.

SELECT nomBungalow
FROM BUNGALOWS
WHERE idBungalow NOT IN (SELECT idBungalow
						FROM LOCATIONS
						WHERE dateDebut <= '31/08/2021' AND dateFin >= '01/08/2021');

--R87:
--le nom des employés qui possèdent plusieurs subordonnés (c'est-à-dire qu’ils sont chefs de plusieurs employés).

SELECT chef.nomEmploye
FROM EMPLOYES e
JOIN EMPLOYES chef ON e.idEmployeChef = chef.idEmploye
GROUP BY chef.nomEmploye, chef.idEmploye
HAVING COUNT(*) > 1;

--R88:
--le nom et le prénom des clients qui ont réalisé que des locations qui ont couté plus de 1 200 €.

SELECT nomClient, prenomClient
FROM CLIENTS
WHERE idClient IN (SELECT idClient FROM LOCATIONS
				MINUS
					SELECT idCLient FROM LOCATIONS
					WHERE montantLocation <=1200);

--R89:
--le nom des campings dont tous les bungalows possèdent moins de 4 services.

SELECT nomCamping
FROM CAMPINGS
WHERE idCamping IN (SELECT idCamping FROM CAMPINGS
				MINUS
					SELECT b.idCamping 
					FROM BUNGALOWS b
					JOIN PROPOSER p ON p.idBungalow = b.idBungalow
					GROUP BY b.idBungalow, b.idCamping
					HAVING COUNT(*) >= 4);

--R100:
--le nom des bungalows qui proposent tous les services (c'est-à-dire tous les services qui sont dans la table Services).

SELECT nomBungalow
FROM BUNGALOWS b
JOIN PROPOSER p ON b.idBungalow = p.idBungalow
GROUP BY noMBungalow, b.idBungalow
HAVING COUNT(*) = (SELECT COUNT(*) FROM SERVICES);

SELECT nomBungalow
FROM BUNGALOWS b
WHERE NOT EXISTS (SELECT idService FROM SERVICES
				MINUS
					SELECT idService FROM PROPOSER p
					WHERE p.idBungalow = b.idBungalow);

--R101:
--le nom des bungalows qui proposent tous les services de la catégorie ‘Luxe’.

SELECT nomBungalow
FROM BUNGALOWS b
WHERE NOT EXISTS (SELECT idService FROM SERVICES WHERE categorieService = 'Luxe'
				MINUS
					SELECT idService FROM PROPOSER p
					WHERE p.idBungalow = b.idBungalow);

SELECT nomBungalow
FROM BUNGALOWS b
JOIN PROPOSER p ON b.idBungalow = p.idBungalow
JOIN SERVICES s ON s.idService = p.idService
WHERE categorieService = 'Luxe'
GROUP BY noMBungalow, b.idBungalow
HAVING COUNT(*) = (SELECT COUNT(*)
					FROM SERVICES
					WHERE categorieService = 'Luxe');

--R102:
--le nom des bungalows qui proposent tous les services proposés par le bungalow qui se nomme ‘La Poubelle’.

SELECT nomBungalow
FROM BUNGALOWS b
WHERE NOT EXISTS (SELECT idService FROM PROPOSER p
				JOIN BUNGALOWS bb ON p.idBungalow = bb.idBungalow
				WHERE nomBungalow = 'La Poubelle'
				MINUS
					SELECT idService FROM PROPOSER p
					WHERE p.idBungalow = b.idBungalow);

SELECT nomBungalow
FROM BUNGALOWS b
JOIN PROPOSER p ON b.idBungalow = p.idBungalow
WHERE idService IN (SELECT idService FROM PROPOSER p
					JOIN BUNGALOWS bb ON p.idBungalow = bb.idBungalow
					WHERE nomBungalow = 'La Poubelle')
GROUP BY noMBungalow, b.idBungalow
HAVING COUNT(*) = (SELECT COUNT(*)
					FROM PROPOSER p
					JOIN BUNGALOWS bb ON p.idBungalow = bb.idBungalow
					WHERE nomBungalow = 'La Poubelle');

--R103:
--le nom des clients qui ont réalisé au moins une location dans toutes les villes pour lesquelles il y a des campings.

SELECT nomClient
FROM CLIENTS c
WHERE NOT EXISTS (SELECT villeCamping FROM CAMPINGS
				MINUS
					SELECT villeCamping FROM CAMPINGS ca
					JOIN BUNGALOWS b ON ca.idCamping = b.idCamping
					JOIN LOCATIONS l ON l.idBungalow = b.idBungalow
					WHERE c.idClient = l.idClient);

--R104:
--le nom des clients qui ont loué tous les bungalows loués par la cliente Agathe Zeblouse.

SELECT nomClient
FROM CLIENTS c
WHERE NOT EXISTS (SELECT idBungalow FROM LOCATIONS l
				JOIN CLIENTS az ON l.idClient = az.idClient
				WHERE az.prenomClient = 'Agathe' AND az.nomClient = 'Zeblouse'
				MINUS
				SELECT idBungalow FROM LOCATIONS l
				WHERE l.idClient = c.idClient);

--R105:
--le nom et le prénom des clients qui ont sont allés exactement dans les mêmes campings que la cliente Agathe Zeblouse.

SELECT nomClient, prenomClient
FROM CLIENTS c
WHERE NOT EXISTS (SELECT idCamping FROM LOCATIONS l
				JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
				JOIN CLIENTS az ON l.idClient = az.idClient
				WHERE az.prenomClient = 'Agathe' AND az.nomClient = 'Zeblouse'
			MINUS
				SELECT idCamping FROM LOCATIONS l
				JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
				WHERE l.idClient = c.idClient)

AND NOT EXISTS (SELECT idCamping FROM LOCATIONS l
				JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
				WHERE l.idClient = c.idClient
			MINUS
				SELECT idCamping FROM LOCATIONS l
				JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
				JOIN CLIENTS az ON l.idClient = az.idClient
				WHERE az.prenomClient = 'Agathe' AND az.nomClient = 'Zeblouse');



--R110:
--le nom des services qui sont proposés dans tous les bungalows dont la superficie est supérieure à 60 m2.

SELECT nomService
FROM SERVICES s
WHERE NOT EXISTS(SELECT idBungalow FROM BUNGALOWS
				WHERE superficieBungalow > 60
				MINUS
				SELECT idBungalow
				FROM PROPOSER p 
				WHERE p.idService = s.idService);

--R111:
--le numéro, le nom et le prénom des clients qui n’ont jamais fait de location dans un camping de Palavas. Les clients doivent être classés par ordre lexicographique de leur nom.

SELECT c.idClient, nomClient, prenomClient
FROM CLIENTS c
WHERE NOT EXISTS (SELECT * FROM LOCATIONS l
				JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
				JOIN CAMPINGS ca ON ca.idCamping = b.idCamping
				WHERE villeCamping = 'Palavas' AND l.idClient = c.idClient);

--R112:
--le nom des services proposés par le bungalow le plus grand du camping ‘Les Flots Bleus’.

SELECT nomService
FROM SERVICES s
JOIN PROPOSER p ON s.idService = p.idService
JOIN BUNGALOWS b ON b.idBungalow = p.idBungalow
JOIN CAMPINGS c ON c.idCamping = b.idCamping
WHERE nomCamping = 'Les Flots Bleus' AND superficieBungalow = (SELECT MAX(superficieBungalow)
															FROM BUNGALOWS b
															JOIN CAMPINGS c ON c.idCamping = b.idCamping
															WHERE nomCamping = 'Les Flots Bleus');

--R113:
--pour chacun des employés du camping ‘La décharge Monochrome’, le nom et le prénom de l’employé ainsi que le nombre de subordonnés qu’il possède.

SELECT chef.nomEmploye, chef.prenomEmploye, COUNT(e.idEmploye)
FROM EMPLOYES chef
LEFT JOIN EMPLOYES e ON chef.idEmploye = e.idEmployeChef
JOIN CAMPINGS c ON c.idCamping = chef.idCamping
WHERE nomCamping = 'La Décharge Monochrome'
GROUP BY chef.nomEmploye, chef.prenomEmploye, chef.idEmploye;

--R114:
--le nom des campings où tous les bungalow ont une superficie supérieure à 50 m2.

SELECT nomCamping
FROM CAMPINGS c
JOIN BUNGALOWS b ON c.idCamping = b.idCamping
GROUP BY nomCamping, c.idCamping
HAVING MIN(superficieBungalow) > 50;

--R115:
--le nom des clients qui ont réalisé le même nombre de locations que le client Agathe Zeblouse (il n’y a qu’un seul client qui se nomme Agathe Zeblouse).

SELECT nomClient FROM CLIENTS c
JOIN LOCATIONS l ON c.idClient = l.idClient
GROUP BY nomClient, c.idClient
HAVING COUNT(*) = (SELECT COUNT(*)
				FROM CLIENTS c
				JOIN LOCATIONS l ON c.idClient = l.idClient
				WHERE nomClient = 'Zeblouse' AND prenomClient = 'Agathe');

--R116:
--le nom des services qui sont proposés dans moins de cinq bungalows.

SELECT nomService
FROM SERVICES s
JOIN PROPOSER p ON s.idService = p.idService
GROUP BY nomService, s.idService
HAVING COUNT(*) < 5;

--R117:
--le nom du camping qui a le plus d’employés.

SELECT nomCamping
FROM CAMPINGS c
JOIN EMPLOYES e ON c.idCamping = e.idCamping
GROUP BY nomCamping, c.idCamping
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
					FROM CAMPINGS c
					JOIN EMPLOYES e ON c.idCamping = e.idCamping
					GROUP BY nomCamping, c.idCamping);

--R118:
--les bungalows qui proposent des services de toutes les catégories.

SELECT nomBungalow
FROM BUNGALOWS b
WHERE NOT EXISTS (SELECT DISTINCT categorieService FROM SERVICES
				MINUS
					SELECT categorieService FROM SERVICES s
					JOIN PROPOSER p ON s.idService = p.idService
					WHERE b.idBungalow = p.idBungalow);

--R119:
--le nom des bungalows qui proposent exactement les mêmes services que le bungalow ‘La Suite Régalienne’.

SELECT nomBungalow
FROM BUNGALOWS b
WHERE NOT EXISTS (SELECT idService FROM PROPOSER p
				JOIN BUNGALOWS bb ON p.idBungalow = bb.idBungalow
				WHERE nomBungalow = 'La Suite Régalienne'
				MINUS
				SELECT idService FROM PROPOSER p
				WHERE b.idBungalow = p.idBungalow)
AND NOT EXISTS (SELECT idService FROM PROPOSER p
				WHERE b.idBungalow = p.idBungalow
				MINUS
				SELECT idService FROM PROPOSER p
				JOIN BUNGALOWS bb ON p.idBungalow = bb.idBungalow
				WHERE nomBungalow = 'La Suite Régalienne');
