#1
select Numele, Varsta, count(idPersoana) as Rude
from persoane as p
inner join rude r on p.idPersoana = r.idPersoana1 or p.idPersoana = r.idPersoana2
group by idPersoana
HAVING max(r.idPersoana1 = p.idPersoana OR r.idPersoana2 = p.idPersoana)
order by rude desc;

#2
select distinct a1.Numele, a2.Numele
from amici as p
inner join persoane a1 on a1.idPersoana = p.idPersoana1
inner join persoane a2 on a2.idPersoana = p.idPersoana2;

#3
select distinct p1.Numele, p2.Numele
from rude as r
inner join persoane as p1 on r.idpersoana1 = p1.idPersoana
inner join persoane as p2 on r.idpersoana2 = p2.idPersoana
where p1.Varsta <> p2.Varsta;

#4
delimiter $$
create procedure pr1()
begin
    select distinct rude.idpersoana1 AS A,
                rude.idpersoana2 AS X,
                if ( r.idpersoana1 <> rude.idpersoana1 AND r.idpersoana1 <> rude.idpersoana2, r.idpersoana1,
                if ( r.idpersoana2 <> rude.idpersoana1 AND r.idpersoana2 <> rude.idpersoana2, r.idpersoana2, NULL )) AS B
    from rude
    inner join rude r on r.idpersoana1 = rude.idpersoana2
    having B is not null;
end $$;
call pr1();

#5
delimiter $$
create procedure pr2(nume varchar(20))
begin
select count(persoane.idpersoana)
from persoane
inner join amici a on persoane.idpersoana = a.idpersoana1
or persoane.idpersoana = a.idpersoana2
where persoane.numele = nume
group by persoane.idpersoana;
end; $$
delimiter ;
call pr2('Elvi');

#6
delimiter $$
create function func1(nume1 varchar(20),nume2 varchar(20))
returns varchar(10)
begin
if exists (select *
from persoane
inner join amici on idpersoana = idpersoana1
or idpersoana=idpersoana2
where numele = nume1 and numele = nume2 )
then
return 'True';
else
return 'False';
end if;
end $$
delimiter ;
select func1('Sam','Louis');
