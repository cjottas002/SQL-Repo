--Creacion de una base de datos
CREATE DATABASE/SCHEMA nation;

--Usar una base de datos
USE nation;

--Eliminar una base de datos
DROP DATABASE/SCHEMA nation;

--Crear tablas
create table countries (
    country_id int auto_increment,
    name varchar(50) not null,
    area decimal(10,2) not null,
    national_day date,
    country_code2 char(2) not null unique,
    country_code3 char(3) not null unique,
    region_id int not null,
    foreign key(region_id) 
  	references regions(region_id),
    primary key(country_id)
);

create table country_stats(
    country_id int,
    year int,
    population int,
    gdp decimal(15,0),
    primary key (country_id, year),
    foreign key(country_id)
	references countries(country_id)
);

create table country_languages(
    country_id int,
    language_id int,
    official boolean not null,
    primary key (country_id, language_id),
    foreign key(country_id) 
	references countries(country_id),
    foreign key(language_id) 
	references languages(language_id)
);

create table languages(
    language_id int auto_increment,
    language varchar(50) not null,
    primary key (language_id)
);

create table continents(
    continent_id int auto_increment,
    name varchar(255) not null,
    primary key(continent_id)
);

create table regions(
    region_id int auto_increment,
    name varchar(100) not null,
    continent_id INT NOT NULL,
    primary key(region_id),
    foreign key(continent_id) 
        references continents(continent_id) 
);

create table vips(
    vip_id int primary key,
    name varchar(100) not null
);

create table guests(
    guest_id int primary key,
    name varchar(100) not null
);


