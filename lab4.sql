#Triggers
#1
delimiter $$
create or replace trigger addFriendsRelations
after insert on persoane for each row
begin
insert into amici(idPersoana1, idPersoana2)
values (new.idPersoana, (select persoane.idPersoana
                         from persoane
                         where persoane.Numele = 'Elvi'));
end $$
delimiter ;
insert into persoane value (18, 'Mark', 20);

#2
delimiter $$
create trigger checkIfPersonExists before insert on persoane for each row
begin
if exists(select Numele
          from persoane
          where persoane.numele=new.Numele)
    then
        signal sqlstate '45000' set message_text = 'This person already exists!';
end if;
end$$
delimiter ;
insert into persoane value (19, 'Ivan', 20);

#3
delimiter $$
create or replace trigger duplicateRelations after insert on rude for each row
begin
if not exists(select idPersoana1, idPersoana2
              from amici
              where (amici.idPersoana1=new.idPersoana1) and (amici.idPersoana2=new.idPersoana2))
    then
        insert into amici values (new.idPersoana1, new.idPersoana2);
else
    signal sqlstate '45000' set message_text = 'This relation already exists!';
end if;
end $$
delimiter ;
insert into rude value (4,12);

#4
delimiter $$
create or replace trigger removeRelations
after delete on amici for each row
begin
if not exists(select idPersoana1, idPersoana2
              from rude
              where (rude.idPersoana1=old.idPersoana1) and (rude.idPersoana2=old.idPersoana2))
    then
        delete from amici where amici.idpersoana1 = old.idpersoana1 and amici.idpersoana2 = old.idpersoana2;
else
    signal sqlstate '45000' set message_text = 'Firstly you should remove relations between relatives';
end if;
end $$
delimiter ;
delete from amici where idPersoana1 = 4 and idPersoana2 = 12;

#5
delimiter $$
create trigger deleteAllReferences before delete on persoane for each row
begin
if exists (select idPersoana1
           from rude
           where Rude.idPersoana1=old.idPersoana or Rude.idPersoana2 = old.idPersoana)
           and
          (select idPersoana1
           from Amici
           where Amici.idPersoana1=old.idPersoana or amici.idPersoana2 = old.idPersoana)
    then
        delete from Rude where Rude.idPersoana1=old.idPersoana or Rude.idPersoana2 = old.idPersoana;
        delete from Amici where amici.idPersoana1 = old.idPersoana or amici.idPersoana2 = old.idPersoana;
end if;
end $$
delimiter ;
delete from persoane where idPersoana = 1;

#6
delimiter $$
create trigger removeForeignKeys before insert on amici for each row
begin
if not exists(select idPersoana
              from persoane
              where persoane.idpersoana=new.idpersoana1)
    then
        signal sqlstate '45000' set message_text = 'Careful! Person with idPersoana1 does not exist';
end if;
if not exists(select idpersoana
              from persoane
              where persoane.idpersoana=new.idpersoana2)
    then
        signal sqlstate '45000' set message_text = 'Careful! Person with idPersoana2 does not exist!';
end if;
end $$
delimiter ;
insert into rude value (56,12);

#7
delimiter $$
create trigger modifyCascade
after update on persoane for each row
begin
update amici set amici.idpersoana1 = new.idpersoana
where amici.idpersoana1 = old.idpersoana;
update amici set amici.idpersoana2 = new.idpersoana
where amici.idpersoana2 = old.idpersoana;
end $$
delimiter ;
UPDATE persoane
SET idPersoana = 30
WHERE idPersoana = 18;

#8
delimiter $$
create or replace trigger deleteCascade
before delete on persoane for each row
begin
    delete from amici where amici.idpersoana1 = old.idpersoana or amici.idpersoana2 = old.idpersoana;
end $$
delimiter ;
