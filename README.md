Impasta
=======

> **im-past-a** (noun)
>
> 1. A piece of pasta found with other pasta noodles that do not share its type.
> 2. A test spy that can impersonate a given class and/or track methods passed to it.
>
> **Origin:** portmanteau of *imposter* and *pasta*

*protip: definition #2 is the one we're talking about*

[![Gem Version](https://img.shields.io/gem/v/impasta.svg?style=for-the-badge)](https://rubygems.org/gems/impasta)
[![Build Status](https://img.shields.io/circleci/build/github/acook/impasta/main.svg?style=for-the-badge)](https://circleci.com/gh/acook/impasta/tree/main)

## Installation

Add this line to your application's Gemfile:

    gem 'impasta'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install impasta

## Usage

It's pretty easy, to create a new Impasta just do:

~~~ruby
imp = Impasta.decoy
~~~

You can give it a name too:

~~~ruby
secret_imp = Impasta.ndecoy aka: 'totally not an imposter'
~~~

Both of those Impastas will accept any method and args you throw at them.

~~~ruby
imp.whatever                       #=> self
secret_imp.lulz 2, 3, :slimpickins #=> self
~~~

But you can also constrain the methods Impasta objects accept by passing in a class:

~~~ruby
array_imp = Impasta.infiltrate target: Array.new

array_imp.first        #=> self
array_imp.johnnycarson #=> raises Impasta::ImpastaNoMethodError
~~~

You can also extract information from an instance of Impasta:

~~~ruby
array_imp.impasta.ledger            # will display all methods sent to it in this format: [[method_name, arguments_sent_to_method, block_passed_to_method], ...]
array_imp.impasta.target            #=> [] # (this is the same array passed in earlier)
array_imp.impasta.origin            #=> "readme.rb line #54" # this will display where the Impasta was instantiated
~~~

## Meet the Spies

### Decoy

- A type of dummy object.
- It responds to any message with self!
- Excellent placeholder when you don't care about enforcing which methods can be called.

### Wiretap

- A type of proxy object.
- Passes method calls on to the target and returns exactly that.
- Good to keep an eye on what your objects are talking about when you're not looking.

### Infiltrate

- A type of test double.
- Responds with `self` (the Infiltate object) for any message the target recognizes, raises an exception for anything else.
- Will raise for everything if no target provided!
- Good for enforcing API integrity, if you can use this one instead of a Decoy, I highly recommend it.

### Ghoul

- A type of null object.
- Responds with `nil` for any message the target recognizes, raises an exception for anything else.
- Like Infilitrate, but returns `nil` instead for situations where you need to test nil-resiliency. 

### Forging Messages

- Decoy and Infiltrate Impastas will always return `self` for any method they intercept.
- Ghoul always returns `nil`.
- Wiretap always returns the same thing as the target.

But what if they didn't?

Enter: FORGERY

~~~ruby
imp.decoy
tmp.identity                                     #=> self
imp.impasta.forge :identity, returns: "fake id"
imp.identity                                     #=> "fake id"
~~~

You can use a single `returns` keyword as above or you can use a block instead to set the value it will respond with when it receives the message. 
Arguments are ignored by the forgery, but you can check the ledger to make sure they are correct.

### Secrets

All spies have secrets, you've already interacted with them above, obtained by calling the `Spy#impasta` method.

But they can do other things, here are a few more:

- `secrets.inspect_target` to remind yourself about who this spy is targetting
- `secrets.inspect_forgeries` to see the list of forgeries this spy is carrying
- `secrets.codename` to get the spy to spill the beans on everything it knows
- `secrets.within` accepts a block and executes in the context of the `Impasta::Secrets` instance, good for configuring a bunch of things all at once

## Contributing

1. Fork it ( http://github.com/acook/impasta/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
