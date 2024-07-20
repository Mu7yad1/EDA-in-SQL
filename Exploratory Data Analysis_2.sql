select*
from layoffs_project3;

with total_laid_off(company, date_year, total_laid)as 
(select company, year(`date`), sum(total_laid_off) as total_laid
from layoffs_project3
group by company, year(`date`)
), company_rank as
(select*, dense_rank() over(partition by date_year order by total_laid desc) as company_rank
from total_laid_off
where date_year is not null
and total_laid is not null
group by company, date_year
)
select*
from company_rank
where company_rank <= 5
order by 2 desc;