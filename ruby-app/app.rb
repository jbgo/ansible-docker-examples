require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sequel'
require 'cgi'


def database_url
  db_name = ENV.fetch('DB_NAME')
  db_user = ENV.fetch('DB_USER')
  db_pass = ENV.fetch('DB_PASS')
  db_host = ENV.fetch('POSTGRES_PORT_5432_TCP_ADDR')
  db_port = ENV.fetch('POSTGRES_PORT_5432_TCP_PORT')
  "postgres://#{db_user}:#{db_pass}@#{db_host}:#{db_port}/#{db_name}"
end

DB = Sequel.connect ENV.fetch("DATABASE_URL", database_url)

helpers do
  def h(text)
    CGI.escape_html text
  end

  def missing?(field)
    params[field].to_s.strip.empty?
  end

  def find_shoutouts
    @shoutouts = DB[:shoutouts].reverse_order(:posted_at).limit(100)
  end
end

get '/' do
  @errors = []
  find_shoutouts
  erb :index
end

post '/shoutouts' do
  @errors = []
  @errors << 'Name is required' if missing? :name
  @errors << 'Exclamation is required' if missing? :exclamation

  if @errors.empty?
    DB[:shoutouts].insert({
      name: params[:name],
      exclamation: params[:exclamation],
      posted_at: Time.now
    })
    redirect to('/')
  else
    find_shoutouts
    erb :index
  end
end
