local assets = require "src.assets"
local Explosion = require "src.entities.Explosion"

local Bullet = class("Bullet")

-- ========== 子弹静态属性 ==========
Bullet.speed = 480                -- 子弹速度（像素/秒）
Bullet.sprite = assets.img_bullet -- 子弹图片（单帧，4x4像素）

function Bullet:init(x, y, direction)
    -- ========== 位置和速度 ==========
    self.pos = { x = x, y = y }

    -- 根据发射角度计算速度向量
    self.vel = {
        x = self.speed * math.cos(direction), -- 水平分量
        y = self.speed * math.sin(direction)  -- 垂直分量
    }

    -- ========== 渲染相关 ==========
    self.offset = { x = 4, y = 4 }  -- 渲染偏移（中心对齐）
    self.rot = direction            -- 初始旋转角度
    self.drot = math.random() - 0.5 -- 随机旋转速度（制造翻滚效果）

    -- 背景层标记（子弹在玩家和敌人后面渲染）
    self.bg = true

    -- ========== 物理和逻辑属性 ==========
    self.hitbox = { w = 4, h = 4 } -- 小碰撞盒（4x4像素）
    self.bullet = true           -- 子弹标记
    self.isBullet = true         -- 碰撞过滤器用
    self.isSolid = true          -- 参与碰撞检测
    self.gravity = 1300          -- 受重力影响（子弹会下坠）
end

function Bullet:explode()
    world:remove(self)
    world:add(Explosion(self.pos.x - 32, self.pos.y - 60))
    assets.snd_thud:play()
end

-- 更新子弹状态（每帧调用）
function Bullet:update(dt)
    -- 旋转子弹（飞行中翻滚效果）
    self.rot = self.rot + self.drot * dt * 10
end

function Bullet:onCollision(col)
    self:explode()
    if col.other.isEnemy and col.other.gotHit then
        col.other:gotHit()
    end
end

return Bullet
