#
#  Be sure to run `pod spec lint DiDiPrism.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "DiDiPrism"
  spec.version      = "0.2.10"
  spec.summary      = "一款专注移动端操作行为的工具"
  spec.description  = <<-DESC
                        移动端用户行为分析工具
                   DESC

  spec.homepage     = "https://github.com/didi/DiDiPrism"

  spec.license      =  { :type => 'Apache-2.0', :file => 'LICENSE' }

  spec.author             = { "Hulk" => "ronghao@didichuxing.com" }

  spec.ios.deployment_target = "8.0"

  spec.source       = { :git => "https://github.com/didi/DiDiPrism.git", :tag => "#{spec.version}" }

  spec.requires_arc = true

  spec.default_subspec = 'Core'
  
  spec.subspec 'Core' do |ss| 
    ss.source_files = ['iOS/DiDiPrism/Src/Core/**/*{.h,.m}', 'iOS/DiDiPrism/Src/Category/**/*{.h,.m}', 'iOS/DiDiPrism/Src/Util/**/*{.h,.m}', 'iOS/DiDiPrism/Src/Protocol/**/*{.h,.m}']
    ss.dependency 'RSSwizzle'
  end

end
