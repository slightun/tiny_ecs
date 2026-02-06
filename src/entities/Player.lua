local assets = require "src.assets"
local anim8 = require "lib.anim8"
local Bullet = require "src.entities.Bullet"
local TimerEvent = require "src.entities.TimerEvent"
local ScreenSplash = require "src.entities.ScreenSplash"
local gamestate = require "lib.gamestate"

local Player = class("Player")

-- ========== 自定义渲染：绘制炮管 ==========
-- SpriteSystem会先绘制玩家主精灵，然后调用这个方法绘制炮管
function Player:draw(dt)
    if self.hasGun then
        local p = self.animation.position -- 当前动画帧位置
        -- 根据动画帧调整垂直偏移（不同帧高度略有不同）
        local dy = (p ~= 2 and p ~= 3) and 0 or -1
        -- 根据朝向调整水平偏移
        local dx = self.platforming.direction == 'l' and 2 or -2

        -- 绘制炮管图片
        -- 位置：玩家中心 + 偏移
        -- 角度：gunAngle - π/4（因为炮管图片本身有45度旋转）
        love.graphics.draw(
            assets.img_gun,             -- 炮管图片
            self.pos.x + 16 + dx,       -- X坐标（玩家中心+偏移）
            self.pos.y + 10 + dy,       -- Y坐标（炮管位置）
            self.gunAngle - math.pi / 4 -- 旋转角度（可被玩家控制）
        )
    end
end

function Player:onHit()
    self.isAlive = nil
    self.lifetime = 0.25
    self.fadeTime = 0.25
    self.alpha = 1
    self.ai = nil
    self.platforming.moving = false
    self.vel.y = -300
    self.vel.x = (math.random() - 0.5) * 400
    self.controlable = nil
    assets.snd_meow:play()
    world:add(self)
    local n = gamestate.current().score
    local message = "You Died."
    if n == 0 then
        message = "You Failed Pretty Hard."
    elseif n < 10 then
        message = "You Killed Some Pigs and They Killed you Back."
    elseif n < 30 then
        message = "That's a lot of Bacon."
    elseif n < 100 then
        message = "You a crazy Pig Killer."
    else
        message = "Pigpocolypse."
    end

    world:add(TimerEvent(1.2,
        function() world:add(ScreenSplash(0.5, 0.4, message .. " Press Space to Try Again.", 800)) end))
    gamestate.current().isSpawning = false
    gamestate.current().restartOnSpace = true
end

function Player:onCollision(col)
    if self.isAlive and col.other.isEnemy and col.other.isAlive then
        self:onHit()
    end
end

function Player:init(args)
    -- ========== 渲染相关组件 ==========

    -- 主精灵图：带炮的猫完整图（32x32像素）
    self.sprite = assets.img_catandcannon

    -- 图层标记：前景层（会被SpriteSystem(camera, "fg")处理）
    self.fg = true

    -- ========== 动画设置（使用anim8库）==========
    -- 从cat.png精灵表创建网格（每帧32x32）
    -- cat.png布局：一行5帧（站立1帧 + 行走4帧）
    local g = anim8.newGrid(32, 32, assets.img_cat:getWidth(), assets.img_cat:getHeight())

    -- 站立动画：第1帧，循环间隔0.1秒（实际只有1帧）
    self.animation_stand = anim8.newAnimation(g('1-1', 1), 0.1)

    -- 行走动画：第2-5帧，每帧0.1秒（4帧循环播放）
    self.animation_walk = anim8.newAnimation(g('2-5', 1), 0.1)

    -- 当前激活的动画（初始为站立）
    self.animation = self.animation_stand

    -- ========== 其他渲染属性 ==========
    -- 炮管相关
    self.hasGun = true          -- 是否显示炮管
    self.gunAngle = 2 * math.pi -- 炮管角度（2π = 360度 = 水平向右）

    -- ========== 非渲染组件（物理、逻辑等）==========
    self.cameraTrack = { xoffset = 16, yoffset = -35 }
    self.pos = { x = args.x, y = args.y }
    self.vel = { x = 0, y = 0 }
    self.gravity = 1300
    self.platforming = {
        acceleration = 1000,
        speed = 130,
        jump = 380,
        friction = 2000,
        direction = 'r'
    }
    self.isAlive = true
    self.isPlayer = true
    self.isSolid = true
    self.controlable = true
    self.hitbox = { w = 32, h = 32 }
    self.checkCollisions = true
    self.health = 100
    self.maxHealth = 100
    self.shotTimer = 0
    self.shotInterval = 0.45
end

return Player
