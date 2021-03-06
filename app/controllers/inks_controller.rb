class InksController < ApplicationController

  get "/inks/?" do
    @inks = Ink.all
    erb :"/inks/index.html"
  end

  get "/inks/new/?" do
    log_in!
    erb :"/inks/new.html"
  end

  get "/inks/:id/?" do
    @ink = Ink.find(params[:id])
    erb :"/inks/show.html"
  end

  get "/inks/:id/edit/?" do
    log_in!
    @ink = Ink.find(params[:id])
    redirect "/inks/#{@ink.id}" if !owner(@ink)
    erb :"/inks/edit.html"
  end

  post "/inks/?" do
    @ink = current_user.inks.new(params[:ink])
    brand = InkBrand.find_or_create_by(name: params[:brand])
    @ink.ink_brand = brand if brand.valid?

    if !@ink.save
      flash_error(@ink)
      redirect back
    end

    redirect "/inks/#{@ink.id}"
  end

  patch "/inks/:id/?" do
    @ink = Ink.find(params[:id])

    @ink.update(params[:ink])
    @ink.favorite = params[:ink][:favorite]  #explicitly set because params[ink][favorite] won't go through if it's false
    brand = InkBrand.find_or_create_by(name: params[:brand])
    @ink.ink_brand = brand.valid? ? brand : nil

    if !@ink.save
      flash_error(@ink)
      redirect back
    end

    redirect "/inks/#{@ink.id}"
  end

  delete "/inks/:id/delete/?" do
    @ink = Ink.find(params[:id])
    @ink.delete

    flash_message("Ink deleted", "success")
    redirect "/inks"
  end
end
