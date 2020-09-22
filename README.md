# GetOnBrd API Ruby library

The GetOnBrd Ruby library provides a convenient access to the _Get on Board API_ from applications written in the Ruby language.

It abstracts the developer from having to deal with API requests by mapping the list of the core resources like Company, Category, Tag, Job or Application to ruby classes and objects.

Key features:

- Easy to setup.
- Map core concepts in Get on Board to ruby classes.
- Allow access to relationships among these concepts like accessing all the jobs within a category, or what's the company behind a job.

## Documentation

Check the original API doc at: https://api-doc.getonbrd.com

## Installation

Add this line to your application's Gemfile:

```ruby
gem "getonbrd-ruby", github: "getonbrd/getonbrd-ruby"
```

then execute:

```sh
$ bundle install
```

## Usage

The API has two facets:

- Public: Provides access to the same data you can see in [Get on Board](https://www.getonbrd.com) without having to log in.
- Private: Provides access to the data of subscribed companies. All the requests made to this facet need to be authenticated.

### Public facet

Free access to _companies_, _categories_, _tags_ and _jobs_.

#### Models

The public facet allows anyone to download the data publicly accessible in [Get on Board](https://www.getonbrd.com) without having to login. The models are mapped against the **Public** folder in the [API Reference](https://api-doc.getonbrd.com).

Note: Check the directory `lib/getonbrd/resources/public` for the complete list of resources.

Some examples

```ruby
# download then categories
categories = Getonbrd::Public::Category.all(page: 2, per_page: 5)
# list their names
categories.map(&:name)

# retrieve the Programming category
programming = Getonbrd::Public::Category.retrieve("programming")
# list the published jobs under programming
programming.jobs

# Searching jobs for a free text
jobs = Getonbrd::Public::Search.jobs("remote backend ruby on rails")
```

### Private facet

In order to access your company's private data you'll need to provide the API key that can be found in the page of settings of your account in Get on Board.

#### Initialize the library with the API Key

Using your method of preference initialize the library setting up the API Key, for example in case of a rails application it can be adding an initializer:

```ruby
# file: app/initializers/getonbrd.rb
require "getonbrd"

Getonbrd.api_key = ENV["GoB_API_KEY"] # it is a good idea to use an env not exposing the key
```

#### Models

Those companies with access to the private facet of the API can use the models under `/lib/getonbrd/resources/private`, some examples:

```ruby
# retrieve the list of jobs the company own
jobs = Getonbrd::Private::Job.all(page: 2, per_page: 10) # by default page is 1 and per_page is 100

# retrieve the list if hiring processes and their applications and professionals
processes = Getonbrd::Private::Job.all
processes.each do |process|
  apps = process.applications
  professionals = process.professionals
end
# it is possible to paginate thru applications and professionals directly too
apps = Getonbrd::Private::Application.all
# in the case of professionals a process id is needed
professionals = Getonbrd::Private::Professional.all(process_id: <process-id>, per_page: 50)

# create an application
app_attrs = {
  job_id: 1,
  email: "jon@snow.com",
  name: "Jon Snow",
  reason_to_apply: "They say I know nothing but that's not true..:",
  ...
}
app = Getonbrd::Private::Application.create(app_attrs)

app.update(description: "I do know a thing or two about Ruby and/or Rails")
```

Note: Refer to the [API Reference](https://api-doc.getonbrd.com/) to see the list of resources.

### Expanding the response

Some objects allow you to request additional information as an expanded response by using the expand parameter that is available on several of the endpoints, and applies to the response of that request only.

For instance a a `job` has `tags`, if the response is not expanded, it will return only the id of the tags, however if the response is expanded it will return the list of tags with their data:

```ruby
job = Getonbrd::Private::Job.retrieve(job_id, expand: ["tags", "questions"])
# the tags and questions come expanded within the response
job.tags.map(&:name)
job.questions.each { |q| puts "#{q.required ? "*" : ""} #{q.title}" }
```

## Development

Run the set up:

```sh
$ bundle
```

Run the specs:

```sh
$ bundle exec rspec
```

Run the linter:

```sh
$ bundle exec rubocop
```

## Contributing

1. Fork it.
1. Create your feature branch (git checkout -b my-new-feature).
1. Commit your changes (git commit -am 'Add some feature').
1. Push to the branch (git push origin my-new-feature).
1. Create a new Pull Request.

Bug reports and pull requests are welcome on GitHub at https://github.com/getonbrd/getonbrd-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/getonbrd/getonbrd-ruby/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the GetOnBrd Ruby library project's codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/getonbrd/getonbrd-ruby/blob/master/CODE_OF_CONDUCT.md).
