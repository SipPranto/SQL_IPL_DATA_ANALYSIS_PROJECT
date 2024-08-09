This repository consists of IPL Analysis with proper explanation of code:

1. **Count Records in Tables**
   - Determine the number of records in the `matches` and `deliveries` tables to understand the dataset's size.

2. **Top 5 Players with Most "Player of the Match" Awards**
   - Group by the player who received the award and count the number of awards for each player.
   - Sort to find the top 5 players with the highest counts.

3. **Matches Won by Each Team in Each Season**
   - Aggregate the number of matches won by each team per season.
   - Group results by season and team, then order them.

4. **Average Strike Rate of Batsmen**
   - Calculate the average strike rate for all batsmen by dividing total runs by the number of deliveries faced, excluding extras.

5. **Number of Matches Won Based on Toss Decision**
   - Use Common Table Expressions (CTEs) to count the wins for teams based on their toss decision (bat or bowl first).
   - Aggregate results from two perspectives (team1 and team2) and combine them.

6. **Highest Strike Rate with Minimum 200 Runs**
   - Compute the strike rate for each batsman who has scored more than 200 runs.
   - Sort the results by strike rate in descending order.

7. **Dismissals by Bowler Lasith Malinga**
   - Count the number of times each batsman was dismissed by Lasith Malinga.
   - Filter based on the bowler's name and dismissal conditions.

8. **Average Percentage of Boundaries Hit by Each Batsman**
   - Calculate the percentage of boundary deliveries (4s and 6s) for each batsman.
   - Aggregate and compute the percentage for each batsman.

9. **Total Number of Boundaries per Team per Season**
   - Count the number of boundaries (4s and 6s) hit by each team in each season.
   - Calculate the average number of boundaries per match.

10. **Calculate Partnerships in Each Match**
    - Aggregate runs scored by each pair of batsmen in partnerships for each match.
    - Join data to compute the total partnership runs for each pair.

11. **Highest Partnership for Each Team in Each Season**
    - Identify the highest partnership runs for each team in each season by analyzing partnership data.

12. **Extras (Wide and No Balls) for Each Team and Match**
    - Calculate the total number of extras (wides and no balls) for each team in each match.

13. **Bowler with Most Wickets in a Single Match**
    - Determine which bowler took the most wickets in each match.
    - Group by match and bowler, sorting to find the highest wicket-taker.

14. **Matches Won by Each Team in Each City**
    - Aggregate the number of matches won by each team in each city.

15. **Toss Wins for Each Team in Each Season**
    - Count the number of tosses won by each team in each city.

16. **Player of the Match Awards**
    - Count the number of "Player of the Match" awards received by each player.

17. **Average Runs Scored in Each Innings**
    - Calculate the average runs scored in each innings of a match by aggregating runs and dividing by the number of innings.

18. **Average Runs Scored per Over**
    - Compute the average runs scored per over in each match by grouping by over and calculating averages.
