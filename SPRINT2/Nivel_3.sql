-- Selecionar bbdd
USE transactions;

SELECT * FROM company;
SELECT * FROM transaction;

-- Exercici 1
# Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions 
# amb un valor comprès entre 350 i 400 euros i en alguna d'aquestes dates: 29 d'abril del 2015, 
# 20 de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat.

SELECT c.id,c.company_name,c.country,phone,DATE(t.timestamp) as date,t.amount
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
WHERE t.amount BETWEEN 350 AND 400
AND t.declined = 0
AND DATE(t.timestamp) IN("2015-04-29","2018-07-20","2024-03-13")
ORDER BY t.amount DESC;


-- Exercici 2
# Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
# per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
# però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 400 transaccions o menys.

SELECT c.id,
       c.company_name,
	   count(t.id) AS count_transactions,
       IF (count(t.id) > 400,"Qualified","NO") AS more_than_400_transactions
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
WHERE declined = 0
GROUP BY c.id,c.company_name