#!/usr/bin/env python
# coding: utf-8

# In[1]:


import requests

def fetch_all_exercises():
    """
    Fetches a list of exercises from the wger Workout Manager API.

    The function makes a series of GET requests to the wger API to retrieve
    all exercises. Each exercise's name, description, equipment, muscles involved,
    and ID are extracted and returned in a list of dictionaries.

    Returns:
        List[dict]: A list of dictionaries, each containing details of an exercise.

    Example:
        all_exercises = fetch_all_exercises()
        for exercise in all_exercises:
            print(f"Exercise Name: {exercise['name']}")
            print(f"Description: {exercise['description']}")
            print(f"Equipment: {exercise['equipment']}")
            print(f"Muscles: {exercise['muscles']}")
            print(f"ID: {exercise['id']}")
            print("---------")
    """

    exercises = []
    next_url = 'https://wger.de/api/v2/exercise/'

    while next_url:
        try:
            response = requests.get(next_url)
            response.raise_for_status()
            data = response.json()
            
            for result in data['results']:
                exercise_data = {
                    'name': result['name'],
                    'description': result['description'],
                    'equipment': result['equipment'],
                    'muscles': result['muscles'],
                    'id': result['id']
                }
                exercises.append(exercise_data)
            
            next_url = data['next']
        except requests.exceptions.RequestException as e:
            print(f"An error occurred while making the request: {e}")
            break

    return exercises


if __name__ == "__main__":
    # Example usage of the function
    all_exercises = fetch_all_exercises()
    if all_exercises:
        for exercise in all_exercises:
            print(f"Exercise Name: {exercise['name']}")
            print(f"Description: {exercise['description']}")
            print(f"Equipment: {exercise['equipment']}")
            print(f"Muscles: {exercise['muscles']}")
            print(f"ID: {exercise['id']}")
            print("---------")
    else:
        print("No exercises found.")


# In[ ]:




