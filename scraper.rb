require 'nokogiri'
require 'mechanize'
require 'open-uri'
require 'open_uri_redirections'

BASE_URL = "http://www.nejm.org"
LIST_URL = "http://www.nejm.org/medical-articles/editorial"

client = Mechanize.new
client.get(LIST_URL) do |page|
  document = Nokogiri::HTML::Document.parse(page.body)
  rows = page.css('li.m-result')
    rows[1..-2].each do |row|
    
    hrefs = row.css('a.m-result__link').map{ |a|
      a['href'] if a['href'].match("NEJM")
    }.compact.uniq

    hrefs.each do |href|
      remote_url = BASE_URL + href
      puts remote_url
    end # done: hrefs.each
  end # done: rows.each
end
