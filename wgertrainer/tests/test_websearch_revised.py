#!/usr/bin/env python
# coding: utf-8

# In[3]:


import sys
import os
sys.path.append("/Users/shuaitaotan/Tan_Shuaitao_homework/tan_shuaitao_homework/wgertrainer")

from websearch import search_exercise_on_youtube
import pytest

@pytest.mark.parametrize("query", ["push ups", "yoga"])
def test_search_exercise_on_youtube(query):
    """
    Test the search_exercise_on_youtube function.
    Manually verify that the browser opens with the correct YouTube search URL.
    """

    print(f"Testing '{query}'")
    search_exercise_on_youtube(query)
    print(f"Test for '{query}' completed. Manually verify that the correct URL was opened in the browser.")

if __name__ == "__main__":
    queries = ["push ups", "yoga"]
    for query in queries:
        test_search_exercise_on_youtube(query)


# In[ ]:





# In[ ]:




