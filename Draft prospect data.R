#Geoffrey Rozo

#MSDS 457 Final project

library(sqldf)

draftdata <- read.csv("/Users/grozo/Documents/MSDS 457 Final Project/NBA Draft Prospect Data Final.csv", sep=",")
draftdata <- draftdata[ , 1:45]

prospects <- draftdata[1:130, ]
#2019 list of potential players to be drafted in NBA

draftedNBA <- draftdata[131:370, ]
#2015-2018 list of NBA players drafted

summary(draftedNBA)

nbap10 <- sqldf("select Player, height, weight, year, pick, NCAATeam, NCAAPos from draftedNBA where Pick <= 10 order by Pick, NCAATeam", row.names=TRUE)

nbap10

#shows insights on top 10 picks from past 4 years (College team, height, weight, position...)

#from Python correlations, it showed NCAABPG and NCAAORB are ok indicators of NBA WS... could look... but really not that strong.. only ~0.25-0.27

#So, I decided NBA WS is not as helpful because some players from 2015 have the same WS as players in 2018.. so it would be more meaningful (maybe) 
#to see what players' WS is per tenured year in NBA...

#pdata['NBAWS/Tenure'] = pdata['NBAWS']/pdata['Tenure']

draftedNBA$NBAWSTenure <- draftedNBA$NBAWS/draftedNBA$Tenure

nbap5WS <- sqldf("select Player, Year, Pick, Conf, NCAAORB, NCAABPG, NBAGames, NBAMPTot, NBAWS from draftedNBA where NBAWS >= 5 order by NBAWS DESC")

nbap5WS

#so far I am just exploring, but I think a cool/unique thing to see is checking what late round/2nd round picks have high NBA WS
#example: Pascal Siakam, Malcolm Brogdon, Larry Nance Jr., MONTREZL HARRELL, great steals for NBA teams... HOW?

nbaptopWSyr <- sqldf("select Player, Year, Pick, Conf, NCAAORB, NCAABPG, NBAGames, NBAMPTot, NBAWSTenure from draftedNBA where NBAWSTenure >= 1.5 order by NBAWSTenure DESC")

nbaptopWSyr


nbapWSyrlate <- sqldf("select Player, Year, Pick, Conf, NCAAORB, NCAABPG, NBAGames, NBAMPTot, NBAVORP, NBABPM, NBAWSTenure from draftedNBA where NBAWSTenure >= 1.5 and Pick > 20 order by NBAWSTenure DESC")

nbapWSyrlate
#so this one shows NBA Win share per year, only for NBA players who were picks 11+... shows how NBA teams need to take late round and 2nd round picks seriously.

#Pascal Siakam is currently leading Toronto Raptors in NBA Eastern Conf. Finals == 27th pick in 2016.

#Malcolm Brogdon currently leading Milwaukee Bucks in Eastern Conf. Finals ==> 36th pick in 2016.

#Landry Shamet was 40th pick! and he was having a great playoff series for the Clippers against the Warriors this 2019.

#Monte Morris 51st pick!!! for Denver Nuggets in 2017 and has produced 3.2 Win Share per year with them, they had a strong playoff run this 2019.

#Kevon Looney (30th pick) and Jordan Bell (38th pick) for Warriors... granted, probably skewed because anyone on the Warriors probably contributes to Win Share in a way...

#But all these examples show how important these LATE picks have been in NBA team playoff runs...

nbatop10 <- sqldf('select Player, Year, Pick, Conf, NCAAORB, NCAABPG, NBAVORP, NBABPM, NBAWSTenure from draftedNBA where Pick <= 10 order by Year, NBAWSTenure DESC')
nbatop10


nbaworst10 <- sqldf('select Player, Year, Pick, Conf, NBAVORP, NBABPM, NBAWSTenure from nbatop10 where NBAWSTenure < 1 order by Year, NBAWSTenure DESC')
nbaworst10
#so, just to show an example... top 10 picks for past 4 years, 40 total. 

#6 top 10 players (15%) have produced negative ( - ) Win share results for teams per year.
#12 top 10 players (30%) have produced less than desired win share results (less than 1 per year)...

#This is a BIG deal when some players in late rounds produce way better results than these TOP players.

#Could look at a lot just from these 4 years... right here from "nbaworst10", we can look at specific conferences or teams that produce highest NBA Win share players...

nbaACC <- sqldf('select Player, Year, Pick, Conf, NBAWSTenure from draftedNBA where Conf="ACC" order by Year, NBAWSTenure DESC')
nbaACC

#ACC is a strong NCAA conference... wanted to see how much talent comes from ACC, 2015 shows many players picked outside of top 10 having high Win share
#2016 Malcolm Brogdon 36th pick best Win Share rate... really missed out, Brandon Ingram has been pretty disappointing for a 2ND PICK! to have that low of a Win Share...
#2017 and 2018 top ACC picks were good choices... 2017 some picks outside of top 10 (John Collins 19th, Donovan Mitchell 13th...) good...

