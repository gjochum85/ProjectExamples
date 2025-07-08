-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;

SELECT MAX(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2;

SELECT industry, sum(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_million DESC;

SELECT company, sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT min(`DATE`), max(`date`)
FROM layoffs_staging2;

SELECT year(`date`), sum(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, sum(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, avg(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT substring(`date`,1,7) AS `MONTH`,sum(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`,1,7) is not null
group by `month`
order by 1 ASC
;

WITH Rolling_total AS
(SELECT substring(`date`,1,7) AS `MONTH`,sum(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`,1,7) is not null
group by `month`
order by 1 ASC
)
SELECT `Month`, total_off
,sum(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_total;

SELECT company, sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company,YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH Company_Year (years, company,total_laid_off) AS
(
SELECT YEAR(`date`),company, sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(partition by years ORDER BY total_laid_off DESC) AS layoff_rank
FROM Company_Year
WHERE years is not null
)
SELECT *
FROM Company_Year_Rank
WHERE layoff_rank <= 5
;