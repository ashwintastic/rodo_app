class ResultsController < ApplicationController

  def index
    results = Result.all
    render json: { results: results }
  end


  # Assuming bulk insert isn't supported as per the specs
  def create
    begin
      attrs = result_params
      Result.create(subject: attrs[:subject], timestamp: attrs[:timestamp], marks: attrs[:marks])
      render json: { message: 'Result Created', status: 200}
    rescue => err
      error = err.backtrace.join('\n')
      puts "Some error occurred #{error}"
      render json: {message: err, status: 500}
    end
  end

  def fetch_daily_stats
    begin
      stats = DailyResultStat.all
      render json: { message: stats, status: 200 }
    rescue => err
      error = err.backtrace.join('\n')
      puts "Some error occurred #{error}"
      render json: {message: error, status: 500 }
    end
  end



  def fetch_monthly_stats
    resp = Result.fetch_monthly_stats
    render json: {messsage:  resp }
  end

  private
    # Only allow a list of trusted parameters through.
    def result_params
      params.require(:result).permit(:subject, :timestamp, :marks)
    end
end
