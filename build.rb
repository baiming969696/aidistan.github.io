#!/usr/bin/env ruby
# encoding: UTF-8
require "metropage"
include MetroPage

#
# LANGUAGES
#
MetroPage::LANGUAGES = {
  en:"English",
  cn:"简体中文",
}

#
# Create contents here
#
tile_Adome = Tile.new(
  name:"Adome",
  url:"http://aidi.no-ip.org/Adome",
  title:{
    cn:"Aidi的个人博客",
    en:"Aidi's Blog",
  },
  content:{
    cn:"利用WordPress搭建的个人博客，通过多说同步至Qzone、人人、微博等平台。\n记录心情的点滴。",
    en:"My personal blog based on WordPress, using DuoShuo plugin to synchronize posts to social platforms.\n(In Chinese)",
  }
)
tile_AKB = Tile.new(
  name:"AKB",
  url:"http://aidi.no-ip.org/AKB",
  title:{
    cn:"Aidi的个人知识库",
    en:"Aidi's Knowledge Base",
  },
  content:{
    cn:"利用WordPress搭建的个人知识库，保存一些遇到过问题和解决方法，通过站内检索使用。\n记录探索的感动。",
    en:"My Knowledge database based on WordPress, recording the problems I met.\n(In Chinese)",
  }
)
tile_Github = Tile.new(
  name:"Github",
  url:"https://github.com/aidistan",
  title:{
    cn:"Github",
    en:"Github",
  },
  content:{
    cn:"我在Github参加的开源项目的列表。\n最爱的游乐园。",
    en:"A list of my publicly visible projects which interest me a lot.",
  },
)
tile_LinkedIn = Tile.new(
  name:"LinkedIn",
  url:"http://www.linkedin.com/in/aidistan",
  title:{
    cn:"LinkedIn",
    en:"LinkedIn",
  },
  content:{
    cn:"我在LinkedIn的简历。\nConnect me! :)",
    en:"My brief profile. Connect me :)",
  },
)
tile_Bioinfo = Tile.new(
  name:"Bioinfo",
  url:"http://aidistan.github.io/bioinfo/",
  title:{
    cn:"Bioinfo",
    en:"Bioinfo",
  },
  content:{
    cn:"最初是与生物信息学各种数据库交互的Ruby脚本的合集，现已整理为Ruby Gem库，并在持续地更新~",
    en:"A collection of my scripts used in bioinformatics database processing.",
  },
  other_rubybadge:"http://badge.fury.io/rb/bioinfo"
)
tile_MTG = Tile.new(
  name:"MTG-card",
  url:"http://aidistan.github.io/mtg/",
  title:{
    cn:"MTG-card",
    en:"MTG-card",
  },
  content:{
    cn:"为万智牌写的一个Ruby Gem，可以用来查询牌价和管理牌组。",
    en:"Library of MTG (Magic: The Gathering) for card price querying, deck managing and analysing.",
  },
  other_rubybadge:"http://badge.fury.io/rb/mtg-card"
)
tile_GuipengLee = Tile.new(
  name:"GuipengLee",
  url:"http://gplee.no-ip.org/",
  title:{
    cn:"Lee的网站",
    en:"Lee's Website",
  },
  content:{
    cn:"Lee用Python搭建的网站。",
    en:"Lee's website built by Python.",
  },
  icon_txt:"Lee",
  icon_txt_color:"#009000",
  icon_txt_size:50,
)
tile_Galaxy = Tile.new(
  name:"Galaxy",
  url:"http://galaxy.no-ip.info/",
  title:{
    cn:"Galaxy",
    en:"Galaxy",
  },
  content:{
    cn:"生物信息在线分析平台",
    en:"A online bioinformatics analysis platform.",
  },
)

#
# Create layouts here
#
col_sites = Column.new(name:"Sites").push tile_Adome, tile_AKB
col_pages = Column.new(name:"Pages").push tile_Github, tile_LinkedIn
col_libs = Column.new(name:"Featured Libs").push tile_Bioinfo, tile_MTG
col_links = Column.new(name:"Links").push tile_GuipengLee, tile_Galaxy

tab = Table.new.push col_sites, col_pages, col_libs, col_links

nav = {
  "Mirror" => { href:"#", children:{
    "Adome"  => "http://aidi.no-ip.org",
    "Github" => "http://aidistan.github.io",
    "TNlist" => "http://bioinfo.au.tsinghua.edu.cn/member/atan/",
    }
  }
}

#
# Create pages here
#
Page.new(
  name:"Root", 
  title:"Root | Aidi Stan", 
  left_bottom: ["Aidi Stan's Rootpage", "#"],
  right_bottom: "Copyright (C) 2013 Aidi Stan",
  nav:nav,
).push(tab).build
