
CREATE DATABASE IF NOT EXISTS runik_shop;
USE runik_shop;


CREATE TABLE utilisateur (
  id_user INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  mot_de_passe VARCHAR(255) NOT NULL,
  role ENUM('apprenti','marchand','admin') NOT NULL DEFAULT 'apprenti',
  date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


CREATE TABLE categorie (
  id_categorie INT AUTO_INCREMENT PRIMARY KEY,
  nom_categorie VARCHAR(100) NOT NULL,
  description TEXT
) ENGINE=InnoDB;


CREATE TABLE produit (
  id_produit INT AUTO_INCREMENT PRIMARY KEY,
  nom_produit VARCHAR(150) NOT NULL,
  description TEXT,
  prix DECIMAL(10,2) NOT NULL CHECK (prix >= 0),
  rarete ENUM('commune','rare','épique','légendaire') NOT NULL DEFAULT 'commune',
  stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
  id_categorie INT NOT NULL,
  id_marchand INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_marchand) REFERENCES utilisateur(id_user) ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX (id_categorie),
  INDEX (id_marchand)
) ENGINE=InnoDB;


CREATE TABLE commande (
  id_commande INT AUTO_INCREMENT PRIMARY KEY,
  id_user INT NOT NULL,
  date_commande DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  statut ENUM('en préparation','expédiée','livrée','annulée') NOT NULL DEFAULT 'en préparation',
  total DECIMAL(12,2) NOT NULL DEFAULT 0.00 CHECK (total >= 0),
  FOREIGN KEY (id_user) REFERENCES utilisateur(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX (id_user)
) ENGINE=InnoDB;


CREATE TABLE detail_commande (
  id_commande INT NOT NULL,
  id_produit INT NOT NULL,
  quantite INT NOT NULL CHECK (quantite > 0),
  prix_unitaire DECIMAL(10,2) NOT NULL CHECK (prix_unitaire >= 0),
  PRIMARY KEY (id_commande, id_produit),
  FOREIGN KEY (id_commande) REFERENCES commande(id_commande) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_produit) REFERENCES produit(id_produit) ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX (id_produit)
) ENGINE=InnoDB;


CREATE TABLE livraison (
  id_livraison INT AUTO_INCREMENT PRIMARY KEY,
  id_commande INT NOT NULL UNIQUE,
  adresse_livraison TEXT NOT NULL,
  date_livraison DATETIME,
  mode_livraison VARCHAR(100),
  statut_livraison ENUM('en transit','livrée','retardée') NOT NULL DEFAULT 'en transit',
  FOREIGN KEY (id_commande) REFERENCES commande(id_commande) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX (id_commande)
) ENGINE=InnoDB;



DELIMITER $$
CREATE TRIGGER trg_after_insert_detail
AFTER INSERT ON detail_commande
FOR EACH ROW
BEGIN
  UPDATE produit
    SET stock = stock - NEW.quantite
    WHERE id_produit = NEW.id_produit;

  IF (SELECT stock FROM produit WHERE id_produit = NEW.id_produit) < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuffisant pour ce produit';
  END IF;
END$$
DELIMITER ;


CREATE INDEX idx_produit_nom ON produit(nom_produit);
