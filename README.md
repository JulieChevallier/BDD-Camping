# BDD-Camping

## Contexte
MIDI’HOME CAMPINGTM est une enseigne nationale d’hôtellerie en plein air (ou camping) qui
est très bien implantée dans le sud de la France. MIDI’HOME CAMPING possède une vingtaine
de campings villages qui regroupent au total plus de 5 000 bungalows individuels. Ces
bungalows sont tous différents les uns des autres, ont une superficie propre et proposent des
services distincts qui peuvent aller de la climatisation au sèche-cheveux.

## Contenu
Dans la table Campings se trouvent tous les campings de l’enseigne. Les bungalows de ces
campings sont décrits dans la table Bungalows. Il est à noter que deux bungalows d’un
même camping ne peuvent pas avoir le même nom. Toutefois, il est possible que deux
bungalows de campings différents possèdent le même nom. La table Proposer permet de
connaitre les services qui sont proposés dans les différents bungalows.
Dans la table Clients, sont recensés tous les clients de MIDI’HOME CAMPING ainsi que les
prospects qui n’ont pas encore réalisé de location. La table Locations permet de connaitre
toutes les locations réalisées par les différents clients dans les bungalows.
Enfin, dans la table Employés sont décrites les personnes qui travaillent pour MIDI’HOME
CAMPING. Un employé peut être soit affecté au siège de l’enseigne (son idCamping vaudra
alors NULL), soit affecté à un camping particulier.
Un employé peut éventuellement posséder un chef (qui est alors lui-même un employé). Si un
employé n’a pas de chef, son idEmployeChef vaut NULL.

## Modèle relationnel
  * CAMPINGS (idCamping, nomCamping, villeCamping, nbEtoilesCamping)
  * BUNGALOWS (idBungalow, nomBungalow, superficieBungalow, idCamping#)
  * SERVICES (idService, nomService, categorieService)
  * PROPOSER (idBungalow#, idService#)
  * CLIENTS (idClient, nomClient, prenomClient, dateNaissanceClient, villeClient)
  * LOCATIONS (idLocation, idClient#, idBungalow#, dateDebut, dateFin, montantLocation)
  * EMPLOYES (idEmploye, nomEmploye, prenomEmploye, salaireEmploye, idCamping#, idEmployeChef#)
