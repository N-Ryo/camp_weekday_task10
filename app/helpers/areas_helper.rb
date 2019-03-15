module AreasHelper

  def api_request(zipcode)
    begin 
      # URIを解析し、hostやportをバラバラに取得できるようにする
      uri = URI.parse("http://zipcloud.ibsnet.co.jp/api/search?zipcode=#{zipcode}")
      # 新しくHTTPセッションを開始し、結果をresponseへ格納
      response = Net::HTTP.get_response(uri)
    rescue
      flash.now[:alert] = "郵便番号を入力してください"
      return render :search
    end
    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
      # 成功した場合
      when Net::HTTPOK
        # responseのbody要素をJSON形式で解釈し、hashに変換
        @result = JSON.parse(response.body)
        # 郵便番号が見つからなかったときは空のresponse.bodyが空になるが、statusは200となるためバリデーションを組む。
        if @result["results"].nil? && @result["status"] == 200
          flash.now[:alert] = "郵便番号が見つかりませんでした。"
          return render :search
        end
        # 表示用の変数に結果を格納
        @area.zipcode = @result["results"][0]["zipcode"]
        @area.prefcode = @result["results"][0]["prefcode"]
        @area.address1 = @result["results"][0]["address1"]
        @area.address2 = @result["results"][0]["address2"]
        @area.address3 = @result["results"][0]["address3"]
        @area.kana1 = @result["results"][0]["kana1"]
        @area.kana2 = @result["results"][0]["kana2"]
        @area.kana3 = @result["results"][0]["kana3"]
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue
      flash.now[:alert] = @result["message"]
      render :search
    end
  end
end
