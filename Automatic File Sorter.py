#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os, shutil


# In[2]:


path = r'C:/Users/Austin/Documents/Website/Projects/Python/'


# In[3]:


file_names = os.listdir(path)


# In[4]:


os.listdir(path)


# In[5]:


folder_names = ['html files', 'python notebook files', 'python files']
for loop in range(0, len(folder_names)):
    if not os.path.exists(path + folder_names[loop]):
        os.makedirs(path + folder_names[loop])


# In[6]:


for file in file_names:
    if '.py' in file and not os.path.exists(path + '/python files' + file):
        shutil.move(path + file, path + 'python files/' + file)
    elif '.ipynb' in file and not os.path.exists(path + '/python notebook files' + file):
        shutil.move(path + file, path + 'python notebook files/' + file)
    if '.html' in file and not os.path.exists(path + '/html files' + file):
        shutil.move(path + file, path + 'html files/' + file)

