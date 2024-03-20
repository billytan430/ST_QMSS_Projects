#!/usr/bin/env python
# coding: utf-8

# In[1]:


import requests
import pandas as pd

def fetch_all_exercises():
    """
    Fetches all exercise data from the 'wger.de' API.

    This function makes requests to the 'wger.de' API to retrieve information about various exercises. 
    It compiles this data into a list of dictionaries, each representing an exercise with details such as 
    name, description, equipment, muscles targeted, and an ID. This list can be converted into a DataFrame 
    for further analysis and manipulation.

    Returns:
        List[Dict]: A list of dictionaries, where each dictionary contains data about an exercise.
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
                    'id': str(result['id'])  # Convert 'id' to string
                }
                exercises.append(exercise_data)
            
            next_url = data['next']
        except requests.exceptions.RequestException as e:
            print(f"An error occurred while making the request: {e}")
            break

    return exercises


def find_exercises_by_muscle(dataframe, muscle):
    """
    Filters exercises by a specified muscle group from a given DataFrame.

    This function takes a DataFrame containing exercise data and an integer representing a muscle group. 
    It filters the DataFrame to find exercises that target the specified muscle group.

    Args:
        dataframe (pd.DataFrame): A DataFrame containing exercise data.
        muscle (int): An integer representing the muscle group to filter by.

    Returns:
        pd.DataFrame: A DataFrame containing exercises that target the specified muscle group.
    """
    # Convert the 'muscles' column to lists of integers
    dataframe['muscles'] = dataframe['muscles'].apply(lambda x: [int(m) for m in x])

    # Convert the user input muscle to an integer
    user_input_muscle = int(muscle)

    # Filter the DataFrame to find exercises that match the input muscle
    matching_exercises = dataframe[dataframe['muscles'].apply(lambda x: user_input_muscle in x)]

    return matching_exercises


def find_exercises_by_equipment(dataframe, equipment):
    """
    Filters exercises by specified equipment from a given DataFrame.

    This function takes a DataFrame containing exercise data and an integer representing equipment. 
    It filters the DataFrame to find exercises that use the specified equipment.

    Args:
        dataframe (pd.DataFrame): A DataFrame containing exercise data.
        equipment (int): An integer representing the equipment to filter by.

    Returns:
        pd.DataFrame: A DataFrame containing exercises that use the specified equipment.
    """
    # Filter the DataFrame to find exercises that match the input equipment
    matching_exercises = dataframe[dataframe['equipment'].apply(lambda x: equipment in x)]

    return matching_exercises

def find_best_exercise(dataframe, equipment, muscle):
    """
    Filters exercises from a DataFrame that match both specific equipment and muscle group.

    This function filters the provided DataFrame to find exercises that both use the specified equipment 
    and target the specified muscle group. The function takes integers representing both equipment and muscle.

    Args:
        dataframe (pd.DataFrame): A DataFrame containing exercise data.
        equipment (int): An integer representing the equipment to filter by.
        muscle (int): An integer representing the muscle group to filter by.

    Returns:
        pd.DataFrame: A DataFrame containing exercises that match both the equipment and muscle criteria.
    """
    # Filter the DataFrame to find exercises that match both equipment and muscle
    matching_exercises = dataframe[(dataframe['equipment'].apply(lambda x: equipment in x)) &
                                    (dataframe['muscles'].apply(lambda x: muscle in x))]

    return matching_exercises



def main_menu():
    print("\nWelcome to the Exercise Data Tool!")
    print("First, you need to fetch all exercises to create a DataFrame.")
    print("After that, you can use the other functions to filter the exercises.")

    # Fetch all exercises and create a DataFrame
    all_exercises = fetch_all_exercises()
    exercise_df = pd.DataFrame(all_exercises)

    while True:
        print("\nAvailable Functions:")
        print("1. find_exercises_by_muscle")
        print("2. find_exercises_by_equipment")
        print("3. find_best_exercise")
        print("4. Exit")

        user_choice = input("Enter the number of the function you want to use (1, 2, 3, or 4 to exit): ")

        if user_choice == '1':
            try:
                user_input_muscle = int(input("Enter a muscle: "))
                matching_exercises = find_exercises_by_muscle(exercise_df, user_input_muscle)

                if not matching_exercises.empty:
                    print("Matching Exercises:")
                    print(matching_exercises[['name', 'description']])
                else:
                    print(f"No exercises found for the muscle: {user_input_muscle}")
            except ValueError:
                print("Invalid input. Please enter a valid muscle (integer).")

        elif user_choice == '2':
            try:
                user_input_equipment = int(input("Enter an equipment: "))
                matching_exercises = find_exercises_by_equipment(exercise_df, user_input_equipment)

                if not matching_exercises.empty:
                    print("Matching Exercises:")
                    print(matching_exercises[['name', 'description']])
                else:
                    print(f"No exercises found for the equipment: {user_input_equipment}")
            except ValueError:
                print("Invalid input. Please enter a valid equipment (integer).")

        elif user_choice == '3':
            try:
                user_input_equipment = int(input("Enter an equipment: "))
                user_input_muscle = int(input("Enter a muscle: "))
                best_exercise = find_best_exercise(exercise_df, user_input_equipment, user_input_muscle)

                if not best_exercise.empty:
                    print("Best Exercise:")
                    print(best_exercise[['name', 'description']])
                else:
                    print(f"No best exercise found for equipment: {user_input_equipment} and muscle: {user_input_muscle}")
            except ValueError:
                print("Invalid input. Please enter valid equipment and muscle (integers).")

        elif user_choice == '4':
            print("Exiting the program. Goodbye!")
            break

        else:
            print("Invalid choice. Please enter 1, 2, 3, or 4.")

if __name__ == "__main__":
    main_menu()


# In[ ]:




