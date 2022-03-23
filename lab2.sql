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
select persoane.Numele
from persoane
inner join amici a1 ON persoane.idPersoana = a1.idpersoana2
where a1.idPersoana1 = (SELECT idpersoana
		                   FROM persoane
					       WHERE numele ='Elvi')
UNION
select persoane.Numele
from persoane
inner join amici a2 ON persoane.idPersoana = a2.idpersoana1
where a2.idPersoana2 = (SELECT idpersoana
					       FROM persoane
					       WHERE numele = 'Elvi');

#2
SELECT p1.Numele, p2.Numele
FROM amici
INNER JOIN persoane AS p1 ON amici.idpersoana1 = p1.idPersoana
INNER JOIN persoane AS p2 ON amici.idpersoana2 = p2.idPersoana
WHERE p1.Varsta <> p2.Varsta;

#3
select p1.Varsta, p1.numele, p2.Varsta, p2.numele
from amici
inner join persoane as p1 on amici.idPersoana1 = p1.idPersoana
inner join persoane as p2 on amici.idPersoana2 = p2.idPersoana
where p1.Varsta = p2.Varsta
order by p1.Varsta, p2.Varsta, p1.Numele, p2.Numele;

#4
select p.numele, count(r.idPersoana2) as nr
from persoane
inner join rude r on persoane.idPersoana = r.idPersoana1 or persoane.idPersoana = r.idPersoana2
inner join persoane p on p.idPersoana = r.idPersoana2 or p.idPersoana = r.idPersoana1
group by p.idPersoana
having count(r.idPersoana2) > 1;

#5
select Numele
from persoane
left join rude r1 on persoane.idPersoana = r1.idPersoana1
group by idPersoana
having count(r1.idPersoana2) = 0

union
select Numele
from persoane
right join rude r2 on persoane.idPersoana = r2.idPersoana2
group by idPersoana
having count(r2.idPersoana2) = 0;

#6
select *
from amici
inner join persoane p1 on amici.Idpersoana1 = p1.idpersoana
inner join persoane p2 on amici.Idpersoana2 = p2.idPersoana

union all
select *
from rude
inner join persoane p1 on rude.Idpersoana1 = p1.idpersoana
inner join persoane p2 on rude.Idpersoana2 = p2.idPersoana;

#7
select count(*) - (select COUNT(idPersoana) from persoane where Varsta >= 18) as Diferenta
from persoane;

#8
select Numele
from persoane
left join rude r1 on persoane.idPersoana = r1.idPersoana1
left join rude r2 on persoane.idPersoana = r2.idPersoana2
group by idPersoana
having count(r1.idPersoana2) >= 1 and count(r2.idPersoana2) >= 1

union all
select Numele
from persoane
right join amici a1 on persoane.idPersoana = a1.idPersoana1
right join amici a2 on persoane.idPersoana = a1.idPersoana2
group by idPersoana
having count(a1.idPersoana2) >= 1 and count(a2.idPersoana2) >= 1;

#9
select count(idPersoana) / count(distinct persoane.idPersoana) as prieten_per_pers
from persoane
inner join amici a1 on a1.idpersoana1 = persoane.idPersoana
inner join amici a2 ON a2.idpersoana2 = persoane.idPersoana;

#10
select COUNT(p.idPersoana) AS Nr_persoane
FROM persoane
INNER JOIN amici a ON persoane.idPersoana = a.idpersoana1 OR persoane.idPersoana = a.idpersoana2
inner join persoane p ON (p.idPersoana = a.idpersoana1 OR p.idPersoana = a.idpersoana2) AND p.idPersoana <> persoane.idPersoana
INNER JOIN amici a2 ON p.idPersoana = a2.idpersoana1 OR p.idPersoana = a2.idpersoana2
WHERE persoane.Numele = 'Tiany';


#11
select Numele, Varsta, count(idPersoana) as prieteni
from persoane as p
inner join amici a on p.idPersoana = a.idPersoana1 or p.idPersoana = a.idPersoana2
group by idPersoana
HAVING max(a.idPersoana1 = p.idPersoana OR a.idPersoana2 = p.idPersoana)
order by prieteni desc;

#13

#14
select Numele
from persoane
left join rude r1 on persoane.idPersoana = r1.idPersoana1
left join rude r2 on persoane.idPersoana = r2.idPersoana2
having count(r1.idPersoana2) < 1 and count(r2.idPersoana2) = 1

union all
select numele
from persoane
right join amici a1 on persoane.idPersoana = a1.idPersoana1
right join amici a2 on persoane.idPersoana = a2.idPersoana2
having count(a1.idPersoana2) < 1 and count(a2.idPersoana2) = 1;
