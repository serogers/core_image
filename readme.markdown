## Core Image Gem ##
Simple image manipulation using Apple's Core Image technology.

### Installation ###
`gem install core_image`

### Usage ###
	require 'core_image'
	image = CoreImage.new(path)
	image.rotate(90)
	image.scale_to_size(300)
	image.save
	
### Supports Chaining ###
	image.rotate(90).overlay_image(path).scale(0.6).save(new_path)

### Extra Bits ###
	image.scale(0.80)
	image.flip_horizontal
	image.save # oh no!
	image.revert #=> reverts to the original image

### File Types ###
Core Image can open and save the following formats: jpeg, png, tiff, gif, pct, and bmp.  It can also open pdfs and save them as one of the support image formats.

### Requirements ###
Requires Mac OS X to run.

### Support ###
Serveral updates are in the works but feel free to report issues, make comments, voice concerns and I'll get to them when I can! Enjoy!