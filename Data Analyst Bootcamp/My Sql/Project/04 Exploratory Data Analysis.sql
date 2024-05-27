-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;

SELECT company, MAX(total_laid_off)
FROM layoffs_staging2
GROUP BY company
;


SELECT YEAR(`date`), MAX(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY MAX(total_laid_off) DESC
;

SELECT industry, MAX(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY MAX(total_laid_off) DESC
;

SELECT substring(`date`,6,2) AS `month`, MAX(total_laid_off)
FROM layoffs_staging2
GROUP BY `month`
ORDER BY MAX(total_laid_off) DESC
;

WITH Rolling_Total AS
(SELECT substring(`date`,1,7) AS `month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY `month` ASC
)
SELECT `month`, total_off, SUM(total_off) OVER(ORDER BY `month`) AS rolling_total_laid_off
FROM Rolling_Total
;


WITH Company_Ranking (company_name, years, sum_total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), top5_companies_rank AS # Another CTE to rank the top5 to filter later with WHERE clause
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY sum_total_laid_off DESC) AS company_rank
FROM Company_Ranking
WHERE years IS NOT NULL
AND sum_total_laid_off IS NOT NULL
)
SELECT *
FROM top5_companies_rank
WHERE company_rank <= 5
;