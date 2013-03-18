class TemplatesController < ApplicationController
  unloadable
  menu_item :settings
  model_object WikiTemplates
  before_filter :find_project, :authorize , :only => [:new, :edit, :destroy]

  def index
  end

  def new
    #if  User.current.allowed_to?(:create_templates, @project) && request.post?
    if request.post?
      @mitemplate = WikiTemplates.new
      @mitemplate.text = params[:mitemplate][:text]
      @mitemplate.name = params[:mitemplate][:name]
      @mitemplate.visible_children = params[:mitemplate][:visible_children]
      @mitemplate.project_id = @project.id
      @mitemplate.author_id = User.current.id
      @mitemplate.save
      redirect_to :controller => 'projects', :action => 'settings', :tab => 'wiki_templates', :id => @project
    end
  end

  def destroy
    @mitemplate = WikiTemplates.find(params[:id])
    if @mitemplate
    #if User.current.allowed_to?(:delete_templates, @project)  && @mitemplate
      @mitemplate.destroy
      flash[:notice] = l(:label_template_delete)
    end
    redirect_to :controller => 'projects', :action => 'settings', :tab => 'wiki_templates', :id => @project
    return
  end

  def edit
    if request.post?
    #if User.current.allowed_to?(:edit_templates, @project) && request.post?
      @mitemplate = WikiTemplates.find(params[:id])
      @mitemplate.text = params[:mitemplate][:text]
      @mitemplate.name = params[:mitemplate][:name]
      @mitemplate.visible_children = params[:mitemplate][:visible_children]
      @mitemplate.project_id = @project.id
      @mitemplate.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to :controller => 'projects', :action => 'settings', :tab => 'wiki_templates', :id => @project
    else
      @mitemplate = WikiTemplates.find(params[:id])
    end
  end

  private

  def find_project
    begin
      @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end
end
