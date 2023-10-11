select *
from Portfolio.coviddeath
where continent is not null
order by 3,4;

#select *
#from Portfolio.coviddeath
#order by 3,4;

select location,date,total_Cases,new_cases,total_deaths, population
from Portfolio.coviddeath
where continent is not null
order by 1,2;

#looking at total cases vs total deaths
#shows likelihood of dying if you contract covid in your country

select location,date,total_Cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from Portfolio.coviddeath
where location like '%china%'
order by 1,2;

#looking at total cases vs population
#shows what percentage of population got covid

select location,date,population,total_cases,(total_cases/population)*100 as covidpercentage
from Portfolio.coviddeath
where location like '%china%'
order by 1,2; 

#looking at countries with highest infection rate compared to population

select location,population,max(total_cases) as highestinfectioncount,max((total_cases/population))*100 as percentpopulationinfected
from Portfolio.coviddeath
where continent is not null
group by location,population
order by percentpopulationinfected desc; 

#showing countries with highest death count per population

select location,max(cast(total_deaths as signed)) as totaldeathcount
from Portfolio.coviddeath
where continent is not null
group by location
order by totaldeathcount desc; 

#break things down by continent

#showing continents with the highest death count per population

select continent,max(cast(total_deaths as signed)) as totaldeathcount
from Portfolio.coviddeath
where continent is not null
group by continent
order by totaldeathcount desc; 

#global numbers

select date,sum(new_cases) as total_cases,sum(cast(new_deaths as signed)) as total_deaths, sum(total_deaths)/sum(total_cases)*100 as deathpercentage
from Portfolio.coviddeath
where continent is not null
group by date
order by 1,2;


#looking at total poluation vs vaccinations
#use cte
with popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as(
select d.continent,d.location,d.date,d.population,v.new_vaccinations
	,sum(cast(v.new_vaccinations as signed)) over (partition by d.location order by d.location, d.date) as rollingpeoplevaccinated
from portfolio.coviddeath d
join portfolio.covidvacci v
on d.location=v.location and d.date=v.date
where d.continent is not null)
select *,(rollingpeoplevaccinated/population)*100
from popvsvac;

#creating view to store data for later visualizations
select d.continent,d.location,d.date,d.population,v.new_vaccinations
	,sum(cast(v.new_vaccinations as signed)) over (partition by d.location order by d.location, d.date) as rollingpeoplevaccinated
from portfolio.coviddeath d
join portfolio.covidvacci v
on d.location=v.location and d.date=v.date
where d.continent is not null;

select *
from new_view;



