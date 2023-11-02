Pod::Spec.new do |s|
  s.name         = "SugarToast"
  s.version      = "1.0.0"
  s.summary      = "Create toast views with few lines of code."
  s.description  = "SugarToast is a Swift extension that adds toast notifications. It is highly customizable, lightweight, and easy to use. Most toast notifications can be triggered with just a few lines of code."
  s.homepage     = "https://github.com/Gishyan93/SugarToast"
  s.license      = 'MIT'
  s.author       = { "Tigran Gishian" => "tigran.gishian@gmail.com" }
  s.source       = { :git => "https://github.com/Gishyan93/SugarToast.git", :tag => "#{s.version}" }
  s.swift_version = '5.5'
  s.platform     = :ios, '13.0'
  s.source_files = "Sources/SugarToast/*.swift"
end
