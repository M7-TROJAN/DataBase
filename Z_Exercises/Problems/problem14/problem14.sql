-- Problem 14: Get all Makes with make starts with 'B'

SELECT Makes.Make 
FROM Makes
where Makes.Make like 'B%';