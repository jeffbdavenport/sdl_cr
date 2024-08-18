require "./color"

module SDL
  @[Extern]
  struct Point
    property x : Int32
    property y : Int32

    macro [](x, y)
      SDL::Point.new({{x}}, {{y}})
    end

    def initialize(x : Number, y : Number)
      @x = x.to_i32
      @y = y.to_i32
    end

    def -(other : Point)
      self.class.new(x - other.x, y - other.y)
    end

    def +(other : Point)
      self.class.new(x + other.x, y + other.y)
    end

    def *(other : Point)
      self.class.new(x * other.x, y * other.y)
    end
  end

  @[Extern]
  struct FPoint
    property x : Float32
    property y : Float32

    def initialize(x : Number, y : Number)
      @x = x.to_f32
      @y = y.to_f32
    end

    def -(other : FPoint)
      self.class.new(x - other.x, y - other.y)
    end

    def +(other : FPoint)
      self.class.new(x + other.x, y + other.y)
    end

    def *(other : FPoint)
      self.class.new(x * other.x, y * other.y)
    end
  end

  @[Extern]
  struct Vertex
    @@color = Color.new(255, 255, 255)
    property position : FPoint
    property color : Color = @@color
    property tex_coord : FPoint

    def initialize(position : Tuple(Number, Number), tex_coord : Tuple(Number, Number))
      @position = FPoint.new(*position.map(&.to_f32))
      @tex_coord = FPoint.new(*tex_coord.map(&.to_f32))
    end

    def initialize(@position, @tex_coord, color : Color? = nil)
      @color = color if color
    end
  end

  @[Extern]
  struct Rect
    property x : Int32
    property y : Int32
    property w : Int32
    property h : Int32

    macro [](x, y, w, h)
      SDL::Rect.new({{x}}, {{y}}, {{w}}, {{h}})
    end

    def initialize(@x, @y, @w, @h)
    end

    def includes?(point : SDL::Point)
      includes?(point.x, point.y)
    end

    def includes?(x : Int32, y : Int32)
      @x <= x < @x + @w && @y <= y < @y + @h
    end
  end
end
