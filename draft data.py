
# coding: utf-8

# In[1]:


import pandas as pd  # data frame operations  
import numpy as np  # arrays and math functions

# To plot pretty figures
get_ipython().run_line_magic('matplotlib', 'inline')
import matplotlib
import matplotlib.pyplot as plt
plt.rcParams['axes.labelsize'] = 14
plt.rcParams['xtick.labelsize'] = 12
plt.rcParams['ytick.labelsize'] = 12

import seaborn as sns  # pretty plotting


# In[2]:

#Data comes from:
#https://www.sports-reference.com/cbb/
#and
#https://www.basketball-reference.com/

#I combined past years NCAA data with current NBA player data for each player/record

draft_prospects = pd.read_csv('NBA Draft Prospect Data Final.csv')

for col in draft_prospects:
    if 'Unnamed' in col:
        del draft_prospects[col]


# In[3]:


draft_prospects.shape


# In[4]:


pdata = draft_prospects.dropna(axis=0, how="all")

pdata


# In[5]:


pdata.info()


# In[6]:


#player draft data from 2015 - 2019
#NBAWS = NBA Win Shares is an important value to look at...
#or NBAWS48 = NBA Win Shares per 48 minutes

#players have different WS because of different # of years in the league
#let's make a column NBAWS/yr ... where we divide NBAWS / Tenure

pdata['NBAWS/Tenure'] = pdata['NBAWS']/pdata['Tenure']

pdata['NcaaP.R.A.'] = pdata['NCAAPPG']+pdata['NCAARPG']+pdata['NCAAAPG']


# In[7]:


pdata['NcaaP.R.A.PM'] = pdata['NcaaP.R.A.']/pdata['NCAAMPG']


# In[8]:


pdata


# In[9]:


#visualize/explore different things like players per round (1st vs. 2nd), first 10 picks...etc.


# In[10]:


pdata.boxplot(column='NBAWS/Tenure')


# In[11]:


pdata.hist(column='NBAWS/Tenure')

#average Win share of all players is around 1 or 2 per year...


# In[12]:


college_players_data = pdata.drop(['NBAWS', 'NBAVORP', 'NBATRB', 'NBAPTot', 'NBAMPTot', 'NBABPM',
                                  'NBAWS48', 'NBAGames', 'NBATAST', 'NBAFG%', 'Tenure', 'NBAFT%',
                                  'NBA3P%'], axis=1)

c_data = college_players_data


# In[13]:


corr_matrix_1 = c_data.corr()

corr_matrix_1['NBAWS/Tenure'].sort_values(ascending=False)


# In[15]:


#interesting, NCAAORB leads to showing best NBA Win shares.. they put in most effort/dominate the boards...

c_data['Reb/Min'] = (c_data['NCAARPG'] / c_data['NCAAMPG']) * c_data['height']
#eh...



corr_matrix_1 = c_data.corr()

corr_matrix_1['NBAWS/Tenure'].sort_values(ascending=False)


# In[16]:


college_players_data = pdata.drop(['NBAWS', 'NBAVORP', 'NBATRB', 'NBAPTot', 'NBAMPTot', 'NBABPM',
                                  'NBAWS/Tenure', 'NBAGames', 'NBATAST', 'NBAFG%', 'Tenure', 'NBAFT%',
                                  'NBA3P%'], axis=1)

c_data_2 = college_players_data


# In[17]:


corr_matrix_2 = c_data_2.corr()

corr_matrix_2['NBAWS48'].sort_values(ascending=False)


# In[18]:


c_data = c_data.drop(['NCAAFT%', 'NCAAFGA', 'NCAAFGM', 'ID', 'NCAASPG', 'NCAAAPG', 'NCAAMPG', 'NCAASInj', 'Year', 'Round', 'Pick', 'NCAAPos', 'NCAAGP'], axis=1)


# In[97]:


# correlation heat map setup for seaborn
def corr_chart(df_corr):
    corr=df_corr.corr()
    #screen top half to get a triangle
    top = np.zeros_like(corr, dtype=np.bool)
    top[np.triu_indices_from(top)] = True
    fig=plt.figure()
    fig, ax = plt.subplots(figsize=(18,18))
    sns.heatmap(corr, mask=top, cmap='coolwarm', 
        center = 0, square=True, 
        linewidths=.5, cbar_kws={'shrink':.5}, 
        annot = True, annot_kws={'size': 9}, fmt = '.3f')           
    plt.xticks(rotation=45) # rotate variable labels on columns (x axis)
    plt.yticks(rotation=0) # use horizontal variable labels on rows (y axis)
    plt.title('Correlation Heat Map for Future NBA Success (WS/Tenure)')   
    plt.savefig('plot-corr-map-WS.Tenure.pdf', 
        bbox_inches = 'tight', dpi=None, facecolor='w', edgecolor='b', 
        orientation='portrait', papertype=None, format=None, 
        transparent=True, pad_inches=0.25, frameon=None)      

np.set_printoptions(precision=3)


# In[98]:


corr_chart(df_corr = c_data) 

plt.savefig('corr_chart_WS.Tenure.png', dpi=1000, facecolor='w', edgecolor='w',
        orientation='portrait', papertype=None, format=None,
        transparent=False, bbox_inches=None, pad_inches=0.1,
        frameon=None, metadata=None)


# In[99]:


#so, HEIGHT is correlated with NBA Win Shares/Tenure...:

#Height - 0.236
#Weight - 0.233
#NCAAORB - 0.246  ***
#NCAARPG - 0.221
#NCAABPG - 0.215

