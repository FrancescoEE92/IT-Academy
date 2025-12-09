#Exercici 1
#Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

DELETE FROM transaction
WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";

#Exercici 2
#La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
#S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions.
#Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. 
#Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW VistaMarketing AS (
SELECT c.company_name, c.phone, c.country,round(avg(t.amount),2) as avg_sales
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
GROUP BY c.company_name, c.phone, c.country
ORDER BY avg(t.amount) DESC);

SELECT * FROM VistaMarketing;
#Exercici 3
#Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

SELECT company_name
FROM VistaMarketing
WHERE country = "Germany"