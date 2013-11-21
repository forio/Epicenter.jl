## A package for writing models and simulations

Don't let him near Tybalt, they have a history.

### Usage

#### Create a Model

Inherit from the abstract `Unicorn.Model` type and declare members that will be modified while interfacing with your model.

```julia
type SwimTrunkSalesModel <: Model
    price::Float64
    color::Int  # [1, 4] for simplicity, there are 4 colors of fabric

    num_customers

    SwimTrunkSalesModel(price = 16.0, color = 1) = new(price, color, 0)
end
```

In this case we're trying to figure out how well our swim trucks will sell. We've got a model with two data members that we can play with, `price` and `color`. We've also got a member `num_customers`, which we will calculate. To start using our model, let's resiter it with Unicorn.

```julia
julia> using Unicorn

julia> register_model(SwimTruckSales())

# now we can do cool things like change price and color
julia> setparam(:SwimTrunkSales, [:price, 7], [:color, 3])
```


#### Implement `runmodel`

Unicorn will execute your model by invoking `runmodel(mdl::Model)`, so we need to write a `runmodel(mdl::SwimTrunkSales)`

```julia
function runmodel(mdl::SwimTrunkSalesModel)
    mdl.num_customers = cos(mdl.price / 12) * 64
    mdl.num_customers *= mdl.color / 2.5

    mdl.num_customers
end
```


#### Persist decisions and results

Now that we're able to run our model and get results, we should turn our attention to persisting data so that we can look back at our results. The method we'll use to do this is `push!(:MdlDataType, :member)`, which we can call inside of `runmodel`.

```julia
# for each run, let's save our decisions and results
function runmodel(mdl::SwimTrunkSalesModel)
    push!(:SwimTrunkSalesModel, :price)
    push!(:SwimTrunkSalesModel, :color)

    mdl.num_customers = cos(mdl.price / 12) * 64
    mdl.num_customers *= mdl.color / 2.5
    push!(:SwimTrunkSalesModel, :num_customers)

    mdl.num_customers
end
```

```julia
# now we can run our model, change our decisions, and try again
julia> runmodel(:SwimTrunkSalesModel)
6.02208187655653

julia> setparam(:SwimTrunkSalesModel, [:price, 2.0])

julia> runmodel(:SwimTrunkSalesModel)
25.245266728010883

```


#### Access persisted values

Now that we've run our model a couple times, we've generated some data. The API for accessing it is as follows:

```julia
# is there data to persist => true | false
isempty(mdl_sym::Symbol, member::Symbol)
isempty(mdl_sym::Symbol)
```

```julia
# how many values are queued => Int
length(mdl_sym::Symbol, member::Symbol)
length(mdl_sym::Symbol)
```

```julia
# flush everything from the queue => nothing
empty!(mdl_sym::Symbol, member::Symbol)
empty!(mdl_sym::Symbol)
```

```julia
# pop a single thing from the queue
pop!(mdl_sym::Symbol, member::Symbol) # => val
pop!(mdl_sym::Symbol)                 # => [:member, val]
```

```julia
# pop everything from a models queue => { :member1 => [val1, val2]
#                                         :member2 => [val1, val2, val3] }
popall!(mdl_sym::Symbol)
```

```julia
# splice out an element or a range from a queue
splice!(mdl_sym::Symbol, member::Symbol, ir, ins::AbstractArray = Base._default_splice)
```


#### Other useful methods

```julia
# list names of all registered models => [:model1, :model2, :model3]
registered_models()
```

```julia
# get the model registered for a symbol => Model
getmodel(model::Symbol)
```
