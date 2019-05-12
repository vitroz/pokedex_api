require 'rails_helper'

RSpec.describe Pokemon, :type => :model do
  subject {
    described_class.new(name: "test")
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "is not valid without a name" do
  	subject.name = nil
    expect(subject).to_not be_valid
  end
  it "fails to save a pokemon with the same name as a pre-existent pokemon" do

    pokemon = Pokemon.create(:name => "Pkmn")
    pokemon_same = Pokemon.create(:name => "Pkmn")

    expect(pokemon_same.errors).not_to be_empty
  end
end