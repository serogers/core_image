# CORE IMAGE GEM
# Created by Spencer Rogers on January 24, 2012
# https://github.com/serogers

class CoreImage
  require 'osx/cocoa'
  
  attr_accessor :image_path
  attr_accessor :original_image
  attr_accessor :ciimage
  
  def initialize(object)
    initialize_image(object)
  end
  
  def scale(ratio = 1)
    scaleFilter = OSX::CGAffineTransformMakeScale(ratio, ratio)
    self.ciimage = self.ciimage.imageByApplyingTransform(scaleFilter)
    self
  end
  
  def scale_to_size(maximum = 500)
    dimensions = size_to_fit_maximum(maximum)
    scale(dimensions[:ratio])
  end
  
  def rotate(degrees = 0)
    radians = degrees_to_radians(degrees)
    transform = OSX::CGAffineTransformMakeRotation(radians)
    self.ciimage = self.ciimage.imageByApplyingTransform(transform)
    self
  end
  
  def flip_horizontal
    transform = OSX::CGAffineTransformMakeScale(-1.0, 1.0)
    self.ciimage = self.ciimage.imageByApplyingTransform(transform)
    self
  end
  
  def crop(x, y, w, h)
    # coordinates start in lower left
    self.ciimage = self.ciimage.imageByCroppingToRect(OSX::CGRectMake(x, y, w, h))
    self
  end # crop
  
  def tint(rgb_string)
    image_size = size
    context = create_ci_context(image_size[:width], image_size[:height])
    colored_image = OSX::CIImage.imageWithColor(OSX::CIColor.colorWithString(rgb_string))
    filter = OSX::CIFilter.filterWithName("CIMultiplyCompositing")
    filter.setValue_forKey(colored_image, "inputImage")
    filter.setValue_forKey(self.ciimage, "inputBackgroundImage")
    new_image = filter.valueForKey("outputImage")
    new_image.drawAtPoint_fromRect_operation_fraction(OSX::NSZeroPoint, OSX::NSRectFromCGRect(new_image.extent), OSX::NSCompositeCopy, 1.0)
    self.ciimage = new_image
    self
  end
  
  def overlay_image(object)
    image = open_object(object)
    image_size = size
    context = create_ci_context(image_size[:width], image_size[:height])    
    filter = OSX::CIFilter.filterWithName("CISourceOverCompositing")
    filter.setValue_forKey(image, "inputImage")
    filter.setValue_forKey(self.ciimage, "inputBackgroundImage")
    new_image = filter.valueForKey("outputImage")
    new_image.drawAtPoint_fromRect_operation_fraction(OSX::NSZeroPoint, OSX::NSRectFromCGRect(new_image.extent), OSX::NSCompositeCopy, 1.0)
    self.ciimage = new_image
    self
  end
  
  def color_at(x, y)
    to_bitmap.colorAtX_y(x, y) # returns NSColor
  end
  
  def to_bitmap
    OSX::NSBitmapImageRep.alloc.initWithCIImage(self.ciimage)
  end
  
  def to_cgimage
    to_bitmap.CGImage
  end
  
  def size
    width, height = 0, 0
    
    begin # sometimes ciimage.extent throws an error
      size = self.ciimage.extent.size
      width = size.width
      height = size.height
    rescue
      # if image.extent fails, use another method for measuring size (by converting to a cgimage)
      begin
        cgimage = self.to_cgimage
      	width = OSX::CGImageGetWidth(cgimage)
      	height = OSX::CGImageGetHeight(cgimage)
    	rescue # if the second image size function fails set zero
    	  width = 0
    	  height = 0
  	  end # begin/rescue
  	end # begin/rescue
  	
  	{:width => width, :height => height}
  end
  
  def size_to_fit_maximum(max = 500)    
    image_size = size
    width = image_size[:width].to_f
    height = image_size[:height].to_f
    ratio = width > height ? max.to_f / width : max.to_f / height rescue 1
    {:width => (width * ratio).to_i, :height => (height * ratio).to_i, :ratio => ratio}
  end
  
  def revert
    self.ciimage = self.original_image
    self
  end
  
  def save(save_to = self.image_path)
    blob = to_bitmap.representationUsingType_properties(file_type(save_to), nil)
    blob.writeToFile_atomically(save_to, false)
  end
  
  private
  
  def initialize_image(object)
    self.ciimage = open_object(object)
    self.image_path = object if object.class == String
    
    # remember the original image for reversion
    if self.ciimage
      self.original_image = self.ciimage
    end
  end
  
  def open_object(object)
    case object.class.to_s
    when "String"
      ciimage = File.extname(object).downcase == ".pdf" ? open_from_pdf_path(object) : open_from_path(object)
    when "OSX::CIImage"
      ciimage = object
    end
  end
  
  def open_from_path(path_to_image)
    OSX::CIImage.imageWithContentsOfURL(OSX::NSURL.fileURLWithPath(path_to_image))
  end # open
  
  def open_from_pdf_path(pdf_path, scale = 1, dpi = 72.0, preserve_alpha = false)
    data = OSX::NSData.dataWithContentsOfURL(OSX::NSURL.fileURLWithPath(pdfPath))
    pdf_rep = OSX::NSPDFImageRep.imageRepWithData(data)
    nsimage = OSX::NSImage.alloc.initWithData(data)
    nssize = nsimage.size
    
    # calculate the width and height of the new image
    width = (nssize.width.to_f * 200.0 * scale) / 72.0
    height = (nssize.height.to_f * 200.0 * scale) / 72.0

    # set the size of the new image
    nssize = OSX::NSMakeSize(width, height)
    context = create_ns_context(width, height)
    context.setShouldAntialias(true)
    
    # create a bounding rectangle to grab the contexts of the pdf
    destination_rectangle = pdf_rep.bounds
    destination_rectangle.size = nssize
    
    OSX::NSRectFill(destination_rectangle) if preserve_alpha # defaults to black
    
    # grab the contents of the rectangle from the pdf and store it in the graphics port
    pdf_rep.drawInRect(destination_rectangle)

    # grab the new image from the graphics port and convert to cgimage
    cgimage = OSX::CGBitmapContextCreateImage(context.graphicsPort)
    
    # return a ciimage
    OSX::CIImage.initWithCGImage(cgimage)
  end
  
  def degrees_to_radians(degrees)
    degrees.to_f * (Math::PI / 180.0)
  end
  
  def file_type(image_name)
    return nil if image_name.nil?

    case File.extname(image_name).downcase
    when ".jpg", ".jpeg"
      OSX::NSJPEGFileType
    when ".png"
      OSX::NSPNGFileType
    when ".tiff", ".tif"
      OSX::NSTIFFFileType
    when ".gif"
      OSX::NSGIFFileType
    when ".pct"
      OSX::NSPCTFileType
    when ".bmp"
      OSX::NSBMPFileType
    end
    
  end
  
  def create_ci_context(width, height)
    create_ns_context(width, height).CIContext
  end
  
  def create_ns_context(width, height)
    blank_bitmap = OSX::NSBitmapImageRep.alloc.initWithBitmapDataPlanes_pixelsWide_pixelsHigh_bitsPerSample_samplesPerPixel_hasAlpha_isPlanar_colorSpaceName_bytesPerRow_bitsPerPixel(nil, width, height, 8, 4, true, false, OSX::NSDeviceRGBColorSpace, 0, 0)
    context = OSX::NSGraphicsContext.graphicsContextWithBitmapImageRep(blank_bitmap)
    OSX::NSGraphicsContext.setCurrentContext(context)
    context
  end # createContext
  
end