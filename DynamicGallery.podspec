#
# Be sure to run `pod lib lint DynamicGallery.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DynamicGallery'
  s.version          = '0.1.0'
  s.summary          = 'DynamicGallery is a library used to crate slideshow dynamically by downloading and adding images in a sequence.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'DynamicGallery is a library used to crate slideshow dynamically by downloading and adding images in a sequence. It allows you to easily create neverending slideshow, because of its dynamic behavior. It also supports zooming and dismiss on vertical slide.'

  s.homepage         = 'https://github.com/deelzeek/DynamicGallery'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'deelzeek' => 'dilzosmani@gmail.com' }
  s.source           = { :git => 'https://github.com/deelzeek/DynamicGallery.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'

  s.source_files = 'Classes/**/*.{h,m,swift}'
  s.dependency 'SnapKit', '~> 4.0.0'
  s.dependency 'Alamofire', '~> 4.7'
  s.dependency 'Kingfisher', '~> 4.0'
  s.swift_version = '4.0'
  
end
