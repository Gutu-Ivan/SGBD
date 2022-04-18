#a
create table cercetatori_copy like cercetatori;
insert cercetatori_copy select * from cercetatori;
count(
delete from cercetatori_copy
where cercetatori_copy.iduniversitate=1)

drop table cercetatori_copy;
create table cercetatori_copylikecercetatori;
insertcercetatori_copyselect*fromcercetatori;

delimiter$$
createfunction elimin_1(id_psmallint)
returnsint
begin
declareeliminsmallintdefault0;
declarenrintdefault0;
declarev_idcsmallint;
declarev_nrsmallint;

declarecursor_elimcursorfor
selectidcercetator
fromcercetatori_copy
whereiduniversitate=id_p;

declarecontinuehandler
fornotfoundsetelimin=1;

opencursor_elim;

eticheta:loop
fetchcursor_elimintov_idc;
if(elimin=1)then
leaveeticheta;
endif;

deletefromcercetatori_copy
whereidcercetator=v_idc;
setnr=nr+1;
endloopeticheta;
closecursor_elim;
returnnr;
end;$$
delimiter;

select elimin_1(1);

#b
DELIMITER$$
CREATEFUNCTIONcursor_exB()
RETURNSVARCHAR(100)
DETERMINISTIC
BEGIN
DECLARErezINTDEFAULT0;
DECLAREnume_cercVARCHAR(20);
DECLAREden_univVARCHAR(20);
DECLAREnum_artINT;
DECLARErezultVARCHAR(200)DEFAULT'';


DECLAREcursor_exB1CURSORFOR
SELECTcercetatori.numecercetatorASnumec,universitate.denuniversitateASdenuniv,count(idarticol)ASnumart
FROMautori
INNERJOINcercetatoriONautori.idcercetator=cercetatori.idcercetator
INNERJOINuniversitateONcercetatori.idcercetator=universitate.iduniversitate
GROUPBYcercetatori.idcercetator
HAVINGCOUNT(cercetatori.idcercetator)>1;

DECLAREcursor_exB2CURSORFOR
SELECTcercetatori.numecercetatorASnumec,universitate.denuniversitateASdenuniv,count(idarticol)ASnumart
FROMautori
INNERJOINcercetatoriONautori.idcercetator=cercetatori.idcercetator
INNERJOINuniversitateONcercetatori.idcercetator=universitate.iduniversitate
GROUPBYcercetatori.idcercetator
HAVINGCOUNT(cercetatori.idcercetator)=1;

DECLARECONTINUEhandlerFORNOTFOUNDSETrez=1;
OPENcursor_exB1;

afis_cercetator:
loop
fetchcursor_exB1INTOnume_cerc,den_univ,num_art;
ifrezthen
leaveafis_cercetator;
ENDif;
SETrezult=concat(rezult,nume_cerc,' ',den_univ,' ',num_art,'\n');
ENDloopafis_cercetator;

closecursor_exB1;
SETrez=FALSE;
SETrezult=concat(rezult,'-------------------------','\n');

OPENcursor_exB2;
afis_cercetator:
loop
fetchcursor_exB2INTOnume_cerc,den_univ,num_art;
ifrezthen
leaveafis_cercetator;
ENDif;
SETrezult=concat(rezult,nume_cerc,' ',den_univ,' ',num_art,'\n');
ENDloopafis_cercetator;

closecursor_exB2;

RETURNrezult;

END;$$
DELIMITER;

SELECTcursor_exB();


