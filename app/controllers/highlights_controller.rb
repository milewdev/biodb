class HighlightsController < ApplicationController
  
    before_action :set_user
    before_action :set_highlight, only: [:show, :edit, :update, :destroy]

    # GET /users/1/highlights
    # GET /users/1/highlights.json
    def index
      @highlights = @user.highlights
    end

    # GET /users/1/highlights/1
    # GET /users/1/highlights/1.json
    def show
    end

    # GET /users/1/highlights/new
    def new
      @highlight = @user.highlights.new
    end

    # GET /users/1/highlights/1/edit
    def edit
    end

    # POST /users/1/highlights
    # POST /users/1/highlights.json
    def create
      @highlight = @user.highlights.new(highlight_params)

      respond_to do |format|
        if @highlight.save
          format.html { redirect_to user_highlight_path(@user, @highlight), notice: 'Highlight was successfully created.' }
          format.json { render :show, status: :created, location: @highlight }
        else
          format.html { render :new }
          format.json { render json: @highlight.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /users/1/highlights/1
    # PATCH/PUT /users/1/highlights/1.json
    def update
      respond_to do |format|
        if @highlight.update(highlight_params)
          format.html { redirect_to user_highlight_path(@user, @highlight), notice: 'Highlight was successfully updated.' }
          format.json { render :show, status: :ok, location: @highlight }
        else
          format.html { render :edit }
          format.json { render json: @highlight.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /users/1/highlights/1
    # DELETE /users/1/highlights/1.json
    def destroy
      @user.highlights.destroy(@highlight)
      respond_to do |format|
        format.html { redirect_to user_highlights_url(@user), notice: 'Highlight was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:user_id])
    end
    
    def set_highlight
      @highlight = @user.highlights.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def highlight_params
      params.require(:highlight).permit(:content)
    end

end
