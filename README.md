# NutriQ

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
NutriQ is a meal planner application that generates meals & recipes based on your caloric needs/goals.

## Build Progress
* [x] User can create and account (Email/Password)
* [x] User can log in (Email/Password)

<p float= "left">
   <img src="https://media.giphy.com/media/IdOMSDenTu0XjfZexn/giphy.gif" width=250>
      <img src="https://media.giphy.com/media/Jnulzcott1WwX4gQI0/giphy.gif" width=250><br>
</p>


### App Evaluation
- **Category:** Health and Fitness
- **Mobile:** This app is developed for mobile but can work just as well on a desktop environment, but a mobile version will be easier to track each meal.
- **Story:** Analyzes users health information to calculate their basal metabolic rate and generate a calorie limited meal plan, geared towards the users fitness goals. The user can track their progress over time.
- **Market:** Anybody who is health conscious and wants to change their diet strategy, or for people who want inspiration for cooking their own meals.
- **Habit:** This app can be used often to track all meals, or it can be used mostly as a reference point for framing a generalized meal plan.
- **Scope:** First we start by generating customized meal plans with recipes, eventually users may be able to upload their own meals. Big potential for creating a large food database, or incorporating lite social media elements.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [x]  User can create an account
    * [x] Email, Password
* [x] User can log in
    * [x] User can log in with email
    * [x] User can log in with Google
* [x] User can enter their information
    * [x] Age, Gender, Height, Weight
    * [x] Fitness and weight goals
* [x] User can see customized daily calorie limit
* [ ] User can view customized meal plan (TableView)
    * [ ] Nutrition requirements will be based on calculated BMR (Basal Metabolic Rate)
* [ ] User can click on a cell and view details
* [ ] User can update their weight
* [ ] User can view progress towards goal
* [ ] User can edit their goals
* [ ] User can change password
* [ ] User can delete account


**Optional Nice-to-have Stories**

* [ ] User can add their own meals/recipes
* [ ] Allergies, Diet Preferences (Vegan, Vegetarian, etc.)

### 2. Screen Archetypes

* User Sign Up Screen
   * User can create an account
   * User can log in
* Gather User Information Screen
   * User can enter their information
   * Age, Gender, Height, Weight
* Gather User Information Screen 2
   * Activity Level
* Gather User Information Screen 3
   * Goals (Lose, gain, or maintain weight)
* Gather User Information Screen 4
   * Weekly goals (Pounds +/- per week)
* User Results Screen
   * User can see daily calorie limit
* Home
   * User can view customized meal plan (Table View)
* Cell Detail
   * User can click on a cell and view meal details (ingredients, nutrition information)
* Settings
   * User can edit their goals
   * User can change password
   * User can delete account
* User Stats
   * User can update weight and view progress



### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Meal Plan Screen
* User Profile
* Settings

**Flow Navigation** (Screen to Screen)

* User Sign Up/Log In Screen &rarr; User has the choice to either log in to their existing account or sign up for a new account
* Gather User Information Screens &rarr; When user just signs up, must answer questions for the app to get data to calculate the user's basal metabolic rate
* User Results Screen &rarr; User presented with basal metabolic rate and continues to Home Screen
* Home Screen (Meal Plan Screen) &rarr; View of user's meal plan for each day of the week and aggregate nutrition information (all meals combined)
* Meal View Screen &rarr; View of a specific meal for a specific day. Shows recipes and nutritional breakdown
* User Stats Screen &rarr; View of user's stats. Can update progress and goals
* Settings Screen &rarr; Toggle settings


## Wireframes
<img src="https://github.com/letsgetthisbreadd/NutriQ/blob/master/Images-and-Videos/Handdrawn-Wireframes/Wireframe1.jpg" width=1000><br>
<img src="https://github.com/letsgetthisbreadd/NutriQ/blob/master/Images-and-Videos/Handdrawn-Wireframes/Wireframe2.jpg" width=1000><br>


### [BONUS] Digital Wireframes & Mockups
<p float="left">
    <img src="https://github.com/letsgetthisbreadd/NutriQ/blob/master/Images-and-Videos/Digital-Wireframes/1%20-%20Sign%20Up-Login%402x.png" width=250>
    <img  src="https://github.com/letsgetthisbreadd/NutriQ/blob/master/Images-and-Videos/Digital-Wireframes/1A%20-%20Complete%20Sign%20Up%402x.png" width=250>
    <img src="https://github.com/letsgetthisbreadd/NutriQ/blob/master/Images-and-Videos/Digital-Wireframes/1B%20-%20About%20User%20(You)%402x.png" width=250>
