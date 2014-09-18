require 'spec_helper'

module Namespace
end

##
## named subject 'association' is the SUT
# args can be
# [:table_name] The table name
#
shared_examples_for "major version API compatible" do |args|
  table_name = args[:table_name]
  describe "Major version compatible with table name '#{table_name}'" do
    it "has table name '#{table_name}'" do
      expect(association.instance_variable_get(:@database_table)).to eq table_name
    end
  end
end

describe "PaperclipDatabase" do
  describe "backward compatibility" do
    describe "with default options" do
      before(:context) do
        create_model_tables :users, :avatars
        build_model 'User', nil, :avatar, {}
        reset_activerecord
        @model = User.new
        file = File.open(fixture_file('5k.png'))

        @model.avatar = file
        @model.save
      end
      subject(:association){@model.avatar}
      after(:context) do
        reset_activerecord
        reset_database :users, :avatars
      end
      it_behaves_like "major version API compatible", :table_name => 'avatars'
    end
    describe "with custom model table_name" do
      before(:context) do
        create_model_tables :custom_users, :avatars
        build_model 'CUser', 'custom_users', :avatar, {}
        @model = CUser.new
        file = File.open(fixture_file('5k.png'))

        @model.avatar = file
        @model.save
      end
      subject(:association){@model.avatar}
      after(:context) do
        reset_activerecord
        reset_database :custom_users, :avatars
      end
      it_behaves_like "major version API compatible", :table_name => 'avatars'
    end
    describe "with custom attachment table_name" do
      before(:context) do
        create_model_tables :a_users, :custom_avatars, 'avatar'
        build_model 'AUser', nil, :avatar, {:database_table => :custom_avatars}
        @model = AUser.new
        file = File.open(fixture_file('5k.png'))

        @model.avatar = file
        @model.save
      end
      subject(:association){@model.avatar}
      after(:context) do
        reset_activerecord
        reset_database :a_users, :custom_avatars
      end
      it_behaves_like "major version API compatible", :table_name => 'custom_avatars'
    end
    describe "with custom model table_name and attachment table_name" do
      before(:context) do
        create_model_tables :custom_users, :custom_avatars, 'avatar'
        build_model 'CaUser', 'custom_users', :avatar, {:database_table => :custom_avatars}
        @model = CaUser.new
        file = File.open(fixture_file('5k.png'))

        @model.avatar = file
        @model.save
      end
      subject(:association){@model.avatar}
      after(:context) do
        reset_activerecord
        reset_database :custom_users, :custom_avatars
      end
      it_behaves_like "major version API compatible", :table_name => 'custom_avatars'
    end
  end
end
