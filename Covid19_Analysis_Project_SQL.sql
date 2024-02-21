--SELECT *
--FROM Covid19_Project..CovidDeaths
--ORDER BY 3, 4



--SELECT *
--FROM Covid19_Project..CovidVaccinations
--ORDER BY 3, 4

---Selecting Data That i will be using
Select Location, date, total_cases, new_cases, total_deaths, population
From Covid19_Project..CovidDeaths
Order by 1,2

--- Looking at total cases  vs Total Deaths
--- Shows the likelihood percentage of Dying in your Country
Select Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
From Covid19_Project..CovidDeaths
Where location like '%wati%'
Order by 1,2

---Looking at Total Cases vs Population
--- Shows The Percentage of Population affected by Covid
Select Location, Population ,MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/Population)*100 AS 
PercentagePopulationInfected
From Covid19_Project..CovidDeaths
---Where location like '%China%'
GROUP BY Location, Population
Order by HighestInfectionCount DESC


---Showing Countriess with the Highest Death Count
Select Location, Max(cast(Total_deaths as int )) as HighestDeathRates
From Covid19_Project..CovidDeaths
---Where location like '%China%'
Where continent is not null
GROUP BY Location
order by HighestDeathRates DESC

---Joining the Two Tables


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From Covid19_Project..CovidDeaths dea
join Covid19_Project..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--- Then looking at the total Population vs vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) Over (Partition By dea.Location Order by dea.Location , dea.date)
as RollingPeopleVaccinated
From Covid19_Project..CovidDeaths dea
join Covid19_Project..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

---Creating a CTE to see the Percantage of Vaccinated 
DROP TABLE IF EXISTS popVsVac

with popVsVac (continent, location, date, population, new_vaccinations,RollingPeopleVaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) Over (Partition By dea.Location Order by dea.Location , dea.date)
as RollingPeopleVaccinated
From Covid19_Project..CovidDeaths dea
join Covid19_Project..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null)

Select *, (RollingPeopleVaccinated / population)*100
From popVsVac


---Creating View to store data for later Visualization

Create View PercentPopulationVaccinated as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) Over (Partition By dea.Location Order by dea.Location , dea.date)
as RollingPeopleVaccinated
From Covid19_Project..CovidDeaths dea
join Covid19_Project..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null)
