class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.string :subject
      t.timestamp :timestamp
      t.float :marks

      t.timestamps
    end
  end
end
