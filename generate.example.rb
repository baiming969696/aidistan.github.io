#!/usr/bin/env ruby
# encoding: UTF-8
require_relative "generator"

#
# LANGUAGES
#
LANGUAGES = {
  en:"English",
  cn:"简体中文",
}

#
# Create contents here
#
item_11 = MetroItem.new(
  "Adome",
  "http://aidistan.no-ip.org/Adome",
  {
    cn:"Aidi的个人博客",
    en:"Aidi's Blog",
  },
  {
    cn:"中文内容",
    en:"English content",
  }
)

item_21 = MetroItem.new(
  "Adome",
  "http://aidistan.no-ip.org/Adome",
  {
    cn:"Aidi的个人博客",
    en:"Aidi's Blog",
  },
  {
    cn:"中文内容",
    en:"English content",
  },
  {
    icon:{ text:"<tr><td>Aidi Stan</td></tr>", color:"#009000", size:25}
  }
)

item_22 = MetroItem.new(
  "Adome",
  "http://aidistan.no-ip.org/Adome",
  {
    cn:"Aidi的个人博客",
    en:"Aidi's Blog",
  },
  {
    cn:"中文内容",
    en:"English content",
  },
  {
    icon:{ text:"<tr><td>Now is<br />#{Time.now.hour}:#{Time.now.min}</td></tr>", color:"#009000", size:25}
  }
)

item_23 = MetroItem.new(
  "Adome",
  "http://aidistan.no-ip.org/Adome",
  {
    cn:"Aidi的个人博客",
    en:"Aidi's Blog",
  },
  {
    cn:"中文内容",
    en:"English content",
  },
  {
    icon:{ text:"<tr><td>Sep 20<br /><small>Aidi Stan</small></td></tr>", color:"#009000", size:25}
  }
)

#
# Create layouts here
#
col1 = MetroColumn.new("", [item_11])
col2 = MetroColumn.new("", [item_21, item_22, item_23])
tab = MetroTab.new.push(col1, col2)

#
# Create pages here
#
MetroPage.new.push(tab).build
