Sequel.migration do
  change do
    create_table :shoutouts do
      primary_key :id
      String :exclamation, null: false
      String :name, null: false
      DateTime :posted_at
    end
  end
end

