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
  
  
  s.default_subspec = 'HTTPConnection','YYManager','HTTPCategory','HTTPCommon','HTTPManager','HTTPOperation','HTPhotoManager'
  
  
  s.subspec 'HTTPConnection' do |ssHTTPConnection|
      
      ssHTTPConnection.source_files = 'ZFHTTPNetwork/Classes/HTTPConnection/**/*'
      
      ssHTTPConnection.public_header_files = 'ZFHTTPNetwork/Classes/HTTPConnection/**/*.h'
      
  end
  
  
  s.subspec 'YYManager' do |ssYYManager|
      
      ssYYManager.source_files = 'ZFHTTPNetwork/Classes/YYManager/**/*'
      
      ssYYManager.public_header_files = 'ZFHTTPNetwork/Classes/YYManager/**/*.h'
      
  end
  
  
  s.subspec 'HTTPCategory' do |ssHTTPCategory|
      
      ssHTTPCategory.source_files = 'ZFHTTPNetwork/Classes/HTTPCategory/**/*'
      
      ssHTTPCategory.public_header_files = 'ZFHTTPNetwork/Classes/HTTPCategory/**/*.h'
      
  end
  
  
  s.subspec 'HTTPCommon' do |ssHTTPCommon|
      
      ssHTTPCommon.source_files = 'ZFHTTPNetwork/Classes/HTTPCommon/**/*'
      
      ssHTTPCommon.public_header_files = 'ZFHTTPNetwork/Classes/HTTPCommon/**/*.h'
      
      
      ssHTTPCommon.dependency 'ZFHTTPNetwork/HTTPConnection'
      
  end
  
  
  s.subspec 'HTPhotoManager' do |ssHTPhotoManager|
      
      ssHTPhotoManager.source_files = 'ZFHTTPNetwork/Classes/HTPhotoManager/**/*'
      
      ssHTPhotoManager.public_header_files = 'ZFHTTPNetwork/Classes/HTPhotoManager/**/*.h'
      
      
      ssHTPhotoManager.dependency 'ZFHTTPNetwork/HTTPCommon'
      
  end
  
  
  s.subspec 'HTTPOperation' do |ssHTTPOperation|
      
      ssHTTPOperation.source_files = 'ZFHTTPNetwork/Classes/HTTPOperation/**/*'
      
      ssHTTPOperation.public_header_files = 'ZFHTTPNetwork/Classes/HTTPOperation/**/*.h'
      
      
      ssHTTPOperation.dependency 'ZFHTTPNetwork/HTPhotoManager'
      
      ssHTTPOperation.dependency 'ZFHTTPNetwork/HTTPConnection'
      
  end
  
  
  s.subspec 'HTTPManager' do |ssHTTPManager|
      
      ssHTTPManager.source_files = 'ZFHTTPNetwork/Classes/HTTPManager/**/*'
      
      ssHTTPManager.public_header_files = 'ZFHTTPNetwork/Classes/HTTPManager/**/*.h'
      
      
      ssHTTPManager.dependency 'ZFHTTPNetwork/HTTPOperation'
      
      ssHTTPManager.dependency 'ZFHTTPNetwork/HTPhotoManager'
      
      ssHTTPManager.dependency 'ZFHTTPNetwork/HTTPConnection'
      
  end
  
    
end
