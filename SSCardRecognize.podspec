#
# Be sure to run `pod lib lint SSCardRecognize.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SSCardRecognize'
  s.version          = '0.1.0'
  s.summary          = '识别银行卡'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
识别中国身份证和银行卡
                       DESC

  s.homepage         = 'https://github.com/753331342'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '753331342@qq.com' => '753331342@qq.com' }
  s.source           = { :git => 'https://github.com/753331342/SSCardRecognize.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SSCardRecognize/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SSCardRecognize' => ['SSCardRecognize/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'OpenCV/Dynamic', '~> 3.2.0'
end
