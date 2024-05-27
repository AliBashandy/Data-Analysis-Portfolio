-- Standarizing data

-- First check for empty spaces
SELECT company, TRIM(company)
FROM layoffs_staging2;
UPDATE layoffs_staging2
SET company = TRIM(company);

-- check for unstandard names
SELECT DISTINCT(company)
FROM layoffs_staging2;

SELECT DISTINCT(location)
FROM layoffs_staging2
order by 1;

SELECT DISTINCT(industry)
FROM layoffs_staging2
order by 1;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'; 

SELECT DISTINCT (country)
FROM layoffs_staging2
order by 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'
;

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;
UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y')
;
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;