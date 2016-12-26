#
# Be sure to run `pod lib lint FeedCollectionViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FeedCollectionViewController'
  s.version          = '0.1.0'
  s.summary          = 'A wrapper around UICollectionView for loading content as its needed'

  s.description      = <<-DESC
A wrapper around UICollectionView used for infinite scrolling and loading content dynamically.
This would be used for a feed or images or other cells that need to load as the user scrolls.
                       DESC

  s.homepage         = 'https://github.com/oliveroneill/FeedCollectionViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Oliver ONeill' => 'oliveroneill04@gmail.com' }
  s.source           = { :git => 'https://github.com/oliveroneill/FeedCollectionViewController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'FeedCollectionViewController/Classes/**/*'
end
