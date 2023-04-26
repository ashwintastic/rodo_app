class Result < ApplicationRecord

  class << self

    def extract_subject_with_count(data_set)

      data_set.reduce({}) do |acc, ele|
        acc[ele[0]]=  ele[1].count
        acc
      end
    end

    def n_days_ago(days)
      (Date.today - days.send(:days))
    end

    def prepare_response(data_set)
      grouped_by = data_set.group_by(&:subject)
      grouped_by.reduce([]) do |memo, ele|
        acc = {}
        acc[:count] = ele[1].count
        acc[:subject] = ele[0]
        acc[:monthly_low] = ele[1].map{ | e| e.marks}.min
        acc[:monthly_high] = ele[1].map{ | e| e.marks}.max
        memo << acc
        memo
      end

    end

    def fetch_monthly_stats
      min_limit = 200
      days = 5

      below_threshold_lambda = ->(subject_with_count) {
        return subject_with_count.select { |_,v|
          v < min_limit
        }
      }

      data_set = Result.where("date(timestamp) > #{n_days_ago(days)}")
      subject_with_count = extract_subject_with_count(data_set.group_by(&:subject))
      oldest_day = Result.select(:timestamp).order(:timestamp).first.timestamp.to_date
      below_threshold = below_threshold_lambda[subject_with_count]

      while below_threshold.keys.count != 0 && n_days_ago(days) >= oldest_day
        data_set = Result.where("date(timestamp) >= #{n_days_ago(days)} and subject in (#{below_threshold.keys.map{|t|  "'" + t +"'"  }.join(',')})")
        subject_with_count = extract_subject_with_count(data_set.group_by(&:subject))
        below_threshold = below_threshold_lambda[subject_with_count]
        days += 1
      end
      prepare_response(data_set)
    end
  end
end
