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
    zipcode = params[:zipcode]
    # getリクエストで遷移してきたときは処理させない条件分岐
    if zipcode
      @area = Area.new
      # areas_helper.rbにメソッドを記述
      api_request(zipcode)
    end
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
