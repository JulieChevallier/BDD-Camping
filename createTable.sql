CREATE TABLE sr_location.Clients (idClient VARCHAR(3), nomClient VARCHAR(20), prenomClient VARCHAR(20),
CONSTRAINT pk_Clients PRIMARY KEY (idClient));

CREATE TABLE sr_location.Bungalows (idBungalow VARCHAR(3), nomBungalow VARCHAR(20), nomCamping VARCHAR(30),
CONSTRAINT pk_Bungalows PRIMARY KEY (idBungalow));

CREATE TABLE sr_location.Locations (idLocation VARCHAR(3), dateDebutLocation DATE, idClient VARCHAR(3), idBungalow VARCHAR(3),
CONSTRAINT pk_Locations PRIMARY KEY (idLocation),
CONSTRAINT fk_Locations_idBungalow FOREIGN KEY (idBungalow) REFERENCES sr_location.Bungalows(idBungalow),
CONSTRAINT fk_Locations_idClient FOREIGN KEY (idClient) REFERENCES sr_location.Clients(idClient));

CREATE TABLE sr_vente.Clients (numClient VARCHAR(3), nomClient VARCHAR(20), prenomClient VARCHAR(20),
CONSTRAINT pk_Clients PRIMARY KEY (numClient));

CREATE TABLE sr_vente.Ventes (numVente VARCHAR(3), dateVente DATE, montantVente INTEGER, numClient VARCHAR(3),
CONSTRAINT pk_Ventes PRIMARY KEY (numVente),
CONSTRAINT fk_Ventes_numClient FOREIGN KEY (numClient) REFERENCES sr_vente.Clients(numClient));

CREATE TABLE Clients
(idClient VARCHAR(5), nomClient VARCHAR(25), prenomClient VARCHAR(25), dateNaissanceClient DATE, villeClient VARCHAR(25), 
CONSTRAINT pk_Clients PRIMARY KEY (idClient)) ;

CREATE TABLE Campings
(idCamping VARCHAR(5), nomCamping VARCHAR(25), villeCamping VARCHAR(25), nbEtoilesCamping NUMBER, 
CONSTRAINT pk_Campings PRIMARY KEY (idCamping)) ;


CREATE TABLE Bungalows
(idBungalow VARCHAR(5), nomBungalow VARCHAR(25), superficieBungalow NUMBER, idCamping VARCHAR(5),
CONSTRAINT pk_Bungalows PRIMARY KEY (idBungalow),
CONSTRAINT fk_Bungalows_idCamping FOREIGN KEY (idCamping) REFERENCES Campings(idCamping),
CONSTRAINTS un_Bungalows_nomBun_idCamp UNIQUE (nomBungalow , idCamping)) ;

CREATE TABLE Locations
(idLocation VARCHAR(5), idClient VARCHAR(5), idBungalow VARCHAR(5), dateDebut DATE, dateFin DATE, montantLocation NUMBER,
CONSTRAINT pk_Locations PRIMARY KEY (idLocation),
CONSTRAINT fk_Locations_idClient FOREIGN KEY (idClient) REFERENCES Clients(idClient),
CONSTRAINT fk_Locations_idBungalow FOREIGN KEY (idBungalow) REFERENCES Bungalows(idBungalow),
CONSTRAINT nn_Locations_idClient CHECK (idClient IS NOT NULL),
CONSTRAINT nn_Locations_idBungalow CHECK (idBungalow IS NOT NULL)) ;

CREATE TABLE Services
(idService VARCHAR(5), nomService VARCHAR(25), categorieService VARCHAR(25), 
CONSTRAINT pk_Services PRIMARY KEY (idService)) ;

CREATE TABLE Proposer
(idBungalow VARCHAR(5), idService VARCHAR(5),
CONSTRAINT pk_Proposer PRIMARY KEY (idBungalow, idService),
CONSTRAINT fk_Proposer_idBungalow FOREIGN KEY (idBungalow) REFERENCES Bungalows(idBungalow),
CONSTRAINT fk_Proposer_idService FOREIGN KEY (idService) REFERENCES Services(idService));

CREATE TABLE Employes
(idEmploye VARCHAR(5), nomEmploye VARCHAR(25), prenomEmploye VARCHAR(25), salaireEmploye NUMBER, idCamping VARCHAR(5), idEmployeChef VARCHAR(5),
CONSTRAINT pk_Employes PRIMARY KEY (idEmploye),
CONSTRAINT fk_Employes_idCamping FOREIGN KEY (idCamping) REFERENCES Campings(idCamping),
CONSTRAINT fk_Employes_idEmployeChef FOREIGN KEY (idEmployeChef) REFERENCES Employes(idEmploye)) ;
