require 'rubygems'
require 'riot'
require './lib/core_image.rb'

context 'Core Image' do
  
  setup {CoreImage.new("./test/images/test.png")}
  
  context '.scale(1.5)' do
    asserts("Image was scaled up by 150%") {topic.scale(1.5).size == {:width => 75, :height => 75}}
  end
  
  context '.scale(0.6)' do
    asserts("Image was scaled down by 60%") {topic.scale(0.6).size == {:width => 30, :height => 30}}
  end
  
  context '.scale_to_size(300)' do
    asserts("Image was scaled to fit within 500px") {topic.scale_to_size(300).size == {:width => 300, :height => 300}}
  end
  
  context '.color_at' do
    setup {topic.color_at(25, 25)}
    asserts("Brightness > 0.0") {topic.brightnessComponent > 0.0}
    asserts("Green > 0.50 and Green < 0.51") {topic.greenComponent > 0.50 and topic.greenComponent < 0.51}
    asserts("Saturation is equal to 1.0") {topic.saturationComponent == 1.0}
  end
  
  context '.to_bitmap' do
    setup {topic.to_bitmap}
    asserts("Is a bitmap") {topic.class.to_s == "OSX::NSBitmapImageRep"}
  end
  
  context '.to_cgimage' do
    setup {topic.to_cgimage}
    asserts("Is a cgimage") {topic.class.to_s == "OSX::NSObject"}
  end
  
  context '.size' do
    asserts("Size equals 50x50") {topic.size == {:width => 50, :height => 50}}
  end
  
  context '.size_to_fit_maximum(350)' do
    asserts("Returns 350x350 ratio of 7.0") {topic.size_to_fit_maximum(350) == {:height=>350, :width=>350, :ratio=>7.0}}
  end
  
  context '.revert' do
    asserts("Image reverts to original") {topic.ciimage = topic.flip_horizontal.revert.ciimage}
  end
  
end