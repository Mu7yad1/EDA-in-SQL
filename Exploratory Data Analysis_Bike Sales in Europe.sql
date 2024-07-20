-- Data Cleaning (Bike Sales in Europe from 2013-2016)

#01. Remove Duplicate
with duplicate_cte as
(
select*, row_number() over(partition by `Date`, `Day`, `Month`, `Year`, Customer_Age, Age_Group, Customer_Gender, Country, State, Product_Category, Sub_Category, Product, Order_Quantity, Unit_Cost, Unit_Price, Profit, Cost, Revenue) as row_num
from sales_3
)
select*
from duplicate_cte
where row_num>1;

with product_category_cte  as
(
select Product_Category, sum(profit) as profit
from sales_3
group by Product_Category
)
select max(profit)
from product_category_cte;

CREATE TABLE `sales_31` (
  `Date` text,
  `Day` int DEFAULT NULL,
  `Month` text,
  `Year` int DEFAULT NULL,
  `Customer_Age` int DEFAULT NULL,
  `Age_Group` text,
  `Customer_Gender` text,
  `Country` text,
  `State` text,
  `Product_Category` text,
  `Sub_Category` text,
  `Product` text,
  `Order_Quantity` int DEFAULT NULL,
  `Unit_Cost` int DEFAULT NULL,
  `Unit_Price` int DEFAULT NULL,
  `Profit` int DEFAULT NULL,
  `Cost` int DEFAULT NULL,
  `Revenue` int DEFAULT NULL,
  `Row_Num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select*
from sales_31;

insert into sales_31
select*, row_number() over(partition by `Date`, `Day`, `Month`, `Year`, Customer_Age, Age_Group, Customer_Gender, Country, State, Product_Category, Sub_Category, Product, Order_Quantity, Unit_Cost, Unit_Price, Profit, Cost, Revenue) as row_num
from sales_3;

delete
from sales_31
where Row_Num>1;

select distinct Country
from sales_31;

#02. Standardize the Data

select*
from sales_31;

select `Date`, str_to_date(`Date`,'%m/%d/%Y')
from sales_31;

alter table sales_31
modify column `Date` date;

select*
from sales_31;

alter table sales_31
drop column Row_Num;

-- Exploratory data analysis 
select*
from sales_31;

#01. Country_rank by year/ U.S, Canada, Australia
with country_by_year (country, years, profit) as
(
select Country, `Year`, sum(profit)
from sales_31
group by Country,`Year`
), country_rank as
(select*, dense_rank() over(partition by years order by profit desc) as country_rank
from country_by_year
)
select*
from country_rank 
where country_rank <=3;

#02. Country_rank_in_3_years (U.S, Australia, Canada, U.K, Germany, France)
with country_profit (country, profit) as
(
select country, sum(Profit)
from sales_31
group by country
), country_rank as
(select*, dense_rank() over(order by profit desc)
from country_profit
)
select*
from country_rank;

#03. age_group_rank_by_country (Adults(35-64), Young Adults(25-34))
select*
from sales_31;

select distinct Age_Group
from sales_31;

with country_age_group (country, age_group, profit) as
(
select country, Age_Group, sum(profit)
from sales_31
group by country, Age_Group
), country_rank as
(select*, dense_rank() over(partition by country order by profit desc) as country_rank
from country_age_group
)
select*
from country_rank 
where country_rank <=2;

#04. Age_group_rank_by_years (Adults(35-64),Young Adults(25-34))
select*
from sales_31;

with age_group_by_year (age_group, years, profit)
as
(
select Age_Group, `Year`, sum(profit)
from sales_31
group by Age_Group, `Year`
), age_group as
(select*, dense_rank() over(partition by years order by profit desc) as country_rank
from age_group_by_year
)
select*
from age_group
where country_rank <=2;

select*
from sales_31;

