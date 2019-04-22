class AreasController < ApplicationController
  # apiリクエストが送れるようになるやつ
  require 'net/http'
  # URI::HTTPの形に整形してくれるやつ
  require 'uri'
  # api_requestメソッドを使用可能にする
  include AreasHelper
  
  def index
    @areas = Area.all
  end

  def search
  end

  def form
    @area = Area.new
    # areas_helper.rbにメソッドを記述
    api_request(params[:zipcode])
  end

  def create
    @area = Area.new(area_params)
    # @areaのバリデーション判定
    if @area.save
      flash[:notice] = '地域を登録しました。'
      redirect_to root_path
    else
      flash.now[:alert] = "Validation failed: #{@area.errors.full_messages.join}"
      render :form
    end
  end

  private
    def area_params
      params.require(:area).permit!
    end
end
