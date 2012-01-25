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
