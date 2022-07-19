#
# Be sure to run `pod lib lint AkaraIOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AkaraIOS'
  s.version          = '0.0.2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.summary          = 'Multi-language Word Suggestions Tool for iOS'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
    s.description      = '💡Multi-Language Word Suggestions Toolkit for iOS'
  
  s.homepage         = 'https://github.com/Socret360/akara-ios'
  s.author           = { 'vaifathuy' => 'vaifathuy@gmail.com' }
  s.source           = { :git => 'https://github.com/Socret360/akara-ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.static_framework = true
  s.swift_versions = '4.0'
  
  s.source_files = 'akara-ios/Classes/**/*'
  
  s.resource_bundles = {
    'AkaraIOS' => ['akara-ios/Assets/**/*']
  }
  s.dependency 'TensorFlowLiteSwift', '2.7.0'
  s.dependency 'GoogleMLKit/LanguageID', '3.1.0'
  s.dependency 'XMLCoder', '~> 0.13.1'
end
