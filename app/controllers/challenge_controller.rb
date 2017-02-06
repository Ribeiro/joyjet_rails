class ChallengeController < ApplicationController
  def home
    
  end

  def level1
    @data = get_json("https://bitbucket.org/lixao/tech-interview/raw/ccd601aa8cb60601ce7567ce0a7ec31925156e87/backend/level1/data.json")

    @articles = []
    @carts = []
    totals = []

    #Store fees in "fees" hash
    for i in 0..@data["articles"].size-1
      @articles << Article.new(@data["articles"][i])
    end

    # calculate carts' totals
    for i in 0..@data["carts"].size-1
      cart = Cart.new()
      price = 0
      for c in 0..@data["carts"][i]["items"].size-1
        item = Item.new(@data["carts"][i]["items"][c])
        for artic in @articles
          if (artic.id == item.article_id)
            price += item.quantity*artic.price
            break
          end
        end
      end
      totals << price
      @carts << cart
    end

    @hash = Hash.new
    @hash["carts"] = []

    #Create output hash
    for h in 1..@carts.size
      hashCart = Hash.new
      hashCart["id"] = h
      hashCart["total"] = totals[h-1]

      @hash["carts"] << hashCart
    end

    respond_to do |format|
      format.html { render "challenge/level1"}
      format.json { render json: JSON.pretty_generate(JSON.parse(@hash.to_json(:include =>{:category => {:only => [:category]} })))}
    end
  end

  def level2
    @data = get_json("https://bitbucket.org/lixao/tech-interview/raw/ccd601aa8cb60601ce7567ce0a7ec31925156e87/backend/level2/data.json")

    @fees = Hash.new
    @fees["delivery_fees"] = []

    #Store fees in "fees" hash
    for fee in 0..@data["delivery_fees"].size-1
      tier = Hash.new
      max = @data["delivery_fees"][fee]["eligible_transaction_volume"]["max_price"]
      min = @data["delivery_fees"][fee]["eligible_transaction_volume"]["min_price"]

      tier["min"] = @data["delivery_fees"][fee]["eligible_transaction_volume"]["min_price"]
      tier["max"] = @data["delivery_fees"][fee]["eligible_transaction_volume"]["max_price"]
      tier["price"] = @data["delivery_fees"][fee]["price"]

      @fees["delivery_fees"] << tier
    end

    @articles = []
    @carts = []
    totals = []

    #store articles in "@articles" for later use
    for i in 0..@data["articles"].size-1
      @articles << Article.new(@data["articles"][i])
    end

    # calculate carts' totals
    for c in 0..@data["carts"].size-1
      cart = Cart.new()
      price = 0
      for i in 0..@data["carts"][c]["items"].size-1
        item = Item.new(@data["carts"][c]["items"][i])
        for artic in @articles
          if (artic.id == item.article_id)
            price += item.quantity*artic.price
            break
          end
        end
      end
      totals << price
      @carts << cart
    end

    @hash = Hash.new
    @hash["carts"] = []

    # Calculate delivery fees' according to cart's total
    for c in 1..@carts.size
      hashCart = Hash.new
      hashCart["id"] = c
      for fee in 0..@fees["delivery_fees"].size-1
        if totals[c-1] >= @fees["delivery_fees"][fee]["min"] and @fees["delivery_fees"][fee]["max"] == nil
          totals[c-1] += @fees["delivery_fees"][fee]["price"]
          break
        end
        if totals[c-1] >= @fees["delivery_fees"][fee]["min"] and totals[c-1] < @fees["delivery_fees"][fee]["max"]
          totals[c-1] += @fees["delivery_fees"][fee]["price"]
        end
      end
      hashCart["total"] = totals[c-1]
      @hash["carts"] << hashCart
    end

    respond_to do |format|
      format.html { render "challenge/level2"}
      format.json { render json: JSON.pretty_generate(JSON.parse(@hash.to_json(:include =>{:category => {:only => [:category]} })))}
    end
  end

  def level3
    @data = get_json("https://bitbucket.org/lixao/tech-interview/raw/ccd601aa8cb60601ce7567ce0a7ec31925156e87/backend/level3/data.json")

    @fees = Hash.new
    @fees["delivery_fees"] = []
    
    #Store fees in "fees" hash
    for fee in 0..@data["delivery_fees"].size-1
      tier = Hash.new
      max = @data["delivery_fees"][fee]["eligible_transaction_volume"]["max_price"]
      min = @data["delivery_fees"][fee]["eligible_transaction_volume"]["min_price"]

      tier["min"] = @data["delivery_fees"][fee]["eligible_transaction_volume"]["min_price"]
      tier["max"] = @data["delivery_fees"][fee]["eligible_transaction_volume"]["max_price"]
      tier["price"] = @data["delivery_fees"][fee]["price"]

      @fees["delivery_fees"] << tier
    end

    @articles = []
    @carts = []
    totals = []

    #store articles in "@articles" for later use
    for artic in 0..@data["articles"].size-1
      @articles << Article.new(@data["articles"][artic])
    end

    # Recalculate articles prices according to its discounts
    for artic in 0..@articles.size-1
      for discount in 0..@data["discounts"].size-1
        if @articles[artic].id == @data["discounts"][discount]["article_id"]
          
          if @data["discounts"][discount]["type"] == "amount"
            @articles[artic].price -= @data["discounts"][discount]["value"]
          else
            @articles[artic].price = @articles[artic].price*(1.0-@data["discounts"][discount]["value"].to_f/100)
          end

        end
      end
    end

    # calculate carts' totals
    for c in 0..@data["carts"].size-1
      cart = Cart.new()
      price = 0
      for i in 0..@data["carts"][c]["items"].size-1
        item = Item.new(@data["carts"][c]["items"][i])
        for artic in @articles
          if (artic.id == item.article_id)
            price += item.quantity*artic.price
            break
          end
        end
      end
      totals << price
      @carts << cart
    end


    @hash = Hash.new
    @hash["carts"] = []


    # Calculate delivery fees' according to cart's total
    for c in 1..@carts.size
      hashCart = Hash.new
      hashCart["id"] = c

      for fee in 0..@fees["delivery_fees"].size-1
        
        if totals[c-1] >= @fees["delivery_fees"][fee]["min"] and @fees["delivery_fees"][fee]["max"] == nil
          totals[c-1] += @fees["delivery_fees"][fee]["price"]
          break
        end

        if totals[c-1] >= @fees["delivery_fees"][fee]["min"] and totals[c-1] < @fees["delivery_fees"][fee]["max"]
          totals[c-1] += @fees["delivery_fees"][fee]["price"]
          break
        end
      end

      hashCart["total"] = totals[c-1]
      @hash["carts"] << hashCart
    end

    respond_to do |format|
      format.html { render "challenge/level3"}
      format.json { render json: JSON.pretty_generate(JSON.parse(@hash.to_json(:include =>{:category => {:only => [:category]} })))}
    end
  end

  def get_json(url)
    # Read the url and return json string
		resp = Net::HTTP.get_response(URI.parse(url))
		data = resp.body
		result = JSON.parse(data)
	end
end