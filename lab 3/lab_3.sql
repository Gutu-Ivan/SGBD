#1, 2
create table articole(
idArticol smallint primary key,
denArticol varchar(100)
);

create table universitate (
idUniversitate smallint,
denUniversitate varchar(100)
);

create table cercetatori(
idCercetator smallint,
numeCercetator varchar(100),
idUniversitate smallint,
calificativ varchar(20)
);

create table autori(
idCercetator smallint,
idArticol smallint,
primary key (idArticol)
);
alter table cercetatori
    add constraint idUniversitate
        foreign key (idUniversitate) references universitate (idUniversitate);
ALTER TABLE cercetatori ENGINE=InnoDB;

#3
insert into articole
values  (1, 'Articol1'),
	    (2, 'Articol2'),
	    (3, 'Articol3'),
	    (4, 'Articol4'),
	    (5, 'Articol5');

insert into universitate
values  (1, 'USARB'),
	    (2, 'USM'),
	    (3, 'ASEM');

insert into cercetatori
values  (1, 'Dodu Petru', 1, 1),
	    (2, 'Lungu Vasile', 2, 1),
	    (3, 'Vrabie Maria', 1, 2),
	    (4, 'Ombun Bogdan', 3, 1),
        (5, 'Charlize Moreno', 2, 3),
        (6, 'Damian Hirst', 3, 1);

insert into autori
values  (1, 1),
	    (2, 2),
	    (3, 3),
	    (4, 4);

#Procedures
#1
delimiter $$
create procedure getArticleList(in CercetatorId smallint)
begin
    select denArticol
    from articole
        join autori a on articole.idArticol = a.idArticol
        join cercetatori c on a.idCercetator = c.idCercetator
    where c.idCercetator = CercetatorId
    order by articole.denArticol;
end$$
delimiter ;
call getArticleList(3);

#2
delimiter $$
create procedure getExplorersAndArticlets(in UniversitateId smallint)
begin
    select distinct cercetatori.idCercetator, cercetatori.numeCercetator, art.idArticol, art.denArticol
    from cercetatori
        inner join universitate u on cercetatori.idUniversitate = u.idUniversitate
        inner join autori a on cercetatori.idCercetator = a.idCercetator
        inner join articole art on art.idArticol = a.idArticol
    where u.idUniversitate = UniversitateId
    order by a.idCercetator;
end$$
delimiter ;
call getExplorersAndArticlets(2);

#3
delimiter $$
create or replace procedure getExplorersAndArticlets(in UniversitateId smallint)
begin
    select distinct cercetatori.idCercetator, cercetatori.numeCercetator, art.idArticol, art.denArticol
    from cercetatori
        left join universitate u on cercetatori.idUniversitate = u.idUniversitate
        left join autori a on cercetatori.idCercetator = a.idCercetator
        left join articole art on art.idArticol = a.idArticol
    where u.idUniversitate = UniversitateId
    order by a.idCercetator;
end$$
delimiter ;
call getExplorersAndArticlets(3);

#4
delimiter $$
create or replace procedure calcUniversityAndMainRating()
begin
    select cercetatori.idCercetator, numeCercetator,
    count(a.idArticol) / (select count(*) from articole) * 100 as MainRating,
    count(a.idArticol) / (select count(*) from universitate) * 100 as UniversityRating
    from cercetatori
        join universitate u on cercetatori.idUniversitate = u.idUniversitate
        left join autori a on cercetatori.idCercetator = a.idCercetator
        left join articole art on art.idArticol = a.idArticol
    group by cercetatori.idCercetator;
end$$
delimiter ;
call calcUniversityAndMainRating();

