include DXOpal

GROUND_Y = 460
Image.register(:riokun, 'images/riokun.png')
Image.register(:nezumi, 'images/nezumi.png')
Image.register(:runba, 'images/runba.png')
Sound.register(:get, 'sounds/nakis.mov')
Sound.register(:explosion, 'sounds/nakim.mov')

GAME_INFO = {
  score: 0      # 現在のスコア
}

class Player < Sprite
  def initialize
    x = Window.width / 8
    y = GROUND_Y - Image[:riokun].height
    image = Image[:riokun]
    super(x, y, image)
    self.collision = [image.width / 2, image.height / 2, 16]
  end

  def update
    if Input.key_down?(K_LEFT) && self.x > 0
      self.x -= 8
    elsif Input.key_down?(K_RIGHT) && self.x < (Window.width - Image[:riokun].width)
      self.x += 8
    end
  end
end

class Item < Sprite
  def initialize(image)
    x = rand(Window.width - image.width)
    y = 0
    super(x, y, image)
    @speed_y = rand(5) + 3
  end

  def update
    self.y += @speed_y
    if self.y > Window.height
      self.vanish
    end
  end
end

class Nezumi < Item
  def initialize
    super(Image[:nezumi])
    self.collision = [image.width / 2, image.height / 2, 56]
  end

  def hit
    Sound[:get].play
    self.vanish
    GAME_INFO[:score] += 10
  end
end

class Runba < Item
  def initialize
    super(Image[:runba])
    self.collision = [image.width / 2, image.height / 2, 42]
  end

  def hit
    Sound[:explosion].play
    self.vanish
    GAME_INFO[:score] = 0
  end
end

class Items
  N = 2

  def initialize
    @items = []
  end

  def update(player)
    @items.each{|x| x.update(player)}
    Sprite.check(player, @items)
    Sprite.clean(@items)

    (N - @items.size).times do
      if rand(100) < 40
        @items.push(Nezumi.new)
      else
        @items.push(Runba.new)
      end
    end
  end

  def draw
    Sprite.draw(@items)
  end
end

Window.load_resources do
player = Player.new
  items = Items.new

  Window.loop do
    player.update
    items.update(player)

    Window.draw_box_fill(0, 0, Window.width, GROUND_Y, [0, 0, 0,])
    Window.draw_box_fill(0, GROUND_Y, Window.width, Window.height, [0, 128, 0])
    Window.draw_font(0, 0, "SCORE: #{GAME_INFO[:score]}", Font.default)
    player.draw
    items.draw
  end
end