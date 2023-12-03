#!/usr/bin/env python
# coding: utf-8

# In[143]:


#import needed packages
import pandas as pd
import os
import matplotlib.pyplot as plt
import seaborn as sns
import calendar
import numpy as np


# In[144]:


#Merge 12 months of sales data into single file
files = [file for file in os.listdir('./Sales')]

print(files)

df = pd.concat((pd.read_csv(r'./Sales/' + file) for file in files), ignore_index = True)


# In[145]:


#inspect the data frame
df.info()

df.head()


# In[146]:


#drop rows with null values and set index
df.dropna(axis = 0, inplace = True)

df.head()


# In[147]:


#drop rows with column headers as values
df.drop(df.index[df['Order ID'] == 'Order ID'], axis = 0, inplace = True)


# In[148]:


#convert columns to desired data types
df[['Quantity Ordered', 'Price Each']] = df[['Quantity Ordered', 'Price Each']].apply(pd.to_numeric)

df['Order Date'] = pd.to_datetime(df['Order Date'], format = '%m/%d/%y %H:%M')

df.info()


# In[149]:


#Find the month with the highest sales
df['sale_amount'] = df['Quantity Ordered'] * df['Price Each']

monthly_sales = df.groupby(df['Order Date'].dt.month)['sale_amount'].sum().reset_index().set_index('Order Date')

monthly_sales.index = pd.to_datetime(monthly_sales.index, format='%m').month_name().str[:3]

monthly_sales.sort_values(by = 'sale_amount', ascending = False)


# In[150]:


# plot the monthly sales
monthly_sales_plot = plt.bar(monthly_sales.index, monthly_sales['sale_amount'])
plt.xticks(monthly_sales.index)
plt.xlabel('Month')
plt.ylabel('Sales (in 10M USD)')
plt.title('Sales Per Month')
plt.show()


# In[151]:


#create columns for elements of address
df['zip_code'] = df['Purchase Address'].str.split(' ').str[-1].str.strip()
df['state'] = df['Purchase Address'].str.split(' ').str[-2].str.strip()
df['city'] = df['Purchase Address'].str.split(',').str[-2].str.strip() + ', ' + df['state']
df.head()


# In[152]:


#What city had the highest numebr of sales
city_sales = df.groupby('city')['sale_amount'].sum().reset_index().sort_values(by = 'sale_amount', ascending = False)
city_sales


# In[153]:


#plot the city sales
city_plot = sns.catplot(city_sales, y = 'city', x = 'sale_amount', kind = 'bar', height = 5, aspect = 1.5)
city_plot.set_axis_labels(x_var = 'Sales (1M USD)', y_var = 'City')
city_plot.fig.suptitle('Sales Per City', y = 1)

plt.show()


# In[154]:


#When should we advertise to maximize sales?
hour_data = df.groupby(df['Order Date'].dt.hour)['sale_amount'].sum().reset_index().rename(columns = {'Order Date':'hour', 'sale_amount':'total_sales'})
hour_data


# In[164]:


hour_plot = sns.relplot(data = hour_data, x = 'hour', y = 'total_sales', kind = 'line', aspect = 1.5)
plt.xticks(np.arange(0, 24))
hour_plot.set_xticklabels([12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], size = 10)
hour_plot.set_yticklabels([0, .5, 1, 1.5, 2, 2.5, 3], size = 10)
hour_plot.set_axis_labels(x_var = 'Hour', y_var = 'Sales in 1M USD')
plt.show()


# In[156]:


#What products are most often sold together?
grouped_products = df[['Order ID', 'Product']].merge(df[['Order ID', 'Product']], on = 'Order ID')
grouped_products.drop(grouped_products.index[grouped_products['Product_x'] == grouped_products['Product_y']], axis = 0, inplace = True)
grouped_products.drop_duplicates(subset = 'Order ID', inplace = True)
grouped_counts = grouped_products.groupby(['Product_x', 'Product_y']).count().rename(columns = {'Order ID':'order_counts'})
grouped_counts = grouped_counts.sort_values(by = 'order_counts', ascending = False).drop_duplicates().reset_index()
grouped_counts.head()


# In[157]:


#Prepare grouped_counts for heatmap
grouped_counts = grouped_counts.pivot_table(index = 'Product_x', columns = 'Product_y', values = 'order_counts').fillna(0)


# In[158]:


#plot the product combinations
grouped_product_plot = sns.heatmap(grouped_counts, cmap = 'flare')
plt.show()


# In[159]:


#What product sold the most?
product_counts = df.groupby(df['Product'])['Quantity Ordered'].count().reset_index().sort_values(by = 'Quantity Ordered', ascending = False)
product_counts.head()


# In[167]:


#find the average price of each product
avg_price = df.groupby('Product')['Price Each'].mean().reset_index()
avg_price


# In[200]:


#plot the products ordered
products_plot = sns.catplot(price_quantity, 
                            y = 'Product', 
                            x = 'Quantity Ordered', 
                            kind = 'bar', 
                           aspect = 1.5)
products_plot.set_yticklabels()
products_plot.set(title = 'Most Popular Products Ordered')
plt.show()


# In[199]:


#combine price and quanity dfs
price_quantity = avg_price.merge(product_counts, on = 'Product').sort_values(by = 'Quantity Ordered', ascending = False)
price_quantity.head()


# In[205]:


#plot the relation between unit price and quantity ordered
price_quantity_plot = sns.relplot(price_quantity, x = 'Price Each', y = 'Quantity Ordered')
plt.show()


# In[ ]:




