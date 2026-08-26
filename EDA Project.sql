select max(total_laid_off),max(percentage_laid_off) from layoffs_staging2;
select * from layoffs_staging2 where percentage_laid_off=1 order by funds_raised_millions desc;
select company,sum(total_laid_off) from layoffs_staging2 group by company order by 2 desc;
select min(`date`),max(`date`) from layoffs_staging2;

select industry,sum(total_laid_off) from layoffs_staging2 group by industry order by 2 desc;

select country,sum(total_laid_off) from layoffs_staging2 group by country order by 2 desc;
-- Rolling Total

select `date`, sum(total_laid_off) from layoffs_staging2 group by `date` order by 1;
select substring(`date`,1,7) as `Month`, sum(total_laid_off) FROM layoffs_staging2 group by  substring(`date`,1,7) order by 1;

with rolling_total as 
(select substring(`date`,1,7) as `Month`,sum(total_laid_off) as total_laid FROM layoffs_staging2 group by  substring(`date`,1,7) order by 1)
select `Month`,total_laid,sum(total_laid) over (order by `Month`) as total_sum_laid_off from rolling_total;

select country,sum(total_laid_off) from layoffs_staging2 group by country order by 2 desc;

-- 1)find the total laid off per year by company
-- 2)rank the companies by year
-- 3)display the top 5 companies

select company,year(`date`),sum(total_laid_off) from layoffs_staging2 where total_laid_off group by company,year(`date`) ;

WITH Company_laid_off as
(select company,year(`date`),sum(total_laid_off) from layoffs_staging2 where total_laid_off group by company,year(`date`) ;)

select *,dense_rank() over(partition by company order by 1) from Company_laid_off;

select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`);

WITH company_year(company,years,total_laid_off) as(select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)), company_year_rank as
(select *,dense_rank() over(partition by years order by total_laid_off desc) as ranking from company_year where years is not null)
select * from company_year_rank where ranking <=5 ;