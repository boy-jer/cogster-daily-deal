class ProjectOption < ActiveRecord::Base
  validates_presence_of :description

  serialize :redemption_schedule, Array
  has_many :projects do
    def active
      where(['active = ?', true])
    end
  end
  attr_accessor :redemption_schedule_duration, :redemption_schedule_return
  before_validation :set_redemption_schedule
  validates_uniqueness_of :description, :redemption_schedule
  validate :cogsters_get_money_back
  before_destroy :check_for_active_projects

  def self.with_redemption_schedule(intervals)
    project = new
    intervals = 4 if intervals.blank?
    project.redemption_schedule = Array.new(intervals.to_i) do |n|
      { :percentage => 50, :duration => 7 }
    end
    project
  end

  def duration
    redemption_schedule.sum{|interval| interval[:duration].to_i }
  end

  def inactive?
    projects.active.empty?
  end

  def redemption_percentage(n)
    redemption_schedule[n][:percentage]
  end

  def redemption_period(n)
    wait = redemption_schedule[0...n].sum{|period| period[:duration] }
    start = Date.today + wait
    finish = start + redemption_schedule[n][:duration]
    [start, finish]
  end

  def redemption_schedule
    read_attribute(:redemption_schedule) || write_attribute(:redemption_schedule, [])
  end

  def redemption_total
    redemption_schedule.sum{|period| period[:percentage] } / 100.0
  end
  protected

    def check_for_active_projects
      projects.empty?
    end

    def cogsters_get_money_back
      if redemption_total < 1
        errors.add(:base, "The total return rate must be at least 100%")
      end
    end

    # ||= instead of = bc I set schedule directly in factories
    def set_redemption_schedule
      if redemption_schedule_duration
        self.redemption_schedule = redemption_schedule_duration.zip(redemption_schedule_return).map do |duration, percentage|
          { :duration => duration.to_i, :percentage => percentage.to_i }
        end
      end
    end
end

