create table persoane(
    idPersoana smallint,
    Numele varchar(50),
    Varsta smallint,
    primary key(idPersoana)
);

create table rude(
    idPersoana1 smallint,
    idPersoana2 smallint
);

create table amici(
    idPersoana1 smallint,
    idPersoana2 smallint
);

insert into persoane
values (1, 'Elvi', 19),
       (2, 'Farouk', 19),
       (3, 'Sam', 19),
       (4, 'Tiany', 19),
       (5, 'Nadia', 14),
       (6, 'Chris', 12),
       (7, 'Kris', 10),
       (8, 'Bethany', 16),
       (9, 'Louis', 17),
       (10, 'Austin', 22),
       (11, 'Gabriel', 21),
       (12, 'Jessica', 20),
       (13, 'John', 16),
       (14, 'Alfred', 19),
       (15, 'Samantha', 17),
       (16, 'Craig', 17);

insert into amici
values (1, 2),
       (1, 3),
       (2, 4),
       (2, 6),
       (3, 9),
       (4, 9),
       (7, 5),
       (5, 8),
       (6, 10),
       (13, 6),
       (7, 6),
       (8, 7),
       (9, 11),
       (12, 9),
       (10, 15),
       (12, 11),
       (12, 15),
       (13, 16),
       (15, 13),
       (16, 14);

insert into rude
values (4, 6),
       (2, 4),
       (9, 7),
       (7, 8),
       (11, 9),
       (13, 10),
       (14, 5),
       (12, 13);

#1
select numele from persoane
inner join amici a2 on persoane.idPersoana = a2.idPersoana2
where (SELECT idPersoana2 where idPersoana1 = 1);

#2
SELECT p1.Numele, p2.Numele
FROM amici
INNER JOIN persoane AS p1 ON amici.idpersoana1 = p1.idPersoana
INNER JOIN persoane AS p2 ON amici.idpersoana2 = p2.idPersoana
WHERE p1.Virsta <> p2.Virsta;


#3
select p1.varsta, p1.numele, p2.varsta, p2.numele
from amici
inner join persoane as p1 on amici.idPersoana1 = p1.idPersoana
inner join persoane as p2 on amici.idPersoana2 = p2.idPersoana
where p1.Varsta = p2.Varsta
order by p1.Varsta, p2.Varsta, p1.Numele, p2.Numele;

#4
select p.numele, count(r.idPersoana2) as nr
from persoane
inner join rude as r on persoane.idPersoana = r.idPersoana1
inner join persoane p on p.idPersoana = r.idPersoana2
where count(r.idPersoana2) > 1
order by  Numele;

#5
select numele
from persoane
inner join rude r1 on persoane.idPersoana = r1.idPersoana1
inner join rude r2 on persoane.idPersoana = r2.idPersoana2
having count(r2.idPersoana2) < 1;

#6
select *
from persoane
inner join amici as a1 on persoane.idPersoana = a1.idPersoana1
inner join amici as a2 on persoane.idPersoana = a2.idPersoana2
inner join rude as r1 on persoane.idPersoana = r1.idPersoana1
inner join rude as r2 on persoane.idPersoana = r2.idPersoana2;

#7
select count(idPersoana) - (select COUNT(idPersoana)
from persoane where Varsta >= 18) as Diferenta
from persoane;

#8
select distinct Numele
from persoane
inner join rude r1 on persoane.idPersoana = r1.idPersoana1
inner join rude r2 on persoane.idPersoana = r2.idPersoana2
inner join amici a1 on persoane.idPersoana = a1.idPersoana1
inner join amici a2 on persoane.idPersoana = a2.idPersoana2
where count(a2.idPersoana2) => 1 and count(r2.idPersoana2) => 1;

#9
SELECT count(idPersoana) / count(distinct persoane.idPersoana) as prieten_per_pers
FROM persoane
INNER JOIN amici ON amici.idpersoana1 = persoane.idPersoana
INNER JOIN amici ON amici.idpersoana2 = persoane.idPersoana;



#11
select numele, varsta
from persoane
inner join amici a1 on persoane.idPersoana = a1.idPersoana1
inner join amici a2 on persoane.idPersoana = a2.idPersoana2
having max(a2.idPersoana2);

#13

#14
select distinct Numele
from persoane
inner join rude r1 on persoane.idPersoana = r1.idPersoana1
inner join rude r2 on persoane.idPersoana = r2.idPersoana2
inner join amici a1 on persoane.idPersoana = a1.idPersoana1
inner join amici a2 on persoane.idPersoana = a2.idPersoana2
where count(a2.idPersoana2) < 1 and count(r2.idPersoana2) = 1