#interesting insights...

#Could do a lm(), see which Conf has best NBA win share / year...

nbaEuro <- sqldf('select Player, Year, Pick, Conf, NBAWSTenure from draftedNBA where Conf="Euro" order by Year, NBAWSTenure DESC')
nbaEuro

#Euro players seem to be most risky since so many don't ever end up coming to play in the NBA, so many are picked in the late 2nd round apparent from "nbaEuro"
#risk pays off when you get a Kristaps Porzingis (4th in 2015), Ivica Zubac (32nd in 2016), Terrance Ferguson (21st in 2017), and Luka Doncic (3rd in 2018)...
#but Euro players show to be most risky choices...Most risk/OK reward...

nbaSEC <- sqldf('select Player, Year, Pick, Conf, NBAWSTenure from draftedNBA where Conf="SEC" order by Year, NBAWSTenure DESC')
nbaSEC

#SEC shows good results from 2015, many great big men... 2016 Ben Simmons... Top picks (1st...)...Bam Adebayo (14th in 2017)...

nbaP12 <- sqldf('select Player, Year, Pick, Conf, NBAWSTenure from draftedNBA where Conf="P12" order by Year, NBAWSTenure DESC')
nbaP12

#P12 has been eh... 2017 drafted SO MANY, really not much good besides Lauri Markkanen and Kyle Kuzma (27th pick)... 2018 only best pick was Deandre Ayton (#1)
#Markelle Fultz a failure SO FAR... takes a lot of patience...

ncaa20ppg <- sqldf('select Player, Year, Pick, Conf, NCAATeam, NCAAPos, NCAAPPG, NBAVORP, NBABPM, NBAWSTenure from draftedNBA where NCAAPPG>=20 order by NCAAPPG DESC')
ncaa20ppg

#not all players with high ppg do well...

ncaa20ppgHighWS <- sqldf('select Player, Year, Pick, Conf, NCAATeam, NCAAPos, NCAAPPG, NBAVORP, NBABPM, NBAWSTenure from ncaa20ppg where NBAWSTenure>0.5 order by NBAWSTenure DESC')
ncaa20ppgHighWS

#since 2015, 7 players with 20+ ppg who have had high Win Shares in their NBA Tenure came from Pac 12, SEC, ACC, Big 12, and WAC (Pascal Siakam)

ncaa1020ppgHighWS <- sqldf('select Player, Year, Pick, Conf, NCAATeam, NCAAPos, NCAAPPG, NBAVORP, NBABPM, NBAWSTenure from draftedNBA where NBAWSTenure>1.5 and NCAAPPG<20 and NCAAPPG>=10 order by NBAWSTenure DESC')
ncaa1020ppgHighWS


#I just had an idea... because it shows Karl-Anthony Towns has the highest Win Shares but the lowest PPG from NCAA... need to factor in Rebounds and Assists...
#have an idea:

draftedNBA$NCAAPRAPG <- draftedNBA$NCAAPPG+draftedNBA$NCAARPG+draftedNBA$NCAAAPG

draftedNBA$NCAAPRAPM <- draftedNBA$NCAAPRAPG/draftedNBA$NCAAMPG

draftedNBA$NCAAReb.Min <- draftedNBA$NCAARPG/draftedNBA$NCAAMPG

####----------------------------------------------------------------------------

prospects$NCAAPRAPG <- prospects$NCAAPPG+prospects$NCAARPG+prospects$NCAAAPG

prospects$NCAAPRAPM <- prospects$NCAAPRAPG/prospects$NCAAMPG

prospects$NCAAReb.Min <- prospects$NCAARPG/prospects$NCAAMPG

####----------------------------------------------------------------------------

#try this to see if it shows any correlation with Karl-Anthony Towns high Win Shares...

#so the big thing is... Karl-Anthony Towns played such LOW minutes in college at Kentucky...he was able to be SO EFFECTIVE in only 21.1 minutes,
#compare to someone (Ben Simmons) playing 34.9 MPG in college... then take created variable (NCAAPRAPG = Points+Rebounds+Assists Per Game) divide by / NCAAMPG

sqldf('select Player, Pick, NCAAMPG, NCAAPPG, NCAARPG, NCAAAPG, NCAAPRAPG, NBAWSTenure from draftedNBA where NBAWSTenure>2 and NCAAPRAPG>15 order by NBAWSTenure DESC')

sqldf('select Player, Pick, NCAAPRAPG, NCAAPRAPM, NBAWSTenure from draftedNBA where NBAWSTenure>2 and NCAAPRAPM>=0.7 order by NBAWSTenure DESC')

#Find best draft picks == best in NBA so far...

