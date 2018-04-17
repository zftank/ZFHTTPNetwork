#
# Be sure to run `pod lib lint ZFHTTPNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  s.name             = 'ZFHTTPNetwork'
  s.version          = '1.0.0'
  s.summary          = 'ZFHTTPNetwork'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.homepage         = 'https://github.com/zftank/ZFHTTPNetwork.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhangfeng' => 'zftank@163.com' }
  s.source           = { :git => 'https://github.com/zftank/ZFHTTPNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

#s.source_files = 'ZFHTTPNetwork/Classes/**/*.{h,m}'
  
  s.source_files = 'ZFHTTPNetwork/Classes/*'
  
  #s.frameworks = 'UIKit'
  
  s.default_subspec = 'YYManager','HTTPCategory','HTTPCommon','HTTPManager','HTTPOperation','HTPhotoManager'
  
  s.subspec 'YYManager' do |spec|
      spec.source_files = 'ZFHTTPNetwork/Classes/YYManager/*.{h,m}'
  end
  
  s.subspec 'HTTPCategory' do |spec|
      spec.source_files = 'ZFHTTPNetwork/Classes/HTTPCategory/*.{h,m}'
  end
  
  s.subspec 'HTTPCommon' do |spec|
      spec.source_files = 'ZFHTTPNetwork/Classes/HTTPCommon/*.{h,m}'
  end
  
  s.subspec 'HTTPManager' do |spec|
      spec.source_files = 'ZFHTTPNetwork/Classes/HTTPManager/*.{h,m}'
  end
  
  s.subspec 'HTTPOperation' do |spec|
      spec.source_files = 'ZFHTTPNetwork/Classes/HTTPOperation/*.{h,m}'
  end
  
  s.subspec 'HTPhotoManager' do |spec|
      spec.source_files = 'ZFHTTPNetwork/Classes/HTPhotoManager/*.{h,m}'
  end
  
end
