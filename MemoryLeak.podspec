#
#  Be sure to run `pod spec lint MemoryLeak.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "MemoryLeak"
  spec.version      = "1.0"
  spec.summary      = "Additional tool for debug memory"

  spec.description  = <<-DESC
  You able to see who retain and who release yours classes
                   DESC

  spec.homepage     = "https://github.com/cvladislav/MemoryLeak.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "cvladislav" => "cvl@ciklum.com" }

  spec.ios.deployment_target = "13.0"
  spec.swift_version = "5.0"

  spec.source        = { :git => "https://github.com/cvladislav/MemoryLeak.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/MemoryLeak/**/*.{h,m,swift}"

end
