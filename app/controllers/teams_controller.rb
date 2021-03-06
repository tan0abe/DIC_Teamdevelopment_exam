class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy change_owner]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit
    # if current_user == @team.owner
    # else
    #   redirect_to @team, notice: 'チームのオーナーではないので編集出来ません！'
    # end

    redirect_to @team, notice: 'チームのオーナーではないので編集出来ません！' unless current_user == @team.owner
  end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: 'チーム作成に成功しました！'
    else
      flash.now[:error] = '保存に失敗しました、、'
      render :new
    end
  end

  def update
    if current_user == @team.owner
      if @team.update(team_params)
        redirect_to @team, notice: 'チーム更新に成功しました！'
      else
        flash.now[:error] = '保存に失敗しました、、'
        render :edit
      end
    else
      redirect_to @team, notice: 'チームのオーナーではないので編集出来ません！'
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'チーム削除に成功しました！'
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  def change_owner
    if @team.update(owner_id: params[:team][:user_id])
      ChangeOwnerMailer.change_owner_mail(@team.name, current_user.email,@team.owner.email).deliver
      redirect_to team_url(@team), notice: 'チームのオーナーを変更しました'
    else
      redirect_to team_url(@team), notice: 'チームのオーナーの変更が失敗しました'
    end
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end
end
