local assets = require "src.assets"
local anim8 = require "lib.anim8"
local Explosion = require "src.entities.Explosion"
local gamestate = require "lib.gamestate"

local Pig = class "Pig"

-- ========== 猪精灵图设置 ==========
-- 静态属性：所有猪实例共享同一张精灵图
Pig.sprite = assets.img_pig -- pig.png（30x21像素精灵表）

function Pig:init(x, y, target)
    self.pos = { x = x, y = y }
    self.vel = { x = 0, y = 0 }
    self.gravity = 1300

    self.isAlive = true
    self.isEnemy = true
    self.isSolid = true

    self.platforming = {
        acceleration = 1000,
        speed = 60,
        jump = 250,
        friction = 2000,
        direction = 'r'
    }

    self.ai = {
        -- AI组件标记（具体逻辑在AISystem中）
    }

    self.hitbox = { w = 30, h = 21 } -- 碰撞盒与精灵尺寸匹配
    self.health = 50
    self.maxHealth = 50

    -- ========== 动画设置 ==========
    -- pig.png布局：一行5帧（站立1帧 + 行走4帧），每帧30x21像素
    local g = anim8.newGrid(30, 21, assets.img_pig:getWidth(), assets.img_pig:getHeight())

    -- 站立动画：第1帧
    self.animation_stand = anim8.newAnimation(g('1-1', 1), 0.1)

    -- 行走动画：第2-5帧（4帧循环）
    self.animation_walk = anim8.newAnimation(g('2-5', 1), 0.1)

    -- 初始动画
    self.animation = self.animation_stand

    -- ========== 渲染图层 ==========
    self.fg = true -- 前景层（与玩家同层）
end

function Pig:gotHit()
    if self.isAlive then
        self.isAlive = nil
        self.lifetime = 0.25
        self.fadeTime = 0.25
        self.alpha = 1
        self.ai = nil
        self.platforming.moving = false
        self.vel.y = -300
        self.vel.x = 0
        assets.snd_oink:play()
        assets.snd_yay:play()
        world:add(self)
        gamestate.current().score = gamestate.current().score + 1
    end
end

return Pig