#Bigger players are valued most / get biggest Win share in the league...


# In[100]:


c_data_vorp = pdata.drop(['NBAWS', 'NBATRB', 'NBAPTot', 'NBAMPTot', 'NBABPM',
                          'NBAWS/Tenure', 'NBAGames', 'NBATAST', 'NBAFG%', 'Tenure', 'NBAFT%',
                          'NBA3P%', 
                          'NCAAFT%', 'NCAAFGA', 'NCAAFGM', 'ID', 'NCAASPG', 'NCAAAPG', 'NCAAMPG',
                          'NCAASInj', 'Year', 'Round', 'Pick', 'NCAAPos', 'NCAAGP'], axis=1)


# In[101]:


# correlation heat map setup for seaborn
def corr_chart(df_corr):
    corr=df_corr.corr()
    #screen top half to get a triangle
    top = np.zeros_like(corr, dtype=np.bool)
    top[np.triu_indices_from(top)] = True
    fig=plt.figure()
    fig, ax = plt.subplots(figsize=(18,18))
    sns.heatmap(corr, mask=top, cmap='coolwarm', 
        center = 0, square=True, 
        linewidths=.5, cbar_kws={'shrink':.5}, 
        annot = True, annot_kws={'size': 9}, fmt = '.3f')           
    plt.xticks(rotation=45) # rotate variable labels on columns (x axis)
    plt.yticks(rotation=0) # use horizontal variable labels on rows (y axis)
    plt.title('Correlation Heat Map for Future NBA Success (VORP)')   
    plt.savefig('plot-corr-map-VORP.pdf', 
        bbox_inches = 'tight', dpi=None, facecolor='w', edgecolor='b', 
        orientation='portrait', papertype=None, format=None, 
        transparent=True, pad_inches=0.25, frameon=None)      

np.set_printoptions(precision=3)


# In[102]:


corr_chart(df_corr = c_data_vorp) 

plt.savefig('corr_chart_vorp.png', dpi=1000, facecolor='w', edgecolor='w',
        orientation='portrait', papertype=None, format=None,
        transparent=False, bbox_inches=None, pad_inches=0.1,
        frameon=None, metadata=None)


# In[ ]:


#Future performance NBA Win Shares per 48 minutes:

#Weight - 0.258
#NCAAORB - 0.261
#NCAABPG - 0.270 ****
#NCAARPG - 0.257

#AllRegion - 0.066
#NCAATournExp - 0.153

#Future performance indicator of VORP:

#NCAABPG - 0.283   *****
#NCAARPG - 0.218
#NCAAORB - 0.215
#Height - 0.190
#Weight - 0.192

#Also, NCAAFG% - 0.146
    #AllRegion - 0.135
# NCAATournExp.- 0.112


# In[ ]:


#############################################################################################################################


# In[21]:


#What do NBA coaches/scouts/decision-makers see in players?? Let's look at draft order. (picks)

draft_order_1 = pdata.drop(['NBAWS', 'NBAVORP', 'NBATRB', 'NBAPTot', 'NBAMPTot', 'NBABPM',
                                  'NBAWS/Tenure', 'NBAGames', 'NBATAST', 'NBAFG%', 'Tenure', 'NBAFT%',
                                  'NBA3P%', 'Round', 'Year'], axis=1)

corr_matrix_10 = draft_order_1.corr()

corr_matrix_10['Pick'].sort_values(ascending=False)


# In[ ]:


#NBA Draft order ***(Picks 1-60)***

#read these correlations as the opposite... Higher picks are lower numbers (top 10 Picks are best players)

#top 10 players are correlated with YrsNCAA, they have a LOW # of years in the NCAA, usually Freshman enter
#NBA draft early

#then ALL other variables are - negatively correlated, meaning that "As Pick goes down (5, 4, 3, 2, 1),
#then that variable (NcaaP.R.A.PM) goes up... "

#BEST correlation is with Ncaa P.R.A. PM (-0.218896)

#Next high is NCAATournExp (-0.215736)


# In[24]:


draft_order_2 = pdata.drop(['NBAWS', 'NBAVORP', 'NBATRB', 'NBAPTot', 'NBAMPTot',
                                  'NBAGames', 'NBATAST', 'NBAFG%', 'Tenure', 'NBAFT%',
                                  'NBA3P%', 'Round', 'Year'], axis=1)

corr_matrix_11 = draft_order_2.corr()

corr_matrix_11['NBABPM'].sort_values(ascending=False)


# In[ ]:


#NBA BPM has weakest correlations with NCAA data...

#Best is neg. correl with NCAA 3PA (-0.1573), 3PM (-0.145961), FGA (-0.137), YrsNCAA (-0.1256), then Height (+0.122181)


# In[26]:


draft_order_3 = pdata.drop(['NBAWS', 'NBATRB', 'NBAPTot', 'NBAMPTot', 'NBABPM',
                                  'NBAGames', 'NBAWS/Tenure', 'NBAWS48', 'NBATAST', 'NBAFG%', 'Tenure', 'NBAFT%',
                                  'NBA3P%', 'Round', 'Year'], axis=1)

corr_matrix_12 = draft_order_3.corr()

corr_matrix_12['NBAVORP'].sort_values(ascending=False)


# In[ ]:


#BIGGEST/strongest correlation to ***NBAVORP*** is NCAA BPG (0.283184), then RPG (0.218311), 
#ORB, and DRB, Weight, Height, P.R.A. PM....

