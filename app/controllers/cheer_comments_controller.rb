class CheerCommentsController < ApplicationController
  # GET /cheer_comments
  # GET /cheer_comments.json
  def index
    @cheer_comments = CheerComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cheer_comments }
    end
  end

  # GET /cheer_comments/1
  # GET /cheer_comments/1.json
  def show
    @cheer_comment = CheerComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cheer_comment }
    end
  end

  # GET /cheer_comments/new
  # GET /cheer_comments/new.json
  def new
    @cheer_comment = CheerComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cheer_comment }
    end
  end

  # GET /cheer_comments/1/edit
  def edit
    @cheer_comment = CheerComment.find(params[:id])
  end

  # POST /cheer_comments
  # POST /cheer_comments.json
  def create
    @cheer_comment = CheerComment.new(params[:cheer_comment])

    respond_to do |format|
      if @cheer_comment.save
        format.html { redirect_to @cheer_comment, notice: 'Cheer comment was successfully created.' }
        format.json { render json: @cheer_comment, status: :created, location: @cheer_comment }
      else
        format.html { render action: "new" }
        format.json { render json: @cheer_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cheer_comments/1
  # PUT /cheer_comments/1.json
  def update
    @cheer_comment = CheerComment.find(params[:id])

    respond_to do |format|
      if @cheer_comment.update_attributes(params[:cheer_comment])
        format.html { redirect_to @cheer_comment, notice: 'Cheer comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cheer_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cheer_comments/1
  # DELETE /cheer_comments/1.json
  def destroy
    @cheer_comment = CheerComment.find(params[:id])
    @cheer_comment.destroy

    respond_to do |format|
      format.html { redirect_to cheer_comments_url }
      format.json { head :no_content }
    end
  end
end
