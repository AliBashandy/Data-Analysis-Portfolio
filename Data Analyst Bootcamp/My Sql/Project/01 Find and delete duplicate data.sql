SELECT *
FROM layoffs;

-- Data Cleaning
-- 1. Remove Duplicates
-- 2. Standarize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns

CREATE TABLE layoff_staging
LIKE layoffs;

INSERT layoff_staging
SELECT *
FROM layoffs;

-- Remove Duplicates
-- Because there is no ID column it is necessary to partition the duplicates one way is to use ROW_NUM() in a new table
-- checking the duplicates by CTE
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- It is important to check randomly the result of the partitioning
SELECT *
FROM layoff_staging
where company = 'Casper';

-- Creating the table with ROW_NUM coulumn
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Now we have the empty table so next step is to instert the tabe with the row_num coulumn
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_staging;
-- Check the rows to be deleted
 SELECT*
 FROM layoffs_staging2
 WHERE row_num > 1;
 -- Delete the rows
 DELETE
 FROM layoffs_staging2
 WHERE row_num > 1;
 
 