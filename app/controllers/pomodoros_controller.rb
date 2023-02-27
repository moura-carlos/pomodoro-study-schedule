class PomodorosController < ApplicationController
  require 'csv'
  def index
    @intervals = []
    if params[:hours] && params[:minutes] && params[:start_time]
      study_hours = params[:hours].to_i
      study_minutes = params[:minutes].to_i
      start_time = Time.parse(params[:start_time])
      end_time = start_time + study_hours.hours + study_minutes.minutes
      @intervals = pomodoro_intervals(start_time, end_time)
    end
  end

  def export_csv
    intervals = pomodoro_intervals(Time.now, Time.now + 60.minutes)
    csv_string = CSV.generate do |csv|
      csv << ["Start Time", "End Time", "Duration", "Break Type"]
      intervals.each do |interval|
        start_time = interval[:start_time].strftime("%H:%M")
        end_time = interval[:end_time].strftime("%H:%M")
        duration = (interval[:end_time] - interval[:start_time]) / 60
        break_type = interval[:break_type].capitalize
        csv << [start_time, end_time, duration, break_type]
      end
    end
    send_data csv_string, filename: "pomodoro_intervals.csv"
  end

  def pomodoro_intervals(start_time, end_time)
    intervals = []
    current_time = start_time
    pomodoro_count = 0
    while current_time < end_time
      interval = {
        start_time: current_time,
        end_time: current_time + 25.minutes,
        break_type: "short"
      }
      intervals << interval
      current_time += 25.minutes
      pomodoro_count += 1
      if pomodoro_count % 4 == 0
        interval = {
          start_time: current_time,
          end_time: current_time + 30.minutes,
          break_type: "long"
        }
        intervals << interval
        current_time += 30.minutes
      else
        interval = {
          start_time: current_time,
          end_time: current_time + 5.minutes,
          break_type: "short"
        }
        intervals << interval
        current_time += 5.minutes
      end
    end
    intervals
  end
end
