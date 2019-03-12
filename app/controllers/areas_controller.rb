class AreasController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  def index
  end

  def search
    if params[:zipcode]
      # hash形式でパラメタ文字列を指定し、URL形式にエンコード
      # params = URI.encode_www_form({zipcode: '7830060'})
      # URIを解析し、hostやportをバラバラに取得できるようにする
      # uri = URI.parse("http://zipcloud.ibsnet.co.jp/api/search?#{params}")
      uri = URI.parse("http://zipcloud.ibsnet.co.jp/api/search?zipcode=#{params[:zipcode]}")
      # リクエストパラメタを、インスタンス変数に格納
      @query = uri.query

      # 新しくHTTPセッションを開始し、結果をresponseへ格納
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        # 接続時に待つ最大秒数を設定
        http.open_timeout = 5
        # 読み込み一回でブロックして良い最大秒数を設定
        http.read_timeout = 10
        # ここでWebAPIを叩いている
        # Net::HTTPResponseのインスタンスが返ってくる
        http.get(uri.request_uri)
      end
      # 例外処理の開始
      begin
        # responseの値に応じて処理を分ける
        case response
        # 成功した場合
        when Net::HTTPSuccess
          # responseのbody要素をJSON形式で解釈し、hashに変換
          @result = JSON.parse(response.body)
          # 表示用の変数に結果を格納
          @zipcode = @result["results"][0]["zipcode"]
          @address1 = @result["results"][0]["address1"]
          @address2 = @result["results"][0]["address2"]
          @address3 = @result["results"][0]["address3"]
          @kana1 = @result["results"][0]["kana1"]
          @kana2 = @result["results"][0]["kana2"]
          @kana3 = @result["results"][0]["kana3"]
          flash[:alert] = @result["message"]
        # 別のURLに飛ばされた場合
        when Net::HTTPRedirection
          @message = "Redirection: code=#{response.code} message=#{response.message}"
          flash[:alert] = @result["message"]
        # その他エラー
        else
          @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
          flash[:alert] = @result["message"]
        end
      # エラー時処理
      rescue IOError => e
        @message = e
        flash[:alert] = @result["message"]
      rescue TimeoutError => e
        @message = e
        flash[:alert] = @result["message"]
      rescue JSON::ParserError => e
        @message = e
        flash[:alert] = @result["message"]
      rescue => e
        @message = e
        flash[:alert] = @result["message"]
      end

    end
    
  end

  def create
  end
end
