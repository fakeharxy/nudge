class CompletesController < ApplicationController
  def index
    session['count'] = nil
    @notes = Complete.in_order_of_completion(current_user.id)
    @completes = true
  end

  def send_to_archive
    @note = Note.find(params[:id])
    @note.transfer_to_complete
    session['count'] = session['count'] - 1 if session['count']
    redirect_to notes_url
  end

  def destroy
    @note = Complete.find(params[:id])
    @note.destroy_with_tags
    respond_to do |format|
      format.html { redirect_to completes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
