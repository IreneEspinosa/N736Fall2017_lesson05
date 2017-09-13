# Data Wrangling
Melinda K. Higgins, PhD.  
September 11, 2017  



## Data Wrangling

For today's lesson, you will want to download/make a copy of the Github repository [https://github.com/melindahiggins2000/N736Fall2017_lesson05](https://github.com/melindahiggins2000/N736Fall2017_lesson05). This repo contains 3 datasets we will be working with in the exercises below: 

* `dataA.csv` - has 3 variables (var1, var2, var3) and 6 subjects (1,2,3,5,8,9)
* `dataB.csv` - has 3 variables: 2 same and 1 different than `dataA` (var1, var2, var4) and 6 more subjects (11,12,14,15,17,18)
* `dataC.csv` - has 3 more variables (var5, var6, var7) and 6 subjects (1,2,3,4,7,10) some in common with `dataA` and some different

Today's lesson will cover these topics:

* merging; joining; stacking; concatenating

We will cover these later:

* adding labels and other notations
* recoding
* manipulating data types
* import/export

## Merging datasets

Often the data you want for your analyses will exist in different files. In order to complete your analyses, you will need to merge these data in some way. For the most part (at least for the focus of this course), your data will be rectangular - usually with the rows representing your samples or subjects - basically the "objects" you want to analyze - and your columns will be the attributes or variables of these "objects" (e.g. your measurements on your subjects or samples).

Given this rectangular structure of your data, you will typically want to either add rows (add more subjects or samples), often as a result or data collected at a later time point that needs to be merged in for final analyses - OR - add columns (adding variables or other measurements taken on your samples/subjects), often as a resultsof data coming from another source (hospital records, laboratory results, etc).

when adding rows ot columns **IT IS VERY IMPORTANT to ALWAYS read** the documentation for (a) the software you are using and (B) the details for the merging/joining procedure or function in the software you are using, i.e. check assumptions, parameters needed, and default settings. Some consideration include:

* exact numbering or naming of your objects, samples or subjects - often the variable (field) that contains the number or label for your subjects will be used as the "KEY" reference for aligning and merging everything together so these should be checked carefully - especially for adding columns and aligning by row;
* the variable names need to match EXACTLY when adding rows and aligning by column
* determine whether you want all columns or rows kept even if they do not exist in both datasets (i.e. do you want to keep everything - think the "UNION" of 2 datasets or do you only want to keep items that exist in both datasets - think the "INTERSECTION" of 2 datasets - or possibly some variation of keeping everything that matches in 1 of the 2 datasets)...
* always check for DUPLICATE issues which arise is you have the same subject IDs in both datasets when adding rows or duplicate column/variable names when adding columns... these need to be unique for the merge to work correctly.

### "Stacking" / "Concatenating" - adding rows - aligning columns (vars)

When adding rows, it is assumed that the rows (new subjects, new samples) are DIFFERENT that what is in the current dataset. If needed, make sure to update the samepl/subject ID to reflect that the data in the new file is new or different otherwise the merge will not work. This is common when you have later time points or follow-up measures on subjects/samples that you already have at baseline. For the merge to work you will want to update your subject IDs to also include the time point information. For example assume you have a subject id `10023` and you have data at baseline (time 0) and data at 6 month and 12 months you want to add. In this case you should probably add 2 digits to the end of the subject ID to differentiate these different time points:

* baseline subject id `1002300`
* 6 months ID `1002306`
* 12 months ID `1002312`

or whatever works for you and your dataset.

You should also consider what you want to do if the 2 datasets have some columns in common and some that are not in common and whether you want the final merged file to keep only the columns that are in common or all of the columns regardless of whether they are in dataset 1 or 2.

Here is an example dataset:

**Dataset `dataA`**

**R CODE**


```r
library(readr)
dataA <- read_csv("dataA.csv")

library(knitr)
kable(dataA)
```



 id   var1  var2    var3
---  -----  -----  -----
  1      3  m         45
  2      3  m         44
  3      2  f         34
  5      4  f         38
  8      1  m         41
  9      5  f         39

Let's suppose we want to add more subjects from `dataB`:

