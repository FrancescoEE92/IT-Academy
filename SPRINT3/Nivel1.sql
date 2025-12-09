USE transactions;
SHOW COLUMNS FROM company;
SHOW COLUMNS FROM transaction;

#Exercici 1
#La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
#La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules
#("transaction" i "company"). Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.


### DESCRIPICION MODELO Y TABLAS TENENDO EN CUENTA TODAS LAS TABLAS HASTA EL NIVEL 3 ###

/*Tenemos una base de datos que describe transaciones economicas de diferentes empresas,
tenemos 4 tablas: 
Primero de todo tenemos un modelo estrella formato da:
la tabla Transaction que es una tabla de hechos.
la tablas Company,Credit_Card,Data_User que son de dimensiónes.

Company tiene:
la columna ID como Primary.

Transaction tiene:
la columna ID como Primary,
la columna "company_id" como foreign key 
la columna "credit_card_id" como foreign key
la columna "user_id" como foreign Key

Credit_Card tiene:
la columna ID como Primary.

Data_User tiene:
la columna ID como Primary.


Las tablas estan conectada gracias a las relaciones 1 a n,
con la tabla de hechos en el medio(transaction).
donde 1 es en Company(primary key "ID")
y M es en Transaction(foreign key "company_id" 
donde 1 es en Credit_Card(primary key "ID")
y M es en Transaction(foreign key "credit_card_id"
donde 1 es en Data_User(primary key "ID")
y M es en Transaction(foreign key "user_id"*/

### PONER MISMO valore de FORMATO PARA MEJOR FUNCIONALIDAD FOREIGN KEY ####

ALTER TABLE transaction MODIFY credit_card_id VARCHAR(20);

#### CREO TABLA CREDIT CARD ####

DROP TABLE IF EXISTS credit_card;

CREATE TABLE IF NOT EXISTS credit_card (
id VARCHAR(20) PRIMARY KEY,
iban VARCHAR(50),
pan VARCHAR(50),
pin VARCHAR(4),
cvv INT ,
expiring_date VARCHAR(20),
fecha_actual DATE DEFAULT (CURRENT_DATE));

ALTER TABLE transaction
ADD CONSTRAINT fk_credit_card
FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);


#Exercici 2
#El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit 
#amb ID CcU-2938. La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.
SELECT * FROM credit_card
WHERE id = 'CcU-2938';

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

#Exercici 3
#En la taula "transaction" ingressa una nova transacció amb la següent informació:

### puedo anadir los valores en las tablas company y credit card manualmente o crear un trigger! ###

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
     
IF NOT EXISTS( SELECT 1 FROM user WHERE id = new.credit_card_id)
THEN INSERT INTO credit_card(id)
     VALUES(new.credit_card_id);
     END IF;
END$$

DELIMITER ;

## Despues haber creado el trigger que actualiza automaticamente las tablas company y credit card puedo inserir la nueva transaccion ###

## Antes cambio la columna timestamp, para que tenga como DEFAULT dia y hora actual en automatico,si no me sale null ###

ALTER TABLE transaction MODIFY timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

### ahora puedo inserir tranquilamente ###

INSERT INTO transaction(id,credit_card_id,company_id,user_id,lat,longitude,amount,declined)
VALUES ("108B1D1D-5B22-A76C-55EF-C568E49A99DD","CcU-3999","b-9939",9399,829.999,-117.999,111.11,0);

SELECT * FROM transaction
WHERE id = "108B1D1D-5B22-A76C-55EF-C568E49A99DD";

#Exercici 4
#Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.
SELECT * FROM credit_card;

ALTER TABLE credit_card DROP COLUMN pan;





