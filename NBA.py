#!/usr/bin/env python
# coding: utf-8

# In[1]:


#program to obtain multiple years of data from site
years = [2019, 2020, 2021, 2022, 2023]
url = "https://www.basketball-reference.com/leagues/NBA_{}_per_game.html"

for year in years : 
    url_link = url.format(year)
    print(url_link)


# In[2]:


import pandas as pd


# In[3]:


#scrape data from url into pandas data frame
df = pd.read_html(url_link, header = 0)[0]
df.head(25)


# In[4]:


#drop rows with headers and reset the index
df.drop(df[df.Age == 'Age'].index, inplace = True)
df.reset_index()
df.head(25)


# In[5]:


#change data type of numeric columns
df[['Age', 'G', 'GS', 'MP', 'FG', 'FGA', 'FG%', '3P', '3PA', '3P%', '2P', '2PA', '2P%', 'eFG%', 'FT', 'FTA', 'FT%', 'ORB', 'DRB', 'TRB', 'AST', 'STL', 'BLK', 'TOV', 'PF', 'PTS']] = df[['Age', 'G', 'GS', 'MP', 'FG', 'FGA', 'FG%', '3P', '3PA', '3P%', '2P', '2PA', '2P%', 'eFG%', 'FT', 'FTA', 'FT%', 'ORB', 'DRB', 'TRB', 'AST', 'STL', 'BLK', 'TOV', 'PF', 'PTS']].apply(pd.to_numeric, errors = 'coerce')
df.dtypes


# In[6]:


import seaborn as sns


# In[7]:


# plot the distribution of points
sns.distplot(df.PTS, 
             kde = False, 
            hist_kws = dict(edgecolor = 'black', 
                           linewidth = 2), 
            color = '#00BFC4')


# In[8]:


#style data frame fonts and colors using CSS
df.head(25).style.set_table_styles(
[{'selector' : 'th', 
     'props' : [('background', '#7CAE00'), 
               ('color', 'white'), 
               ('font-family', 'verdana')]}, 
{'selector' : 'td', 
    'props' : [('font-family', 'verdana')]}, 
{'selector' : 'tr:nth-of-type(odd)', 
    'props' : [('background', '#DCDCDC')]}, 
{'selector' : 'tr:nth-of-type(even)', 
    'props' : [('background', 'white')]},
{'selector' : 'tr:hover', 
    'props' : [('background-color', 'yellow')]}
]
)


# In[9]:


#color point totals by given ranges
def color_red(val) : 
    if val > 20 : 
        color = 'green'
    elif val > 5 : 
        color = 'red'
    else : 
        color = 'black'
    return 'color: %s' % color
df[['PTS']].head(25).style.applymap(color_red)

