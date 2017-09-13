* ======================================;
* SAS Code for N736 Lesson 05;
* date 9/11/2017
*
* Melinda Higgins, PhD;
* ======================================;

* ======================================;
* load dataA;
* ======================================;
proc import datafile='C:\MyGithub\N736Fall2017_lesson05\dataA.csv'
  out=dataA dbms=csv;
run;

* ======================================;
* load dataB;  
* ======================================;
proc import datafile='C:\MyGithub\N736Fall2017_lesson05\dataB.csv'
  out=dataB dbms=csv;
run;

* ======================================;
* concatenate dataA and dataB
  add rows and keep columns in both;
* ======================================;
  
data dataAB;
  set dataA dataB;
run;
  
proc print data=dataAB noobs; run;

* ======================================;
* keep only var1 and var2;
* ======================================; 
  
data dataAB_var12;
  set dataAB;
  drop var3 var4;
run;
  
proc print data=dataAB_var12 noobs; run;

* ======================================;
* load dataC;  
* ======================================;
proc import datafile='C:\MyGithub\N736Fall2017_lesson05\dataC.csv'
  out=dataC dbms=csv;
run;

* ======================================;
* do a full (outer) join;
* ======================================;

proc sort data=dataA; by id; run;
proc sort data=dataC; by id; run;

data dataAC_fulljoin;
  merge dataA dataC;
  by id;
run;

proc print data=dataAC_fulljoin noobs; run;

* ======================================;
* do an inner join;  
* ======================================;

data dataAC_innerjoin;
  merge dataA(in=A) dataC(in=C);
  by id;
  if A and C;
run;

proc print data=dataAC_innerjoin noobs; run;

* ======================================;
* left join;  
* ======================================;

data dataAC_leftjoin;
  merge dataA(in=A) dataC(in=C);
  by id;
  if A;
run;

proc print data=dataAC_leftjoin noobs; run;

* ======================================;
* right join;  
* ======================================;

data dataAC_rightjoin;
  merge dataA(in=A) dataC(in=C);
  by id;
  if C;
run;

proc print data=dataAC_rightjoin noobs; run;

