#!/usr/bin/env python
# coding: utf-8

# In[1]:


from bs4 import BeautifulSoup
import requests


# In[2]:


url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_by_revenue'
page = requests.get(url)
soup = BeautifulSoup(page.text, 'html')


# In[3]:


table = soup.find_all('table')[0]
table


# In[4]:


world_titles = table.find_all('th', scope = "col")
world_titles


# In[5]:


world_table_titles = [title.text.strip() for title in world_titles][1:-1]
world_table_titles


# In[6]:


import pandas as pd


# In[7]:


df = pd.DataFrame(columns = world_table_titles)
df


# In[8]:


column_data = table.find_all('tr')


# In[9]:


for row in column_data[2:]:
    row_data = row.find_all('td')
    indv_row_data = [data.text.strip() for data in row_data]

    length = len(df)
    df.loc[length] = indv_row_data
    
df.head()


# In[10]:


df = df.drop(['Ref.', 'State-owned'], axis = 1)


# In[15]:


df = df.rename(columns = {'Revenue':'Revenue(Mil USD)', 'Profit':'Profit(Mil USD)', 'Headquarters[note 1]':'Headquarters'})
df


# In[17]:


df.to_csv(r'C:\Users\Austin\Documents\Website\Projects\Python\Companies.csv', index = False)

