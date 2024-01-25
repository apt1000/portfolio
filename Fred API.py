#!/usr/bin/env python
# coding: utf-8

# !pip install fredapi > /dev/null

# In[16]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import plotly.express as px

plt.style.use('fivethirtyeight')
pd.set_option('display.max_columns', 500)
color_pal = plt.rcParams['axes.prop_cycle'].by_key()['color']


# Create the Fred object with the API key

# In[18]:


from full_fred.fred import Fred

fred = Fred(r"fredAPIkey.txt")

fred.get_api_key_file()


# Retrieve the SP 500 data

# In[56]:


sp500 = fred.get_series_df(series_id = 'SP500')
sp500.head(), sp500.info()


# Convert the columns to the correct data type and drop rows with incomplete data

# In[59]:


sp500[['realtime_start', 'realtime_end', 'date']] = sp500[['realtime_start', 'realtime_end', 'date']].apply(pd.to_datetime)
sp500 = sp500[sp500.value != '.']
sp500['value'] = sp500['value'].astype('float')
sp500.info()


# Plot the Data

# In[60]:


sp500.plot(x = 'date', 
           y = 'value', 
           figsize = (10, 5), 
          title = 'SP 500', 
          lw = 2)


# Pul the Unemployement Rate data

# In[73]:


unrate = fred.get_series_df('UNRATE')
unrate.info(), unrate.head()


# In[74]:


unrate[['realtime_start', 'realtime_end', 'date']] = unrate[['realtime_start', 'realtime_end', 'date']].apply(pd.to_datetime)
unrate['value'] = unrate['value'].astype('float')
unrate.info()


# Plot the Unemployment Rate

# In[78]:


unrate.plot(x = 'date', 
           y = 'value')


# In[117]:


fig, ax = plt.subplots()

ax2 = ax.twinx()

ax.plot(sp500['date'], 
          sp500['value'],  
          label = 'SP 500')

ax2.plot(unrate[unrate.date.dt.year > 2014]['date'], 
           unrate[unrate.date.dt.year > 2014]['value'], 
           label = 'Unemployment', 
            color = color_pal[1])

