SELECT * 
FROM PortfolioProject..CovidDeaths
where continent is not null
-------------------------------------------------------------------------------------
select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where location = 'Tunisia' 
and continent is not null
order by 1,2
-- Looking at Total cases vs Total Deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location = 'Tunisia'
and continent is not null
order by 1,2

-- look at total cases vs population
select location, date, population, total_cases,(total_cases/population)*100 as CasePercentage
from PortfolioProject..CovidDeaths
where location = 'Tunisia'
and continent is not null
order by 1,2
-- look at countries with highest infection rates
select location, population, MAX(total_cases) as HighestInfectionRate, MAX(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
group by population, location
order by PercentPopulationInfected desc

-- Show countries with highest death count per population
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by  location
order by TotalDeathCount desc

-- Show countries with highest death count per population
select location, MAX(cast(total_deaths as int)) as TotalDeathCount, MAX(cast(total_deaths as int)/population)*100 as PercentageDeathPerPopulation
from PortfolioProject..CovidDeaths
where continent is not null
group by  location
order by PercentageDeathPerPopulation desc
-- Show continent with highest death count per population
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by  location
order by TotalDeathCount desc

-- Globally per day
select date, SUM(cast(total_deaths as int)) as TotalDeaths, SUM(new_cases) as TotalCases, SUM(cast(total_deaths as int))/SUM(new_cases)
from PortfolioProject..CovidDeaths
where continent is not null
group by  date
order by 1,2

-- Global sum
select SUM(cast(total_deaths as int)) as TotalDeaths, SUM(new_cases) as TotalCases, SUM(cast(total_deaths as int))/SUM(new_cases) as percentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Vaccination table
select * 
from..CovidVaccinations

-- Join table
Select *
from PortfolioProject..CovidVaccinations dea
join PortfolioProject..CovidDeaths vac
     on dea.location = vac.location
	 and dea.date = vac.date

-- Total population vs vaccination
Select dea.continent, dea.location, dea.population, dea.date, (cast(new_vaccinations as bigint)) as NewVaccinations, SUM(CONVERT(bigint, new_vaccinations)) OVER (partition by dea.location order by dea.location, CONVERT (date, dea.date))
From PortfolioProject..CovidVaccinations dea
Join PortfolioProject..CovidDeaths vac
    on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3
-- Tunisia population vs vaccination
Select dea.continent, dea.location, dea.population, dea.date, (cast(new_vaccinations as bigint)) as NewVaccinations, SUM(CONVERT(bigint, new_vaccinations)) OVER (partition by dea.location order by dea.location, CONVERT (date, dea.date)) as NumberOfVaccines
From PortfolioProject..CovidVaccinations dea
Join PortfolioProject..CovidDeaths vac
    on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
and dea.location = 'Tunisia'
order by 2,3

-- CTE
with PopVsVac (continent, location, population, date, new_vaccinations, NumberOfVaccines)
as
(
Select dea.continent, dea.location, dea.population, dea.date, (cast(new_vaccinations as bigint)) as NewVaccinations, SUM(CONVERT(bigint, new_vaccinations)) OVER (partition by dea.location order by dea.location, CONVERT (date, dea.date)) as NumberOfVaccines
From PortfolioProject..CovidVaccinations dea
Join PortfolioProject..CovidDeaths vac
    on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
and dea.location = 'Tunisia'
--order by 2,3
)
Select *, (NumberOfVaccines/population)*100 as PercentagePopulationVaccinated
from PopVsVac

-- Create a view to store data for later visulizations (Tunisia)

create View PercentagePopulationVaccinated as
Select dea.continent, dea.location, dea.population, dea.date, (cast(new_vaccinations as bigint)) as NewVaccinations, SUM(CONVERT(bigint, new_vaccinations)) OVER (partition by dea.location order by dea.location, CONVERT (date, dea.date)) as NumberOfVaccines
From PortfolioProject..CovidVaccinations dea
Join PortfolioProject..CovidDeaths vac
    on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
and dea.location = 'Tunisia'

-- Create a view for world
create View PercentagePopulationVaccinatedworld as
Select dea.continent, dea.location, dea.population, dea.date, (cast(new_vaccinations as bigint)) as NewVaccinations, SUM(CONVERT(bigint, new_vaccinations)) OVER (partition by dea.location order by dea.location, CONVERT (date, dea.date)) as NumberOfVaccines
From PortfolioProject..CovidVaccinations dea
Join PortfolioProject..CovidDeaths vac
    on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null

