local assets = require "src.assets"
local anim8 = require "lib.anim8"

local Explosion = class "Explosion"

-- ========== 爆炸特效精灵图 ==========
Explosion.sprite = assets.img_explosion -- explosion.png（64x64精灵表）

function Explosion:init(x, y)
	self.pos = { x = x, y = y }

	-- ========== 渲染图层 ==========
	self.bg = true -- 背景层（在角色后面显示）

	-- ========== 爆炸动画设置 ==========
	-- explosion.png布局：一行10帧，每帧64x64像素
	local g = anim8.newGrid(64, 64, assets.img_explosion:getWidth(), assets.img_explosion:getHeight())

	-- 播放第1-10帧，每帧0.05秒（总共0.5秒）
	self.animation = anim8.newAnimation(g('1-10', 1), 0.05)

	-- ========== 生命周期 ==========
	-- 动画播放完后自动销毁（9帧间隔 * 0.05秒 = 0.45秒）
	self.lifetime = 9 * 0.05
end

return Explosion
