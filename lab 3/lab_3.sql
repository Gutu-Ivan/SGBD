#1, 2
create table articole(
idArticol smallint primary key,
denArticool varchar(100)
);

create table universitate (
idUniversitate smallint,
denUniversitate varchar(100)
);

create table cercetatori(
idCercetator smallint,
numeCercetator varchar(100),
foreign key (idUniversitate) references universitate(idUniversitate)
);

craete table autori(
idCercetator smallint,
idArticol smallint,
foreign key (idCercetator) references cercetatori(idCercetator),
primary key (idArticol)
);

#3
insert into articole
values  (1, 'Articol1'),
	(2, 'Articol2'),
	(3, 'Articol3'),
	(4, 'Articol4'),
	(5, 'Articol5');

insert into universitate (
values  (1, 'USARB'),
	(2, 'USM'),
	(3, 'ASEM');

insert into cercetatori
values  (1, 'Dodu Petru', 1),
	(2, 'Lungu Vasile', 2),
	(3, 'Vrabie Maria', 1),
	(4, 'Ombun Bogdan', 3);

insert into autori
values  (1, 1),
	(2, 2),
	(3, 3),
	(4, 4);

#4
#4.1
create procedure pr1(idCercetator)
	returns denArticol as $$
begin
	select 1
	order by denArticol desc;
end;
