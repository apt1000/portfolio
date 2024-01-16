#!/usr/bin/env python
# coding: utf-8

# In[1]:


#Anaconda prompt command to increase data rate limit
#jupyter notebook --NotebookApp.iopub_data_rate_limit=1e10

from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import json

url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
parameters = {
  'start':'1',
  'limit':'15',
  'convert':'USD'
}
headers = {
  'Accepts': 'application/json',
  'X-CMC_PRO_API_KEY': 'xxxxxxxxxxxxxxxxxxx',
}

session = Session()
session.headers.update(headers)

try:
  response = session.get(url, params=parameters)
  data = json.loads(response.text)
  print(data)
except (ConnectionError, Timeout, TooManyRedirects) as e:
  print(e)


# In[2]:


#create data frame
import pandas as pd

df = pd.json_normalize(data['data'])


# In[3]:


#create timestamp column
df['timestamp'] = pd.to_datetime('now', utc = True)


# In[10]:


def get_coin_data():
    
    global df
    
    from requests import Request, Session
    from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
    import json

    url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
    parameters = {
      'start':'1',
      'limit':'15',
      'convert':'USD'
    }
    headers = {
      'Accepts': 'application/json',
      'X-CMC_PRO_API_KEY': '09ad8618-af91-423d-8c31-1d953676ef71',
    }

    session = Session()
    session.headers.update(headers)
    
    #get data from api
    try:
      response = session.get(url, params=parameters)
      data = json.loads(response.text)
        
    except (ConnectionError, Timeout, TooManyRedirects) as e:
      print(e)
    
    #create data frame
    import pandas as pd

    df2 = pd.json_normalize(data['data'])
    
    #create timestamp column
    df2['timestamp'] = pd.to_datetime('now', utc = True)
    
    #write new data to csv file
    if not os.path.isfile(r"\Python\CryptoCaps.csv"): 
        df.to_csv(r"\Python\CryptoCaps.csv", header = 'column_names')
    else:
        df.to_csv(r"\Python\CryptoCaps.csv", header = False, mode = 'a')


# In[13]:


#create automation loop
import os
from time import time
from time import sleep

for i in range(333):
    get_coin_data()
    print('Retrieved Coin Data')
    sleep(60)
exit()


# In[14]:


new_df = pd.read_csv(r"\Python\CryptoCaps.csv")


# In[16]:


pd.set_option('display.float_format', lambda x: '%.5f' % x)
df.info()


# In[76]:


percent_change_df = df.groupby('name', sort = False)[['quote.USD.percent_change_1h', 'quote.USD.percent_change_24h', 'quote.USD.percent_change_7d', 'quote.USD.percent_change_30d', 'quote.USD.percent_change_60d', 'quote.USD.percent_change_90d']].mean()


# In[77]:


percent_change_df = percent_change_df.stack()
percent_change_df = percent_change_df.to_frame(name = 'percent')


# In[78]:


percent_change_df.reset_index(inplace = True)
percent_change_df


# In[79]:


percent_change_df = percent_change_df.rename(columns = {'level_1' : 'timeframe', '0' : 'percent'})
percent_change_df.head()


# In[83]:


#plot percent changes over time for top 15 market cap coins
import matplotlib.pyplot as plt
import seaborn as sns

plot = sns.catplot(data = percent_change_df, x = 'timeframe', y = 'percent', hue = 'name', kind = 'point')
plt.xticks(rotation = 90)
plot.set_xticklabels(['1h', '24h', '7d', '30d', '60d', '90d'])
plt.show()


# In[85]:


bitcoin_price_df = df[df['name'] == 'Bitcoin'][['quote.USD.price', 'timestamp']]
bitcoin_price_df


# In[88]:


#plot price of bitcoin over time
sns.set_theme(style = 'darkgrid')
plot = sns.lineplot(bitcoin_price_df, x = 'timestamp', y = 'quote.USD.price')
plt.xticks(rotation = 90)
plt.show()


# In[ ]:




