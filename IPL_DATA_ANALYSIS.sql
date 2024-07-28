USE ipl;

select count(*) from matches                    -- 128

select count(*) from deliveries                 -- 29784


-- Top 5 players with most player of the match award
select player_of_match,count(*) as Number_of_MOM
from matches
group by player_of_match 
order by Number_of_MOM desc
limit 5


-- how many matches were  won by each team in each season
select season,winner,count(*) as Total_winning_match from matches
group by  season,winner
order by season ,winner


-- average strike rate of batsman in the dataset 
select (sum(batsman_runs)/count(*))*100  as average_strike_rate from deliveries
where extra_runs=0 


-- number of matches won for each team  for bat first and bowl first
with t1 as
(select team1,toss_decision,
sum(case
	when team1=winner then 1
    else 0
    end ) as winning_number2
from matches
group by team1,toss_decision),
t2 as 
(select team2,toss_decision,
sum(case
	when team2=winner then 1
    else 0
    end ) as winning_number1
from matches
group by team2,toss_decision)


select t1.team1 as team,t1.toss_decision as Decision,(winning_number1+winning_number2) as Win_Number
from t1
join t2
on t1.team1=t2.team2
and t1.toss_decision=t2.toss_decision
order by team ,Decision


-- highest strike rate (minimum 200 runs)

select batsman ,sum(batsman_runs) as Total_runs ,(sum(batsman_runs)/count(*))*100 as Strike_Rate
from deliveries
where extra_runs=0
group by batsman
having Total_runs>200
order by Strike_Rate  desc

-- hoe many times has each batsman benn dismissed by bowler Malinga

select batsman,count(*) from deliveries
where bowler like 'SL Malinga' 
and player_dismissed=batsman
-- and dismissal_kind is in ('caught','bowled','lbw','stumped','caught and bowled')
group by batsman


-- Avrage percentage of boundaries hit by each batsman (balll faced wise)
with t as(
select batsman, 
sum(case
	 when batsman_runs=6 or batsman_runs=4 then 1
     else 0
     end ) as total_boundary_number,
sum(case
	 when extra_runs=0 then 1
     else 0
     end) as Total_delivery_faced
from deliveries
group by batsman
)
select batsman, round((total_boundary_number/Total_delivery_faced)*100,1) as Percentage_of_Boundary 
from t
order by Percentage_of_Boundary desc

-- Total number of boundaries hit by each team in each season in a match 

select season,batting_team,count(*) as  Total_boundary,count(Distinct id)as Match_no,
round((count(*)/count(Distinct id)),0) as Average_Boundary_per_match
from deliveries
join matches
on matches.id=deliveries.match_id
where batsman_runs=6 or batsman_runs=4
group by season,batting_team
order by season,batting_team

-- calucalte the partnership in each match

with t as
(select  id,season,batting_team,batsman,non_striker,sum(batsman_runs) as 1st_run from deliveries
join matches
on matches.id=deliveries.match_id
group by id,season,batting_team,batsman,non_striker)

select t1.id,t1.season,t1.batting_team,t1.batsman as 1st_batsman,t1.non_striker as 2nd_batsman,t1.1st_run as 1st_batsman_run,t2.1st_run as 2nd_batsman_run,(t1.1st_run+t2.1st_run) as Partnership 
from t as t1
join t as t2
on t1.batsman=t2.non_striker and t1.non_striker=t2.batsman and t1.id=t2.id
order by t1.id asc


-- calculate the highest partnership in each team for each season

with t as
(select  id,season,batting_team,batsman,non_striker,sum(batsman_runs) as 1st_run from deliveries
join matches
on matches.id=deliveries.match_id
group by id,season,batting_team,batsman,non_striker),
v as (select t1.id,t1.season,t1.batting_team,t1.batsman as 1st_batsman,t1.non_striker as 2nd_batsman,t1.1st_run as 1st_batsman_run,t2.1st_run as 2nd_batsman_run,(t1.1st_run+t2.1st_run) as Partnership 
from t as t1
join t as t2
on t1.batsman=t2.non_striker and t1.non_striker=t2.batsman and t1.id=t2.id
order by t1.id asc)

select season,batting_team,max(Partnership) as Highest_Partnership
from v
group by season,batting_team


-- How namy extras (wide and no balls) for each team and each match

select match_id,bowling_team as Team,batting_team as Opponent ,sum(noball_runs+wide_runs) as Extras 
from deliveries
group by match_id,bowling_team,batting_team


-- bowler gets most wicket in a single match

select match_id,bowler,batting_team as opponent,count(*) as Wicket from deliveries 
where player_dismissed != '' and(dismissal_kind='bowled' or dismissal_kind='caught and bowled' or dismissal_kind='lbw'or dismissal_kind='stumped')
group by match_id,batting_team,bowler
order by Wicket desc


-- how many matches resulted in a win for each team for each city

select winner,city,count(*) as Number_of_Winning from matches
group by winner,city
order by winner,Number_of_Winning desc

-- how many matches did each team win the toss in each season

select toss_winner,city ,count(*) as Toss_win_number from matches
group by toss_winner,city
order by toss_winner,city


-- how many matches did each player win the man of the match

select player_of_match, count(*) as number_of_player_of_match 
from matches 
group by player_of_match
order by number_of_player_of_match desc

-- what is the average number of runs scored in each  innnings in each match

select match_id,sum(total_runs) as Total_run, round((sum(total_runs)/2),0) as Average_Run from deliveries
group by match_id


-- what is the average number of runs scored in each over in each match
select match_id,  round((sum(Over_run)/count(*)),1) as Average_over_run from
(select match_id,over_,batting_team,sum(total_runs) as Over_run from deli
group by match_id,over_,batting_team)k
group by match_id

-- highest total score in a single match
with t as(
select match_id, batting_team,bowling_team,sum(total_runs) as Total_Run from deliveries
group by match_id, batting_team,bowling_team)

select * from t 
where Total_Run=(select max(Total_Run) from t)

-- which batsman has scored  most runs in a single match
with k as (
select match_id,batsman,bowling_team,sum(batsman_runs) as Run,count(*) as ball
from deliveries 
where extra_runs=0
group by batsman,match_id,bowling_team)

select *, round((Run/ball)*100,1) as Strike_rate from k
where Run=(select max(Run) from k)


-- match wise kohlis Total run and strike rate

select  match_id,season,bowling_team,sum(batsman_runs) as Run,count(*) as ball, round((sum(batsman_runs)/count(*))*100,1) as Strike_rate from deliveries d 
join matches m
on m.id=d.match_id
where batsman='V Kohli' and extra_runs=0
group by match_id,bowling_team,season

-- season wise kohlis Total run and strike rate , fifty and hundred

with k as
(select  match_id,season,bowling_team,sum(batsman_runs) as Run,count(*) as ball, round((sum(batsman_runs)/count(*))*100,1) as Strike_rate,
case 
	when sum(batsman_runs)>50 and sum(batsman_runs)<100 then 1
    
	else 0
	end  as 50_s,
case 
	when sum(batsman_runs)>100 then 1
    
	else 0
	end as 100_s
from deliveries d 
join matches m
on m.id=d.match_id
where batsman='V Kohli' and extra_runs=0
group by match_id,bowling_team,season)

select season,sum(Run) as Total_Run ,sum(ball) as Total_ball_face ,round((sum(Run)/sum(ball))*100,1)  as Strike_Rate,
sum(50_s) as Fifty,sum(100_s) as Hundred
from k
group by season


-- top 5 batsman for each team
select batting_team,batsman,Total_Run
from (
select batting_team,batsman,sum(batsman_runs) as Total_Run,
dense_rank() over(partition by batting_team order by sum(batsman_runs) desc) as rnk
from deliveries
group by batting_team,batsman
order by batting_team asc ,Total_Run desc)p
where p.rnk<6



-- top 2 batsman for each team in each season
with k as(
select batting_team,batsman,season,sum(batsman_runs) as Total_Run
from deliveries d
join matches m on m.id=d.match_id
group by batting_team,batsman,season)

select season,batting_team,batsman,Total_Run
from(
select * ,
dense_rank() over(partition by batting_team,season order by Total_Run desc) as rnk
from k)p
where p.rnk<3
order by season,batting_team 


-- V kohlis cumulative runs in ipl

select concat('Match_no-',cast(row_number() over(order by match_id asc) as char)) as Match_no,
sum(batsman_runs) as Match_run,
sum(sum(batsman_runs)) over(rows between unbounded preceding and current row) as Cumulative_run
from deliveries
where batsman='V Kohli'
group by match_id
order by match_id desc


-- how many matches kohli need to complete his first 500 runs in ipl
with k as
(select concat('Match_no-',cast(row_number() over(order by match_id asc) as char)) as Match_no,
sum(batsman_runs) as Match_run,
sum(sum(batsman_runs)) over(rows between unbounded preceding and current row) as Cumulative_run
from deliveries
where batsman='V Kohli'
group by match_id
order by match_id )

select * from k
where Cumulative_run>500
order by Match_no
limit 1


-- findout player who has more 200 runs and 5 wickets

with run_ as
(select batsman,sum(batsman_runs) as Run from deliveries
group by batsman),
wicket_ as
(select bowler,count(*) as Wicket from deliveries
where dismissal_kind='bowled' or dismissal_kind='caught and bowled' or dismissal_kind='lbw'or dismissal_kind='stumped'
group by bowler)
select r.batsman as Player,Run,Wicket from run_ r
join wicket_ w
on w.bowler=r.batsman
where Run>200 and Wicket>5

-- TOP 5 most economist bowler atleast bowl 5 overs
with ec as(
select bowler,sum(total_runs) as Run_conced,count(*) as Total_ball,round(count(*)/6,1) as overs,round((sum(total_runs)/count(*))*6,1) as Economy
from deliveries
where bye_runs=0 
group by bowler)

select * from ec
where overs>5
order by Economy
limit 5

-- Kohlis Highest Run
select 
concat('Match_no-',cast(row_number() over(order by match_id asc) as char)) as Match_no,
batsman,sum(batsman_runs) as Run,
dense_rank() over(order by sum(batsman_runs) desc) as rnk 
from deliveries
where batsman='V Kohli'
group by match_id
order by rnk asc
limit 1






