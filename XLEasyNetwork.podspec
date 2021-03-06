#
# Be sure to run `pod lib lint XLEasyNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "XLEasyNetwork"
  s.version          = "0.1.0"
  s.summary          = "网络库."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
封装简单的网络库，实现网络请求，取消请求，一些特性化队列（保证一定提交成功、多个请求的互相依赖），网络请求的全局控制（请求数量、超时、优先级）
                       DESC

  s.homepage         = "https://github.com/randyeasy/XLEasyNetwork"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "晓亮" => "yanxiaoliang@baijiahulian.com" }
  s.source           = { :git => "https://github.com/randyeasy/XLEasyNetwork.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'

  s.dependency 'AFNetworking', '~> 3.0.4'
end
