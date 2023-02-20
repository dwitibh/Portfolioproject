--SELECT *
--FROM sqlPortfolioProject..CovidVaccinationsf
--ORDER BY 3,4
SELECT *
FROM sqlPortfolioProject..CovidDeathsf
ORDER BY 3,4
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM sqlPortfolioProject..CovidDeathsf
ORDER BY 1,2
-- shows likelyhood of dying if you effect with covid in diffrent country

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Deathpercentage
FROM sqlPortfolioProject..CovidDeathsf
Where location like '%kingdom%'
ORDER BY 1,2

--total cases vs population
SELECT location,date,population,total_cases,(total_cases/population)*100 AS Infectionpercentage
FROM sqlPortfolioProject..CovidDeathsf
Where location like '%kingdom%'
ORDER BY 1,2

--country with highest infection ratio to population

SELECT location,population,MAX(total_cases)as HighestinfectionCount,
MAX((total_cases/population))*100 AS Infectionpercentage
FROM sqlPortfolioProject..CovidDeathsf
--Where location like '%kingdom%'
GROUP BY location,population
ORDER BY HighestinfectionCount

--countries with highest death count per population
SELECT location,population,MAX(total_deaths)as HighestdeathCount,
Max((total_deaths/population))*100 AS Deathpercentage
FROM sqlPortfolioProject..CovidDeathsf
--Where location like '%kingdom%'
GROUP BY location,population
ORDER BY HighestdeathCount DESC

--Highest death in country

SELECT location,MAX(cast(total_deaths as int)) as TotaldeathCount
From sqlPortfolioProject..CovidDeathsf
Where continent is not null
GROUP BY location
ORDER BY TotaldeathCount DESC

--seprate above by continent 

SELECT continent,MAX(cast(total_deaths as int)) as TotaldeathCount
From sqlPortfolioProject..CovidDeathsf
Where continent is not null
GROUP BY continent
ORDER BY TotaldeathCount DESC


--global counts date vise
SELECT date,sum(new_cases)as TotalNewCases,sum(cast(new_deaths as int)) as TotalNewDeath,
sum(cast(new_deaths as int))/sum(new_cases)*100 as GloabalDeathpercentage 
From sqlPortfolioProject..CovidDeathsf
Where continent is not null
Group By date
Order BY 1

--Global count
SELECT sum(new_cases)as TotalNewCases,sum(cast(new_deaths as int)) as TotalNewDeath,
sum(cast(new_deaths as int))/sum(new_cases)*100 as GloabalDeathpercentage 
From sqlPortfolioProject..CovidDeathsf
Where continent is not null
--Group By date
Order BY 1,2

--total population vs vaccination 
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
FROM sqlPortfolioProject..CovidDeathsf dea
JOIN sqlPortfolioProject..CovidVaccinationsf vac
ON dea.location=vac.location and 
dea.date=vac.date
Where dea.continent is not null
Order BY 2,3

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location, dea.date)as Rollingcount_PeopleVaccinated
FROM sqlPortfolioProject..CovidDeathsf dea
JOIN sqlPortfolioProject..CovidVaccinationsf vac
ON dea.location=vac.location and 
dea.date=vac.date
Where dea.continent is not null
Order BY 2,3

--cte


With popvsvac(continent,location,date,population,new_vaccinations,Rollingcount_PeopleVaccinated)

as
(SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location, dea.date)as Rollingcount_PeopleVaccinated
FROM sqlPortfolioProject..CovidDeathsf dea
JOIN sqlPortfolioProject..CovidVaccinationsf vac
ON dea.location=vac.location and 
dea.date=vac.date
Where dea.continent is not null
--Order BY 2,3
)
SELECT *,(Rollingcount_PeopleVaccinated/population)*100
FROM popvsvac

--tem table method
Drop table if exists #Percentagepoulationvaccinated
Create Table #Percentagepoulationvaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
Rollingcount_PeopleVaccinated numeric
)
Insert Into #Percentagepoulationvaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location, dea.date)as Rollingcount_PeopleVaccinated
FROM sqlPortfolioProject..CovidDeathsf dea
JOIN sqlPortfolioProject..CovidVaccinationsf vac
ON dea.location=vac.location and 
dea.date=vac.date
Where dea.continent is not null
--Order BY 2,3

SELECT *,(Rollingcount_PeopleVaccinated/population)*100 as VaccinatedPercent
FROM #Percentagepoulationvaccinated

--creating view for visulazation
Create view Percentagepoulationvaccinated as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location, dea.date)as Rollingcount_PeopleVaccinated
FROM sqlPortfolioProject..CovidDeathsf dea
JOIN sqlPortfolioProject..CovidVaccinationsf vac
ON dea.location=vac.location and 
dea.date=vac.date
Where dea.continent is not null