</p>
<p float="left">
    <img src="https://github.com/letsgetthisbreadd/NutriQ/blob/master/Images-and-Videos/Digital-Wireframes/1C%20-%20About%20User%20(Activity%20Level)%402x.png" width=250>
    <img src="https://github.com/letsgetthisbreadd/NutriQ/blob/master/Images-and-Videos/Digital-Wireframes/1D%20-%20About%20User%20(General%20Goal)%402x.png" width=250>
    <img src="https://github.com/letsgetthisbreadd/NutriQ/blob/master/Images-and-Videos/Digital-Wireframes/1E-%20About%20User%20(Weekly%20Goal)%402x.png" width=250>
</p>
<img src="https://github.com/letsgetthisbreadd/NutriQ/blob/master/Images-and-Videos/Digital-Wireframes/1F-%20Results%20%E2%80%93%202%402x.png" width=250><br>

### [BONUS] Interactive Prototype
<img src="https://github.com/letsgetthisbreadd/NutriQ/blob/master/Images-and-Videos/Prototypes/NutriQ-Prototype-Part1.gif" width=250><br>

## Schema 
### Models
#### User
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | username      | String   | unique name for the user |
   | password      | String   | password of the user |
   | currentWeight | Number   | current weight of the user |
   | dateOfBirth   | DateTime | date when user was worn |
   | gender        | Boolean  | gender of user; 0 for male, 1 for female |
   | activityLevel | Number   | number representing activity level of user |
   | mealCountPreference | Number | number of daily meals user prefers to have in meal plan |
   | goalWeight | Number | weight user would like to achieve |
   | goalWeeklyWeightLoss | Number| weight user would like to lose every week |
   | basalMetabolicRate | Number | number of calories user needs to consume to maintain current weight |
   | requiredMacros | JSON Object | all nutrients required by user in a day; name, unit, calories, percentage of daily total |
   | requiredNutrients | JSON Object | all nutrients required by user in a day; name, unit (g, mg) |
   | createdAt | DateTime | date when user created (default field) |
   | updatedAt | DateTime | date when any user property updated (default field) |
#### Meal Plan
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | mealPlanId    | String   | unique id for the meal plan (default field) |
   | createdAt     | DateTime | date when meal plan was created (default field) |
   | updatedAt     | DateTime | date when meal plan was updated (default field) |
   | username      | Pointer to User | user the meal plan belongs to |
#### Meal
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | mealId        | String   | unique id for the meal (default field) |
   | dayNumber     | Number   | number representing the day of the week (1 - Monday, 7 - Sunday) |
   | mealNumber    | Number   | meal number of the day (1, 2, 3, etc.) |
   | name          | String   | name of the meal |
   | calories      | Number   | number of calories in the meal |
   | nutrients     | JSON Object | all nutrients in the meal; nutrient name, unit (g, mg), percentage of daily value |
   | recipe        | JSON Object | recipe used to created the meal; food item id, food item name, unit (g, cups), servings, nutrients |
#### Food Item
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | foodItemId    | String   | unique id for the food item (default field) |
   | name          | String   | name of the food item |
   | weight        | Number   | weight of the food item (g) |
   | calories      | Number   | number of calories in the food item |
   | nutrients     | JSON object | all nutrients in the food item; nutrient name, unit (g, mg), percentage of daily value |

### Networking
#### List of network requests by screen
   - Sign Up/Login Screen
      - Sign Up
         - (Create/POST) - Create a new user object
      - Login
         - (Read/GET) - Query logged in user object
   - Gather General User Information Screen
      - (Update/PUT) - Update user information (gender, height, weight, date of birth, etc.)
   - Gather User Activity Level Screen
      - (Update/PUT) - Update user's activity level
   - Gather User "General" Goals Screen
      - (Update/PUT) - Update user's goals
   - Gather Weekly Goal Screen
      - (Update/PUT) - Update user's weekly goal
   - Show User Results (Basal Metabolic Rate) Screen
      - (Read/GET) - Query information user has input (gender, height, weight, date of birth, activity level, etc.) to calculate basal metabolic rate
      - (Update/PUT) - Update user's basal metabolic rate
   - Home Screen
      - (Read/GET) - Query logged in user object for meal plan object
   - Settings Screen
      - (Update/PUT) - Update user's goals, password, or other settings
   - Weekly Meal Plan Screen
      - (Read/GET) - Query meal plan object for recipe objects and meal objects
   - Food Item Screen
      - (Read/GET) - Query meal object for food item object
   - User Stats Screen
      - (Read/GET) - Query logged in user object
      - (Update/PUT) - Update user weight, goals, etc.
#### [OPTIONAL: List endpoints if using existing API such as Yelp]
