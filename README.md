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
imp = Impasta.new
~~~

You can give it a name too:

~~~ruby
secret_imp = Impasta.new 'totally not an imposter'
~~~

Both of those types of Impastas will accept any method and args you throw at them.

~~~ruby
imp.whatever                       #=> self
secret_imp.lulz 2, 3, :slimpickins #=> self
~~~

But you can also contrain the methods Impasta objects accept by passing in a class:

~~~ruby
array_imp = Impasta.new Array

array_imp.first        #=> self
array_imp.johnnycarson #=> raises Impasta::ImpastaNoMethodError
~~~

An Impasta will always return self for any method it intercepts.

You can also extract information from an instance of Impasta:

~~~ruby
array_imp.impasta_dump.keys           #=> [:caller, :class, :instance, :name, :methods]
array_imp.impasta_dump[:class]        #=> Array
array_imp.impasta_dump[:caller].first #=> this will display where the Impasta was instantiated
~~~

## Contributing

1. Fork it ( http://github.com/acook/impasta/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
