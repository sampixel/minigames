--[[
MIT License

Copyright (c) 2021 sampixel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local graphics = love.graphics
local cw = graphics.getWidth()
local ch = graphics.getHeight()

local lib = {}

lib.list = {}
lib.list.mode = {"norm", "quad"}
lib.list.format = {"png", "jpg", "bmp", "tga", "hdr", "pic", "exr"}

function lib.mode(m) -- check if self.mode is in array
  for i = 1, #lib.list.mode do
    if (m == lib.list.mode[i]) then
      return true
    end
  end
end

function lib.format(f) -- check if format image is in array
  for i = 1, #lib.list.format do
    if (f == lib.list.format[i] or f == "jpeg") then
      return true
    end
  end
end

function lib.line(s)
  graphics.setColor(1, 1, 1, 1)
  if (s.mode == "norm") then
    graphics.line(s.x, s.y, s.x + s.width, s.y, s.x + s.width, s.y + s.height, s.x, s.y + s.height, s.x, s.y)
  elseif (s.mode == "quad") then
    graphics.line(
      s.x, s.y,
      s.x + (s.frame.width * s.scale.x), s.y,
      s.x + (s.frame.width * s.scale.y),
      s.y + (s.frame.height * s.scale.y), s.x,
      s.y + (s.frame.height * s.scale.y),
      s.x, s.y
    )
  end
end

function lib.load(s, v, d)
  assert(d, "Could not find image directory")
  assert(s.mode, "Could not find mode")
  assert(lib.mode(s.mode), "Could not load mode due to its wrong value: \"" .. s.mode .. "\"")
  assert(lib.format(s.filename:sub(-3, #s.filename)), "Missing image format from filename: \"" .. s.filename .. "\"")

  if (v) then
    assert(type(v) == "number", "Wrong type of value parameter: number expected")
    if (s.mode == "norm" and value) then
      assert(s.mode == "norm" and value == 1,  "Wrong value parameter: range=1-1")
      assert(s.x, "Missing x number value")
      assert(s.y, "Missing y number value")
      assert(s.scale,    "Missing scale table value")
      assert(s.scale.x,  "Missing scale.x number value")
      assert(s.scale.y,  "Missing scale.y number value")
      assert(type(s.x) == "number", "Wrong type in x: number expected")
      assert(type(s.y) == "number", "Wrong type in y: number expected")
      assert(type(s.scale) == "table",     "Wrong type in scale: table expected")
      assert(type(s.scale.x) == "number",  "Wrong type in scale.x: number expected")
      assert(type(s.scale.y) == "number",  "Wrong type in scale.y: number expected")
    elseif (s.mode == "quad" and value) then
      assert(s.mode == "quad" and value > 0 and value < 6, "Wrong value parameter: range=1-5")
      assert(s.scale,   "Missing scale table value")
      assert(s.scale.x, "Missing scale.x number value")
      assert(s.scale.y, "Missing scale.y number value")
      assert(s.frame,       "Missing frame table value")
      assert(s.frame.rows,  "Missing frame.rows number value")
      assert(s.frame.cols,  "Missing frame.cols number value")
      assert(s.button,        "Missing button table value")
      assert(s.button.top,    "Missing button.top string value")
      assert(s.button.bottom, "Missing button.bottom string value")
      assert(s.button.right,  "Missing button.right string value")
      assert(s.button.left,   "Missing button.left string value")
      assert(s.sequence,        "Missing sequence table value")
      assert(s.sequence.top,    "Missing sequence.top table value")
      assert(s.sequence.bottom, "Missing sequence.bottom table value")
      assert(s.sequence.right,  "Missing sequence.right table value")
      assert(s.sequence.left,   "Missing sequence.left table value")
      assert(s.sequence.top.start,    "Missing sequence.top.start number value")
      assert(s.sequence.top.count,    "Missing sequence.top.count number value")
      assert(s.sequence.bottom.start, "Missing sequence.bottom.start number value")
      assert(s.sequence.bottom.count, "Missing sequence.bottom.count number value")
      assert(s.sequence.right.start,  "Missing sequence.right.start number value")
      assert(s.sequence.right.count,  "Missing sequence.right.count number value")
      assert(s.sequence.left.start,   "Missing sequence.left.start number value")
      assert(s.sequence.left.count,   "Missing sequence.left.count number value")
      assert(type(s.scale) == "table",    "Wrong type in scale: table expected")
      assert(type(s.scale.x) == "number", "Wrong type in scale.x: number expected")
      assert(type(s.scale.y) == "number", "Wrong type in scale.y: number expected")
      assert(type(s.frame) == "table",        "Wrong type in frame: table expected")
      assert(type(s.frame.rows) == "number",  "Wrong type in frame.rows: number expected")
      assert(type(s.frame.cols) == "number",  "Wrong type in frame.cols: number expected")
      assert(type(s.button) == "table",         "Wrong type in button: table expected")
      assert(type(s.button.top) == "string",    "Wrong type in button.top: string expected")
      assert(type(s.button.bottom) == "string", "Wrong type in button.bottom: string expected")
      assert(type(s.button.right) == "string",  "Wrong type in button.right: string expected")
      assert(type(s.button.left) == "string",   "Wrong type in button.left: string expeceted")
      assert(type(s.sequence) == "table",         "Wrong type in sequence: table expected")
      assert(type(s.sequence.top) == "table",     "Wrong type in sequence.top: table expected")
      assert(type(s.sequence.bottom) == "table",  "Wrong type in sequence.bottom: table expected")
      assert(type(s.sequence.right) == "table",   "Wrong type in sequence.right: table expected")
      assert(type(s.sequence.left) == "table",    "Wrong type in sequence.left: table expected")
      assert(type(s.sequence.top.start) == "number",    "Wrong type in sequence.top.start: number expected")
      assert(type(s.sequence.top.count) == "number",    "Wrong type in sequence.top.count: number expected")
      assert(type(s.sequence.bottom.start) == "number", "Wrong type in sequence.bottom.start: number expected")
      assert(type(s.sequence.bottom.count) == "number", "Wrong type in sequence.bottom.count: number expeceted")
      assert(type(s.sequence.rights.start) == "number", "Wrong type in sequence.right.start: number expected")
      assert(type(s.sequence.right.count) == "number",  "Wrong type in sequence.right.count: number expected")
      assert(type(s.sequence.left.start) == "number",   "Wrong type in sequence.left.start: number expected")
      assert(type(s.sequence.left.count) == "number",   "Wrong type in sequence.left.count: number expected")
    end
  end
end

function lib.animate(s, e, d)
  assert(e, "Missing execute parameter: \"walk\" or \"idle\"")
  assert(d, "Missing direction parameter: \"top\", \"bottom\", \"right\" or \"left\"")
  assert(type(e) == "string", "Wrong type on execute parameter: string expected")
  assert(type(d) == "string", "Wrong type on direction parameter: strin expected")
end

return lib
