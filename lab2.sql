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
select p1.varsta, p1.numele, p2.varsta, p2.numele
from amici inner join persoane as p1
on amici.idPersoana1 = p1.idPersoana
inner join persoane as p2
on amici.idPersoana2 = p2.idPersoana
where p1.Varsta = p2.Varsta
order by p1.Varsta, p2.Varsta, p1.Numele, p2.Numele