**Dataset `dataB`**

**R CODE**


```r
dataB <- read_csv("dataB.csv")
kable(dataB)
```



 id   var1  var2    var4
---  -----  -----  -----
 11      4  f          0
 12      4  m          6
 14      2  m          4
 15      3  f          7
 17      1  f          8
 18      5  m          5

The first thing you'll notice is that only 2 variables (2 columns) `var1` and `var2` are in common for `dataA` and `dataB`. `dataA` has `var3` and `dataB` has `var4`. 

Suppose we want to keep ALL of the variables - for this (in `R code`) we will use the `dplyr` package and the `bind_rows` function. Learn more about `dplyr` at [http://dplyr.tidyverse.org/](http://dplyr.tidyverse.org/).

**R CODE**


```r
library(dplyr)
dataAB <- bind_rows(dataA, dataB)
```

**Dataset `dataAB`**

**R CODE**


```r
kable(dataAB)
```



 id   var1  var2    var3   var4
---  -----  -----  -----  -----
  1      3  m         45     NA
  2      3  m         44     NA
  3      2  f         34     NA
  5      4  f         38     NA
  8      1  m         41     NA
  9      5  f         39     NA
 11      4  f         NA      0
 12      4  m         NA      6
 14      2  m         NA      4
 15      3  f         NA      7
 17      1  f         NA      8
 18      5  m         NA      5

Notice that the `NA`a are placed for the rows that do not have data for the variables that were not in common: `var3` and `var4`.

You can also use the `union_all` function from `dplyr`.

**R CODE**


```r
dataAB <- union_all(dataA, dataB)
kable(dataAB)
```



 id   var1  var2    var3   var4
---  -----  -----  -----  -----
  1      3  m         45     NA
  2      3  m         44     NA
  3      2  f         34     NA
  5      4  f         38     NA
  8      1  m         41     NA
  9      5  f         39     NA
 11      4  f         NA      0
 12      4  m         NA      6
 14      2  m         NA      4
 15      3  f         NA      7
 17      1  f         NA      8
 18      5  m         NA      5

Suppose we want only want to keep the 2 columns that are in common. In `R` after using `bind_rows`, use the `select` command to just keep `id`, `var1` and `var2`.

**R CODE**


```r
dataAB_var12 <- dataAB %>%
  select(id,var1,var2)
kable(dataAB_var12)
```



 id   var1  var2 
---  -----  -----
  1      3  m    
  2      3  m    
  3      2  f    
  5      4  f    
  8      1  m    
  9      5  f    
 11      4  f    
 12      4  m    
 14      2  m    
 15      3  f    
 17      1  f    
 18      5  m    

### **SAS CODE with sasHTML output using ODS output**



Load datasets - **BE SURE TO CHANGE THE CODE BELOW FOR YOUR FILE LOCATION**

**SAS CODE**


```sashtml
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
```

After loading `dataA` and `dataB` the `set` command within the `DATA` step concatenates or "stacks" the 2 datasets together. The columns from both datasets are retained even if they are no in common. Missing data is inserted for rows that didn't have that variable in the other dataset.

**SAS CODE**


```sashtml

* ======================================;
* concatenate dataA and dataB
  add rows and keep columns in both;
* ======================================;
  
data dataAB;
  set dataA dataB;
run;
  
proc print data=dataAB noobs; run;
  
```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" summary="Procedure Print: Data Set WORK.DATAAB">
<colgroup>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">id</th>
<th class="r header" scope="col">var1</th>
<th class="l header" scope="col">var2</th>
<th class="r header" scope="col">var3</th>
<th class="r header" scope="col">VAR4</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
<td class="r data">3</td>
<td class="l data">m</td>
<td class="r data">45</td>
<td class="r data">.</td>
</tr>
<tr>
<td class="r data">2</td>
<td class="r data">3</td>
<td class="l data">m</td>
<td class="r data">44</td>
<td class="r data">.</td>
</tr>
<tr>
<td class="r data">3</td>
<td class="r data">2</td>
<td class="l data">f</td>
<td class="r data">34</td>
<td class="r data">.</td>
</tr>
<tr>
<td class="r data">5</td>
<td class="r data">4</td>
<td class="l data">f</td>
<td class="r data">38</td>
<td class="r data">.</td>
</tr>
<tr>
<td class="r data">8</td>
<td class="r data">1</td>
<td class="l data">m</td>
<td class="r data">41</td>
<td class="r data">.</td>
</tr>
<tr>
<td class="r data">9</td>
<td class="r data">5</td>
<td class="l data">f</td>
<td class="r data">39</td>
<td class="r data">.</td>
</tr>
<tr>
<td class="r data">11</td>
<td class="r data">4</td>
<td class="l data">f</td>
<td class="r data">.</td>
<td class="r data">0</td>
</tr>
<tr>
<td class="r data">12</td>
<td class="r data">4</td>
<td class="l data">m</td>
<td class="r data">.</td>
<td class="r data">6</td>
</tr>
<tr>
<td class="r data">14</td>
<td class="r data">2</td>
<td class="l data">m</td>
<td class="r data">.</td>
<td class="r data">4</td>
</tr>
<tr>
<td class="r data">15</td>
<td class="r data">3</td>
<td class="l data">f</td>
<td class="r data">.</td>
<td class="r data">7</td>
</tr>
<tr>
<td class="r data">17</td>
<td class="r data">1</td>
<td class="l data">f</td>
<td class="r data">.</td>
<td class="r data">8</td>
</tr>
<tr>
<td class="r data">18</td>
<td class="r data">5</td>
<td class="l data">m</td>
<td class="r data">.</td>
<td class="r data">5</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>

If you want you can use the `drop` or `keep` commands in a `DATA` step to get rid of the variables not in common.

**SAS CODE**


```sashtml
  
* ======================================;
* keep only var1 and var2;
* ======================================; 
  
data dataAB_var12;
  set dataAB;
  drop var3 var4;
run;
  
proc print data=dataAB_var12 noobs; run;  

```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" summary="Procedure Print: Data Set WORK.DATAAB_VAR12">
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">id</th>
<th class="r header" scope="col">var1</th>
<th class="l header" scope="col">var2</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
<td class="r data">3</td>
<td class="l data">m</td>
</tr>
<tr>
<td class="r data">2</td>
<td class="r data">3</td>
<td class="l data">m</td>
</tr>
<tr>
<td class="r data">3</td>
<td class="r data">2</td>
<td class="l data">f</td>
</tr>
<tr>
<td class="r data">5</td>
<td class="r data">4</td>
<td class="l data">f</td>
</tr>
<tr>
<td class="r data">8</td>
<td class="r data">1</td>
<td class="l data">m</td>
</tr>
<tr>
<td class="r data">9</td>
<td class="r data">5</td>
<td class="l data">f</td>
</tr>
<tr>
<td class="r data">11</td>
<td class="r data">4</td>
<td class="l data">f</td>
</tr>
<tr>
<td class="r data">12</td>
<td class="r data">4</td>
<td class="l data">m</td>
</tr>
<tr>
<td class="r data">14</td>
<td class="r data">2</td>
<td class="l data">m</td>
</tr>
<tr>
<td class="r data">15</td>
<td class="r data">3</td>
<td class="l data">f</td>
</tr>
<tr>
<td class="r data">17</td>
<td class="r data">1</td>
<td class="l data">f</td>
</tr>
<tr>
<td class="r data">18</td>
<td class="r data">5</td>
<td class="l data">m</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>




### "Merging" / "Joining" - adding columns (vars) - aligning rows

Jenny Bryan has an excellent discussion on the different "joins" for adding columns using `R` - see her lesson on this topic in her STAT245 course [http://stat545.com/bit001_dplyr-cheatsheet.html](http://stat545.com/bit001_dplyr-cheatsheet.html).

Also read through the details on "joins" in the "R for Data Science" book at [http://r4ds.had.co.nz/relational-data.html#understanding-joins](http://r4ds.had.co.nz/relational-data.html#understanding-joins).

I will not cover all of these, but do highlight some of the more common approaches.

For this example we will work with `dataA` and `dataC` - here are what these 2 datasets look like:

**R CODE**


```r
dataC <- read_csv("dataC.csv")
```

Dataset `dataA`


```r
kable(dataA)
```



 id   var1  var2    var3
---  -----  -----  -----
  1      3  m         45
  2      3  m         44
  3      2  f         34
  5      4  f         38
  8      1  m         41
  9      5  f         39

Dataset `dataC`


```r
kable(dataC)
```



 id   var5   var6   var7
---  -----  -----  -----
  1     78     50     55
  2     80     45     53
  3     87     55     50
  4     79     53     51
  7     89     51     56
 10     95     49     49

So, only 3 ID's 1,2,3 are in common between `dataA` and `dataC` - IDs 5,8,9 are only in `dataA` and IDs 4,7,10 are only in `dataC`.

#### Inner Join

First, let's try an `inner_join` which will keep only the IDs in common between the 2 datasets.


```r
library(dplyr)
dataAC_innerjoin <- inner_join(dataA, dataC, by = "id")
kable(dataAC_innerjoin)
```



 id   var1  var2    var3   var5   var6   var7
---  -----  -----  -----  -----  -----  -----
  1      3  m         45     78     50     55
  2      3  m         44     80     45     53
  3      2  f         34     87     55     50

#### Outer Join - Full Join

Next let's keep all rows (all IDs) from both datasets - this is a `full_join`.


```r
dataAC_fulljoin <- full_join(dataA, dataC, by = "id")
kable(dataAC_fulljoin)
```



 id   var1  var2    var3   var5   var6   var7
---  -----  -----  -----  -----  -----  -----
  1      3  m         45     78     50     55
  2      3  m         44     80     45     53
  3      2  f         34     87     55     50
  5      4  f         38     NA     NA     NA
  8      1  m         41     NA     NA     NA
  9      5  f         39     NA     NA     NA
  4     NA  NA        NA     79     53     51
  7     NA  NA        NA     89     51     56
 10     NA  NA        NA     95     49     49

#### Left Join

Next let's keep all rows (all IDs) from the "LEFT" (or first) dataset provided - adding only data for rows (IDs) that match in the 2nd dataset (in this example those in `dataA`) - this is a `left_join`.


```r
dataAC_leftjoin <- left_join(dataA, dataC, by = "id")
kable(dataAC_leftjoin)
```



 id   var1  var2    var3   var5   var6   var7
---  -----  -----  -----  -----  -----  -----
  1      3  m         45     78     50     55
  2      3  m         44     80     45     53
  3      2  f         34     87     55     50
  5      4  f         38     NA     NA     NA
  8      1  m         41     NA     NA     NA
  9      5  f         39     NA     NA     NA

#### Right Join

Similarly, you can do a "RIGHT" join keeping the rows (IDs) which match those in the 2nd listed dataset (in this example those in `dataC`) - this is a `right_join`.


```r
dataAC_rightjoin <- right_join(dataA, dataC, by = "id")
kable(dataAC_rightjoin)
```



 id   var1  var2    var3   var5   var6   var7
---  -----  -----  -----  -----  -----  -----
  1      3  m         45     78     50     55
  2      3  m         44     80     45     53
  3      2  f         34     87     55     50
  4     NA  NA        NA     79     53     51
  7     NA  NA        NA     89     51     56
 10     NA  NA        NA     95     49     49

**SAS Code**

In `SAS` we'll used `PROC SORT` to sort both datasets by `ID` and then used a `MERGE` command in a `DATA` step.



Load the datasets `dataA` and `dataC`.


```sashtml
* ======================================;
* load dataC;  
* ======================================;
proc import datafile='C:\MyGithub\N736Fall2017_lesson05\dataC.csv'
  out=dataC dbms=csv;
run;
```

Sort both datasets by `id` and the use the `MERGE` command in a `DATA` step.


```sashtml
proc sort data=dataA; by id; run;
proc sort data=dataC; by id; run;

data dataAC_fulljoin;
  merge dataA dataC;
  by id;
run;

proc print data=dataAC_fulljoin noobs; run;
```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" summary="Procedure Print: Data Set WORK.DATAAC_FULLJOIN">
<colgroup>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">id</th>
<th class="r header" scope="col">var1</th>
<th class="l header" scope="col">var2</th>
<th class="r header" scope="col">var3</th>
<th class="r header" scope="col">var5</th>
<th class="r header" scope="col">var6</th>
<th class="r header" scope="col">var7</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
<td class="r data">3</td>
<td class="l data">m</td>
<td class="r data">45</td>
<td class="r data">78</td>
<td class="r data">50</td>
<td class="r data">55</td>
</tr>
<tr>
<td class="r data">2</td>
<td class="r data">3</td>
<td class="l data">m</td>
<td class="r data">44</td>
<td class="r data">80</td>
<td class="r data">45</td>
<td class="r data">53</td>
</tr>
<tr>
<td class="r data">3</td>
<td class="r data">2</td>
<td class="l data">f</td>
<td class="r data">34</td>
<td class="r data">87</td>
<td class="r data">55</td>
<td class="r data">50</td>
</tr>
<tr>
<td class="r data">4</td>
<td class="r data">.</td>
<td class="l data"> </td>
<td class="r data">.</td>
<td class="r data">79</td>
<td class="r data">53</td>
<td class="r data">51</td>
</tr>
<tr>
<td class="r data">5</td>
<td class="r data">4</td>
<td class="l data">f</td>
<td class="r data">38</td>
<td class="r data">.</td>
<td class="r data">.</td>
<td class="r data">.</td>
</tr>
<tr>
<td class="r data">7</td>
<td class="r data">.</td>
<td class="l data"> </td>
<td class="r data">.</td>
<td class="r data">89</td>
<td class="r data">51</td>
<td class="r data">56</td>
</tr>
<tr>
<td class="r data">8</td>
<td class="r data">1</td>
<td class="l data">m</td>
<td class="r data">41</td>
<td class="r data">.</td>
<td class="r data">.</td>
<td class="r data">.</td>
</tr>
<tr>
<td class="r data">9</td>
<td class="r data">5</td>
<td class="l data">f</td>
<td class="r data">39</td>
<td class="r data">.</td>
<td class="r data">.</td>
<td class="r data">.</td>
</tr>
<tr>
<td class="r data">10</td>
<td class="r data">.</td>
<td class="l data"> </td>
<td class="r data">.</td>
<td class="r data">95</td>
<td class="r data">49</td>
<td class="r data">49</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>

For an inner join you need to name the datasets using the `(in=name)` for each dataset and then use the `if` command to state which dataset should govern which rows are kept. To keep only rows in common in both `dataA` and `dataC` I used the `if A and C` command below.


```sashtml
data dataAC_innerjoin;
  merge dataA(in=A) dataC(in=C);
  by id;
  if A and C;
run;

proc print data=dataAC_innerjoin noobs; run;
```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" summary="Procedure Print: Data Set WORK.DATAAC_INNERJOIN">
<colgroup>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">id</th>
<th class="r header" scope="col">var1</th>
<th class="l header" scope="col">var2</th>
<th class="r header" scope="col">var3</th>
<th class="r header" scope="col">var5</th>
<th class="r header" scope="col">var6</th>
<th class="r header" scope="col">var7</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
<td class="r data">3</td>
<td class="l data">m</td>
<td class="r data">45</td>
<td class="r data">78</td>
<td class="r data">50</td>
<td class="r data">55</td>
</tr>
<tr>
<td class="r data">2</td>
<td class="r data">3</td>
<td class="l data">m</td>
<td class="r data">44</td>
<td class="r data">80</td>
<td class="r data">45</td>
<td class="r data">53</td>
</tr>
<tr>
<td class="r data">3</td>
<td class="r data">2</td>
<td class="l data">f</td>
<td class="r data">34</td>
<td class="r data">87</td>
<td class="r data">55</td>
<td class="r data">50</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>

For an left join you need to name the datasets using the `(in=name)` for each dataset and then use the `if` command to state which dataset should govern which rows are kept. To keep only rows in  `dataA` I used the `if A` command below.


```sashtml
data dataAC_leftjoin;
  merge dataA(in=A) dataC(in=C);
  by id;
  if A;
run;

proc print data=dataAC_leftjoin noobs; run;
```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" summary="Procedure Print: Data Set WORK.DATAAC_LEFTJOIN">
<colgroup>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">id</th>
<th class="r header" scope="col">var1</th>
<th class="l header" scope="col">var2</th>
<th class="r header" scope="col">var3</th>
<th class="r header" scope="col">var5</th>
<th class="r header" scope="col">var6</th>
<th class="r header" scope="col">var7</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
<td class="r data">3</td>
<td class="l data">m</td>
<td class="r data">45</td>
<td class="r data">78</td>
<td class="r data">50</td>
<td class="r data">55</td>
</tr>
<tr>
<td class="r data">2</td>
<td class="r data">3</td>
<td class="l data">m</td>
<td class="r data">44</td>
<td class="r data">80</td>
<td class="r data">45</td>
<td class="r data">53</td>
</tr>
<tr>
<td class="r data">3</td>
<td class="r data">2</td>
<td class="l data">f</td>
<td class="r data">34</td>
<td class="r data">87</td>
<td class="r data">55</td>
<td class="r data">50</td>
</tr>
<tr>
<td class="r data">5</td>
<td class="r data">4</td>
<td class="l data">f</td>
<td class="r data">38</td>
<td class="r data">.</td>
<td class="r data">.</td>
<td class="r data">.</td>
</tr>
<tr>
<td class="r data">8</td>
<td class="r data">1</td>
<td class="l data">m</td>
<td class="r data">41</td>
<td class="r data">.</td>
<td class="r data">.</td>
<td class="r data">.</td>
</tr>
<tr>
<td class="r data">9</td>
<td class="r data">5</td>
<td class="l data">f</td>
<td class="r data">39</td>
<td class="r data">.</td>
<td class="r data">.</td>
<td class="r data">.</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>

For an right join you need to name the datasets using the `(in=name)` for each dataset and then use the `if` command to state which dataset should govern which rows are kept. To keep only rows in  `dataC` I used the `if C` command below.


```sashtml
data dataAC_rightjoin;
  merge dataA(in=A) dataC(in=C);
  by id;
  if C;
run;

proc print data=dataAC_rightjoin noobs; run;
```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" summary="Procedure Print: Data Set WORK.DATAAC_RIGHTJOIN">
<colgroup>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">id</th>
<th class="r header" scope="col">var1</th>
<th class="l header" scope="col">var2</th>
<th class="r header" scope="col">var3</th>
<th class="r header" scope="col">var5</th>
<th class="r header" scope="col">var6</th>
<th class="r header" scope="col">var7</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
<td class="r data">3</td>
<td class="l data">m</td>
<td class="r data">45</td>
<td class="r data">78</td>
<td class="r data">50</td>
<td class="r data">55</td>
</tr>
<tr>
<td class="r data">2</td>
<td class="r data">3</td>
<td class="l data">m</td>
<td class="r data">44</td>
<td class="r data">80</td>
<td class="r data">45</td>
<td class="r data">53</td>
</tr>
<tr>
<td class="r data">3</td>
<td class="r data">2</td>
<td class="l data">f</td>
<td class="r data">34</td>
<td class="r data">87</td>
<td class="r data">55</td>
<td class="r data">50</td>
</tr>
<tr>
<td class="r data">4</td>
<td class="r data">.</td>
<td class="l data"> </td>
<td class="r data">.</td>
<td class="r data">79</td>
<td class="r data">53</td>
<td class="r data">51</td>
</tr>
<tr>
<td class="r data">7</td>
<td class="r data">.</td>
<td class="l data"> </td>
<td class="r data">.</td>
<td class="r data">89</td>
<td class="r data">51</td>
<td class="r data">56</td>
</tr>
<tr>
<td class="r data">10</td>
<td class="r data">.</td>
<td class="l data"> </td>
<td class="r data">.</td>
<td class="r data">95</td>
<td class="r data">49</td>
<td class="r data">49</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>




