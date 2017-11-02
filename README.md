# Blueprint Agreement

[![Build Status](https://travis-ci.org/charly-palencia/blueprint-agreement.svg?branch=master)](https://travis-ci.org/charly-palencia/blueprint-agreement)
[![Code Climate](https://codeclimate.com/github/charly-palencia/blueprint-agreement/badges/gpa.svg)](https://codeclimate.com/github/charly-palencia/blueprint-agreement)

A Minitest API Documentation Matcher based on ApiBluePrint schema.

Note: This Gem Is Currently on Development.

## Description

- A ruby library for Validate API Blueprint Documentation
- Support MiniTest Assertion and Spec format
- Use drakov node library to serve Mock API server


## Getting Started

Add this line to your application's Gemfile:

    gem 'blueprint_agreement'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install agreement

*MiniTest*

```ruby
require 'blueprint_agreement'
```

## Usage

### Quick Start

Blueprint agreement works based on a markdown file with an valid API Blueprint format. Add your file into `/docs` folder in your project root folder (or set your custom documentation folder)

./docs/test.md

```
FORMAT: 1A

# The Simplest API

## API Blueprint

# GET /message
+ Request  200 (application/json)
+ Response 200 (application/json)

    + Body

            {
              'name': 'Hello World'
            }

```

Then, test your documentation:

```ruby

describe Test do
  it 'has a valid response' do
    get :index
    response.shall_agree_upon('test.md')
  end
end
```

### Debug Mode

use an env variable called `AGREEMENT_LOUD`

```bash
  $ AGREEMENT_LOUD=true rake test
```

Output:

```bash
...Drakov server output...
[DRAKOV] GET /message example

Method: GET
Path: http://localhost:8082/message

Headers:
Content-Type: application/json
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.example

Body:
{"param_1": "hi"}
```

### Configuration

`test/support/blueprint_agreement.rb`

```ruby
BlueprintAgreement.configure do |config|
  config.port = '8082'
  config.server_path = '.'
  config.exclude_attributes = ['field_name']
  config.allow_headers = ['Authorization', 'Cookie']
  config.request_headers = ['Authorization', 'Content-Type', 'Cookie']
end

# or
BlueprintAgreement.configuration.port = '8080'
BlueprintAgreement.configuration.server_path = '.'
```

### Allow Headers

This config option sets the `Access-Control-Allow-Headers` header.

More info: https://github.com/Aconex/drakov#allow-headers-header

### Exclude attributes

This config option intents to exclude attributes when the match is perform. It only works with **JSON structures**

Examples:

```ruby
# This excludes 'field_one' and the element 'sub_field_one' inside the 'field_two' array. It doesn't exclude 'field_two'.
BlueprintAgreement.configuration.exclude_attributes = ['field_one', field_two: [ 'sub_field_one' ]]

# This excludes 'field_one' and 'sub_field_four'. It doesn't exclude 'field_two' or 'sub_field_one'.
BlueprintAgreement.configuration.exclude_attributes = ['field_one', field_two: { sub_field_one: [ 'sub_field_four' ] } ]
```

### Request Headers

This option accepts an array allowing you to specify which headers should be sent to drakov when running tests.
You should use this option if you are using any custom headers, `Accept-Version` or `Api-Token` are examples of custom headers.

The default value is:

```ruby
[ "Content-Type", "Authorization", "Cookie" ]
```

## Contributing

1. Fork it ( http://github.com/charly-palencia/agreement/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
