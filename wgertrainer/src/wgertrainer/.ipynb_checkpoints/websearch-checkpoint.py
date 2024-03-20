#!/usr/bin/env python
# coding: utf-8

# In[1]:


import webbrowser

def search_exercise_on_youtube(exercise_name):
    """
    Opens a web browser and searches YouTube for the specified exercise.

    Args:
        exercise_name (str): The name of the exercise to search for.

    The function constructs a search query URL for YouTube using the provided
    exercise name and opens a new browser tab with the search results.

    Example:
        search_exercise_on_youtube("push ups")
    """

    # Construct the YouTube search URL with the exercise name
    search_query = f"https://www.youtube.com/results?search_query={exercise_name.replace(' ', '+')}"
    webbrowser.open(search_query)


if __name__ == "__main__":
    try:
        # Input the exercise name from the user
        exercise_name = input("Enter an exercise name: ")

        # Call the function to search for the exercise on YouTube
        search_exercise_on_youtube(exercise_name)
    except Exception as e:
        print(f"An error occurred: {e}")


# In[ ]:




