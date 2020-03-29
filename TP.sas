/* manelle nouar*/

LIBNAME data "Z:\SAS\1 - TP0 - Enquête de Santé\Données";

/*1 importation macro excel xls*/

%macro import(nom=) ;
PROC IMPORT  out=&nom. 
     DATAFILE= "Z:\SAS\1 - TP0 - Enquête de Santé\Données\Sante-travail2.xls" 
     DBMS= xls
     REPLACE;
     SHEET="&nom."; 
     GETNAMES=YES;
	 run;

%mend; 


%import(nom=socdem);
%import(nom=conditrav);
%import(nom=examed);
%import(nom=modevie);

/* macro importation TEXTE */
%macro import_texte(nom=,var=) ;

data &nom.;
infile "Z:\SAS\1 - TP0 - Enquête de Santé\Données\&nom..txt"
dlm=";";
input id &var;
run;

%mend import_texte;
%import_texte(nom=socdem,var=v1-v14);
%import_texte(nom=conditrav,var= v1-v16=v15-v30);
%import_texte(nom=examed,var= v1-v12=v48-v59);
%import_texte(nom=modevie, var= v1-v17=v31-v47);




%macro import_texteorexcel(choix=,nom=,var=);
/*%IF &choix. %THEN %DO;*/
%IF (&choix=1) %THEN %DO;
PROC IMPORT  out=&choix. 
     DATAFILE= "Z:\SAS\1 - TP0 - Enquête de Santé\Données\Sante-travail2.xls" 
     DBMS= xls
     REPLACE;
     SHEET="&choix."; 
     GETNAMES=YES;
	 run;
%end;
/*%IF &choix. %THEN %DO;*/
%IF (&choix=2) %THEN %DO;
data &nom.;
infile "Z:\SAS\1 - TP0 - Enquête de Santé\Données\&choix..txt"
dlm=";";
input id &var;
run;
%end;
%mend import_texteorexcel
%import_texteorexcel(nom=socdem,var=v1-v14);
%import_texteorexcel(&choix.,nom=conditrav,var= v1-v16=v15-v30);
%import_texteorexcel(&choix.,nom=examed,var= v1-v12=v48-v59);
%import_texteorexcel(&choix.,nom=modevie, var= v1-v17=v31-v47);

/*macro programme*/

%MACRO frecen (table=, var=);
proc freq data=&table.;
tables &var./ out= &table._&var.;
run;
%mend;

%frecen(table=T1,var=age);
%frecen(table=T2,var=ville);
%frecen(table=T1,var=sex);
/*macro var*/
proc sql;
select max(argent)
into: max_argent 
from t1;
quit;
%put &max_argent; 

%let a= b;
&a.;

call symputx/*sert a r*/



proc contents data=socdem_a out=t1 ;
run;
%LET chemin= Z:\SAS\1 - TP0 - Enquête de Santé\Données;
%puT &CHEMIN.;

PROC IMPORT OUT= WORK.socdem_a 
DATAFILE= "Z:\SAS\1 - TP0 - Enquête de Santé\Données\Sante-travail2.xls" 
DBMS=xls
REPLACE;
SHEET="socdem";  
GETNAMES=YES;
RUN;

proc sql ;
select  count(ID)
into :eff
from socdem_a;
quit;

%put = &eff.;

proc sql noprint ;
select  name
into : numerique separed by ' '
from t1
where type=1;
quit;

%put = &numerique.;

proc sql noprint ;
select  name
into : caractere 
from t1
where type=2;
quit;

%put = &caractere.;



/*som d'une var ou min ou max*/
proc sql ;
select max(actual)
into: max_actual
FROM SASHELP.PRDSALE
QUIT;
%put &max_actual;

proc sort data=SASHELP.PRDSALE out=temp; by descending actual;run;
data _null_;
set temp;
if _N_=1 then
call symputx("montant_max", actual);
run;
%put &montant_max.;

proc means data= temp max;
var actual;
output out=moyenne;
run;

data _null_ ; 
set maximum_actual; 
call symputx ("montant_max",actual) ;
where _STAT_="max";
run ;                                  
%put &=moy ; 






/*
%LET chemin= ;
%puT &CHEMIN.;
PROC IMPORT  out=WORK.data_a 
     DATAFILE= "Z:\SAS\1 - TP0 - Enquête de Santé\Données\Sante-travail2.xls" 
     DBMS= xls
     REPLACE;
     SHEET="socdem"; 
     GETNAMES=YES;
	 
RUN;

proc sql ;
select  count(ID)
into :eff
from socdem_a;
quit;
%put &eff.;

*/
PROC IMPORT  out=WORK.data_a 
     DATAFILE= "Z:\SAS\1 - TP0 - Enquête de Santé\Données\Sante-travail2.xls" 
     DBMS= xls
     REPLACE;
     SHEET="socdem"; 
     GETNAMES=YES;
	 
RUN;


PROC IMPORT OUT= WORK.socdem_a 
DATAFILE= "Z:\SAS\1 - TP0 - Enquête de Santé\Données\Sante-travail2.xls" 
DBMS=xls
REPLACE;
SHEET="socdem";  
GETNAMES=YES;
RUN;
PROC IMPORT OUT= WORK.conditrav_a
	       DATAFILE= "Z:\SAS\1 - TP0 - Enquête de Santé\Données\Sante-travail2.xls" 
            DBMS=xls REPLACE;
	     SHEET="conditrav"; 
	     GETNAMES=YES;
	RUN;
	PROC IMPORT OUT= WORK.modevie_a 
            DATAFILE= "Z:\SAS\1 - TP0 - Enquête de Santé\Données\Sante-travail2.xls" 
            DBMS=xls REPLACE;
     SHEET="modevie"; 
	     GETNAMES=YES;
	RUN;
PROC IMPORT OUT= WORK.examed_a 
DATAFILE= "Z:\SAS\1 - TP0 - Enquête de Santé\Données\Sante-travail2.xls" 
 DBMS=xls REPLACE;
    SHEET="examed"; 
     GETNAMES=YES;
	RUN;

/* 2) a) renomme les variables pour éviter écrasement */
DATA conditrav_a; 
SET conditrav_a; 
rename v1-v16=v15-v30; 
run;
DATA modevie_a; 
SET modevie_a; 
rename v1-v17=v31-v47; 
run;
DATA examed_a;
SET examed_a; 
rename v1-v12=v48-v59; 
run;


/* 2)b) Tri  */
proc sort data=socdem_a; 
by id; 
run;
proc sort data=conditrav_a;
by id; 
run;
proc sort data=modevie_a; 
by id; 
run;
proc sort data=examed_a; 
by id; 
run;
/*4)fusion*/
	
DATA ech_a;
MERGE socdem_a conditrav_a modevie_a examed_a;
by id;
run;
/*Importation txt*/
data socdem_b ;
infile 'Z:\SAS\1 - TP0 - Enquête de Santé\Données\socdem.txt'
dlm=";";
input id v1-v6 v7$ v8-v14;
run;/*charactere*/

data conditrav_b;
infile 'Z:\SAS\1 - TP0 - Enquête de Santé\Données\conditrav.txt'
dlm=";";
input id v15 v16$ v17 v18$ v19-v29 v30$;
run;

data examed_b;
infile 'Z:\SAS\1 - TP0 - Enquête de Santé\Données\examed.txt'
dlm=";";
input id v48-v56 v57 $ v58 $ v59 $;
run;

data modevie_b;
infile 'Z:\SAS\1 - TP0 - Enquête de Santé\Données\modevie.txt'
dlm=";";
input id v31-v47;
run;

/*Tri*/
proc sort data=socdem_b; 
by id ; 
run;
proc sort data=conditrav_b; 
by id ; 
run;
proc sort data=modevie_b; 
by id ; 
run;
proc sort data=examed_b; 
by id ; 
run;

/*fusion*/
	
DATA ech_b;
MERGE socdem_b conditrav_b modevie_b examed_b;
by id;
run;
data TABLE_FINAL;
set ech_b  ech_a ;
run;
/*exercice  3*/


proc freq data=TABLE_FINAL;
tables sexe
/nocum
out= test1;
/*assenblée table sas*/
run;

proc freq data=TABLE_FINAL;
tables v58
/nocum
out= test2;
run;
data test;
merge test1 test2;
run;
