# frozen_string_literal: true

Sequel.migration do
  up do
    create_table :currencies do
      Date    :date
      String  :iso_code
      Float   :rate

      index %i[date iso_code], unique: true
    end
  end

  down do
    drop_table :currencies
  end
end
