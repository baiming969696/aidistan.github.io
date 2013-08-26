#!/usr/bin/env ruby
# encoding: UTF-8
#
# The Generator of my Windows-8-style website
# The only purpose is to manage contents and their layouts.
#
# Copyright 2013 Aidi Stan
#

require "rexml/document"

LANGUAGES = {
  en:"English",
  cn:"简体中文",
}

MetroItem = Struct.new(:name, :url, :title, :content, :others)
class MetroItem
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
    ele.add_element("img").add_attributes({
        "alt" => self.name,
        "src" => "images/#{self.name}.png"
      })

    # Title
    ele = root.add_element("h4")
    ele.add_attribute("class", lang.to_s)
    ele.text = self.title[lang]

    # Content
    self.content[lang].split("\n").each do |p|
      ele = root.add_element("p")
      ele.add_attribute("class", lang.to_s)
      ele.text = p
    end

    # Others
    if self.others.is_a? Hash
      if self.others.include? :rubybadge
        ele = root.add_element("a")
        ele.add_attribute("href", self.others[:rubybadge])

        ele.add_element("img").add_attributes({
            "class" => "metroitem_rubybadge",
            "src" => self.others[:rubybadge] + "@2x.png"
          })
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
      if @cols[index+1].is_a? MetroColumn && !@cols[index+1].name.nil?
        root.elements[1].add_element("td").add_attribute("style", "width:50px;")
        num_row.times{ |i| root.elements[2+i].add_element("td") }
      end
    end

    return root
  end
end

class MetroPage
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
    return <<-HERE_DOC_END
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Root | Aidi Stan</title>
<link rel="stylesheet" type="text/css" href="aidi_style.css" media="all">
</head>
<body>
<div class="container">
  <div class="header">
    <table border="0">
      <tr style="width:20px">
        <td><h1 style="font-size: 300%; margin-top: 40px;">Root</h1></td>
      </tr>
    </table>
  </div><!-- end .header -->
  <div class="content">
#{
  @tabs.map{|tab| tab.to_s(lang).split("\n").map{|line| " "*8 + line}.join("\n")}.join("
    <hr style=\"margin:40px 0px 40px 0px; background-color:#FFFFFF; color:#FFFFFF; height:1px; border:0;\"/>\n")
}
  </div><!-- end .content -->
  <div class="footer">
    <hr/>
    <span class="fltlft">
      <!-- <p style="color: #AAAAAA;"><a href="#" style="color: #AAAAAA; text-decoration: none;">Aidi Stan's Homepage</a></p> -->
      <ul id="nav">
        <li><a href="#">Aidi Stan's Homepage</a>
        <li><a href="#">Language</a>
          <ul class="subs">
#{
  $LANGUAGES.keys.collect{|sym| " "*24 + "<li><a href=\"index_#{sym}.html\">#{$LANGUAGES[sym]}</a></li>"}.join("\n")
}
          </ul>
        </li>
        <li><a href="#">Mirror</a>
          <ul class="subs">
            <li><a href="http://aidistan.no-ip.org">Adome</a></li>
            <li><a href="http://aidistan.github.io">Github</a></li>
          </ul>
        </li>
      </ul>
    </span>
    <span class="fltrt">
      <p style="color: #AAAAAA;">Copyright (C) 2013 Aidi Stan</p>
    </span>
  </div><!-- end .footer -->
</div><!-- end .container -->
</body>
</html>
HERE_DOC_END
  end

end
