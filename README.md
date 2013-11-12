### A Julia package for writing models and simulations

Don't let him near Tybalt, they have a history.

### Usage

#### Create a Model

Inherit from the abstract `Mercutio.Model` type and declare members that will be modified while interfacing with your model.

```
type SwimTruckSales <: Model
    price::Float64
    color::Int  # [1, 4] for simplicity, there are 4 colors of fabiric we can use
    
    num_customers::Int
    
    SwimTruckSales(price = 16, color = 1) = new(price, color, 0)
end
```

In this case we're trying to figure out how well our swim trucks will sell. We've got a model with two data members that we can play with, `price` and `color`. We've also got a member `num_customers`, which we will calculate. To start using our model, let's resiter it with Mercutio.

```
using Mercutio

register_model(SwimTruckSales())

# now we can do cool things like change price and color
setparam(:SwimTrunkSales, [:price, 7], [:color, :red])
```


#### Implement `runmodel`

Unicorn will execute your model by invoking `runmodel(mdl::Model)`, so we need to write a `runmodel(mdl::SwimTrunkSales)`

```
function runmodel(mdl::SwimTrunkSales)
    mdl.num_customers = cos(mdl.price / 12) * 64
    mdl.num_customers *= mdl.color / 2.5
    
    mdl.num_customers
end
```


#### Persist decisions and results

Now that we're able to run our model and get results, we should turn our attention to persisting data so that we can look back at our results. The method we'll use to do this is `push!(:MdlDataType, :member)`, which we can call inside of `runmodel`.

```
# for each run, let's save our decisions and results
function runmodel(mdl::SwimTrunkSales)
    push!(:SwimTruckSales, :price)
    push!(:SwimTruckSales, :color)

    mdl.num_customers = cos(mdl.price / 12) * 64
    mdl.num_customers *= mdl.color / 2.5
    push!(:SwimTrunkSales, :num_customers)
    
    mdl.num_customers
end
```

```
# now we can run our model, change our decisions, and try again
julia> runmodel(:SwimTrunkSalesModel)
6.02208187655653

julia> setparam(:SwimTrunkSalesModel, [:price, 2.0])

julia> runmodel(:SwimTrunkSalesModel)
25.245266728010883

```


#### Accessing persisted values
