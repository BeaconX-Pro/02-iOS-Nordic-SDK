post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 12.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
            end
        end
    end
end
platform :ios,'12.0'

inhibit_all_warnings!
source 'git@120.27.8.241:mokoBaseLibrary/mokoBaseIndexLibrary.git'
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

target 'BeaconXPlus' do

pod 'mokoLibrary'
pod 'YYKit'
pod 'MLInputDodger'
pod 'iOSDFULibrary','4.6.1'
pod 'UMCCommon'
pod 'MKBLEBaseModule'

end
