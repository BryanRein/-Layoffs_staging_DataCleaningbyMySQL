-- world_layoffs cleanup process

-- STEP 1: create staging table (keep raw data safe)
create table layoffs_staging like layoffs;

-- add helper column for row numbering
alter table layoffs_staging add column row_num int;

-- insert data + assign row numbers for detecting duplicates
insert into layoffs_staging
select *,
       row_number() over(
         partition by company, location, industry, total_laid_off,
                      percentage_laid_off, `date`, stage, country, funds_raised_millions
       ) as row_num
from layoffs;

-- check all data
select * from layoffs_staging;

-- STEP 2: remove duplicate rows (keep only row_num = 1)
select * 
from layoffs_staging
where row_num > 1;

delete 
from layoffs_staging
where row_num > 1;

-- confirm no duplicates remain
select * 
from layoffs_staging
where row_num > 1;

-- STEP 3: standardize the data

-- check distinct industry values (for cleaning)
select distinct industry 
from layoffs_staging
order by 1;

-- update standardized country and industry names (example for crypto + US)
update layoffs_staging
set country = 'United States',
    industry = 'Crypto'
where lower(country) like '%united s%'
  and lower(industry) like '%crypto%';

-- convert text dates to date format (only if still in text like mm/dd/yyyy)
update layoffs_staging
set `date` = str_to_date(`date`, '%m/%d/%Y')
where `date` like '%/%';

-- change column type to proper date
alter table layoffs_staging modify `date` date;

-- STEP 4: handle null or blank values

-- check rows where industry is null or empty
select * 
from layoffs_staging
where industry is null
   or industry = '';

-- set empty industry strings to null
update layoffs_staging
set industry = null
where industry = '';

-- check all rows for a specific company (e.g., airbnb)
select * 
from layoffs_staging
where company = 'Airbnb';

-- find rows where same company + location but one has null industry and the other has known industry
select t1.industry as t1_industry, t2.industry as t2_industry
from layoffs_staging t1
join layoffs_staging t2
  on t1.company = t2.company
 and t1.location = t2.location
where t1.industry is null
  and t2.industry is not null;

-- update null industries by copying from matching rows (same company + location)
update layoffs_staging t1
join layoffs_staging t2
  on t1.company = t2.company
 and t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is null
  and t2.industry is not null;

-- confirm updates for a specific company
select * 
from layoffs_staging
where company = 'Airbnb';

-- STEP 5: remove unrelated rows and cleanup columns

-- check rows where total + percentage laid off are both null
select * 
from layoffs_staging
where total_laid_off is null 
  and percentage_laid_off is null;

-- delete unrelated rows
delete 
from layoffs_staging
where total_laid_off is null 
  and percentage_laid_off is null;

-- drop helper column
alter table layoffs_staging drop column row_num;

-- final check on cleaned table
select * 
from layoffs_staging;
