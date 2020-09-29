#! /usr/bin/env ruby
# frozen_string_literal: true

def player
  raise ArgumentError if ARGV == []

  ARGV[0]
end

def extract_cards msg
  result = []
  msg.gsub(/を.+/, '').split("、").each do |card|
    if /\d+枚/ =~ card
      num = card.match(/\d+枚/).to_s.to_i
      card = card.match(/[^\d]+/).to_s
      num.times { result << card }
    else
      result << card
    end
  end

  result
end

player_name = player
log_text = `pbpaste`
commads = log_text.scan(/^#{player_name}は.+/)

my_cards = []
commads.each do |msg|
  msg.gsub! /#{player_name}は/, ''

  if msg.include?('獲得') || msg.include?('受け取')
    my_cards.push(*extract_cards(msg))
  elsif msg.include?('廃棄')
    extract_cards(msg).each do |card|
      my_cards.delete_at my_cards.index card
    end
  end

  p my_cards
end
