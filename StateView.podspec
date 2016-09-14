Pod::Spec.new do |s|
  s.name             = "StateView"
  s.version          = "2.0"
  s.summary          = "Automatically-updating views you can actually understand."
  s.description      = "Define once what your users should see when the data is one way or another and let StateView handle the rest. StateView will update only the parts of your UI that need updating whenever data changes, and you don't even need to refactor your app into a set of event streams. Write normal code and watch your view update itself."

  s.homepage         = "https://github.com/sahandnayebaziz/StateView"
  s.license          = 'MIT'
  s.author           = { "sahandnayebaziz" => "designedeverything@icloud.com" }
  s.source           = { :git => "https://github.com/sahandnayebaziz/StateView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://www.sahand.me'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'StateView/*.swift'
  s.dependency 'SnapKit'
end
