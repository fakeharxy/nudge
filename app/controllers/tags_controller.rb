class TagsController < ApplicationController
  before_action :set_tag, only: :show

  def index
    @taglist = Tag.in_order_of_most_used(current_user.id)
  end

  def show
    @secondslevel = true
    @notes = @tag.get_all_notes(current_user.id)
    @secondlist = @tag.get_all_seconds(current_user.id)
  end

  def changeimportance
    Tag.find_by(id:params['tagID']).set_importance = params['noteNum']
    redirect_to tags_path
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end
end
