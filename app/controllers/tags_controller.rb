class TagsController < ApplicationController
  before_action :set_tag, only: :show

  def index
    @tags = Tag.all
  end

  def show
    @notes = @tag.get_all_notes
    @tags = current_user.tags_in_order_of_most_used
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end
end
