class ExampleController < ApplicationController
  def index
    person = Person.new
    person.id = 1
    person.age = 40
    render json: JSONAPI::Serializer.serialize([person], is_collection: true)
  end
end
