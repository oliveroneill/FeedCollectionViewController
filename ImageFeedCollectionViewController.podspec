Pod::Spec.new do |s|
  s.name             = 'ImageFeedCollectionViewController'
  s.version          = '1.0.6'
  s.summary          = 'An extension on FeedCollectionViewController that is used for image feeds'

  s.description      = <<-DESC
An extension on FeedCollectionViewController that is used for image feeds. This is used for infinite
scrolling and loading images dynamically. This is inspired by scrolling through photos on Facebook or
Instagram.
                       DESC

  s.homepage         = 'https://github.com/oliveroneill/FeedCollectionViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Oliver ONeill' => 'oliveroneill@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/oliveroneill/FeedCollectionViewController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'ImageFeedCollectionViewController/Classes/**/*'

  s.dependency 'OOPhotoBrowser', '2.0.7'
  s.dependency 'FeedCollectionViewController'
end
