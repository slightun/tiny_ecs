local multisource = require "lib.multisource"

local assets = {}

-- ========== 图形渲染设置 ==========
-- 设置纹理过滤模式为"最近邻"，保持像素风格（不模糊）
love.graphics.setDefaultFilter("nearest", "nearest")

-- ========== 图片资源加载 ==========
-- 玩家相关精灵图
assets.img_cat = love.graphics.newImage("assets/cat.png")                   -- 猫动画精灵表（行走/站立动画）
assets.img_catandcannon = love.graphics.newImage("assets/catandcannon.png") -- 带炮的猫完整图（玩家主精灵）
assets.img_gun = love.graphics.newImage("assets/gun.png")                   -- 炮管图片（可旋转）

-- 武器/特效精灵图
assets.img_bullet = love.graphics.newImage("assets/bullet.png")       -- 子弹精灵
assets.img_explosion = love.graphics.newImage("assets/explosion.png") -- 爆炸特效精灵表

-- 敌人相关精灵图
assets.img_pig = love.graphics.newImage("assets/pig.png")         -- 猪精灵表（行走/站立动画）
assets.img_spawner = love.graphics.newImage("assets/spawner.png") -- 敌人生成点标记图

-- ========== 音效资源加载 ==========
-- 使用multisource包装音效，支持同时播放多个相同音效
assets.snd_catjump = multisource.new(love.audio.newSource("assets/catjump.wav", "static")) -- 猫跳跃音效
assets.snd_cannon = multisource.new(love.audio.newSource("assets/cannon.wav", "static"))   -- 炮击音效
assets.snd_thud = multisource.new(love.audio.newSource("assets/thud.wav", "static"))       -- 爆炸撞击音效
assets.snd_meow = multisource.new(love.audio.newSource("assets/meow.ogg", "static"))       -- 猫死亡叫声
assets.snd_oink = multisource.new(love.audio.newSource("assets/oink.ogg", "static"))       -- 猪死亡叫声
assets.snd_yay = multisource.new(love.audio.newSource("assets/yay.wav", "static"))         -- 击杀敌人音效

-- 背景音乐（使用stream流式播放，节省内存）
assets.snd_music = love.audio.newSource("assets/music.ogg", "stream")

-- ========== 字体资源加载 ==========
assets.fnt_hud = love.graphics.newFont("assets/font.ttf", 48)            -- HUD大字体（分数、标题）
assets.fnt_smallhud = love.graphics.newFont("assets/font.ttf", 32)       -- HUD中字体（提示文本）
assets.fnt_reallysmallhud = love.graphics.newFont("assets/font.ttf", 24) -- HUD小字体（详细信息）


return assets
