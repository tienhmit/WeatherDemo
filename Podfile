# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WeatherAlert' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WeatherAlert
  pod 'SnapKit', '~> 5.0.0'
  pod 'SVProgressHUD'
  pod 'SVPullToRefresh'
  pod 'TPKeyboardAvoiding'
  pod 'SDWebImage', '~> 4.0'
  pod 'MGSwipeTableCell'
  pod 'SVProgressHUD'
  pod 'Toast', '~> 4.0.0'
  pod 'AlamofireSwiftyJSON'
  pod 'SwiftyJSON'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'Localize'

  post_install do |installer|
       installer.pods_project.targets.each do |target|
           target.build_configurations.each do |config|
               config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
               config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
               config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
           end
       end
  end
end

  target 'WeatherAlertTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'SnapshotTesting', '~> 1.9.0'
  end

  target 'WeatherAlertUITests' do
    # Pods for testing
    pod 'SnapshotTesting', '~> 1.9.0'
  end
