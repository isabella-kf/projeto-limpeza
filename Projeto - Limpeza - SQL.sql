-- Inspeção e limpeza gerais

-- Checar presença de nulos
SELECT * FROM projeto.audible WHERE name IS NULL
				OR author IS NULL
				OR narrator IS NULL
				OR time IS NULL
				OR releasedate IS NULL
				OR language IS NULL
				OR stars IS NULL
				OR price IS NULL;


-- Checar presença de linhas duplicadas
SELECT name, author, narrator, time, releasedate, language, stars, price
FROM projeto.audible
GROUP BY name, author, narrator, time, releasedate, language, stars, price
HAVING COUNT(*) > 1;


-- Coluna 'name'
-- Remover espaços extras
UPDATE projeto.audible
SET name = TRIM(name);

-- Remover espaços antes de ? e !
UPDATE projeto.audible
SET name = REPLACE(name, ' ?', '?'),
   	name = REPLACE(name, ' !', '!')
WHERE name LIKE '% ?%' OR name LIKE '% !%';


-- Coluna 'author'
-- Remover espaços extras
UPDATE projeto.audible
SET author = TRIM(author);

-- Remover 'Writtenby:'
UPDATE projeto.audible 
SET author = REPLACE(author, 'Writtenby:', '')
WHERE author LIKE '%Writtenby:%';

-- Separar por autor
-- Criar novas colunas para cada autor
ALTER TABLE projeto.audible
ADD COLUMN author0 VARCHAR(256),
ADD COLUMN author1 VARCHAR(256),
ADD COLUMN author2 VARCHAR(256),
ADD COLUMN author3 VARCHAR(256);

-- Separar a coluna author em cada vírgula
UPDATE projeto.audible
SET
    author0 = SUBSTRING_INDEX(author, ',', 1),
    author1 = CASE
        WHEN LENGTH(author) - LENGTH(REPLACE(author, ',', '')) >= 1
        THEN SUBSTRING_INDEX(SUBSTRING_INDEX(author, ',', 2), ',', -1)
        ELSE NULL
    END,
    author2 = CASE
        WHEN LENGTH(author) - LENGTH(REPLACE(author, ',', '')) >= 2
        THEN SUBSTRING_INDEX(SUBSTRING_INDEX(author, ',', 3), ',', -1)
        ELSE NULL
    END,
    author3 = CASE
        WHEN LENGTH(author) - LENGTH(REPLACE(author, ',', '')) >= 3
        THEN SUBSTRING_INDEX(author, ',', -1)
        ELSE NULL
    END;

 -- Remover coluna 'author', permanecendo apenas as colunas com os nomes de cada autor separados
 ALTER TABLE audible
 DROP COLUMN author;


-- Coluna 'narrator'
-- Remover espaços extras
UPDATE projeto.audible
SET narrator = TRIM(narrator);

-- Remover 'Narratedby:'
UPDATE projeto.audible 
SET narrator = REPLACE(narrator, 'Narratedby:', '')
WHERE narrator LIKE '%Narratedby:%';

-- Separar por narrador
-- Criar novas colunas para cada narrador
ALTER TABLE projeto.audible
ADD COLUMN narrator0 VARCHAR(256),
ADD COLUMN narrator1 VARCHAR(256),
ADD COLUMN narrator2 VARCHAR(256),
ADD COLUMN narrator3 VARCHAR(256);

-- Separar a coluna narrator em cada vírgula
UPDATE projeto.audible
SET
    narrator0 = SUBSTRING_INDEX(narrator, ',', 1),
    narrator1 = CASE
        WHEN LENGTH(narrator) - LENGTH(REPLACE(narrator, ',', '')) >= 1
        THEN SUBSTRING_INDEX(SUBSTRING_INDEX(narrator, ',', 2), ',', -1)
        ELSE NULL
    END,
    narrator2 = CASE
        WHEN LENGTH(narrator) - LENGTH(REPLACE(narrator, ',', '')) >= 2
        THEN SUBSTRING_INDEX(SUBSTRING_INDEX(narrator, ',', 3), ',', -1)
        ELSE NULL
    END,
    narrator3 = CASE
        WHEN LENGTH(narrator) - LENGTH(REPLACE(narrator, ',', '')) >= 3
        THEN SUBSTRING_INDEX(narrator, ',', -1)
        ELSE NULL
    END;

 -- Remover coluna 'narrator', permanecendo apenas as colunas com os nomes de cada narrador separados
 ALTER TABLE audible
 DROP COLUMN narrator;


-- Coluna 'time'
-- Remover espaços extras
UPDATE projeto.audible
SET time = TRIM(time);

-- Converter para minutos
UPDATE projeto.audible
SET time = 
	CASE
		WHEN (REGEXP_SUBSTR(time, '^[0-9]*') * 60) + REGEXP_SUBSTR(time, '[0-9]+(?= min$| mins$)') IS NULL THEN (REGEXP_SUBSTR(time, '^[0-9]*') * 60)
		ELSE (REGEXP_SUBSTR(time, '^[0-9]*') * 60) + REGEXP_SUBSTR(time, '[0-9]+(?= min$| mins$)')
	END
	
-- Alterar tipo de dado para double
ALTER TABLE projeto.audible
MODIFY COLUMN time DOUBLE;


-- Coluna 'releasedate'
-- Remover espaços extras
UPDATE projeto.audible
SET releasedate = TRIM(releasedate);

-- Converter datas para formato AAAA-MM-DD
UPDATE projeto.audible
SET releasedate = STR_TO_DATE(releasedate,'%d-%m-%Y');

-- Alterar tipo de dado para date
ALTER TABLE projeto.audible
MODIFY COLUMN releasedate DATE;


-- Coluna 'language'
-- Capitalizar todos os valores
UPDATE projeto.audible
SET language = CONCAT(UCASE(LEFT(language, 1)),SUBSTRING(language, 2));


-- Coluna 'stars'
-- Remover espaços extras
UPDATE projeto.audible
SET stars = TRIM(stars);

-- Adicionar coluna ratings
ALTER TABLE projeto.audible 
ADD COLUMN ratings int;

UPDATE projeto.audible
SET ratings = 
	CASE
		WHEN stars LIKE 'Not rated yet' THEN 0
		ELSE REGEXP_SUBSTR(stars, '[0-9]+(?= rating$| ratings$)')
	END

-- Apenas estrelas
UPDATE projeto.audible
SET stars = REGEXP_SUBSTR(stars, '^[0-9].[0-9]*');

-- Alterar tipo de dado para double
ALTER TABLE projeto.audible
MODIFY COLUMN stars double;


-- Coluna 'price'
-- Remover espaços extras
UPDATE projeto.audible
SET price = TRIM(price);

-- Remover vírgulas
UPDATE projeto.audible
SET price = REPLACE(price, ',', '');

-- Substituir 'Free' por 0
UPDATE projeto.audible
SET price = REPLACE(price, 'Free', '0');

-- Alterar tipo de dado para double
ALTER TABLE projeto.audible
MODIFY COLUMN price DOUBLE;

