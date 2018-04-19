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

  s.homepage         = 'https://github.com/zftank/ZFHTTPNetwork.git'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhangfeng' => 'zftank@163.com' }
  s.source           = { :git => 'https://github.com/zftank/ZFHTTPNetwork.git', :tag => '1.0.0' }


  s.requires_arc = true

  s.ios.deployment_target = '8.0'


  #s.source_files = 'ZFHTTPNetwork/Classes/**/*'
  
  #s.public_header_files = 'ZFHTTPNetwork/Classes/**/*.h'
  
  #s.source_files = 'ZFHTTPNetwork/Classes/*'
  
  #s.dependency 'ZFHTTPNetwork'
  
  
  s.default_subspec = 'HTTPConnection'
  
  
  s.subspec 'HTTPConnection' do |ssHTTPConnection|
      
      ssHTTPConnection.source_files = 'ZFHTTPNetwork/Classes/**/*'
      
      ssHTTPConnection.public_header_files = 'ZFHTTPNetwork/Classes/**/*.h'
      
  end
    
end
