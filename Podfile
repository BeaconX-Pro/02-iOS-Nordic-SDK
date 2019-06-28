post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
            end
        end
    end
end
platform :ios,'9.0'

inhibit_all_warnings!
use_frameworks!

target 'BeaconXPlus' do

pod 'mokoLibrary', :git => 'git@120.27.8.241:mokoBaseLibrary/mokoLibrary.git'
pod 'MLInputDodger'
pod 'iOSDFULibrary'

end
