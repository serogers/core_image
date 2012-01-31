## Core Image Gem ##
Simple image manipulation using Apple's Core Image technology.

### Installation ###
`gem install core_image`

### Usage ###
	require 'core_image'
	image = CoreImage.new(location) # more on this below
	image.rotate(90)
	image.scale_to_size(300)
	image.save
	
### Supports Chaining ###
	image.rotate(90).scale(0.6).save(new_path)

### Extra Bits ###
	image.flip_horizontally
	image.flip_vertically
	image.save # oh no!
	image.revert #=> reverts to the original image
	
### One More Thing! ###
	image.tint({:red => 0, :green => 0, :blue => 255, :alpha => 1.0})
	image.crop(x, y, w, h) # starts from lower left
	image.color_at(x, y) # => RGB Hash of specified pixel
	image.overlay(another_image) # follows the same instantiation rules


### Instantiating ###
You can instantiate a new Core Image object with the following:  
*	A path to a file  
*	A url to a file  
*	An Apple image object: NSImage, CIImage, CGImage  
*	Another Core Image object  

### File Types ###
Core Image can open and save the following formats: jpeg, png, tiff, gif, pct, and bmp.  It can also open pdfs and save them as one of the previously listed image formats.

### Requirements ###
Requires Mac OS X to run.

### Tests ###
Core Image testing is done via the [Riot](http://rubygems.org/gems/riot) gem and can be run by typing `rake` from the root directory of this repository (you must have Riot installed to do so).

### Support ###
Serveral updates are in the works but feel free to report issues, make comments, voice concerns and I'll get to them when I can! Enjoy!