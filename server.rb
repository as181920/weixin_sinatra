# encoding: utf-8

require "sinatra"
require 'active_support/all'
require 'digest/md5'
require "yaml"
require "logger"

Log= Logger.new File.join(File.dirname(__FILE__),"log","#{Sinatra::Base.environment}.log"), "weekly"
#Log.level = Logger::INFO


class Server < Sinatra::Application
  get "/" do
    "hello weixin."
  end

  get "/auth" do
    if signature_valid?(signature= params[:signature], timestamp = params[:timestamp], nonce= params[:nonce] )
      Log.info("signature is ok and return #{params[:echostr]}")
      puts "signature is ok and return #{params[:echostr]}"
      params[:echostr]
    end
  end

  post "/" do
    ""
  end

  private
  def signature_valid?(signature,timestamp,nonce)
    token = YAML.load(File.read(File.join(File.dirname(__FILE__),"config/config.yml")))["token"]

    if token.present? and signature.present? and timestamp.present? and nonce.present?
      guess_signature = geneate_signature(token,timestamp,nonce)
      guess_signature.eql? signature
    end
  end

  def generate_signature(token,timestamp,nonce)
    signature = [token.to_s,timestamp.to_s,nonce.to_s].sort.join("")
    Digest::SHA1.hexdigest(signature)
  end

  # start the server if ruby file executed directly
  run! if app_file == $0

end


