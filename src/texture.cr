module SDL
  class Texture
    def initialize(@texture : LibSDL::Texture*)
    end

    def initialize(renderer : Renderer | LibSDL::Renderer, width, height, pixel_format = LibSDL::PixelFormatEnum::RGBA8888, texture_access = LibSDL::TextureAccess::STREAMING)
      @texture = LibSDL.create_texture(renderer, pixel_format, texture_access, width, height)
    end

    def finalize
      LibSDL.destroy_texture(@texture)
    end

    # Creates a `Texture` for *renderer* from a `Surface`.
    def self.from(surface : Surface, renderer : Renderer)
      texture = LibSDL.create_texture_from_surface(renderer, surface)
      raise Error.new("SDL_CreateTextureFromSurface") unless texture
      new(texture)
    end

    def width
      ret = LibSDL.query_texture(self, out format, out access, out w, out h)
      raise Error.new("SDL_QueryTexture") unless ret == 0
      w
    end

    def height
      ret = LibSDL.query_texture(self, out format, out access, out w, out h)
      raise Error.new("SDL_QueryTexture") unless ret == 0
      h
    end

    def color_mod=(rgb)
      ret = LibSDL.set_texture_color_mod(@texture, *rgb)
      raise Error.new("SDL_SetTextureColorMod") unless ret == 0
      rgb
    end

    def color_mod
      ret = LibSDL.get_texture_color_mod(@texture, out r, out g, out b)
      raise Error.new("SDL_SetTextureColorMod") unless ret == 0
      {r, g, b}
    end

    def alpha_mod=(alpha)
      ret = LibSDL.set_texture_alpha_mod(@texture, alpha)
      raise Error.new("SDL_SetTextureAlphaMod") unless ret == 0
      alpha
    end

    def alpha_mod
      ret = LibSDL.get_texture_alpha_mod(@texture, out alpha)
      raise Error.new("SDL_SetTextureColorMod") unless ret == 0
      alpha
    end

    def blend_mode=(blend_mode : BlendMode)
      ret = LibSDL.set_texture_blend_mode(@texture, blend_mode)
      raise Error.new("SDL_SetTextureBlendMode") unless ret == 0
      blend_mode
    end

    def blend_mode
      ret = LibSDL.get_texture_blend_mode(@texture, out blend_mode)
      raise Error.new("SDL_GetTextureBlendMode") unless ret == 0
      blend_mode
    end

    # def update
    # end

    # def update_yuv
    # end

    def lock : {Slice(UInt32), Int32}
      pitch = uninitialized Int32
      pixels_pointer = uninitialized Void*
      ret = LibSDL.lock_texture(self, nil, pointerof(pixels_pointer), pointerof(pitch))
      raise Error.new("SDL_LockTexture") unless ret == 0
      {Slice.new(Pointer(UInt32).new(pixels_pointer.address), width * height), pitch}
    end

    # Locks a texture and yields a buffer of pixels for write only changes along with the pitch the data
    def lock(& : Slice(UInt32), Int32 ->) : Nil
      buffer, pitch = lock
      yield buffer, pitch
    ensure
      unlock
    end

    def unlock
      LibSDL.unlock_texture(self)
    end

    # Binds an OpenGL/ES/ES2 texture to the current texture, for use with OpenGL
    # instructions when Rendering OpenGL primitives directly.
    def gl_bind
      ret = LibSDL.gl_bind_texture(@texture, out w, out h)
      raise Error.new("SDL_GL_BindTexture") unless ret == 0
      {w, h}
    end

    # Unbinds an OpenGL/ES/ES2 texture from the current context.
    def gl_unbind
      ret = LibSDL.gl_bind_texture(@texture)
      raise Error.new("SDL_GL_UnbindTexture") unless ret == 0
    end

    def to_unsafe
      @texture
    end
  end
end
