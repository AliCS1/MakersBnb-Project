--DROP TABLE IF EXISTS spaces;

--CREATE TABLE spaces (
--id SERIAL PRIMARY KEY,
--spaces_name text,
--description text,
--price int,
--users_id int,
--constraint fk_user foreign key(users_id) references users(id)
--);


INSERT INTO spaces (spaces_name, description, price, users_id) VALUES ('BobsSpace', 'This is a 5 star room', 10, 1);