ncaaHighPRAPM <- sqldf('select Player, Pick, Conf, NCAATeam, NCAAPos, NCAAPRAPG, NCAAPRAPM, NBAWSTenure from draftedNBA where NCAAPRAPM>=0.9 order by NCAAPRAPM DESC')
ncaaHighPRAPM


#################################################################################

#*******************IMPORTANT*******************

sqldf('select Player, Pick, NCAAPRAPM, NCAAORB, NCAARPG, NCAABPG, NBAWSTenure from draftedNBA where NCAAORB>2 and NCAABPG>2 order by NBAWSTenure DESC')


#*******************IMPORTANT*******************

#This ABOVE shows how larger players with Offensive Rebounding and Blocking abilities end up successful in NBA...specifically Karl-Anthony Towns and Pascal Siakam
#BELOW TOO.

sqldf('select Player, Pick, Conf, NCAATeam, NCAAPRAPM, NCAAORB, NCAARPG, NCAABPG, NBAWSTenure from draftedNBA where NCAAORB>2 and NCAABPG>1.3 order by NBAWSTenure DESC')


#################################################################################


main.effects.model <-
  
{NBAWSTenure ~ height + weight + NCAAORB + NCAARPG + NCAABPG + NCAAPPG + NCAAPRAPM + NCAAReb.Min}


# fit linear regression model using main effects only (no interaction terms)

main.effects.model.fit <- lm(main.effects.model, data=draftedNBA)

print(summary(main.effects.model.fit)) 

#Height most significant... but not much (p<0.1)




#################################################################################
########################################
#################################################################################



main.effects.model2 <-
  
{NBAWSTenure ~ height + weight + NCAAPRAPM + Conf + NCAATeam}


# fit linear regression model using main effects only (no interaction terms)

main.effects.model2.fit <- lm(main.effects.model2, data=draftedNBA)

print(summary(main.effects.model2.fit)) 

#NCAAPRAPM                      3.646669   1.295634   2.815   0.0057 **

#ConfACC                        4.024163   2.399980   1.677   0.0962 .


#NCAATeamKentucky               3.195952   1.761853   1.814   0.0722 .
#NCAATeamTennessee              4.940449   2.395106   2.063   0.0413 * 
#NCAATeamTexas                  5.002081   2.405568   2.079   0.0397 *
#NCAATeamUtah                   2.302326   1.370729   1.680   0.0956 . 

#I think LSU is thrown off because it has ONLY 1 sample size (Ben Simmons)
#who came from there... nobody else really... Kentucky is more believable...

#NCAATeamLSU                    3.440271   1.964616   1.751   0.0825 .

#Negative effects

#NCAATeamBoise State           -4.530159   2.412409  -1.878   0.0628 . 
#NCAATeamBoston College        -4.143297   2.411597  -1.718   0.0883 . 
#NCAATeamConnecticut           -4.088574   2.368746  -1.726   0.0869 .
#NCAATeamNorth Carolina        -4.057541   1.899841  -2.136   0.0347 * 
#NCAATeamNorth Carolina State  -4.529384   2.405680  -1.883   0.0621 . 
#NCAATeamSyracuse              -4.021042   1.912769  -2.102   0.0376 * 
#NCAATeamUNLV                  -3.964542   1.940288  -2.043   0.0432 * 


#################################################################################
########################################
#################################################################################

main.effects.model3 <-
  
{NBAVORP ~ height + weight + NCAAPRAPM + Conf + NCAATeam}


# fit linear regression model using main effects only (no interaction terms)

main.effects.model3.fit <- lm(main.effects.model3, data=draftedNBA)

print(summary(main.effects.model3.fit)) 

#NBA VORP

#NCAATeamKentucky               3.719780   2.111627   1.762  0.08028 .
#NCAATeamTennessee              7.891730   2.872580   2.747  0.00678 **
#NCAATeamTexas                  6.333703   2.884127   2.196  0.02970 *


#Negative VORP:

#NCAATeamUNLV                  -6.885994   2.328855  -2.957  0.00364 **



#################################################################################
########################################
#################################################################################

main.effects.model4 <-
  
{NBAVORP ~ height + weight + NCAAORB + NCAARPG + NCAABPG + NCAAPPG + NCAAPRAPM + NCAAReb.Min}


# fit linear regression model using main effects only (no interaction terms)

main.effects.model4.fit <- lm(main.effects.model4, data=draftedNBA)

print(summary(main.effects.model4.fit)) 

#NCAABPG      0.630321   0.245474   2.568   0.0109 *


#################################################################################
########################################
#################################################################################
########################################################################################3

topBigprospects <- sqldf('select Player, height, weight, Pick, Conf, NCAATeam, NCAAPRAPM, NCAAORB, NCAARPG, NCAABPG from prospects where NCAAORB>2 and NCAABPG>1.3 order by NCAAORB DESC')
topBigprospects
