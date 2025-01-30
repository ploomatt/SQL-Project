--Provide an overview of all values listed in the dataset
Select *
From PortfolioProject..CovidDeathsXL
Where continent <> ''
order by location, CAST(date AS DATE);


--Total cases vs Total Deaths
--Liklihood of death upon contraction
Select 
	Location, 
	date, 
	total_cases, 
	total_deaths, 
	(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject..CovidDeathsXL
Where continent <> ''
order by location, CAST(date AS DATE);


--Total Covid cases vs Population in the US
--percentage of population contracted Covid
Select 
	Location, 
	date, 
	total_cases, 
	population, 
	(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeathsXL
Where location like '%states%' and continent <> ''
order by location, CAST(date AS DATE);


-- Looking at Countries with Highest Infection Rate compared to population
SELECT 
	Location, 
	Population, 
	MAX(total_cases) AS HighestInfectionCount, 
	MAX(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeathsXL
Where continent <> ''
GROUP BY Location, Population
ORDER BY PercentPopulationInfected desc;


-- Showing Countries with Highest Death Count per Population(Countries)
Select 
	Location, 
	Population, 
	MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeathsXL
Where continent <> ''
GROUP BY location, population
ORDER BY TotalDeathCount desc;


--Showing continents with the highest death count
Select 
	continent,
	MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeathsXL
Where continent <> ''
GROUP BY continent
ORDER BY TotalDeathCount desc;


--Death percentage by Global infection numbers
SELECT 
	SUM(CAST(new_cases AS INT)) AS TotalCases,
	SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
	SUM(CAST(new_deaths AS INT)) * 100.0 / NULLIF(SUM(CAST(new_cases AS INT)), 0) AS DeathPercentage
FROM PortfolioProject..CovidDeathsXL
WHERE continent <> ''
ORDER BY 1,2


--Global Infection numbers by date
SELECT 
	date,
	SUM(CAST(new_cases AS INT)) AS TotalCases,
	SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
	SUM(CAST(new_deaths AS INT)) * 100.0 / NULLIF(SUM(CAST(new_cases AS INT)), 0) AS DeathPercentage
FROM PortfolioProject..CovidDeathsXL
WHERE continent <> '' -- Exclude blanks
GROUP BY date
ORDER BY CAST(date AS DATE);


--Total Population vs Vaccination
SELECT 
    dea.continent, 
	dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations, 
    SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (
        PARTITION BY dea.location 
        ORDER BY dea.date
    ) AS RollingVaccinatedPeople, 
    (SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date) 
	/ NULLIF(CONVERT(FLOAT, dea.population), 0)) * 100 AS VaccinationPercentage
FROM PortfolioProject..CovidDeathsXL dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent <> ''
ORDER BY dea.location, CAST(dea.date AS DATE);


--CTE for rolling vaccinated people and vaccination percentage
With PopvsVac (continent, location, date, population, new_vaccinations,RollingVaccinatedPeople)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.location Order by dea.location, 
dea.date) as RollingVaccinatedPeople--, (RollingVaccinatedPeople/dea.population)*100
From PortfolioProject..CovidDeathsXL dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ''
)
Select *, (CAST(RollingVaccinatedPeople AS FLOAT)/NULLIF(CAST(population AS FLOAT),0))*100 AS VaccinationPercentage
From PopvsVac
order by location,CAST(date AS DATE);


--Calulate Rolling Vaccination Rates
--TEMP TABLE
IF OBJECT_ID('tempdb..#PercentPopulationVaccinated') IS NOT NULL
    DROP TABLE #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated
(Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC);

INSERT INTO #PercentPopulationVaccinated (Continent, Location, Date, Population, New_vaccinations)
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    TRY_CAST(dea.population AS NUMERIC) AS Population, 
    TRY_CAST(vac.new_vaccinations AS NUMERIC) AS New_vaccinations 
FROM PortfolioProject..CovidDeathsXL dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent <> ''
  AND TRY_CAST(vac.new_vaccinations AS NUMERIC) IS NOT NULL 
  AND TRY_CAST(dea.population AS NUMERIC) IS NOT NULL; 

SELECT 
    Continent,
    Location,
    Date,
    Population,
    New_vaccinations,
    SUM(New_vaccinations) OVER (PARTITION BY Location ORDER BY Date
    ) AS RollingVaccinatedPeople, 
    (CAST(SUM(New_vaccinations) OVER (PARTITION BY Location ORDER BY Date
    ) AS FLOAT) / NULLIF(CAST(Population AS FLOAT), 0)) * 100 AS VaccinationPercentage
FROM #PercentPopulationVaccinated
ORDER BY Location ASC, Date ASC;
DROP TABLE #PercentPopulationVaccinated;


--Create View to store data for potential visualizations
Create View PercentPopulationVaccinated as
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.location Order by dea.location, 
dea.date) as RollingVaccinatedPeople
From PortfolioProject..CovidDeathsXL dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ''

Select* 
From PercentPopulationVaccinated
