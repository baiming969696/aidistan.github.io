#!/usr/bin/env ruby
# encoding: UTF-8

require_relative "generator"

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

item_Galaxy = MetroItem.new(
  "Galaxy",
  "http://galaxy.no-ip.info/",
  {
    cn:"Galaxy",
    en:"Galaxy",
  },
  {
    cn:"生物信息在线分析平台",
    en:"A online bioinformatics analysis platform.",
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
col_links = MetroColumn.new("Links", [item_GuipengLee, item_Galaxy])

tab = MetroTab.new.push col_sites, col_pages, col_libs, col_links

#
# Create pages here
#
MetroPage.new.push(tab).build
