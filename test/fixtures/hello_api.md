FORMAT: 1A

# The Simplest API
This is one of the simplest APIs written in the **API Blueprint**. One plain
resource combined with a method and that's it! We will explain what is going on
in the next installment -
[Resource and Actions](02.%20Resource%20and%20Actions.md).

**Note:** As we progress through the examples, do not also forget to view the
[Raw](https://raw.github.com/apiaryio/api-blueprint/master/examples/01.%20Simplest%20API.md)
code to see what is really going on in the API Blueprint, as opposed to just
seeing the output of the Github Markdown parser.

Also please keep in mind that every single example in this course is a **real
API Blueprint** and as such you can **parse** it with the
[API Blueprint parser](https://github.com/apiaryio/drafter) or one of its
[bindings](https://github.com/apiaryio/drafter#bindings).

## API Blueprint
+ [This: Raw API Blueprint](https://raw.github.com/apiaryio/api-blueprint/master/examples/01.%20Simplest%20API.md)
+ [Next: Resource and Actions](02.%20Resource%20and%20Actions.md)

### Message [/message]

#### Valid response [GET]

+ Request

    + Headers

        Accept: application/json

+ Response 200 (application/json)

    + Body

            {
              "name": "Hello World"
            }

#### Not found response [GET]

+ Request

    + Headers

          Accept: application.404/json

+ Response 404 (application/json)

    + Body

            {
              "error": "Not found message"
            }

# POST /message/empty
+ Request  (application/json)
+ Response 204 (application/json)

    + Body

            {
              "name": "Hello World"
            }

# PATCH /message/1
+ Request (application/json)
+ Response 200 (application/json)

    + Body

            {
              "name": "Hello World"
            }

# GET /cookie
+ Request (application/json)

    + Headers

            Cookie: cookie=have-a-cookie

+ Response 200 (application/json)

    + Body

            {
              "cookie": "have a cookie!"
            }

# GET /extra_headers
+ Request (application/json)

    + Headers

            Cookie: cookie=have-a-cookie
            Accept: application/json
            Version: v1

+ Response 200 (application/json)

    + Body

            {
              "cookie": "have a cookie!"
            }
