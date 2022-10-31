

CREATE TABLE users (
 id SERIAL PRIMARY KEY,
  email text,
  password_1 text
);


INSERT INTO users (email, password_1) VALUES ('ABC@gmail.com','MyPassword123');