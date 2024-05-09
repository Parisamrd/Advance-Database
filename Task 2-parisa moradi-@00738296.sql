/*Create FoodserviceDB Database*/
create database FoodserviceDB

/*Set restaurant_ID as primary key*/
ALTER TABLE restaurants
ADD CONSTRAINT PK_restaurant PRIMARY KEY (Restaurant_ID);

go

/*Set consumer_ID as Primary key*/
ALTER TABLE consumers
ADD CONSTRAINT PK_consumers PRIMARY KEY (Consumer_ID);

/*SET combination of the two keys as primary */
ALTER TABLE ratings
ADD CONSTRAINT pk_rating PRIMARY KEY (Consumer_ID, Restaurant_ID);

/*also define the foreign_key*/
ALTER TABLE ratings
ADD CONSTRAINT FK_consumers FOREIGN KEY (Consumer_ID) REFERENCES consumers(Consumer_ID)

ALTER TABLE ratings
ADD CONSTRAINT FK_rarest FOREIGN KEY (Restaurant_ID) REFERENCES restaurants(Restaurant_ID);

go
/*SET Primary key and Foreign key for restaurant_cuisines table*/
ALTER TABLE restaurant_cuisines
ADD CONSTRAINT PK_rescuis PRIMARY KEY (Restaurant_ID,Cuisine)

ALTER TABLE restaurant_cuisines
ADD CONSTRAINT FK_rescuis FOREIGN KEY (Restaurant_ID) REFERENCES restaurants(Restaurant_ID);


/*
Question 1 Medium Range Price, Open Area, Mexican Food
*/

SELECT restaurants.* 
FROM restaurants
JOIN restaurant_cuisines ON restaurants.Restaurant_ID = restaurant_cuisines.Restaurant_ID
WHERE restaurants.price = 'Medium' 
AND restaurants.Area = 'Open' 
AND restaurant_cuisines.cuisine = 'Mexican';

/*Question 2*/
/*Total number of restaurants with overall rating 1 serving Mexican food*/
SELECT COUNT(*) AS mexican_restaurants_count
FROM restaurants r
JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
JOIN ratings rat ON r.restaurant_ID = rat.restaurant_ID
WHERE rat.overall_rating = 1
AND rc.Cuisine = 'Mexican';

/*Total number of restaurants with overall rating 1 serving Italian food*/
SELECT COUNT(*) AS italian_restaurants_count
FROM restaurants r
JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
JOIN ratings rat ON r.Restaurant_ID = rat.Restaurant_ID
WHERE rat.overall_rating = 1
AND rc.Cuisine = 'Italian';

/*average age of consumers who have given a 0 rating to the 'Service_rating' column.*/
SELECT ROUND(AVG(c.age), 0) AS average_age
FROM consumers c
JOIN ratings r ON c.Consumer_ID = r.Consumer_ID
WHERE r.service_rating = 0;

/*restaurants ranked by youngest consumers/sort the result high to low*/
SELECT 
    res.name AS restaurant_name,
    r.food_rating
FROM 
    restaurants res
JOIN 
    ratings r ON res.Restaurant_ID = r.Restaurant_ID
JOIN 
    consumers c ON r.Consumer_ID = c.Consumer_ID
JOIN 
    (SELECT 
        MIN(age) AS min_age
    FROM 
        consumers) AS min_age_table ON min_age_table.min_age = c.age
ORDER BY 
    r.food_rating DESC;

/*Stored Procedure update service rating to 2 if have parking*/
CREATE PROCEDURE UpdateServiceRatingWithParking
AS
BEGIN
    UPDATE ratings
    SET Service_rating = '2'
    WHERE Restaurant_ID IN (
        SELECT Restaurant_ID
        FROM restaurants
        WHERE parking = 'yes' OR parking = 'public'
    );
END


EXEC UpdateServiceRatingWithParking;

/*restaurants that have at least one consumer rated their service as '2'*/
SELECT Name
FROM restaurants AS r
WHERE EXISTS (
    SELECT 1
    FROM ratings AS ra
    WHERE ra.Restaurant_ID = r.Restaurant_ID
    AND ra.Service_rating = '2' 
);

/*names of all restaurants received the highest food rating serve at least one cuisine from either Italy or France*/
SELECT r.name
FROM restaurants r
JOIN ratings ra ON r.Restaurant_ID = ra.Restaurant_ID
JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
WHERE ra.Food_Rating = (
    SELECT MAX(Food_Rating)
    FROM ratings
)
AND (rc.Cuisine = 'Italian' OR rc.Cuisine = 'French');


/*names of restaurants/ lowest rating food/ Italian cuisine */
SELECT name
FROM restaurants
WHERE Restaurant_ID IN (
    SELECT Restaurant_ID
    FROM ratings
    WHERE Food_Rating = 0 
)
AND Restaurant_ID IN (
    SELECT Restaurant_ID
    FROM restaurant_cuisines
    WHERE Cuisine = 'Italian'
);

/*list of cities, states, and countries/ more than one consumer,
orders them by the total number of consumers in each location/ highest number first.*/
SELECT City, State, Country, COUNT(*) as Total_Consumers
FROM consumers
GROUP BY City, State, Country
HAVING COUNT(*) > 1
ORDER BY Total_Consumers DESC, City, State, Country;





