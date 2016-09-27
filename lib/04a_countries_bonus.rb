# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

# BONUS QUESTIONS: These problems require knowledge of aggregate
# functions. Attempt them after completing section 05.

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
    SELECT
      name
    FROM
      countries
    WHERE
      gdp > (
        SELECT
          MAX(gdp)
        FROM
          countries
        WHERE
          continent = 'Europe'
        GROUP BY
          continent
      )
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
    SELECT
      continent, name, area
    FROM
      countries large_countries
    WHERE
      name IN (
        SELECT
          name
        FROM
          countries
        WHERE
          large_countries.continent = countries.continent
        ORDER BY
          area DESC
        LIMIT 1
      )
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
  SELECT
    large_countries.name, large_countries.continent
  FROM
    countries large_countries
  WHERE
    large_countries.population IS NOT NULL AND
    large_countries.population > 3 * (
      SELECT
        countries.population
      FROM
        countries
      WHERE
        large_countries.continent = countries.continent AND
        large_countries.name != countries.name AND
        countries.population IS NOT NULL
      ORDER BY
        countries.population DESC
      LIMIT 1
    )
  SQL
end
