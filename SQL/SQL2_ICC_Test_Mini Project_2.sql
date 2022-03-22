#Tasks to be performed:

#1.	Import the csv file to a table in the database.
#use the table data import wizard

#2.	Remove the column 'Player Profile' from the table.
alter table icc drop column `Player Profile`;

desc icc;


#3.	Extract the country name and player names from the given data and store it in 
#seperate columns for further usage.

#add new column fullname
alter table icc add column fullname varchar(50);
update icc
set fullname=trim(substring_index(Player,'(',1));

#Add a column country_0 as intermediate column
alter table icc add column Country_0 varchar(10);
#update the values for country_0
update icc
set country_0=replace(substring(player, instr(trim(player),'(')+1) , ')','');

#Add a column country
alter table icc add column Country varchar(10);
#update the values for country
update icc
set country= substr( country_0, INSTR(country_0,'/')+1) ;

#4.	From the column 'Span' extract the start_year and end_year and store them in 
#seperate columns for further usage.

#Add a column start year and end year
alter table icc add column start_year varchar(10);
alter table icc add column end_year varchar(10);

#update the values for Start year and end year
update icc
set start_year=substr( span, 1,4);
update icc
set end_year=substr( span, INSTR(span,'-')+1);

#5.	The column 'HS' has the highest score scored by the player so far in any given match.
# The column also has details if the player had completed the match in a NOT OUT status. 
#Extract the data and store the highest runs and the NOT OUT status in different columns.

#Add a column Not_Out_Status and Highest_score
alter table icc add column Not_Out_Status varchar(1);
alter table icc add column Highest_score int;

#update the values for Not_Out_Status and Highest_score
update icc
set Not_Out_Status=IF(INSTR(HS,'*')=0 ,'N','Y');

update icc
set Highest_score=Replace(HS,'*','');


#6.	Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those 
#who have a good average score across all matches for India.

#Batting order 1 - Players with Good average batting score
Select * 
from (
Select * , Dense_Rank() over (order by Avg Desc) as Good_Avg_Rank
from icc
where Country='INDIA'
and  end_year >= 2019
)a
where Good_Avg_Rank<=6;


#7.	Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those 
#who have highest number of 100s across all matches for India.

#Batting order 2 - players with highest number of 100s
Select * 
from (
Select * , Rank() over(order by `100` desc) as Good_Avg_Rank
from icc
where Country='INDIA'
and  end_year >= 2019
)a
where Good_Avg_Rank<=6;



#8.	Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using 2 selection criterias of your
# own for India.

#Batting order 3 - players with highest number of 100s and 50s
Select * 
from (
Select * , Rank() over(order by `100`+`50` desc) as Good_Avg_Rank
from icc
where Country='INDIA'
and  end_year >= 2019
)a
where Good_Avg_Rank<=6;

#Batting order 4 - players with lowset number matches played in test match
Select * 
from (
Select * , Rank() over(order by mat) as Good_Avg_Rank
from icc
where Country='INDIA'
and  end_year >= 2019
)a
where Good_Avg_Rank<=6;




#9.	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, 
#considering the players who were active in the year of 2019, create a set of 
#batting order of best 6 players using the selection criteria of those who have 
#a good average score across all matches for South Africa.

#Batting order - Players with Good average batting score
Create View Batting_Order_GoodAvgScorers_SA
As 
(
Select * 
from (
Select * , Dense_Rank() over (order by Avg Desc) as Good_Avg_Rank
from icc
where Country='SA'
and  end_year >= 2019
)a
where Good_Avg_Rank<=6
);

Select * from Batting_Order_GoodAvgScorers_SA;



#10.	Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the 
#data given, considering the players who were active in the year of 2019, create 
#a set of batting order of best 6 players using the selection criteria of those 
#who have highest number of 100s across all matches for South Africa.

#Batting order - players with highest number of 100s
Create View Batting_Order_HighestCenturyScorers_SA
As 
(
Select * 
from (
Select * , Rank() over(order by `100` desc) as Good_Avg_Rank
from icc
where Country='SA'
and  end_year >= 2019
)a
where Good_Avg_Rank<=6
);

Select * from Batting_Order_HighestCenturyScorers_SA;

