# frozen_string_literal: true

Sequel.migration do
  up do
    create_table :days do
      date  :date
      jsonb :rates
      index :date, unique: true
    end
    drop_table :currencies
  end

  down do
    create_table :currencies do
      date    :date
      string  :iso_code
      float   :rate
      index %i[date iso_code], unique: true
    end
    drop_table :days
  end
end
