pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
  game = {}
  run_intro()
end

function _update()
  game.update()
end

function _draw()
  game.draw() 
end

function run_intro()
 game.update = intro_update
 game.draw = intro_draw
end

function intro_update()
 if btnp(4) then run_level() end
end

function intro_draw()
 cls()
 print("welcome to bob's donuts!",0,0,7)
 print("you are our newest recruit",0,14,7)
 print("bob has high hopes for you!",0,21,7)
 print("aim: correctly serve more than",0,35,7)
 print("20 donuts in 30 seconds",0,42,7)
 print("press z to start",0,56,7)
end

function run_level()
  instructions = {
    x = 81,
    y = 48,
    draw = function(self)
      local lx, ly = self.x, self.y
      rect(lx,ly,126,48 + 32 -1,7)
      lx += 2
      ly += 2
      print(food.instructions.up,lx,ly,7)
      ly += 6
      print(food.instructions.down,lx,ly,7)
      ly+=6
      print('❎ serve',lx,ly,7)
    end
  }

  score = 0
  timer = 0

  food = make_donut()
  food:assign_order()
  
  game.update = level_update
  game.draw = level_draw
end

function level_update()
 timer += 1/30 
 food:update()
 if timer > 30 then run_game_over() end
end

function level_draw()
  cls()
  rectfill(0,0,127,127,13) --backgorund
  if timer < 18 then
   print('time: '..flr(timer),0,0,11)
  else
   print('time: '..flr(timer),0,0,8)
  end
  print('score: '..score,0,10,7)
  rectfill(48,48,48 + 32 -1,48 + 32 -1,1) --stage
  -- line(0,63,63,63,0)
  -- line(63,63,63,127,0)
  rectfill(0,104,127,127,15) --order text
  food:draw()
  if food.is_staged then print(food.order.order_text,1,105,0) end--order text
  instructions:draw()
end

function make_donut()
  local d = {
    attrs = {
     choc = false,
     sprinkles = false
    },
    x = 0,
    y = 64 - (24/2),
    center_x = function(self)
     return self.x + (self.width/2)
    end,
    width = 16,
    height = 24,
    is_staged = false,
    assign_order = function(self)
     self.order = make_donut():attach_order()
    end,
    attach_order = function(self)
      local num = flr(rnd(4))
      if num == 0 then
        self.attrs.choc = true
        self.order_text = 'just chocolate please'
      elseif num == 1 then
        self.attrs.sprinkles = true
        self.order_text = 'i only want sprinkles'
      elseif num == 2 then
        self.attrs.choc = true
        self.attrs.sprinkles = true
        self.order_text = 'gimme everything!'
      else
        self.order_text = 'i like it plain'
      end
      return self
    end,
    update = function(self)
      if self.is_staged then
       if btnp(2) then self.attrs.choc = true end
       if btnp(3) then self.attrs.sprinkles = true end
       if btnp(5) then
         if self:matches_order() then score += 1 end
         food = make_donut()
         food:assign_order()
       end
      elseif self:center_x() > 64 then
       self.is_staged = true
       self.x = 64 - (self.width/2)
      else
       self.x += 4
      end
    end,
    draw = function(self)
      if self.attrs.choc == true then pal(15,4) end
      spr(0,self.x,self.y,1,3)
      spr(0,self.x + (self.width/2),self.y,1,3,true,false)
      if self.attrs.sprinkles then
        rect(64,67,65,68,11)
        rect(57,60,58,61,11)
        rect(65,58,66,59,14)
        pset(59,59,11)
        pset(63,56,14)
        pset(70,64,11)
        pset(61,67,14)
        pset(69,67,14)
        pset(59,69,11)
        pset(69,58,11)
      end
      line(self.x + self.width - 4,self.y + 9,self.x + self.width - 4,self.y + 9 + 4,7) -- shine
      pset(self.x + self.width - 4 - 1,self.y + 9 + 4 + 1,7) -- shine
      pal()
    end,
    instructions = {
      up = '⬆️ choc',
      down = '⬇️ sprnkls'
    },
    matches_order = function(self)
      local result = true
      for k, v in pairs(self.attrs) do
       if self.order.attrs[k] != self.attrs[k] then 
        result = false
        break 
       end
      end
      return result
    end
  }
  return d
end

function run_game_over()
 game.update = game_over_update
 game.draw = game_over_draw
end

function game_over_update()
 if btnp(4) then run_level() end
end

function game_over_draw()
 cls()
 rectfill(0,0,127,127,0) --backgorund
 print('outta time!',0,0,7)
 print('your score is: '..score,0,7,7)
 if score >= 18 then
  print('congrats! you beat a score of 18',0,14,7)
 else
  print('blud, you scored less than 18',0,14,7) 
 end
 print('hit z to replay',0,21,7)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000fffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0fffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffff99000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffff999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffff900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9fffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99ffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
099fffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
