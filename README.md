### A Julia package for writing models and simulations

Don't let him near Tybalt, they have a history.

### Usage

#### Create a Model

Inherit from the abstract `Mercutio.Model` type and declare members that will be modified while interfacing with your model.

```
type SwimTruckSales <: Model
    price::Float64
    color::Symbol
    
    num_customers::Int
    
    SwimTruckSales(price = 16, color = :cyan) = new(price, color, 0)
end
```

In this case we're trying to figure out how well our swim trucks will sell. We've got a model with two data members that we can play with, `price` and `color`. To start using our model, let's resiter one with Mercutio.

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
    mdl.num_customers *= mdl.formula / 2.5
    
    mdl.num_customers
end
```

#### Persist decisions and results

