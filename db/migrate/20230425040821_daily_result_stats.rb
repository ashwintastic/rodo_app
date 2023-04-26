class DailyResultStats < ActiveRecord::Migration[7.0]
  # TODO:: Apply pagination whenever required
  def change
    execute <<-SQL
    CREATE OR REPLACE VIEW daily_result_stats AS
      SELECT  date(timestamp) Date,  SUBJECT ,MIN(MARKS) DAILY_LOW, MAX(MARKS) DAILY_HIGH,
      COUNT(SUBJECT) DAILY_VOLUME from results GROUP BY SUBJECT,date(timestamp)
    SQL
  end
end
