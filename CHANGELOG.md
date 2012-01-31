### v0.0.3 ###
* changed: flip_horizontal => flip_horizontally
* changed: overlay_image => overlay
* changed: rotate default to 90 degress
* changed: color_at now returns RGB hash with alpha
* changed: tint method now uses RGB hash as input
* added: tests for all major methods
* added: flip_vertically
* added: to_nsimage
* added: ability to open NSImage, CGImage, CIImage, CoreImage instantiation, image url
* squashed: opening a pdf caused an error