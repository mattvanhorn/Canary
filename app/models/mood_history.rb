# This class abstracts the idea of 1 update/day/user
class MoodHistory

  def initialize(project, users = nil)
    @history = {}
    @project = project
    @user_ids = screen_users(users).uniq.map(&:id)
    @today = Time.zone.now.beginning_of_day
    @history = populated_history.sort.inject({}) {|hsh,(key,val)| hsh[key]=val; hsh}
  end

  def days
    @history.keys.sort
  end

  def [](datetime)
    @history[datetime.in_time_zone.beginning_of_day]
  end

  alias :on :[]

  def number_of_days
    @history.size
  end

  protected

  def screen_users(users)
    project_users = @project.users
    users_from_project = ((users || project_users) & project_users)
    if users && users.size > users_from_project.size
      warn("#{__FILE__}:#{__LINE__}: user ids: [#{(users - users_from_project).map(&:id).join(', ')}] were not associated with project and were ignored!")
    end
    users_from_project
  end

  def raw_data
    @raw_data ||= @project.mood_updates.includes(:membership).order('mood_updates.updated_at').group_by{|mu| mu.updated_at.in_time_zone.beginning_of_day }
  end

  def first_day
    raw_data.keys.first || @today
  end

  def total_days
    ((@today - first_day)/ 1.day).ceil
  end

  def populated_history
    populated = {}
    0.upto(total_days) do |num|
      key = (@today - num.days).in_time_zone
      days_updates = raw_data[key]
      if days_updates.present?
        populated[key] = @user_ids.map{|uid| days_updates.select{|mu|mu.user.id == uid}.last }
      else
        populated[key] = [nil] * @user_ids.size
      end
    end
    populated
  end
end