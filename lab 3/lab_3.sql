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
idUniversitate smallint
);

create table autori(
idCercetator smallint,
idArticol smallint,
primary key (idArticol)
);

alter table autori
    add constraint idCercetator
    	foreign key (idCercetator) references cercetatori(idCercetator);
	
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
create procedure pr1
    (
    idCercetator smallint
)
begin
	select denArticol
	from articole
	order by idCercetator desc;
end;

#5
create procedure pr2
    (
    idUniversitate smallint
    )
begin
    select numeCercetator,denArticol
    from cercetatori
    inner join autori a1 on a1.idCercetator = cercetatori.idCercetator
    inner join articole a on a.idArticol = a1.idArticol
    where idUniversitate = 1;
end; 