#5
/*delimiter $$
create procedure setValuesToQualifier()
begin
    alter table cercetatori
        add column if not exists calificativ varchar(20);
    select *
    from cercetatori
    join universitate u on cercetatori.idUniversitate = u.idUniversitate
    join autori a on cercetatori.idCercetator = a.idCercetator
    join articole art on art.idArticol = a.idArticol
    group by case
        when count(art.idArticol) > 25 then
            set calificativ = 'foarte bine'
        when count(idArticol) >15 and 25 > count(idArticol) then
            set calificativ = 'bine'
        when count(idArticol) > 5 and 15 > count(idArticol) then
            set calificativ = 'suficient'
        else
            set calificativ = 'insuficient'
    end*/

    /*if count(idArticol) > 25 then
         update cercetatori
         set calificativ = 'foarte bine';
    else if count(idArticol) >15 and 25 > count(idArticol) then
        update cercetatori
        set calificativ = 'bine';
    else if count(idArticol) > 5 and 15 > count(idArticol) then
        update cercetatori
        set calificativ = 'suficient';
    else
        update cercetatori
        set calificativ = 'insuficient';*/
/*end$$
delimiter ;
call setValuesToQualifier();*/

#6
drop function if exists checkExplorerErase;
delimiter $$
create procedure checkExplorerErase(in CercetatorId smallint)
begin
    select case
        when (select count(idCercetator) from cercetatori where idCercetator = CercetatorId) < 1 then 'Explorer does not exist'
        when (select count(a.idArticol) from cercetatori  where idCercetator = CercetatorId) != 0 then 'Explorer has articles'
        else 'Explorer can be deleted'
        end
    from cercetatori
    join universitate u on cercetatori.idUniversitate = u.idUniversitate
    join autori a on cercetatori.idCercetator = a.idCercetator
    join articole art on art.idArticol = a.idArticol
    where cercetatori.idCercetator = CercetatorId;
end$$
delimiter ;
call checkExplorerErase(3);

#Functions
#7
drop function if exists getUniversity;
delimiter $$
create function getUniversity(CercetatorId smallint)
returns varchar(5)
begin
    return (
        select denUniversitate
        from universitate
            inner join cercetatori c on universitate.idUniversitate = c.idUniversitate
        where idCercetator = CercetatorId);
end $$
delimiter ;
select getUniversity(3);

#8
drop function if exists getQualifier;
delimiter $$
create function getQualifier(CercetatorId smallint)
returns varchar(20)
begin
    return (
        select calificativ
        from cercetatori
        where cercetatori.idCercetator = CercetatorId);
end $$
delimiter ;
select getQualifier(3);

#9
drop function if exists getAmountOfUniversityExplorers;
delimiter $$
create function getAmountOfUniversityExplorers(denUniversitate varchar(20))
returns smallint
begin
    return (
        select count(idCercetator)
        from cercetatori
        inner join universitate u on cercetatori.idUniversitate = u.idUniversitate
        where denUniversitate = u.denUniversitate
        );
end $$
delimiter ;
select getAmountOfUniversityExplorers('USARB');

#10
drop function if exists getNumberOfUniversityArticles;
delimiter $$
create function getNumberOfUniversityArticles(UniversitateId smallint)
returns smallint
begin
return(select count(idArticol)
 		from autori
 		inner join cercetatori on cercetatori.idcercetator = autori.idcercetator
 		where iduniversitate = UniversitateId);
end $$
delimiter ;
select getNumberOfUniversityArticles(1);

#11
drop function if exists getNumberOfExplorerArticles;
delimiter $$
create function getNumberOfExplorerArticles(NumeCercetator VARCHAR(20))
returns smallint
begin
return(select count(idArticol)
 		from autori
 		inner join cercetatori c on c.idcercetator = autori.idcercetator
 		where c.numecercetator = NumeCercetator);
end $$
delimiter ;
select getNumberOfExplorerArticles('Dodu Petru');

#12
delimiter $$
create function checkExplorersUniversity(NumeCercetator VARCHAR(20), UniversitateId smallint)
returns bool
begin
    if exists (select *
               from cercetatori c
               where c.numecercetator = NumeCercetator and c.idUniversitate = UniversitateId)
        then
            return TRUE;
    else
        return FALSE;
end if;
end $$
delimiter ;

select checkExplorersUniversity('Lungu Vasile', 2);
select checkExplorersUniversity('Lungu Vasile', 1);
