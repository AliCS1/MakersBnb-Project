DROP TABLE IF EXISTS users; 

CREATE TABLE users (
 id SERIAL PRIMARY KEY,
  email text,
  password_1 text
);

TRUNCATE TABLE users RESTART IDENTITY;


INSERT INTO users (email, password_1) VALUES  
('ABC@gmail.com','MyPassword123'),
('123@gmail.com', 'FirstPassword3');