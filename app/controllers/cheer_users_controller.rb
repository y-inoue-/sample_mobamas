class CheerUsersController < ApplicationController
  # GET /cheer_users
  # GET /cheer_users.json
  def index
    @cheer_users = CheerUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cheer_users }
    end
  end

  # GET /cheer_users/1
  # GET /cheer_users/1.json
  def show
    @cheer_user = CheerUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cheer_user }
    end
  end

  # GET /cheer_users/new
  # GET /cheer_users/new.json
  def new
    @cheer_user = CheerUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cheer_user }
    end
  end

  # GET /cheer_users/1/edit
  def edit
    @cheer_user = CheerUser.find(params[:id])
  end

  # POST /cheer_users
  # POST /cheer_users.json
  def create
    @cheer_user = CheerUser.new(params[:cheer_user])

    respond_to do |format|
      if @cheer_user.save
        format.html { redirect_to @cheer_user, notice: 'Cheer user was successfully created.' }
        format.json { render json: @cheer_user, status: :created, location: @cheer_user }
      else
        format.html { render action: "new" }
        format.json { render json: @cheer_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cheer_users/1
  # PUT /cheer_users/1.json
  def update
    @cheer_user = CheerUser.find(params[:id])

    respond_to do |format|
      if @cheer_user.update_attributes(params[:cheer_user])
        format.html { redirect_to @cheer_user, notice: 'Cheer user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cheer_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cheer_users/1
  # DELETE /cheer_users/1.json
  def destroy
    @cheer_user = CheerUser.find(params[:id])
    @cheer_user.destroy

    respond_to do |format|
      format.html { redirect_to cheer_users_url }
      format.json { head :no_content }
    end
  end
end
