require 'open-uri'

#GOOGLE_KEY = 'SDeulnhQFHIK7kikQwIQSapNA5Q0C9d'

def search query, results=10
  query = query.gsub(/\W/) {|c| format '%%%02x', c[0]}
  url = "http://api.search.yahoo.com/WebSearchService/V1/webSearch?appid=fortunately&query=#{query}&type=phrase&results=#{results}&language=en"
  p url
  s = open(url) {|f|f.read}
  s.scan(/<Result>(.*?)<\/Result>/m).map do |result|
    Hash[*
        result.first.scan(/<([^>]+)>(.*?)<\/\1>/m).
        map {|k,v| [k.downcase.intern, v]}.flatten]
  end
end

def search query, count=10, start=1
  if count > 10
    return search(query, 10, start) + search(query, count-10, start+10)
  end
  require 'cgi'
  url = "http://www.google.com/search?hl=en&q=#{CGI::escape(query)}"
  url += "&start=#{start}" if start>1
  s = open(url) {|f| f.read}
  #return s
  s.scan(%r{<a class=l href="(.*?)".*?>(.*?)<.*?<td class=j>(.*?)\.\.\.}m).
    map{|url,title,s| {:url => url,
      :title => title,
      :sentence => s.gsub(%r{<.*?>}, '').gsub("\r\n", '')}}[0...count]
end

#p search('Fortunately, Oliver')

STOPS = %w{a an the and with without or by for a was is does doesn't isn't before to of in or his her their from most any some all when before after he she but as during which be than that will shall might must may can were was we since until} unless Object.const_defined?(:STOPS)

def fix_sentence s
  s.gsub! /.{20,},[^,]*$/, '\1'
  s.gsub! /\s+(and|but|so).*$/, ''
  s.gsub! /\s*\..*$/, ''
  while STOPS.include? s[/[\w\']+$/]
    s.gsub! /\s*\w+$/, ''
  end
  return s
end

module Fortunately
  def self.filter_results term
    first_word = term[/\W*(\w*)/, 1]
    results = search(term, 15)
    if true
      result = results.
        reject {|r| r[:url] =~ /osteele\.com/}.
        select {|r| r[:summary]}.
        each {|r| r[:summary].gsub!(/^\.*\s*/, '');
          r[:summary].gsub!(/\s*\.*$/, '')}.
        select {|r| i = r[:summary].index first_word;
          r[:sentence] = r[:summary][i..-1] if i}.
        each {|r| r[:sentence] = fix_sentence r[:sentence]}
      index = Hash[*results.reverse.map{|r|[r[:sentence], r]}.flatten]
      results = results.select {|r| index[r[:sentence]] == r}
      results = results.select {|r| r[:sentence].split.length > 4}
      results = results[0..[results.length,5].min]
    end
    results
  end
  
  def self.interleave term
    long = filter_results "'Fortunately, #{term}'"
    short = filter_results "'Unfortunately, #{term}'"
    long, short = short, long if short.length > long.length
    long.reverse!
    short.reverse!
    r = []
    while short.any?
      r << long.pop
      r << short.pop
    end
    r << long.pop unless long.empty?
    return r
  end
  
  def self.story_for term, include_url=false
    results = interleave term
    return 'Not enough search results.  Please try another term.' if results.length < 3
    i = 0
    results.each {|r| r[:sentence].sub!(/(\w+)/, '<em>\1</em>')}
    results.map {|r| r[:sentence].sub(/\.?$/, '.')+%Q{<a href="#{r[:url]}" title="&ldquo;&hellip;#{r[:summary]}&hellip;&rdquo; &mdash; #{r[:title]}"><sup>#{i+=1}</sup></a>}}.join("\n")
  end
end

#puts Fortunately.story_for('Oliver')
