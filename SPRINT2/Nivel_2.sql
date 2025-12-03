-- Selecionar DATABASE
USE transactions;

SELECT * FROM company;
SELECT * FROM transaction;

-- Exercici 1
#01. Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT t.id,
	   DATE(t.timestamp) AS date,
	   t.amount,
       tabla.tot_daily_sales
FROM transaction as t
JOIN (
      SELECT DATE(timestamp) AS date,SUM(amount) AS tot_daily_sales
      FROM transaction 
      WHERE declined = 0
      GROUP BY DATE(timestamp)
      HAVING SUM(amount) >= ( SELECT MIN(tab.tot_daily_sales)
                              FROM( SELECT DATE(timestamp) AS date,SUM(amount) AS tot_daily_sales
                                    FROM transaction 
                                    WHERE declined = 0
                                    GROUP BY DATE(timestamp)
                                    ORDER BY tot_daily_sales DESC
                                    LIMIT 5
								   ) AS tab
							 ) 
      ) as tabla
ON DATE(t.timestamp) = tabla.date
WHERE t.declined = 0
ORDER BY DATE(timestamp) ASC;



-- Exercici 2
#02. Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT c.country,ROUND(AVG(t.amount),2) as tot_sales
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
WHERE declined = 0
GROUP BY c.country
ORDER BY tot_sales DESC;


-- Exercici 3
-- En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". 
-- Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

#01. Mostra el llistat aplicant JOIN i subconsultes.

SELECT t.id,t.credit_card_id,t.company_id,t.user_id,t.timestamp,t.amount
FROM transaction AS t
JOIN company AS c
ON t.company_id = c.id
WHERE c.company_name != "Non Institute"
AND c.country IN (SELECT country
                    FROM company
                    WHERE company_name = "Non Institute");

#02. Mostra el llistat aplicant solament subconsultes.

SELECT *
FROM transaction 
WHERE company_id IN ( SELECT id 
					FROM company
					WHERE company_name != "Non Institute"
					AND country IN ( SELECT country
									 FROM company
									 WHERE company_name = "Non Institute"));