DROP TABLE IF EXISTS bookings;

CREATE TABLE bookings (
id SERIAL PRIMARY KEY,
spaces_id int,
users_id int,
confirmed boolean,
booking_date date,
constraint fk_user foreign key(users_id) references users(id),
constraint fk_space foreign key(spaces_id) references spaces(id)
);


TRUNCATE TABLE bookings RESTART IDENTITY;


INSERT INTO bookings (spaces_id, users_id, confirmed,  booking_date) VALUES (2, 1, false,'2022-11-11');
