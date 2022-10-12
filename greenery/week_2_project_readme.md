# Answers to Week 2 Project Questions

## Part 1. Models 
- What is our user repeat rate?


- What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?


- More stakeholders are coming to us for data, which is great! But we need to get some more models created before we can help. Create a marts folder, so we can organize our models, with the following subfolders for business units:
    - Core
    - Marketing
    - Product

- Within each marts folder, create intermediate models and dimension/fact models.

- Use the dbt docs to visualize your model DAGs to ensure the model layers make sense

## Part 2. Tests

- We added some more models and transformed some data! Now we need to make sure they’re accurately reflecting the data. Add dbt tests into your dbt project on your existing models from Week 1, and new models from the section above

- What assumptions are you making about each model? (i.e. why are you adding each test?)

- Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
    - Apply these changes to your github repo
- Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

## Part 3. dbt Snapshots 
Let's update our orders snapshot that we created last week to see how our data is changing:

1. Run the orders snapshot model using dbt snapshot and query it in snowflake to see how the data has changed since last week. (Done)
2. Which orders changed from week 1 to week 2?