require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/cross_origin'
require 'sequel'
require 'json'
require 'sanitize'

DB = Sequel.sqlite

#DB = Sequel.connect('sqlite://db.db')

DB.create_table :providers do
  primary_key :id
  String :name
  String :slug
  String :url
  String :domain
end

providers = DB[:providers]
providers.insert(name: 'Berliner Stadtreinigung',
                 slug: 'bsr', url: 'https://www.bsr.de/',
                 domain: 'Entsorgung/ Reinigung')
providers.insert(name: 'Berliner Wasserbetriebe',
                 slug: 'bwb', url: 'http://www.bwb.de/',
                 domain: 'Wasserversorgung/ Abwasser')
providers.insert(name: 'Berliner Verkehrsbetriebe',
                 slug: 'bvg', url: 'http://www.bvg.de/',
                 domain: 'UBahn/ Bus/ Tram')
providers.insert(name: 'Stromnetz Berlin',
                 slug: 'sb', url: 'https://www.stromnetz.berlin',
                 domain: 'Stromversorgung')

DB.create_table :offers do
  primary_key :id
  Int :provider_id
  String :name
  String :description
  String :url
  String :domain
  String :type
end

offers = DB[:offers]
offers.insert(provider_id: 1, name: 'Foo', description: 'empty', url: 'http://emoty,de', domain: 'foo', type: 'dataset')

DB.create_table :pins do
  primary_key :id
  Int :provider_id
  String :name
  String :description
  String :like
  String :status
  String :comment
end

class Provider < Sequel::Model
  plugin :json_serializer, naked: true
  one_to_many :offers
  one_to_many :pins
end

class Offer < Sequel::Model
  plugin :json_serializer, naked: true
  many_to_one :provider
end

class Pin < Sequel::Model
  plugin :json_serializer, naked: true
  many_to_one :provider
end

#DB.create_table :

class App < Sinatra::Base
  helpers do

  end

  configure do
    enable :cross_origin
  end

  #enable :sessions
  set :json_encoder, :to_json

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  get '/' do
    slim :index
  end

  get '/api/providers' do
    json({ status: 'success',
           data: { providers: Provider.all } })
  end

  get '/api/providers/:slug' do
    slug = Sanitize.fragment(params[:slug])
    provider = Provider.where(slug: slug)

    if !provider.empty?
      json({ status: 'success',
             data: { providers: provider } })
    else
      json({ status: 'error',
             message: 'No such provider' })
    end
  end

  get '/api/providers/:slug/offers' do
    slug = Sanitize.fragment(params[:slug])
    provider = Provider.where(slug: slug)
    if !provider.empty?
      offers = Offer.where(provider_id: provider.first.id)
      json({ status: 'success',
             data: {
               provider: provider,
               offers: offers }})
    else
      json({ status: 'error',
             message: 'No such provider' })
    end
  end

  get '/api/providers/:slug/pins' do
    slug = Sanitize.fragment(params[:slug])
    provider = Provider.where(slug: slug)
    if !provider.empty?
      pins = Pin.where(provider_id: provider.first.id)
      json({ status: 'success',
             data: {
               provider: provider,
               pins: pins }})
    else
      json({ status: 'error',
             message: 'No such provider' })
    end
  end

  post '/api/providers/:slug/pins' do
    slug = Sanitize.fragment(params[:slug])
    provider = Provider.where(slug: slug)
    name = Sanitize.fragment(params[:name])
    description = Sanitize.fragment(params[:description])
    pin = Pin.new(provider_id: provider.first.id,
               name: name,
               description: description,
               status: 'neu')
    if pin.save
      json({ status: 'success',
             message: 'Pin created' })
    else
      json({ status: 'error',
             message: 'Pin could not be saved' })
    end
  end

  patch '/api/pin/:pin_id' do
    id = Sanitize.fragment(params[:slug]).to_i
    pin = Pin.where(id: id).first
    status = Sanitize.fragment(params[:status])
    comment = Sanitize.fragment(prams[:comment])
    if !pin.empty?
      pin.update(status: status, comment: comment)
      json({ status: 'success',
             data: {
               pin: pin }})
    else
      json({ status: 'error',
             message: 'Pin not found' })
    end
  end

  post '/api/pin/:pin_id/like' do
    id = Sanitize.fragment(params[:slug]).to_i
    pin = Pin.where(id: id).first
    like = pin.like + 1
    if !pin.empty?
      pin.update(like: like)
      json({ status: 'success',
             data: {
               pin: pin }})
    else
      json({ status: 'error',
             message: 'Pin not found' })
    end
  end

  options "*" do
    response.headers["Allow"] = "GET, POST, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end
end
