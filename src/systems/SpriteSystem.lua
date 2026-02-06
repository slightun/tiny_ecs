-- ========== 精灵渲染系统 ==========
-- 负责渲染所有带有sprite组件的实体
-- 支持：静态图片、动画、透明度、旋转、缩放、水平/垂直翻转

local SpriteSystem = tiny.processingSystem(class "SpriteSystem")

function SpriteSystem:init(camera, layerFlag)
    self.camera = camera
    -- 过滤器：只处理有sprite、pos和特定图层标记的实体
    -- layerFlag可以是"bg"（背景层）或"fg"（前景层）
    self.filter = tiny.requireAll("sprite", "pos", layerFlag)
end

-- 渲染前：应用摄像机变换
function SpriteSystem:preProcess(dt)
    self.camera:apply()
end

-- 渲染后：移除摄像机变换，恢复颜色
function SpriteSystem:postProcess(dt)
    self.camera:remove()
    love.graphics.setColor(1, 1, 1, 1) -- 恢复完全不透明的白色
end

function SpriteSystem:process(e, dt)
    local an = e.animation     -- 动画对象（可选，来自anim8库）
    local alpha = e.alpha or 1 -- 透明度（0-1，用于淡入淡出效果）

    -- 获取渲染参数
    local pos = e.pos       -- 位置 {x, y}
    local sprite = e.sprite -- 精灵图片（Image对象）
    local scale = e.scale   -- 缩放 {x, y}（可选）
    local rot = e.rot       -- 旋转角度（弧度）（可选）
    local offset = e.offset -- 偏移量 {x, y}（可选）

    -- 解析参数（使用默认值）
    local sx = scale and scale.x or 1   -- X轴缩放，默认1
    local sy = scale and scale.y or 1   -- Y轴缩放，默认1
    local r = rot or 0                  -- 旋转角度，默认0
    local ox = offset and offset.x or 0 -- X偏移，默认0
    local oy = offset and offset.y or 0 -- Y偏移，默认0

    -- 设置透明度（限制在0-1范围内）
    love.graphics.setColor(1, 1, 1, math.max(0, math.min(1, alpha)))

    if an then
        -- ========== 动画渲染分支 ==========
        -- 处理水平/垂直翻转
        an.flippedH = e.flippedH or false -- 水平翻转（角色转身）
        an.flippedV = e.flippedV or false -- 垂直翻转（很少使用）

        -- 更新动画帧
        an:update(dt)

        -- 绘制当前动画帧
        -- anim8会自动从精灵表中选择正确的帧
        an:draw(sprite, pos.x, pos.y, r, sx, sy, ox, oy)
    else
        -- ========== 静态图片渲染分支 ==========
        -- 直接绘制整张图片（子弹、爆炸等单帧图）
        love.graphics.draw(sprite, pos.x, pos.y, r, sx, sy, ox, oy)
    end

    -- 如果实体有自定义draw方法，调用它（用于额外渲染，如炮管）
    if e.draw then
        e:draw(dt)
    end
end

return SpriteSystem
