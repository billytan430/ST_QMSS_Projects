#!/usr/bin/env python
# coding: utf-8

# In[6]:


import unittest
from io import StringIO
import sys

# Import the display_muscle_table function from your module
# Replace 'your_module' with the name of the module where display_muscle_table is defined
from display_muscle_table import display_muscle_table

class TestDisplayMuscleTable(unittest.TestCase):
    def setUp(self):
        self.maxDiff = None  # This will show the full difference
        self.capturedOutput = StringIO()
        sys.stdout = self.capturedOutput

    def tearDown(self):
        sys.stdout = sys.__stdout__

    def test_display_muscle_table(self):
        display_muscle_table()
        actual_output = self.capturedOutput.getvalue().strip()

        # Adjust this expected_output based on the actual output you see
        expected_output = """
 id                        name    name_en
  1              Biceps brachii     Biceps
  2            Anterior deltoid  Shoulders
  3           Serratus anterior      Chest
  4            Pectoralis major      Chest
  5             Triceps brachii    Triceps
  6            Rectus abdominis        Abs
  7               Gastrocnemius     Calves
  8             Gluteus maximus     Glutes
  9                   Trapezius       Back
 10          Quadriceps femoris      Quads
 11              Biceps femoris Hamstrings
 12            Latissimus dorsi       Lats
 13                  Brachialis        Arm
 14 Obliquus externus abdominis        Abs
 15                      Soleus      Ankle
""".strip()  # Be mindful of the leading and trailing whitespaces

        self.assertEqual(actual_output, expected_output)


if __name__ == '__main__':
    unittest.main()


# In[ ]:




