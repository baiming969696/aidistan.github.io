#!/usr/bin/env ruby
# encoding: UTF-8
#
# The Generator of my Windows-8-style website
# The only purpose is to manage contents and their layouts.
#
# Copyright 2013 Aidi Stan
#

require "rexml/document"

COLORS = ["#00aeef", "#ea428a", "#eed500", "#f5a70d", "#8bcb30", "#9962c1"]

# @param [Hash] opts
# @option opts [String] :hook HTML code to insert at MetroItem's tail
# @option opts [String] :icon Text to substitute the image icon
# @option opts [String] :rubybadge Rubybadge url
MetroItem = Struct.new(:name, :url, :title, :content, :opts) do
  def to_s(lang)
    REXML::Formatters::Pretty.new(4).write(to_html(lang), String.new)
  end
  def to_html(lang)
    # Root
    root = REXML::Element.new("div")
    root.add_attribute("class", "metroitem")
    # Icon
    ele = root.add_element("a")
    ele.add_attributes({
      "href" => self.url,
      "target" => "_blank",
    })
    if self.opts.is_a?(Hash) && self.opts[:icon]
      color = self.opts[:icon][:color] || COLORS[rand(COLORS.size)]
      size = self.opts[:icon][:size] || 20

      ele = ele.add_element("table")
      ele.add_attributes({
        "class" => "icon",
        "style" => "background-color: #{color}; font-size: #{size}px; line-height: #{size*1.5}px;",
      })
      ele.add_element(REXML::Document.new(self.opts[:icon][:text]).root)
    else
      ele.add_element("img").add_attributes({
        "class" => "icon",
        "alt"   => self.name,
        "src"   => (FileTest.exist?("images/#{self.name}.png") ? "images/#{self.name}.png" : "images/#{self.name}.jpg" ),
      })
    end 
    # Title
    ele = root.add_element("h4")
    ele.add_attribute("class", lang.to_s)
    ele.text = self.title[lang]
    # Content
    self.content[lang].split("\n").each do |p|
      # Parse in html way in case that some html codes live in the content
      ele = root.add_element(REXML::Document.new("<p class='#{lang}'>#{p}</p>").root)
    end
    # Options
    if self.opts.is_a? Hash
      if self.opts.include? :rubybadge
        ele = root.add_element("a")
        ele.add_attribute("href", self.opts[:rubybadge])
        ele.add_element("img").add_attributes({
          "class" => "rubybadge",
          "src" => self.opts[:rubybadge] + "@2x.png"
        })
      end
      if self.opts.include? :hook
        root.add_element(REXML::Document.new(self.opts[:hook]).root)
      end
    end
    return root
  end
end

MetroColumn = Struct.new(:name, :items)

class MetroTab
  attr_accessor :cols

  def initialize
    @cols = []
  end

  def push(*args)
    @cols.push *args
    return self
  end

  def to_s(lang)
    REXML::Formatters::Pretty.new(4).write(to_html(lang), String.new)
  end

  def to_html(lang)
    root = REXML::Element.new("table") 
    root.add_attributes({
      "border" => "0",
      "style" => "text-align:center;",
    })

    # Add rows
    root.add_element("tr") # Title row
    num_row = @cols.map{ |col| col.items.size }.max
    num_row.times do
      root.add_element("tr").add_attribute("style", "height:180px;")
    end

    # Add columns
    @cols.each_with_index do |col, index|
      # Add the title
      ele = root.elements[1].add_element("td")
      ele.add_attribute("style", "width:180px;float:left;")
      ele.add_element("h3").text = col.name

      # Add items
      col.items.size.times do |i|
        root.elements[2+i].add_element("td").add_element(col.items[i].to_html(lang))
      end

      # Add empty items
      (col.items.size+1).upto(num_row) do |i|
        root.elements[1+i].add_element("td")
      end

      # Add an empty column if next column has a name
      if @cols[index+1].is_a?(MetroColumn)
        root.elements[1].add_element("td").add_attribute("style", @cols[index+1].name == "" ? "width:0px;" : "width:50px;")
        num_row.times{ |i| root.elements[2+i].add_element("td") }
      end
    end

    return root
  end
end

class MetroPage
  TAB_SEPARATOR = "<hr style=\"margin:40px 0px 40px 0px; background-color:#FFFFFF; color:#FFFFFF; height:1px; border:0;\"/>\n"

  attr_accessor :tabs

  def initialize
    @tabs = []
  end

  def push(*args)
    @tabs.push *args
    return self
  end

  def build
    LANGUAGES.keys.each {|lang| File.open("index_#{lang}.html", "w").puts self.to_s(lang)}
    return self
  end

  def to_s(lang)
    rtn = File.open("sample_page.html").read
    rtn.sub!(/^\s+<!-- MetroPage.tabs -->/) do
      /^(?<indent> +)<!-- MetroPage.tabs -->/ =~ rtn
      @tabs.map { |tab| tab.to_s(lang).split("\n").map { |line| indent + line }.join("\n") }.join(TAB_SEPARATOR)
    end
    rtn.sub!(/^\s+<!-- MetroPage.LANGUAGES -->/) do
      /^(?<indent> +)<!-- MetroPage.LANGUAGES -->/ =~ rtn
      [
        '<li><a href="#">Language</a>',
        '    <ul class="subs">',
        LANGUAGES.keys.collect{|sym| "<li><a href=\"index_#{sym}.html\">#{LANGUAGES[sym]}</a></li>"},
        '    </ul>',
        '</li>',
      ].flatten.collect! { |line| indent + line }.join("\n")
    end
    return rtn
  end
end
