#!/usr/bin/env python
# coding: utf-8

# Load the dataset

# In[1]:


from sklearn import datasets


# In[2]:


iris = datasets.load_iris()


# Print the Features

# In[3]:


print(iris.feature_names)


# In[4]:


print(iris.target_names)


# Create the X and Y Variables

# In[5]:


x = iris.data
y = iris.target


# Examine the Data Dimensions

# In[6]:


x.shape, y.shape


# Load the Libraries for PCA Analysis

# In[7]:


from sklearn.preprocessing import scale
from sklearn import decomposition
import pandas as pd


# Scale the Data

# In[8]:


x = scale(x)


# Use 3 PCs

# In[9]:


pca = decomposition.PCA(n_components = 3)
pca.fit(x)


# Compute the Scores

# In[10]:


scores = pca.transform(x)


# In[11]:


scores_df = pd.DataFrame(scores, columns = ['PC1', 'PC2', 'PC3'])
scores_df


# In[12]:


y_label = []

for i in y:
    if i == 0:
        y_label.append('setosa')
    elif i == 1:
        y_label.append('versicolor')
    else:
        y_label.append('virginica')

species = pd.DataFrame(y_label, columns = ['species'])


# In[13]:


df_scores = pd.concat([scores_df, species], axis = 1)
df_scores


# Retrieve the Loadings Values

# In[16]:


loadings = pca.components_.T
df_loadings = pd.DataFrame(loadings, columns = ['PC1', 'PC2', 'PC3'], index = iris.feature_names)
df_loadings


# Explained Variance of Each Variable

# In[15]:


explained_variance = pca.explained_variance_ratio_
explained_variance


# Create the Scree Plot

# In[18]:


import numpy as np
import plotly.express as px


# Prepare the Explained Variance Data

# In[19]:


explained_variance = np.insert(explained_variance, 0, 0)


# Prepare the cumulative Variance Data

# In[20]:


cumulative_variance = np.cumsum(np.round(explained_variance, decimals = 3))


# Combine the Data Frame

# In[21]:


pc_df = pd.DataFrame(['', 'PC1', 'PC2', 'PC3'], columns = ['PC'])
explained_variance_df = pd.DataFrame(explained_variance, columns = ['explained_variance'])
cumulative_variance_df = pd.DataFrame(cumulative_variance, columns = ['cumulative_variance'])


# In[23]:


df_explained_variance = pd.concat([pc_df, explained_variance_df, cumulative_variance_df], axis = 1)
df_explained_variance


# In[27]:


fig = px.bar(df_explained_variance,
            x = 'PC', 
            y = 'explained_variance', 
            text = 'explained_variance', 
            width = 800)

fig.update_traces(texttemplate = '%{text:.3f}', 
                 textposition = 'outside')

fig.show()


# Add the Cumulative Variance

# In[28]:


import plotly.graph_objects as go

fig = go.Figure()

fig.add_trace(
    go.Scatter(
        x = df_explained_variance['PC'], 
        y = df_explained_variance['cumulative_variance'], 
        marker = dict(size = 15, color = 'LightSeaGreen')
    )
)

fig.add_trace(
    go.Bar(
        x = df_explained_variance['PC'], 
        y = df_explained_variance['explained_variance'], 
        marker = dict(color = 'RoyalBlue')
    )
)

fig.show()


# Create the Explained and CUmulative Variance Plots Side by Side

# In[30]:


from plotly.subplots import make_subplots
import plotly.graph_objects as go

fig = make_subplots(rows = 1, cols = 2)

fig.add_trace(
    go.Scatter(
        x = df_explained_variance['PC'], 
        y = df_explained_variance['cumulative_variance'], 
        marker = dict(size = 15, color = 'LightSeaGreen')
    ), row = 1, col = 1
)

fig.add_trace(
    go.Bar(
        x = df_explained_variance['PC'], 
        y = df_explained_variance['explained_variance'], 
        marker = dict(color = 'RoyalBlue')
    ), row = 1, col = 2
)

fig.show()


# Create the Scores Plot

# In[31]:


import plotly.express as px


# Create a 3D Scatter Plot

# In[34]:


fig = px.scatter_3d(df_scores, 
                   x = 'PC1', 
                   y = 'PC2', 
                   z = 'PC3', 
                   color = 'species', 
                   symbol = 'species', 
                   opacity = 0.5)

fig.update_layout(margin = dict(l = 0, 
                               r = 0, 
                               b = 0, 
                               t = 0))


# Create the Loadings Plot

# In[35]:


loadings_label = df_loadings.index

fig = px.scatter_3d(df_loadings, 
                   x = 'PC1', 
                   y = 'PC2', 
                   z = 'PC3', 
                   text = loadings_label)

fig.show()

