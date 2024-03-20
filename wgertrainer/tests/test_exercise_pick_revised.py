#!/usr/bin/env python
# coding: utf-8

# In[1]:


import unittest
from exercise_pick_revised import fetch_all_exercises, find_exercises_by_muscle, find_exercises_by_equipment, find_best_exercise
import pandas as pd

class TestExercisePickRevised(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        # This method will run once before all tests
        all_exercises = fetch_all_exercises()
        cls.exercise_df = pd.DataFrame(all_exercises)

    def test_fetch_all_exercises(self):
        # Test to ensure fetch_all_exercises returns a non-empty list of dictionaries
        self.assertIsInstance(fetch_all_exercises(), list)
        self.assertGreater(len(fetch_all_exercises()), 0)

    def test_find_exercises_by_muscle(self):
        # Test to ensure find_exercises_by_muscle returns correct results
        muscle_id = 2  # Example muscle ID
        result = find_exercises_by_muscle(self.exercise_df, muscle_id)
        self.assertIsInstance(result, pd.DataFrame)
        self.assertFalse(result.empty)
        # Further checks can be added to ensure the result contains exercises for the specified muscle

    def test_find_exercises_by_equipment(self):
        # Test to ensure find_exercises_by_equipment returns correct results
        equipment_id = 3  # Example equipment ID
        result = find_exercises_by_equipment(self.exercise_df, equipment_id)
        self.assertIsInstance(result, pd.DataFrame)
        self.assertFalse(result.empty)
        # Further checks to ensure the result contains exercises with the specified equipment

    def test_find_best_exercise(self):
        # Test to ensure find_best_exercise returns correct results
        muscle_id = 2
        equipment_id = 3
        result = find_best_exercise(self.exercise_df, equipment_id, muscle_id)
        self.assertIsInstance(result, pd.DataFrame)
        self.assertFalse(result.empty)
        # Further checks to ensure the result contains exercises with the specified equipment and muscle

if __name__ == '__main__':
    unittest.main()


# In[ ]:




