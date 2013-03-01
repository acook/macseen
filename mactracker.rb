#!/usr/bin/env ruby

require 'pry'
require 'sqlite3'
require 'data_mapper'
require 'dm-sqlite-adapter'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite:mactracker.db')

class MAC
  include DataMapper::Resource

  property :address,   String,   required: true,  key: true
  property :last_seen, DateTime, required: true
end

DataMapper.finalize
DataMapper.auto_upgrade!

while line = gets
  timestamp, address, *_ = line.strip.split ' '

  time = Time.parse timestamp

  mac = MAC.first_or_create address: address
  mac.last_seen = time
  mac.save
end
