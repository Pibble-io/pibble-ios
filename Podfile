# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared_pods
  pod 'Fabric'#, '~> 1.9' #, '1.7.7'
  pod 'Crashlytics' #, '~> 3.12' #, '3.10.2'
  pod 'Moya', '~> 12.0'#, '11.0.2'
  pod 'Kingfisher', '~> 4.10' #, '4.8.0'
  pod 'Locksmith',  '~> 4.0.0'
  
  pod 'VisualEffectView', '~> 3.1' #, '3.0.2'
  
  pod 'GooglePlaces' #, '~> 3.0' #, '2.7.0'
  pod 'GooglePlacePicker' #, '~> 3.0' #, '2.7.0'
  pod 'GoogleMaps' #, '~> 3.0' #, '2.7.0'
  pod 'DeviceKit', '~> 1.11' #, '1.3'
  
  #pod 'SwiftChart', '~> 1.0' #, '1.0.1'
  pod 'SwiftChart', :git => 'https://github.com/gpbl/SwiftChart.git', :branch => 'master'
  pod 'Starscream', '~> 3.0.2'
  pod 'Socket.IO-Client-Swift', '~> 14.0.0'
  #pod 'Firebase/Core', '~> 5.2.0'
  pod 'Firebase/Messaging' #, '~> 3.3'
  pod 'Firebase/Analytics'
  pod 'SwiftyBeaver', '~> 1.7'
  
  pod 'Zip', '~> 1.1'
  pod 'SwipeCellKit', '2.5.4'
  pod 'Localize', '~> 2.3.0'
end

target 'Pibble' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  shared_pods
end

target 'PibbleDev' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  shared_pods
end


target 'PibbleTests' do
  inherit! :search_paths
  # Pods for testing
  
  shared_pods
end

target 'PibbleUITests' do
  inherit! :search_paths
  # Pods for testing
  
  shared_pods
end


post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end
