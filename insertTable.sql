INSERT INTO sr_location.Clients (idClient, nomClient, prenomClient) VALUES
('C1', 'Zétofrais', 'Mélanie'),
('C2', 'Zeblouse', 'Agathe'),
('C3', 'Bricot', 'Judas'),
('C4', 'Croque', 'Odile'),
('C5', 'Gator', 'Ali'),
('C6', 'Némard', 'Jean');

INSERT INTO sr_location.Bungalows (idBungalow, nomBungalow, nomCamping) VALUES
('B1', 'Le Palace', 'Les Flots Bleus'),
('B2', 'Le Royal', 'Les Flots Bleus'),
('B3', 'La Poubelle', 'La Décharge Monochrome'),
('B4', 'Le Caniveau', 'La Décharge Monochrome'),
('B5', 'Le Suite Monarchique', 'The White Majestic'),
('B6', 'La Suite Nuptiale', 'The White Majestic');

INSERT INTO sr_location.Locations (idLocation, dateDebutLocation, idClient, idBungalow) VALUES
('L1', '01/05/2022', 'C1', 'B1'),
('L2', '08/05/2022', 'C1', 'B1'),
('L3', '01/06/2022', 'C1', 'B1'),
('L4', '08/05/2022', 'C1', 'B2'),
('L5', '01/06/2022', 'C1', 'B2'),
('L6', '08/06/2022', 'C1', 'B2'),
('L7', '08/06/2022', 'C1', 'B4'),
('L8', '08/05/2022', 'C1', 'B5'),
('L9', '01/06/2022', 'C1', 'B5'),
('L10', '01/05/2022', 'C1', 'B6'),
('L11', '08/05/2022', 'C1', 'B6'),
('L12', '01/06/2022', 'C1', 'B6');

INSERT INTO sr_vente.Clients (numClient, nomClient, prenomClient) VALUES
('C1', 'Hultou', 'Jeanne'),
('C2', 'Dilpleu', 'Omer'),
('C3', 'Ricovert', 'Léa'),
('C4', 'Lairbon', 'Oussama'),
('C5', 'Nace', 'Ana'),
('C6', 'Coptaire', 'Elie'),
('C7', 'Chette', 'Barbie'),
('C8', 'Air', 'Axelle');

INSERT INTO sr_vente.Ventes (numVente, dateVente, montantVente, numClient) VALUES
('V1', '01/05/2022', 50, 'C1'),
('V2', '02/05/2022', 150, 'C2'),
('V3', '02/05/2022', 125, 'C3'),
('V4', '03/05/2022', 75, 'C4'),
('V5', '05/05/2022', 120, 'C5'),
('V6', '05/05/2022', 145, 'C1'),
('V7', '05/05/2022', 170, 'C6'),
('V8', '06/05/2022', 150, 'C7'),
('V9', '07/05/2022', 70, 'C1'),
('V10', '09/05/2022', 60, 'C2'),
('V11', '10/05/2022', 150, 'C4'),
('V12', '10/05/2022', 250, 'C8'),
('V13', '12/05/2022', 140, 'C2'),
('V14', '13/05/2022', 50, 'C1');

INSERT INTO Clients (idClient, nomClient, prenomClient, dateNaissanceClient, villeClient) (SELECT idClient, nomClient, prenomClient, dateNaissanceClient, villeClient FROM Palleja.CAMP_Clients);
INSERT INTO Campings (idCamping, nomCamping, villeCamping, nbEtoilesCamping)(SELECT idCamping, nomCamping, villeCamping, nbEtoilesCamping FROM Palleja.CAMP_Campings);
INSERT INTO Bungalows (idBungalow, nomBungalow, superficieBungalow, idCamping)(SELECT idBungalow, nomBungalow, superficieBungalow, idCamping FROM Palleja.CAMP_Bungalows);
INSERT INTO Locations (idLocation, idClient, idBungalow, dateDebut, dateFin, montantLocation)(SELECT idLocation, idClient, idBungalow, dateDebut, dateFin, montantLocation FROM Palleja.CAMP_Locations);
INSERT INTO Services (idService, nomService, categorieService)(SELECT idService, nomService, categorieService FROM Palleja.CAMP_Services);
INSERT INTO Proposer (idBungalow, idService)(SELECT idBungalow, idService FROM Palleja.CAMP_Proposer);
INSERT INTO Employes (idEmploye, nomEmploye, prenomEmploye, salaireEmploye, idCamping, idEmployeChef)(SELECT idEmploye, nomEmploye, prenomEmploye, salaireEmploye, idCamping, idEmployeChef FROM Palleja.CAMP_Employes);

COMMIT;
