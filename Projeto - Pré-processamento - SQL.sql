-- Inspeção e pré-processamento gerais

-- Checar presença de nulos
select * from projeto.audible where name is null 
	or author is null
	or narrator is null
	or time is null
	or releasedate is null
	or language is null
	or stars is null
	or price is null;


-- Checar presença de linhas duplicadas
SELECT name, author, narrator, time, releasedate, language, stars, price
FROM projeto.audible
GROUP BY name, author, narrator, time, releasedate, language, stars, price
HAVING COUNT(*) > 1;


-- Coluna 'name'
-- Remover espaços extras
update projeto.audible
set name = TRIM(name);

-- Remover espaços antes de ? e !
UPDATE projeto.audible
SET name = REPLACE(name, ' ?', '?')
   , name = REPLACE(name, ' !', '!')
WHERE name LIKE '% ?%' OR name LIKE '% !%';


-- Coluna 'author'
-- Remover espaços extras
update projeto.audible
set author = TRIM(author);

-- Remover 'Writtenby:'
update projeto.audible 
SET author = REPLACE(author, 'Writtenby:', '')
WHERE author LIKE '%Writtenby:%';

-- Separar por autor
-- Criar novas colunas para cada autor
alter table projeto.audible
add column author0 varchar(256),
add column author1 varchar(256),
add column author2 varchar(256),
add column author3 varchar(256);

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


-- Coluna 'narrator'
-- Remover espaços extras
update projeto.audible
set narrator = TRIM(narrator);

-- Remover 'Narratedby:'
update projeto.audible 
SET narrator = REPLACE(narrator, 'Narratedby:', '')
WHERE narrator LIKE '%Narratedby:%';

-- Separar por narrador
-- Criar novas colunas para cada narrador
alter table projeto.audible
add column narrator0 varchar(256),
add column narrator1 varchar(256),
add column narrator2 varchar(256),
add column narrator3 varchar(256);

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


-- Coluna 'time'
-- Remover espaços extras
update projeto.audible
set time = TRIM(time);

-- Converter para minutos
update projeto.audible
set time = 
	case
		when (REGEXP_SUBSTR(time, '^[0-9]*') * 60) + REGEXP_SUBSTR(time, '[0-9]+(?= min$| mins$)') is null then (REGEXP_SUBSTR(time, '^[0-9]*') * 60)
		else (REGEXP_SUBSTR(time, '^[0-9]*') * 60) + REGEXP_SUBSTR(time, '[0-9]+(?= min$| mins$)')
	end
	
-- Alterar tipo de dado para double
alter table projeto.audible
modify column time double;


-- Coluna 'releasedate'
-- Remover espaços extras
update projeto.audible
set releasedate = TRIM(releasedate);

-- Converter datas para formato AAAA-MM-DD
update projeto.audible
SET releasedate = str_to_date(releasedate,'%d-%m-%Y');

-- Alterar tipo de dado para date
alter table projeto.audible
modify column releasedate date;


-- Coluna 'language'
-- Capitalizar todos os valores
update projeto.audible
set language = CONCAT(UCASE(LEFT(language, 1)),SUBSTRING(language, 2)); -- Explicar o que é


-- Coluna 'stars'
-- Remover espaços extras
update projeto.audible
set stars = TRIM(stars);

-- Adicionar coluna ratings
ALTER TABLE projeto.audible 
ADD COLUMN ratings int;

update projeto.audible
set ratings = 
	case
		when stars like 'Not rated yet' then 0
		else REGEXP_SUBSTR(stars, '[0-9]+(?= rating$| ratings$)')
	end

-- Apenas estrelas
update projeto.audible
set stars = REGEXP_SUBSTR(stars, '^[0-9].[0-9]*');

-- Alterar tipo de dado para double
alter table projeto.audible
modify column stars double;


-- Coluna 'price'
-- Remover espaços extras
update projeto.audible
set price = TRIM(price);

-- Remover vírgulas
update projeto.audible
set price = REPLACE(price, ',', '');

-- Substituir 'Free' por 0
update projeto.audible
set price = REPLACE(price, 'Free', '0');

-- Alterar tipo de dado para double
alter table projeto.audible
modify column price double;

