class PolylineEncoder
  # Encode an rgeo exterior ring/interior ring,
  # anything with an attribute points, containing an array
  # of object with x and y float attributes
  def self.encode(ring)
    encoded = ""
    
    px = 0
    py = 0
  
    ring.points.each_with_index do |point, i|
      dx,dy = point.x-px, point.y-py
      px,py = point.x   , point.y
      
      dx = (dx * 1e5).round
      dy = (dy * 1e5).round

      chunks_x = encodeSignedNumber(dx)
      chunks_y = encodeSignedNumber(dy)
      encoded << chunks_y << chunks_x
    end
  
    return encoded
  end

private

  def self.encodeSignedNumber(num)
    # Based on the official google example
    
    sgn_num = num << 1
    sgn_num = ~(sgn_num) if( num < 0 )
    encodeNumber(sgn_num)
  end

  def self.encodeNumber(num)
    # Based on the official google example
    
    encoded = ""

    while (num >= 0x20) do
      encoded << (0x20 | (num & 0x1f)) + 63
      num = num >> 5
    end

    encoded << num + 63
  end
end
