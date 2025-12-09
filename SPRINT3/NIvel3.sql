#Exercici 1
#La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip va realitzar modificacions en la base de dades,
#però no recorda com les va realitzar. Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:
#En aquesta activitat, és necessari que descriguis el "pas a pas" de les tasques realitzades. És important realitzar descripcions senzilles, simples i fàcils de comprendre.
#Per a realitzar aquesta activitat hauràs de treballar amb els arxius denominats "estructura_dades_user" i "dades_introduir_user"

SHOW COLUMNS FROM transaction;

### para poder hacer la fk tengo cambiar el formato en la tabla USER y anadir el id que falta manualmente o modificar el trigger anterior####

ALTER TABLE user MODIFY id int;

### manualmente ###

# INSERT INTO user(id)
# VALUES (9999);

#### trigger modificado ###

DROP TRIGGER IF EXISTS insert_user_creditcard;

DELIMITER $$

CREATE TRIGGER insert_user_creditcard
BEFORE INSERT ON transaction
FOR EACH ROW
BEGIN
IF NOT EXISTS( SELECT 1 FROM company WHERE id = new.company_id)
THEN INSERT INTO company(id) 
     VALUES(new.company_id);
     END IF;
     
IF NOT EXISTS( SELECT 1 FROM user WHERE id = new.user_id)
THEN INSERT INTO user(id)
     VALUES(new.user_id);
     END IF;
     
IF NOT EXISTS( SELECT 1 FROM credit_card WHERE id = new.credit_card_id)
THEN INSERT INTO credit_card(id)
     VALUES(new.credit_card_id);
     END IF;
END$$

DELIMITER ;

#### tengo que reinserir todo el registro del nivel 1 ###
DELETE FROM transaction
WHERE id = ("108B1D1D-5B22-A76C-55EF-C568E49A99DD");

INSERT INTO transaction(id,credit_card_id,company_id,user_id,lat,longitude,amount,declined)
VALUES ("108B1D1D-5B22-A76C-55EF-C568E49A99DD","CcU-3999","b-9939",9399,829.999,-117.999,111.11,0);

#### ahora puedo anadir la clave foranea ####

ALTER TABLE transaction
ADD CONSTRAINT fk_user
FOREIGN KEY (user_id) REFERENCES user(id);

#Exercici 2
#L'empresa també us demana crear una vista anomenada "InformeTecnico" que contingui la següent informació:

#ID de la transacció
#Nom de l'usuari/ària
#Cognom de l'usuari/ària
#IBAN de la targeta de crèdit usada.
#Nom de la companyia de la transacció realitzada.
#Assegureu-vos d'incloure informació rellevant de les taules que coneixereu i utilitzeu àlies per canviar de nom columnes segons calgui.
#Mostra els resultats de la vista, ordena els resultats de forma descendent en funció de la variable ID de transacció.
DROP VIEW IF EXISTS InformeTecnico;

CREATE VIEW InformeTecnico AS(
SELECT u.id AS user_id,
	   CONCAT(u.name,' ',u.surname) AS full_name_user,
       cc.id AS credit_card_id,
       cc.iban,
       c.id AS company_id,
       c.company_name,
       t.id AS id_transaction,
       t.amount,
       date(t.timestamp) AS date_trasaction
FROM transaction AS t
JOIN user AS u 
ON t.user_id = u.id
JOIN credit_card AS cc
ON t.credit_card_id = cc.id
JOIN company AS c
ON t.company_id = c.id)
ORDER BY id_transaction DESC;

SELECT * FROM InformeTecnico;



