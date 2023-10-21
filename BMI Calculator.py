#!/usr/bin/env python
# coding: utf-8

# In[1]:


weight = input('Enter your weight in pounds: ')


# In[2]:


print(weight)


# In[3]:


height = input('Enter your hight in inches: ')


# In[4]:


print(weight)


# In[5]:


BMI = (int(weight) * 703) / (int(height)**2)
print(BMI)


# In[6]:


if(0 < BMI < 18.5):
    print('Underweight')
elif(BMI < 25):
    print('Normal Range')
elif(BMI < 30):
    print('Overweight')
elif(BMI < 35):
    print('Obese')
elif(BMI < 40):
    print('Severely Obese')
elif(BMI >= 40):
    print('Morbidly Obese')
else:
    print('Enter Valid Inputs')


# In[ ]:




