#!/usr/bin/env python
# coding: utf-8

# In[2]:


import requests
import pandas as pd

def display_equipment_table():
    """
    Fetches equipment data from the API and displays it as a table.
    """
    url = 'https://wger.de/api/v2/equipment/'
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raises an HTTPError if the HTTP request returned an unsuccessful status code

        data = response.json()
        equipment_list = data['results']
        equipment_data = [{'Equipment Name': equipment['name'], 'Equipment ID': equipment['id']} for equipment in equipment_list]
        
        df = pd.DataFrame(equipment_data)
        df.sort_values(by='Equipment ID', ascending=True, inplace=True)
        df.reset_index(drop=True, inplace=True)
        
        print(df[['Equipment Name', 'Equipment ID']])
    except requests.RequestException as e:
        print(f"Failed to fetch data from the API: {e}")

# Example usage
# display_equipment_table()
display_equipment_table()


# In[ ]:




