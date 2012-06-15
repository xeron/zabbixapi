#!/usr/bin/ruby

require 'json'
require 'net/http'
require 'net/https'

module Zabbix

  class ZabbixError < RuntimeError
  end

  class ZabbixApi

    def initialize (api_url, api_user, api_password)
      @api_url = api_url
      @api_user = api_user
      @api_password = api_password
      @auth_id = nil
    end

    def do_request(message)

      id = rand 100_000

      message['id'] = id
      message['jsonrpc'] = '2.0'

      message_json = JSON.generate(message)

      uri = URI.parse(@api_url)
      http = Net::HTTP.new(uri.host, uri.port)

      if uri.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = Net::HTTP::Post.new(uri.request_uri)
      request.add_field('Content-Type', 'application/json-rpc')
      request.body=(message_json)

      begin
        response = http.request(request)
      rescue SocketError => e
        raise ZabbixError.new("Could not connect to #{@api_url}: #{e.message}")
      end

      if response.code != "200"
        raise ZabbixError.new("Response code is #{response.code}")
      end

      response_body_hash = JSON.parse(response.body)

      if response_body_hash.include?('error')

        e_message = response_body_hash['error']['message']
        e_data = response_body_hash['error']['data']
        e_code = response_body_hash['error']['code']

        error_message = "Code: #{e_code.to_s}. Data: #{e_data}. Message: #{e_message}."

        if e_code == -32602
          raise ZabbixError.new("Object already exists. #{error_message}")
        else
          raise ZabbixError.new(error_message)
        end
      end

      response_body_hash['result']
    end

    def send_request(message)
      message['auth'] = auth
      do_request(message)
    end

    def auth
      unless @auth_id
        auth_message = {
          'auth' =>  nil,
          'method' =>  'user.authenticate',
          'params' =>  {
            'user' => @api_user,
            'password' => @api_password,
            '0' => '0'
          }
        }

        @auth_id = do_request(auth_message)
      end

      return @auth_id
    end

    # Utils.
    def merge_opt(a, b)
      c = {}

      b.each_pair do |key, value|
        if a.has_key?(key)
          c[key] = value
        end
      end

      return a.merge(c)
    end

  end
end
