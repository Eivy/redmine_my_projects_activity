class MyActivityController < ActivitiesController
  def index
    super
    events = @activity.events(@date_from, @date_to).select{|e,b| User.current.member_of?(e.project)}

    if events.empty? || stale?(:etag => [@activity.scope, @date_to, @date_from, @with_subprojects, @author, events.first, events.size, User.current, current_language])
      respond_to do |format|
        format.html {
          @events_by_day = events.group_by {|event| User.current.time_to_date(event.event_datetime)}
          render :layout => false if request.xhr?
        }
        format.atom {
          title = l(:label_activity)
          if @author
            title = @author.name
          elsif @activity.scope.size == 1
            title = l("label_#{@activity.scope.first.singularize}_plural")
          end
          render_feed(events, :title => "#{@project || Setting.app_title}: #{title}")
        }
      end
    end

  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
