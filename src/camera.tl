require "src/mylib"

global record Camera
  pos: Point
  scaleX: number
  scaleY: number
  rotation: number

  set: function(Camera)
  unset: function(Camera)
  move: function(Camera, Point)
  rotate: function(Camera, number)
  scale: function(Camera, number, number)
  setPosition: function(Camera, Point)
  setScale: function(Camera, number, number)
  fromScreenPosition: function(Camera, Point): Point
end

global camera = {} as Camera
camera.pos = point(0,0)
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self.pos.x, -self.pos.y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(delta: Point)
  self.pos = self.pos + delta
end

function camera:rotate(dr: number)
  self.rotation = self.rotation + dr
end

function camera:scale(sx: number, sy: number)
  local old_width = self.scaleX * love.graphics.getWidth()
  local old_height = self.scaleY * love.graphics.getHeight()

  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)

  local new_width = self.scaleX * love.graphics.getWidth()
  local new_height = self.scaleY * love.graphics.getHeight()
  self.pos = self.pos - point((new_width - old_width) / 2, (new_height - old_height) / 2)
end

function camera:setPosition(position: Point)
  self.pos = position
end

function camera:setScale(sx: number, sy: number)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function camera:fromScreenPosition(position: Point): Point
  return point(position.x * self.scaleX + self.pos.x, position.y * self.scaleY + self.pos.y)
end
