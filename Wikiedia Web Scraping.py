#!/usr/bin/env python
# coding: utf-8

# In[1]:


#import libraries

from bs4 import BeautifulSoup
import requests
import pandas as pd
import csv
import datetime
import time


# In[2]:


#Connect to webiste

url = "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"

headers = {'User-Agent' : "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/119.0"}

page = requests.get(url, headers = headers)

soup1 = BeautifulSoup(page.content, "html.parser")

soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

#Page Title
title = soup2.find(id = 'firstHeading').get_text().strip()

title


# In[3]:


#Select the first table
table = soup2.find('table')

#Select the headers for the table
headers = table.find_all('th')
headers = [header.text.strip().replace('GICS\n              \n              Sector', 'GICS Sector') for header in headers]
headers


# In[4]:


#Create the data frame
df = pd.DataFrame()


# In[5]:


#Select the table data and insert into data frame
rows = table.find_all('tr')
for row in rows:
    row_data = row.find_all('td')
    row_text = pd.DataFrame([data.text.strip() for data in row_data]).transpose()
    df = pd.concat([df, row_text], ignore_index = True)
        
df.columns = headers
df.head()


# In[6]:


#set the unique index
df = df.set_index('CIK')
df.head()


# In[7]:


#Format the date columns
df['Date added'] = pd.to_datetime(df['Date added'], errors = 'coerce')

df['Founded'] = df['Founded'].str.split('(').str[0].str.split('/').str[0].astype('int')

df.head()


# In[8]:


#import libriaries for plotting
import matplotlib.pyplot as plt
import seaborn as sns


# In[9]:


#counting the number of campanies per sector
#create seaborn countplot
plt.style.use('fivethirtyeight')
plot = sns.countplot(data=df, 
                     y='GICS Sector', 
                     order = df['GICS Sector'].value_counts(ascending = False).index)
plot.set_title('Count of Companies by Sector')

plt.show()


# In[10]:


plt.figure(figsize = (12,6))
year_added_counts = df.groupby(df['Date added'].dt.year)['Symbol'].count()
year_added_counts = pd.DataFrame({'year' : year_added_counts.index, 'count' : year_added_counts.values})
year_added_counts['year'] = year_added_counts['year'].astype('int')
chart = sns.barplot(year_added_counts, x = 'year', y = 'count')
chart.set_xticklabels(chart.get_xticklabels(), rotation=90)
plt.show()


# In[11]:


#Create timestamp
today = datetime.date.today()

print(today)


# In[12]:


#Export table into csv file
filename = title + '.csv'
df.to_csv(filename)


# In[13]:


#Read csv from file
df = pd.read_csv(filename, index_col = 'CIK')
df.head()


# In[14]:


def count_industries(): 
    #import libraries

    from bs4 import BeautifulSoup
    import requests
    import pandas as pd
    import csv
    import datetime
    import matplotlib.pyplot as plt
    import seaborn as sns
    
    #Connect to webiste

    url = "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"

    headers = {'User-Agent' : "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/119.0"}

    page = requests.get(url, headers = headers)

    soup1 = BeautifulSoup(page.content, "html.parser")

    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

    #Page Title
    title = soup2.find(id = 'firstHeading').get_text().strip()

    title
    
    #Select the first table
    table = soup2.find('table')

    #Select the headers for the table
    headers = table.find_all('th')
    headers = [header.text.strip().replace('GICS\n              \n              Sector', 'GICS Sector') for header in headers]
    headers
    
    #Create the data frame
    df = pd.DataFrame()
    
    #Select the table data and insert into data frame
    rows = table.find_all('tr')
    for row in rows:
        row_data = row.find_all('td')
        row_text = pd.DataFrame([data.text.strip() for data in row_data]).transpose()
        df = pd.concat([df, row_text], ignore_index = True)

    df.columns = headers
    df.head()
    
    #set the unique index
    df = df.set_index('CIK')
    df.head()
    
    #Format the date columns
    df['Date added'] = pd.to_datetime(df['Date added'], errors = 'coerce')

    df['Founded'] = df['Founded'].str.split('(').str[0].str.split('/').str[0].astype('int')

    df.head()
    
    #counting the number of campanies per sector
    #create seaborn countplot
    plt.style.use('fivethirtyeight')
    plot = sns.countplot(data=df, 
                         y='GICS Sector', 
                         order = df['GICS Sector'].value_counts(ascending = False).index)
    plot.set_title('Count of Companies by Sector')
    
    plot_file_name = title + '.pdf'

    plt.savefig(plot_file_name, bbox_inches = 'tight')
    
    #Export table into csv file
    table_file_name = title + '.csv'
    df.to_csv(table_file_name)


# In[15]:


while(True):
    count_industries()
    time.sleep(31449600)


# In[17]:


#Read csv
df = pd.read_csv(filename)
df.head()


# In[ ]:




