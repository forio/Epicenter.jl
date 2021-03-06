---

##Epicenter.jl

Epicenter.jl is a Julia package for writing models and simulations. It provides an interface for persisting model variables to a backend database, such as Forio's Epicenter platform.

In this document:

* An [overview of this package and its relationship to Forio's Epicenter platform](#overview-and-relationship-to-epicenter-platform)
* How to [set up your Julia environment](#set-up-your-julia-environment) for using Epicenter.jl
* A [sample model](#create-a-model) that uses both Epicenter.jl and other common conventions for writing models that will be hosted on Forio's Epicenter platform
* A [detailed explanation](#recommended-conventions-and-practices-for-modeling) of each of these conventions

<a id="overview-and-relationship-to-epicenter-platform"></a>
###Overview and Relationship to Epicenter Platform

When you write a model and then execute your model in Julia, the model is being executed in memory. If you want to have sets of interactions with your model saved, or if you want to examine these runs later, then you need to have each run of your Julia model persisted. 

Epicenter.jl allows you to persist particular model variables during execution of your model. It does this with a queue: Epicenter.jl's `record(keys...)` method adds the variable to a queue.  

Forio's [Epicenter platform](https://github.com/forio/epicenter) provides a database that can be written to by models that use the Epicenter.jl package. In particular, the Epicenter platform processes the Epicenter.jl persistence queue approximately every second, taking items in the queue and storing them in the Epicenter backend database.

Additionally, the Epicenter platform also provides RESTful APIs for creating runs, setting and reading model variables, and executing methods exposed by the model: everything you need to create a web-based user interface for your model.


<a id="set-up-your-julia-environment"></a>
###Set up your Julia environment

To add Epicenter.jl to your Julia environment, use:
```julia
julia> Pkg.clone("https://github.com/forio/Epicenter.jl.git")
```

Then, at the beginning of your model files, add:
```julia
using Epicenter 
```

*TIP:* Obviously, you can use other packages as well, using the standard `Pkg.add("PackageName")`. If you have any trouble configuring packages or dependencies, please [let the Forio Platform team know](http://forio.com/support) so that they can configure your account on the Epicenter server correctly. 


<a id="create-a-model"></a>
###Create a model

This sample model showcases the Epicenter.jl package and common conventions for writing models that will be hosted on the Epicenter platform. We'll examine each of the key pieces in the sections below.

```julia
# in MyModel.jl
module MyModel

# include the Epicenter.jl package
using Epicenter

# expose variables to users of your model
export  model,
        curr_year

# expose methods to users of your model
export  init,
        advance,
        reset

# -------

type ModelResultType
    num_customers::Int
    revenue::Float64

    ModelResultType(; num_customers = 0, revenue = 0) = new(num_customers, revenue)
end

# -------

type ModelType
    price::Float64
    results_over_time::Array{ModelResultType, 1}

    ModelType(; price = start_price) = new(price, ModelResultType[])
end

# -------

const global start_year = 2014
const global initial_customers = 50
const global start_price = 15

global curr_year
global model

# -------

function init()
    # For this model, init() and reset() end up being identical
    # We choose to put the logic in reset() so that ModelType() doesn't get called multiple times, 
    # and it's more clear why we want to record the entire results_over_time array
    reset()
end

function advance()
    global curr_year += 1

    current_result = ModelResultType()
    current_result.num_customers = int(cos(model.price / 12) * 64)
    current_result.revenue = model.price * current_result.num_customers

    # Add current_result, the results of executing the model for this time step,
    # to the end of the model.results array
    push!(model.results_over_time, current_result)

    # length(model.results_over_time) is the index of the last element of the model.results_over_time array. 
    # So adding model.results[length(model.results)] to the persistence queue 
    # adds only the last element of the array to the persistence queue.
    # When the model runs on the Epicenter platform,
    # the Epicenter platform processes this queue approximately every second
    record(:model, :results_over_time, length(model.results_over_time))
end

function reset()
    global curr_year = start_year
    global model = ModelType()

    current_result = ModelResultType()
    current_result.num_customers = initial_customers
    current_result.revenue = model.price * current_result.num_customers

    push!(model.results_over_time, current_result)

    # Record the entire model.results_over_time array here
    # to ensure that any existing runs (in later indices) are cleared.
    record(:model, :results_over_time)
end

end

```

<a id="recommended-conventions-and-practices-for-modeling"></a>
###Recommended conventions and practices for modeling

There is no one right way to make a Julia model. However, if you're planning to share your Julia model and host it on the Epicenter platform, there are a few recommended conventions and best practices to keep in mind when designing your model. 

####Make the top-level module and file name the same.

Your top-level module should have the same name as your top-level file. 

**Why.** You'll pass this file as an argument when [creating a run](https://github.com/forio/epicenter/blob/master/docs/public/model_apis/run/index.md#post-creating-a-new-run-for-this-project) using the Epicenter platform.

**How.** The sample file is called `MyModel.jl` and the module is `module MyModel`. This is case-sensitive.


####Expose variables and methods in this module, and make the variables global.

This top-level file should include your `export` statements for exposing methods and global variables for end users to manipulate. 

**Why.** In order for the Epicenter platform to set and read model variables, or execute methods in the model, you need to expose the variables and methods using the Julia keyword `export`. Additionally, all of the `export` statements need to be in one file.  Finally, all of the variables need to be declared as `global`. The Epicenter platform makes it easy for a web front-end to set and read these variables and execute these methods.

**How.** The sample file `MyModel.jl` file includes the lines `export init, reset, advance` and `export model, curr_year` and declares the `model` and `curr_year` variables as `global`.

####Define and expose methods that capture how users should interact with your model. 

**Why.** For models hosted on the Epicenter platform, the methods you choose to `export` are the only ways in which end users can interact with your model. So it makes sense that each exposed method correspond to an action that the end user can take with your model.

**How.** For example, the convention used in the sample file includes:

* An initialize function that ensures the model starts from specified, known conditions. This is useful for all models. In our example, this is `init()`. This can be called as soon as a user starts interacting with your model (i.e. immediately after a run is created in the Epicenter platform).

* An advance function, that moves the model forward by one time step, persisting any results needed. This is useful for models that simulate the behavior of a system over time. In our example, this is `advance()`. 

* A reset function, that returns the model to a known state &mdash; often the initial state. This is useful for models in which an end user want to clear out the results and start again. In practice, its details may be the same as the initialize function, but its purpose is slightly different. In our example, this is `reset()`. 
	* Note that this example erases the results when a `reset()` is called. An alternative approach is to have the front-end user interface start a new session when the user wants to reset. This would preserve the existing results while also allowing the user to start again. If you are using the Epicenter platform, you can create a new run (session) with a [POST request to the Run API](https://github.com/forio/epicenter/blob/master/docs/public/model_apis/run/index.md#post-creating-a-new-run-for-this-project). 
	
####Persist variables in exposed methods.

Any variables that you want persisted need to be explicitly persisted using Epicenter.jl's `record(keys...)` method. This call should happen in methods that you have exposed (`export`ed).

**Why.** End users can only interact with your model through exposed (`export`ed) methods. So it's important to persist variables in methods that end users may call.

**How.** Use the method call `record(keys...)`. When you're running your model on the Epicenter platform, the Epicenter platform processes this queue approximately every second, taking items in the queue and storing them in the Epicenter backend database.

`record(keys...)` can take any number of symbols and/or indices that describe the object you want to persist.

In the sample file:
```julia
record(:curr_year)
```

adds the variable `curr_year` to the persistence queue. This means that the persisted variable `curr_year` will be set to the value of `curr_year` (as soon as the persistence queue is processed, e.g. by the Epicenter platform). *Any previous value of `curr_year` is overwritten once the persistence operation is complete.*

As another example from the sample file:
```julia
record(:model, :results_over_time, length(model.results_over_time))
```

adds the variable `model.results_over_time[length(model.results_over_time)]` to the persistence queue. Again, this means that the persisted variable `model.results_over_time[length(model.results_over_time)]` will be set to the current value of this variable (as soon as the persistence queue is processed, e.g. by the Epicenter platform). 

Because Julia arrays are 1-based, `length(model.results_over_time)` refers to the last element of the `model.results_over_time` array. So this example is *only* persisting the last element of the `model.results_over_time` array. Because of how we've defined the array and the method, this is actually the only time that we'll be persisting a value at this particular index ... so we're never overwriting anything. Part of your model design needs to be careful thought about what you do and do not need to keep, and what is and is not ok to overwrite.

####Remember that time is not an inherent property of the model.

The typical convention for this is to use an array, where each array element is an object with fields for all of the variables you want to save.

**Why.** If your model is simulating behavior over time, and you want results from each time step to be persisted, you'll need to persist each of them &mdash; and you'll need to persist each of them in a different variable (otherwise the results will overwrite each other as your model progresses!). 

**How.** In the sample, the `model.results_over_time` array has a new element appended to it during each time step of the model. This new element, which is therefore at index `[length(model.results_over_time)]`, is persisted at each time step. In this way, all of the results are saved; the results from one time step never overwrite the results from a previous time step. 


####Structure your model based on your own best practices.

You can include multiple modules, sub-directories, global or local variables, any defined types or data structures, etc. Aside from the conventions above, use your own good judgement and the nature of the problem being modeled to guide you.

