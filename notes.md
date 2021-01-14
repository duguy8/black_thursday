## Data Access Layer

# Sales Engine

* ```ruby
  se = SalesEngine.from_csv({
    :items     => "./data/items.csv",
    :merchants => "./data/merchants.csv",
  })
```
* SalesEngine.new => our se instance

* method `from_csv` => takes a hash argument where the keys are in reference to our `item` and `merchant` classes and the values are the csv files themselves and where the live(data directory)

* Need: SalesEngine class
        Method to load in `item.csv` and `merchant.csv` files that we get from the `.from_csv` method

* Possible Needs: `items` and `merchant` methods
 - Both these methods assign all of the in



 ## Sales Analyst
  * We need to know how many products 
