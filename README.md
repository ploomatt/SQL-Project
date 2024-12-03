# SQL-Project
Description:
>This SQL project focuses on analyzing international COVID-19 statistics for the years 2020 and 2021.

## Project Overview
#### Motivation
>This project aims to leverage SQL and data analysis techniques to examine key COVID-19 statistics from 2020 and 2021, including case counts, deaths, and vaccination rates. By filtering and querying large datasets, this analysis seeks to uncover valuable insights into the global distribution of the virus, the effectiveness of public health measures, and the relationship between vaccination rates and infection trends.
#### Technologies Used
>SQL: Data querying and analysis using SQL queries for aggregating, filtering, and transforming COVID-19 data.<br>
>Database: Relational database management system (Microsoft Server Management Studio) for data storage and manipulation.<br>
#### Features
>The queries used in this project are designed to explore various connections between key COVID-19 metrics.
>>- By comparing Total COVID cases vs. Total Deaths, the likelihood of death upon contraction is analyzed.<br>
>>- Queries also examine the percentage of the population contracted by COVID<br>
>>- Identifying countries with the highest infection rates relative to their population, and ranks continents by the highest death count, helping to reveal patterns and disparities in the impact of the pandemic globally.<br>
>>- Data is put into perspective of population by calculating the percentage of 
## Data
#### Data Source
>Covid 19 Data from the University of Oxford and Global Change Data Lab.<br>
>>https://ourworldindata.org/covid-deaths <br>
>The data used will be attached below as CovidDeathsXL and CovidVaccinations as a csv file
### Data Structure
>The data is structured in a relational format, with each record representing COVID-19 statistics for a specific country or region on a given date. The key columns in the dataset are:<br>
>> - Location: Represents the country or region for which the data is recorded.<br>
>> - Population: The total population of the country or region.<br>
>> - Continent: The continent to which the location belongs.<br>
>> - Date: The specific date when the data was recorded, allowing for time-series analysis.<br>
>> - New_vaccinations: The number of new vaccinations administered on the recorded date.<br>
### Data Structure Continued...
>As part of the analysis, I created several new data columns to represent key proportions and metrics derived from the existing dataset. These columns were instrumental in gaining deeper insights into the vaccination and death trends. The following new columns were introduced:<br>
>> - VaccinationPercentage: Represents the proportion of the population that has been vaccinated, calculated by dividing the cumulative number of vaccinations by the population and multiplying by 100.<br>
>> - RollingVaccinatedPeople: Measures the cumulative number of people vaccinated over the course of the data period, providing a dynamic view of vaccination progress over time.<br>
>> - DeathPercentage: Indicates the percentage of individuals who have died as a result of COVID-19, calculated by dividing the total number of deaths by the total number of confirmed cases and multiplying by 100.<br>
>> - TotalDeathCount: Represents the cumulative number of deaths due to COVID-19 across all recorded dates.<br>
>> - PercentPopulationInfected: Shows the percentage of the population that has contracted COVID-19, calculated by dividing the total number of COVID-19 cases by the total population and multiplying by 100.<br>
## Results and Insights
>The project uncovers significant trends in COVID-19 cases, deaths, and vaccinations across different countries and regions.<br>
>Key insights include the relationship between vaccination progress and the reduction in COVID cases, as well as the countries with the highest infection and death rates.







