#
#  Be sure to run `pod spec lint VTMagicBox.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name       = 'VTMagicBox'
    s.version    = '2.0.3'
    s.license    = { :type => 'MIT' }
    s.homepage   = 'https://github.com/Suzhibin/VTMagicBox'
    s.authors    = { 'suzhibin' => 'szb2323@163.com' }
    s.summary    = 'A page container for iOS.'
    s.description = <<-DESC
                      VTMagicBox is a fork of VTMagic .A lot of functionality has been added.
                     DESC
    s.source     = { :git => 'https://github.com/Suzhibin/VTMagicBox.git', :tag => s.version.to_s }

    s.public_header_files = 'VTMagicBox/VTMagic.h'
    s.source_files = 'VTMagicBox/VTMagic.h'

    s.platform   = :ios, "6.0"
    s.requires_arc = true
    s.frameworks = 'UIKit'

    s.subspec 'Core' do |ss|
        ss.ios.deployment_target = '6.0'
        ss.exclude_files = 'VTMagicBox/VTMagic.h'
        ss.source_files = 'VTMagicBox/**/*.{h,m}'
    end
end
