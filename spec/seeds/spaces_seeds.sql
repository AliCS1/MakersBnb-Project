DROP TABLE IF EXISTS spaces;

CREATE TABLE spaces (
id SERIAL PRIMARY KEY,
name text,
description text,
price int,
user_id int,
available_from date,
available_to date,
constraint fk_user foreign key(user_id) references users(id)
);

TRUNCATE TABLE spaces RESTART IDENTITY;

INSERT INTO spaces(name, description, price, user_id, available_from, available_to) VALUES ('House', 'BnB House', '75', '1', '2022-11-2', '2022-11-30'), ('Barn', 'Barn BnB', '100', '1', '2022-03-31', '2023-01-14'), ('TreeHouse', 'BnB Treehouse', '150', '2', '2022-07-13', '2022-12-24');