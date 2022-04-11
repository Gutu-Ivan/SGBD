create table film(
idfilm smallint primarykey,
titlu varchar(50) not null,
regizor varchar(50) not null,
anul smallint not null
);

create table actor(
	idactor smallint primarykey,
	nume varchar(50)notnull
);

create table filmographie(
idactor smallint not null,
idfilm smallint not null,
rolu varchar(50)not null,
salariu int not null,
	primarykey(idactor,idfilm),
foreign key(idactor) referencesactor(idactor),
foreign key(idfilm) referencesfilm(idfilm)
);


insert into film values(1,'les evades','darabont',1994);
insert into film values(2,'rango','verbinski',2015);
insert into film values(3,'le parrain','coppola',1972);
insert into film values(4,'le parrain_2','coppola',1974);
insert into film values(5,'chocolat','hallstrom',2013);
insert into film values(6,'scarface','de palma',1983);
insert into film values(7,'l''odyssee de pi','ang lee',2011);

insert into actor values(1,'jonny deep');
insert into actor values(2,'al pacino');
insert into actor values(3,'suraj sharma');
insert into actor values(4,'brad pitt');
insert into actor values(5,'edward norton');

insert into filmographie values(1,5,'roux',5000);
insert into filmographie values(1,7,'rango',10000);
insert into filmographie values(2,2,'michael corleone',10000);
insert into filmographie values(2,3,'michael corleone',20000);
insert into filmographie values(2,6,'tony montana',15000);
insert into filmographie values(3,4,'pi',20000);

#1
#a
SELECT film.idFilm,film.titlu
FROM film
INNER JOIN filmographie ON film.idFilm=filmographie.idFilm
INNER JOIN actor ON filmographie.idActor=actor.idActor
WHERE nume='Suraj Sharma'
ORDER BY titlu

#b
SELECT film.idFilm,film.titlu
FROM film
WHERE film.anul<2000 AND film.regizor="Coppola"

#c
SELECT film.titlu, Sum(filmographie.salariu)
FROM film
INNER JOIN filmographie ON film.idFilm=filmographie.idFilm
GROUP BY film.idFilm
ORDER BY filmographie.salariu DESC

#d
SELECT actor.nume,MAX(filmographie.salariu)
FROM filmographie
INNER JOIN actor ON filmographie.idActor=actor.idActor

#e
SELECT actor.nume,COUNT(filmographie.idFilm)
FROM actor
INNER JOIN filmographie ON actor.idActor=filmographie.idActor
GROUP BY actor.nume

#f
SELECT DISTINCT a1.nume,a2.nume
FROM filmographie f1
INNER JOIN actor a1 ON f1.idActor=a1.idActor
INNER JOIN filmographie f2 ON f1.idActor<>f2.idActor
INNER JOIN actor a2 ON f2.idActor=a2.idActor
INNER JOIN film ON film.idFilm=f2.idFilmandfilm.idFilm=f1.idFilm
WHERE a1.idActor>a2.idActor

#g
SELECT actor.nume,film.titlu
FROM film
INNER JOIN filmographie ON film.idFilm=filmographie.idFilm
INNER JOIN actor ON actor.idActor=filmographie.idActor

#3
#a
CREATE INDEX filmsuraj ON film(titlu);
DROP INDEX filmsuraj ON film;
SELECT film.idFilm,film.titlu
FROM film
INNER JOIN filmographie ON film.idFilm=filmographie.idFilm
INNER JOIN actor ON filmographie.idActor=actor.idActor
WHERE nume='Suraj Sharma'
ORDER BY titlu;
SHOW INDEXES FROM film

#b
CREATE INDEX film2000 ON film(titlu);
DROPINDEX film2000 ON film;
SELECT film.idFilm,film.titlu
FROM film
WHERE film.anul<2000ANDfilm.regizor="Coppola"
SHOW INDEX FROM film

#c
CREATE INDEX film_bugetONfilm(titlu);
DROP INDEX film_bugetONfilm;
SELECT film.titlu,Sum(filmographie.salariu)
FROM film
INNER jOIN filmographie ON film.idFilm=filmographie.idFilm
GROUP BY film.idFilm
ORDER BY filmographie.salariu DESC;
SHOW INDEX FROM film

#d
CREATE INDEX actori_platiti ON filmographie(salariu);
DROP INDEX actori_platiti ON filmographie;
SELECT actor.nume, MAX(filmographie.salariu)
FROM filmographie
INNER JOIN actor ON filmographie.idActor=actor.idActor
SHOW INDEX FROM filmographie;

#e
CREATE INDEX nr_filmeONactor(nume);
DROP INDEX nr_filmeONactor;
SELECT actor.nume, COUNT(filmographie.idFilm)
FROM actor
INNER JOIN filmographie ON actor.idActor=filmographie.idActor
GROUP BY actor.nume
SHOW INDEX FROM actor;

#f
CREATE INDEX perechi_actori ON filmographie(idActor);
DROP INDEX perechi_actori ON filmographie;
SELECT DISTINCT a1.nume,a2.nume
FROM filmographie f1
INNER JOIN actor a1 ON f1.idActor=a1.idActor
INNER JOIN filmographie f2 ON f1.idActor<>f2.idActor
INNER JOIN actor a2 ON f2.idActor=a2.idActor
INNER JOIN film ON film.idFilm=f2.idFilmandfilm.idFilm=f1.idFilm
WHERE a1.idActor>a2.idActor;
SHOW INDEX FROM filmographie;

#g
CREATE INDEX actor_filme ON film(titlu);
DROP INDEX actor_filmeONfilm;
SELECT actor.nume,film.titlu
FROM film
INNER JOIN filmographie ON film.idFilm=filmographie.idFilm
INNER JOIN actor ON actor.idActor=filmographie.idActor;
SHOW INDEX FROM film;

#4
#ѕосле создани€ индексированных запросов мы видим, что врем€ выполнени€ было оптимизировано.







