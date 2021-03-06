class NotesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :set_note, only: [:seen, :show, :edit, :update, :destroy]
  before_action :run_clean_up, if: :clean_up_required?, only: [:index]
  # GET /notes
  # GET /notes.json

  def index
    if session['count'] == 0 || session['count'] == nil
      select
      @hide_write = true
      render :select
    elsif session['count'] == 1
      session['count'] = nil
      @hide_write = true
      flash.now[:notice] = "Well done on revisiting your notes!"
      render :select
    else
      @note = current_user.notes.get_most_urgent
      @progress = 100 - (((session['count']-2)/5.0) * 100)
    end
  end

  def view
    session[:count] = 6
    redirect_to notes_path
  end
  
  # GET /notes/1
  # GET /notes/1.json
  def show; end

  # GET /notes/new
  def new
    session['count'] = nil
    @note = Note.new
    @alltags = Tag.in_order_of_most_used(current_user.id).map{|n| n.name}
    @allseconds = Second.in_order_of_most_used(current_user.id).map{|n| n.name}.uniq
  end

  def clear
    session['count'] = nil
    redirect_to notes_path
  end

  def select
    @note = current_user.notes.get_most_urgent
    @progress = 15
  end

  # def selectvalue
  # session[:count] = params['id'].to_i
  # redirect_to notes_path
  # end

  # GET /notes/1/edit
  def edit; end

  # POST /notes
  # POST /notes.json
  def create
    importance = 11
    @note = Note.new(body: note_params['body'], last_seen: Date.today, user_id: current_user.id, importance: importance)
    @note.add_tag(note_params['tag'].chomp.downcase, current_user.id)
    @note.add_second(note_params['second'].chomp.downcase, @note.tag.id, current_user.id)
    respond_to do |format|
      if @note.save
        format.html { redirect_to notes_path, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { redirect_to notes_path, notice: @note.errors }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def seen
    @note.mark_as_seen(params['format'])
    session['count'] = session['count'] - 1
    redirect_to notes_path
  end

  def reset
    Note.reset_seen_status(current_user.id)
    session['count'] = nil
    respond_to do |format|
      format.html { redirect_to notes_path, notice: 'All notes reset.' }
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    @note.update(body: note_params['body'])
    oldtag = @note.tag
    oldsecond = @note.second
    @note.update_tag(note_params['tag'].chomp.downcase, current_user.id)
    @note.update_second(note_params['second'].chomp.downcase, @note.tag.id, current_user.id)
    oldtag.cleanup
    oldsecond.cleanup
    respond_to do |format|
      if @note.save
        format.html { redirect_to notes_path, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { redirect_to notes_path, notice: @note.errors}
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
