require "spec_helper"

RSpec.describe Panko::ArraySerializer do
  Foo = Struct.new(:name, :address, :data)

  class FooSerializer < Panko::Serializer
    attributes :name, :address
  end

  context "sanity" do
    it "serializers array of elements" do
      array_serializer = Panko::ArraySerializer.new([], each_serializer: FooSerializer)

      foo1 = Foo.new(Faker::Lorem.word, Faker::Lorem.word)
      foo2 = Foo.new(Faker::Lorem.word, Faker::Lorem.word)

      output = array_serializer.serialize [foo1, foo2]

      expect(output).to eq([
        { "name" => foo1.name, "address" => foo1.address },
        { "name" => foo2.name, "address" => foo2.address },
      ])
    end
  end

  context "filter" do
    it "only" do
      array_serializer = Panko::ArraySerializer.new([], each_serializer: FooSerializer, only: [:name])

      foo1 = Foo.new(Faker::Lorem.word, Faker::Lorem.word)
      foo2 = Foo.new(Faker::Lorem.word, Faker::Lorem.word)

      output = array_serializer.serialize [foo1, foo2]

      expect(output).to eq([
        { "name" => foo1.name },
        { "name" => foo2.name },
      ])
    end

    it "except" do
      array_serializer = Panko::ArraySerializer.new([], each_serializer: FooSerializer, except: [:name])

      foo1 = Foo.new(Faker::Lorem.word, Faker::Lorem.word)
      foo2 = Foo.new(Faker::Lorem.word, Faker::Lorem.word)

      output = array_serializer.serialize [foo1, foo2]

      expect(output).to eq([
        { "address" => foo1.address },
        { "address" => foo2.address },
      ])
    end
  end
end