#!/usr/bin/env python
# coding: utf-8

# In[6]:


import unittest
import requests
import pandas as pd
from display_equipment_table import display_equipment_table  

class TestDisplayEquipmentTable(unittest.TestCase):

    def test_api_response(self):
        """
        Test that the API request returns a successful response.
        """
        url = 'https://wger.de/api/v2/equipment/'
        response = requests.get(url)
        self.assertEqual(response.status_code, 200)

    def test_data_format(self):
        """
        Test that the data from the API is formatted correctly.
        """
        url = 'https://wger.de/api/v2/equipment/'
        response = requests.get(url)
        data = response.json()
        equipment_list = data['results']
        equipment_data = [{'Equipment Name': equipment['name'], 'Equipment ID': equipment['id']} for equipment in equipment_list]
        
        df = pd.DataFrame(equipment_data)
        df.sort_values(by='Equipment ID', ascending=True, inplace=True)
        df.reset_index(drop=True, inplace=True)

        # Check if the DataFrame has the expected columns
        self.assertIn('Equipment Name', df.columns)
        self.assertIn('Equipment ID', df.columns)

        # Additional checks can be performed here, such as data types, number of rows, etc.

if __name__ == '__main__':
    unittest.main()


# In[ ]:




