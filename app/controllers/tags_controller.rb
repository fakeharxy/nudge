class TagsController < ApplicationController
  before_action :set_tag, only: :show

  def index
    @tags = Tag.in_order_of_most_used(current_user.id)
    @taglist = Tag.get_all_primary_tags(current_user.id).sort_by{|t| - t.importance}
  end

  def show
    @notes = @tag.get_all_notes
    @tags = current_user.tags_in_order_of_most_used
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
