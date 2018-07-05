require 'nokogiri'
require 'mechanize'
require 'open-uri'
require 'open_uri_redirections'
require 'csv'

DATA_DIR = "data-hold/nejm"
Dir.mkdir(DATA_DIR) unless File.exists?(DATA_DIR)

BASE_URL = "https://www.nejm.org"
LIST_URL = "https://www.nejm.org/medical-articles/editorial"

client = Mechanize.new
pager = Mechanize.new
client.get(LIST_URL) do |page|
  document = Nokogiri::HTML::Document.parse(page.body)
  rows = document.css('li.m-result')
    rows[1..-2].each do |row|
    
    hrefs = row.css('a.m-result__link').map{ |a|
      a['href'] if a['href'].match("NEJM")
    }.compact.uniq

    hrefs.each do |href|
      remote_url = BASE_URL + href
      puts remote_url
      local_fname = "#{DATA_DIR}/#{File.basename(href)}.html"
      puts local_fname

      unless File.exists?(local_fname)
      puts "Fetching #{remote_url}..."
      begin
        article_content = pager.get(remote_url).body
      rescue Exception=>e
        puts "Error: #{e}"
        sleep 5
      else
        File.open(local_fname, 'w'){|file| file.write(article_content)}
        puts "\t...Success, saved to #{local_fname}"
      ensure
        sleep 0 + rand
      end  # done: begin/rescue
    end # done: unless File.exists?
    end # done: hrefs.each
  end # done: rows.each
end
