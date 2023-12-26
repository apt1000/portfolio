#!/usr/bin/env python
# coding: utf-8

# Load the Diabetes Dataset

# In[1]:


from sklearn import datasets


# In[2]:


diabetes = datasets.load_diabetes()


# In[3]:


diabetes


# In[4]:


print(diabetes.DESCR)


# In[5]:


print(diabetes.feature_names)


# Create x and y

# In[6]:


x = diabetes.data
y = diabetes.target


# In[7]:


x.shape, y.shape


# Create Training and Testing Sets

# In[8]:


from sklearn.model_selection import train_test_split


# In[9]:


x_train, x_test, y_train, y_test = train_test_split(x, y, test_size = 0.2)


# In[10]:


x_train.shape, y_train.shape


# In[11]:


x_test.shape, y_test.shape


# Create the Linear Regression Model

# In[12]:


from sklearn import linear_model
from sklearn.metrics import mean_squared_error, r2_score


# In[13]:


model = linear_model.LinearRegression()


# In[14]:


model.fit(x_train, y_train)


# Use the Model to Create Predictions on the Testing Set

# In[15]:


y_pred = model.predict(x_test)


# Print Model Performance

# In[16]:


print('Coefficients: ', model.coef_)
print('Intercept: ', model.intercept_)
print('Mean Squared Error: %.2f' % mean_squared_error(y_test, y_pred))
print('Coefficient of Determination: %.2f' % r2_score(y_test, y_pred))


# Create the Scatter Plots

# In[17]:


import seaborn as sns


# In[18]:


import numpy as np


# In[19]:


np.array(y_test)


# In[20]:


sns.scatterplot(x = y_test, y = y_pred, marker = '+', alpha = 0.5)


# Load the Boston Housing Data

# In[21]:


import pandas as pd


# In[22]:


BostonHousing = pd.read_csv("BostonHousing.csv")
BostonHousing


# Create x and y variables

# In[23]:


x = BostonHousing.drop(['medv'], axis = 1)
y = BostonHousing['medv']


# Create the Training and Testing Sets

# In[24]:


x_train, x_test, y_train, y_test = train_test_split(x, y, test_size = 0.2)


# In[25]:


x_train.shape, y_train.shape


# In[26]:


x_test.shape, y_test.shape


# Create the Model

# In[27]:


model = linear_model.LinearRegression()


# In[28]:


model.fit(x_train, y_train)


# Use Model to Make Predictions on Testing Set

# In[29]:


y_pred = model.predict(x_test)


# Print Model Performance

# In[30]:


print('Coefficients: ', model.coef_)
print('Intercept: ', model.intercept_)
print('Mean squared error: %.2f' % mean_squared_error(y_test, y_pred))
print('Coefficient of Determination: %.2f' % r2_score(y_test, y_pred))


# Create the Scatter Plot

# In[31]:


sns.scatterplot(x = y_test, y = y_pred, marker = '+', alpha = 0.5)

