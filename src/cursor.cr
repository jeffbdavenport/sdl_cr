module SDL
  class Cursor
    def initialize(img : Bytes)
      rwops = LibSDL.rw_from_mem(img, img.size)
      surface = LibIMG.load_png_rw rwops
      @cursor = LibSDL.create_color_cursor(surface, 0, 0)
      LibSDL.free_rw(rwops)
      LibSDL.free_surface surface
    end

    def set_cursor
      LibSDL.set_cursor(@cursor)
    end

    def to_unsafe
      @cursor
    end
  end
end
