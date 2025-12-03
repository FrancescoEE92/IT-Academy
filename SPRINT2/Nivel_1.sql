-- Selecionar Database
USE transactions;

-- Exercici 1
#01. A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules. 
#Mostra les característiques principals de l'esquema creat i explica les diferents taules i variables que existeixen. 
#Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables.

/*Tenemos una base de datos que describe transaciones economicas de diferentes empresas,
tenemos 2 tablas: 
la tabla Transaction es una tabla de hechos.
la tabla Company es de dimensión.

la tabla Company tiene la columna ID como Primary
la tabla transaction la columna ID como Primary
y la columna "company_id" como foreign key 

Las 2 tablas estan conectada gracias a la relacion 1 a m
donde 1 es en Company(primary key "ID")
donde M es en Transaction(foreign key "company_id" */

-- Exercici 2
-- Utilitzant JOIN realitzaràs les següents consultes:

# Mirar las tablas 

SELECT * FROM company;
SELECT * FROM transaction;

#01. Llistat dels països que estan generant vendes.

SELECT DISTINCT country 
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id;

#02. Des de quants països es generen les vendes.

SELECT COUNT(DISTINCT country) AS count_countries
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id;


#03. Identifica la companyia amb la mitjana més gran de vendes.

SELECT c.id,c.company_name,ROUND(AVG(t.amount),2) AS avg_sales
FROM company AS c
JOIN transaction AS t
ON c.id = t.company_id
GROUP BY c.id,c.company_name
HAVING ROUND(AVG(t.amount),2) = (SELECT ROUND(tab.avg_sales,2)
                                 FROM (
                                       SELECT company_id,AVG(amount) AS avg_sales
                                       FROM transaction
									   GROUP BY company_id
									   ORDER BY avg_sales DESC
                                       LIMIT 1) AS tab);

-- Exercici 3
-- Utilitzant només subconsultes (sense utilitzar JOIN):

#01. Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT *
FROM transaction 
WHERE company_id IN (SELECT id 
			         FROM company
				     WHERE country = "Germany");


#02. Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT DISTINCT id,company_name
FROM company
WHERE id IN  (SELECT company_id
              FROM transaction
              WHERE declined = 0
              AND amount > (SELECT avg(amount)
                              FROM transaction
                              WHERE declined = 0));

#03. Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
                 
SELECT id,company_name
FROM company
WHERE id NOT IN (SELECT company_id
				 FROM transaction 
                 WHERE declined = 0)

              
