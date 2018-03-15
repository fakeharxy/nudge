class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [:seen, :show, :edit, :update, :destroy]
  before_action :set_tags, only: [:new, :index, :show, :edit, :update]
  # GET /notes
  # GET /notes.json
  def index
    run_clean_up if clean_up_required?
    @note = current_user.notes.get_most_urgent
  end

  # GET /notes/1
  # GET /notes/1.json
  def show; end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit; end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(body: note_params['body'], last_seen: Date.today, user_id: current_user.id)
    @note.add_tag(note_params['tag'].chomp.downcase, current_user.id)
    @note.add_second(note_params['second'].chomp.downcase, @note.tag.id)
    respond_to do |format|
      if @note.save
        format.html { redirect_to notes_path, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def seen
    @note.mark_as_seen
    redirect_to notes_path
  end

  def reset
    Note.reset_seen_status(current_user.id)
    redirect_to notes_path
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    @note.update(body: note_params['body'])
    @note.update_tag(note_params['tag'].chomp.downcase)
    @note.update_second(note_params['second'].chomp.downcase)
    respond_to do |format|
      if @note.save
        format.html { redirect_to notes_path, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy_with_tags
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = Note.find(params[:id])
  end

  def set_tags
    @tags = current_user.tags_in_order_of_most_used
  end

  def clean_up_required?
    current_user.last_cleanup != Date.today
  end

  def run_clean_up
    Note.reset_seen_status(current_user.id)
    current_user.update(last_cleanup: Date.today)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def note_params
    params.require(:note).permit(:body, :tag, :second)
  end
end
