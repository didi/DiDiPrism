#
#  Be sure to run `pod spec lint DiDiPrism.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "DiDiPrism_Ability"
  spec.version      = "0.2.8"
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

  spec.dependency  'DiDiPrism'
  
  spec.default_subspec = 'WithBehaviorRecord', 'WithBehaviorReplay'

  spec.subspec 'WithBehaviorRecord' do |ss| 
    ss.source_files = 'iOS/DiDiPrism/Src/Ability/BehaviorRecord/**/*{.h,.m}'
  end

  spec.subspec 'WithBehaviorReplay' do |ss| 
    ss.source_files = 'iOS/DiDiPrism/Src/Ability/BehaviorReplay/**/*{.h,.m}'
    ss.dependency "JSONModel", '~> 1.0'
  end

  spec.subspec 'WithBehaviorDetect' do |ss| 
    ss.source_files = 'iOS/DiDiPrism/Src/Ability/BehaviorDetect/**/*{.h,.m}'
    ss.dependency "JSONModel", '~> 1.0'
  end

  spec.subspec 'WithDataVisualization' do |ss| 
    ss.source_files = ['iOS/DiDiPrism/Src/Ability/DataVisualization/**/*{.h,.m}', 'iOS/DiDiPrism/Src/Adapter/**/*{.h,.m}']
    ss.resource_bundles = {
      'DiDiPrism' => 'iOS/DiDiPrism/Resource/**/*'
    }
    ss.dependency "Masonry"
  end

end
