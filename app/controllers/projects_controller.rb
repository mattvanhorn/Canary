class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  autocomplete :company, :name, :full => true
  
  respond_to :html
  
  expose(:company) do 
    if params[:company_id] || params[:project]
      c_id = params[:company_id]
      if params[:project][:company_attributes]
        c_id ||= params[:project][:company_attributes][:id]
        if c_id
          Company.find_by_id(c_id)
        else
          Company.find_or_create_by_name(params[:project][:company_attributes][:name])
        end
      end
    end
  end
  
  expose(:projects) do
    if company
      company.projects
    else
      Project.scoped
    end
  end
  
  expose(:project)
  
  def create
    if current_user.join(project)
      redirect_to my_projects_url
    else
      render :action => 'new'
    end
  end
  
end
