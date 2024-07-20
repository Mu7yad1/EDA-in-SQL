select*
from layoffs_staging3;

-- 01. trim 
update layoffs_staging3 
set company = trim(company);

select distinct country 
from layoffs_staging3
where country like 'United Stat%';

-- 02. delete titik
update layoffs_staging3
set country = trim(trailing '.' from country)
where country like 'United States%';

-- 03. mengisi column kosong dengan kolom yang ada

update layoffs_staging3
set industry = null
where industry like '';

select*
from layoffs_staging3
where industry is null or industry like ''
;

select*
from layoffs_staging3
where company like 'Airb%';

select st1.industry, st2.industry
from layoffs_staging3 st1
join layoffs_staging3 st2
on st1.company = st2.company
where (st1.industry is null or st1.industry like '')
and st2.industry is not null;

update layoffs_staging3 st1
join layoffs_staging3 st2
	on st1.company = st2.company
set st1.industry = st2.industry
where st1.industry is null
and st2.industry is not null;

select*
from  layoffs_staging3
where industry is null or industry like '';

-- 04 delete null kolom 
select*
from layoffs_staging3
where total_laid_off is null 
and percentage_laid_off is null;

delete 
from layoffs_staging3
where total_laid_off is null 
and percentage_laid_off is null;

-- 05 ganti kolom date
select*
from layoffs_staging3;

alter table layoffs_staging3
drop column row_num;

update layoffs_staging3
set `date`= str_to_date(`date`,'%m/%d/%Y/');

alter table layoffs_staging3
modify column `date` date;

-- 06 finish
select*
from layoffs_staging3;
