#!/usr/bin/env ruby

require 'pry'
require 'sqlite3'
require 'data_mapper'
require 'dm-sqlite-adapter'

DataMapper.setup(:default, 'sqlite:macseen.db')

class MAC
  include DataMapper::Resource

  property :address,   String,   required: true,  key: true
  property :last_seen, DateTime, required: true
end

DataMapper.finalize
DataMapper.auto_upgrade!

def self.color new
  new ? "\e[31m" : "\e[32m"
end

def self.normal
  "\e[0m"
end

while line = gets
  timestamp, address, *_ = line.strip.split ' '

  time = Time.parse timestamp

  mac = MAC.first_or_create address: address
  new = !mac.last_seen

  mac.last_seen = time
  mac.save

  print "#{color new}.#{normal}"
end
