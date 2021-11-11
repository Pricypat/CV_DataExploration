Select * from CovidDeath where  continent = 'Africa' --location ='india'
order by 3,4
Select Count(*) from CovidVaccination
 country-->iso_code, continent, location, population
 IND, Asia, Inida, 1339238983


 --create table Country (iso_code varchar(5), continent varchar(20), location varchar(60), population float)
 --Alter table country alter column iso_code varchar(10)
 
 --Insert into Country 
 --Select distinct iso_code, continent, location, population from CovidDeath order by 1
 

 select * from Country
 Select * from CovidVaccination where  continent = 'Africa' 
 Select location,date,total_cases,new_cases,total_deaths,population from Coviddeath
 order by 1,2

  --Looking at Total death in our location
 Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage from Coviddeath
 where location like '%states%'
 order by 1,2

 --Looking at Total cases vs Population
 --Shows the list of DeathPopulation Percentage
 Select location,date,population,total_cases,(total_cases/population)*100 as DeathPopulationPercentage from Coviddeath
 --where location like '%states%'
 order by 1,2

 --Looking at countries with highest infection rate compared to population
 Select location,population,Max(total_cases) as Highestinfection,Max((total_cases/population))*100 as percentpopulationinfected from Coviddeath
 Group by location,population
order by percentpopulationinfected desc

--Showing countries with high death count per population
Select location,Max(cast(total_deaths as int)) as Totaldeathcount from Coviddeath
where Continent is not null
 Group by location
 order by Totaldeathcount desc

 --Let's brek things by continent
 Select continent,Max(cast(total_deaths as int)) as Totaldeathcount from Coviddeath
where Continent is not null
 Group by continent
 order by Totaldeathcount desc

 Select sum(new_cases) as Total_cases,sum(cast(new_deaths as int)) as Total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
 from Coviddeath
 where Continent is not null
 order by 1,2

 --Looking at Total Population vs Vaccinations
 Select D.location,D.continent,D.date, d.population, V.new_vaccinations, 
 sum(convert(float, v.new_vaccinations)) OVER(partition by D.location order by D.location,D.date)as NewlyVaccinated 
 --,sum(convert(float, v.new_vaccinations)) OVER(partition by d.date order by D.date)as NewlyVaccinatedwoldwide 
 From CovidDeath D
	join CovidVaccination V on D.date=V.date and D.location=V.location
	where D.Continent is not null and v.location = 'India'
	--Group by D.location,D.continent,D.date
	order by 1,3 


	 Select distinct date --, new_vaccinations, 
 ,sum(convert(float, new_vaccinations)) OVER(partition by date order by date)as NewlyVaccinatedwoldwide 
 from CovidVaccination --on D.date=V.date and D.location=V.location
	--where D.Continent is not null and v.location = 'India'
	--group by date, new_vaccinations
	--Group by D.location,D.continent,D.date
	order by 1  


	---USE CTE
	with popvsvac (location,continent,date,population,new_vaccinations, TotalVaccinated)
	as
	(
	 Select D.location,D.continent,D.date, d.population, V.new_vaccinations, 
 sum(convert(float, v.new_vaccinations)) OVER(partition by D.location order by D.location,D.date)as TotalVaccinated 
 --,sum(convert(float, v.new_vaccinations)) OVER(partition by d.date order by D.date)as NewlyVaccinatedwoldwide 
 From CovidDeath D
	join CovidVaccination V on D.date=V.date and D.location=V.location
	where D.Continent is not null 
	--Group by D.location,D.continent,D.date
	 --order by 1,3 
	)
	select *, convert(numeric(5,2),(TotalVaccinated/population)*100) from popvsvac where location ='India' order by 1,3



	--------- TEMP Table
	Create table #percentpopulation 
	(
	location nvarchar(255),
	continent nvarchar(255),
	date datetime, 
	population numeric, 
	new_vaccinations numeric,
	TotalVaccinated numeric
	)

	Insert into #percentpopulation
	Select D.location,D.continent,D.date, d.population, V.new_vaccinations, 
 sum(convert(float, v.new_vaccinations)) OVER(partition by D.location order by D.location,D.date)as TotalVaccinated 
 --,sum(convert(float, v.new_vaccinations)) OVER(partition by d.date order by D.date)as NewlyVaccinatedwoldwide 
 From CovidDeath D
	join CovidVaccination V on D.date=V.date and D.location=V.location
	where D.Continent is not null 

	select *, convert(numeric(5,2),(TotalVaccinated/population)*100) Percentage from #percentpopulation where location ='India' order by 1,3

	---Create view 

	Create view percentpopulation as
	Select D.location,D.continent,D.date, d.population, V.new_vaccinations, 
 sum(convert(float, v.new_vaccinations)) OVER(partition by D.location order by D.location,D.date)as TotalVaccinated 
 --,sum(convert(float, v.new_vaccinations)) OVER(partition by d.date order by D.date)as NewlyVaccinatedwoldwide 
 From CovidDeath D
	join CovidVaccination V on D.date=V.date and D.location=V.location
	where D.Continent is not null 

	select *, convert(numeric(5,2),(TotalVaccinated/population)*100) Percentage from percentpopulation where location ='India' order by 1,3
