#!/usr/bin/env python
# coding: utf-8

# In[6]:


import pandas as pd

def display_muscle_table():
    """
    Display a table of muscle IDs, names, and English names using pandas.

    This function retrieves muscle data, sorts it by ID, and prints a table of
    muscle information.

    Example:
        display_muscle_table()

    Returns:
        None
    """
    muscles_data = [
        {"id": 2, "name": "Anterior deltoid", "name_en": "Shoulders"},
        {"id": 1, "name": "Biceps brachii", "name_en": "Biceps"},
        {"id": 11, "name": "Biceps femoris", "name_en": "Hamstrings"},
        {"id": 13, "name": "Brachialis", "name_en": "Arm"},
        {"id": 7, "name": "Gastrocnemius", "name_en": "Calves"},
        {"id": 8, "name": "Gluteus maximus", "name_en": "Glutes"},
        {"id": 12, "name": "Latissimus dorsi", "name_en": "Lats"},
        {"id": 14, "name": "Obliquus externus abdominis", "name_en": "Abs"},
        {"id": 4, "name": "Pectoralis major", "name_en": "Chest"},
        {"id": 10, "name": "Quadriceps femoris", "name_en": "Quads"},
        {"id": 6, "name": "Rectus abdominis", "name_en": "Abs"},
        {"id": 3, "name": "Serratus anterior", "name_en": "Chest"},
        {"id": 15, "name": "Soleus", "name_en": "Ankle"},
        {"id": 9, "name": "Trapezius", "name_en": "Back"},
        {"id": 5, "name": "Triceps brachii", "name_en": "Triceps"}
    ]


    # Create a DataFrame from the data
    df = pd.DataFrame(muscles_data)

    # Sort the DataFrame by 'id' in ascending order
    df = df.sort_values(by='id', ascending=True)

    # Display the 'id', 'name', and 'name_en' columns without the index column
    print(df[['id', 'name', 'name_en']].to_string(index=False))


# In[7]:


display_muscle_table()


# In[ ]:




