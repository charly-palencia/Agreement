require 'jsonapi-serializers'

class PersonSerializer
  include JSONAPI::Serializer

  attributes :id, :age
end
