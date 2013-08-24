#!/usr/bin/env ruby
# encoding: UTF-8
#
# The Generator of my Windows-8-style website
# The only purpose is to manage contents and their layouts.
#
# Copyright 2013 Aidi Stan
#

require "rexml/document"


#
# Definitions
#

$LANGUAGES = {
    en:"English",
    cn:"简体中文",
}

MetroItem = Struct.new(:name, :url, :title, :content, :others)
class MetroItem
    def to_html(lang)
        # Root
        root = REXML::Element.new "div"
        root.add_attribute "class", "metroitem"

        # Icon
        ele = root.add_element "a"
        ele.add_attribute "href", self.url
        ele = ele.add_element "img"
        ele.add_attributes({
            "alt" => self.name,
            "src" => "images/#{self.name}.png"
        })

        # Title
        ele = root.add_element "h4"
        ele.add_attribute "class", lang.to_s
        ele.text = self.title[lang]

        # Content
        self.content[lang].split("\n").each do |p|
            ele = root.add_element "p"
            ele.add_attribute "class", lang.to_s
            ele.text = p
        end

        # Others
        if self.others.is_a? Hash
            if self.others.include? :rubybadge
                ele = root.add_element "a"
                ele.add_attribute "href", self.others[:rubybadge]

                ele = ele.add_element "img"
                ele.add_attributes({
                    "class" => "metroitem_rubybadge",
                    "src" => self.others[:rubybadge]+"@2x.png"
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
        root.add_element("tr")
        num_row = @cols.map{|col| col.items.size}.max
        num_row.times do 
            ele = root.add_element("tr")
            ele.add_attribute "style", "height:180px;"
        end

        # Add columns
        @cols.each_with_index do |col, index|
            # Add the title
            ele = root.elements[1].add_element "td"
            ele.add_attribute "style", "width:180px;float:left;"
            ele = ele.add_element "h3"
            ele.text = col.name

            # Add items
            col.items.size.times do |i|
                ele = root.elements[2+i].add_element "td"
                ele.add_element col.items[i].to_html(lang)
            end

            # Add empty items
            (col.items.size+1).upto(num_row){|i| root.elements[1+i].add_element "td"}

            # Add an empty column if next column has a name
            if @cols[index+1].is_a? MetroColumn and !@cols[index+1].name.nil?
                ele = root.elements[1].add_element "td"
                ele.add_attribute "style", "width:50px;"
                num_row.times{|i| root.elements[2+i].add_element "td"}
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
        $LANGUAGES.keys.each {|lang| File.open("index_#{lang}.html", "w").puts self.to_s(lang)}
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


#
# Create contents here
#
item_Adome = MetroItem.new(
    "Adome",
    "http://aidistan.no-ip.org/Adome",
    {
        cn:"Aidi的个人博客",
        en:"Aidi's Blog",
    },
    {
        cn:"利用WordPress搭建的个人博客，通过多说同步至Qzone、人人、微博等平台。\n记录心情的点滴。",
        en:"My personal blog based on WordPress, using DuoShuo plugin to synchronize posts to social platforms.\n(In Chinese)",
    },
)

item_AKB = MetroItem.new(
    "AKB",
    "http://aidistan.no-ip.org/AKB",
    {
        cn:"Aidi的个人知识库",
        en:"Aidi's Knowledge Base",
    },
    {
        cn:"利用WordPress搭建的个人知识库，保存一些遇到过问题和解决方法，通过站内检索使用。\n记录探索的感动。",
        en:"My Knowledge database based on WordPress, recording the problems I met.\n(In Chinese)",
    }
)

item_Github = MetroItem.new(
    "Github",
    "https://github.com/aidistan",
    {
        cn:"Github",
        en:"Github",
    },
    {
        cn:"我在Github参加的开源项目的列表。\n最爱的游乐园。",
        en:"A list of my publicly visible projects which interest me a lot.",
    },
)

item_LinkedIn = MetroItem.new(
    "LinkedIn",
    "http://www.linkedin.com/in/aidistan",
    {
        cn:"LinkedIn",
        en:"LinkedIn",
    },
    {
        cn:"我在LinkedIn的简历。\nConnect me! :)",
        en:"My brief profile. Connect me :)",
    },
)

item_BioDB = MetroItem.new(
    "BioDB",
    "http://aidistan.github.io/biodb/",
    {
        cn:"BioDB",
        en:"BioDB",
    },
    {
        cn:"最初是与生物信息学各种数据库交互的Ruby脚本的合集，现已整理为Ruby Gem库，并在持续地更新~",
        en:"A collection of my scripts used in bioinformatics database processing.",
    },
    {
        rubybadge:"http://badge.fury.io/rb/biodb"
    },
)

item_MTG = MetroItem.new(
    "MTG-card",
    "http://aidistan.github.io/mtg/",
    {
        cn:"MTG-card",
        en:"MTG-card",
    },
    {
        cn:"为万智牌写的一个Ruby Gem，可以用来查询牌价和管理牌组。",
        en:"Library of MTG (Magic: The Gathering) for card price querying, deck managing and analysing.",
    },
    {
        rubybadge:"http://badge.fury.io/rb/mtg-card"
    },
)

item_GuipengLee = MetroItem.new(
    "GuipengLee",
    "http://gplee.no-ip.org/",
    {
        cn:"Lee的网站",
        en:"Lee's Website",
    },
    {
        cn:"Lee用Python搭建的网站。",
        en:"Lee's website built by Python.",
    },
)

#
# Create layouts here
#
col_sites = MetroColumn.new("Sites", [item_Adome, item_AKB])
col_pages = MetroColumn.new("Pages", [item_Github, item_LinkedIn])
col_libs = MetroColumn.new("Featured Libs", [item_BioDB, item_MTG])
col_links = MetroColumn.new("Links", [item_GuipengLee])

tab = MetroTab.new.push col_sites, col_pages, col_libs, col_links

#
# Create pages here
#
MetroPage.new.push(tab).build

