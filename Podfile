# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'ratchakan' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ratchakan
  pod 'Alamofire'
  pod 'AlamofireImage'
  pod 'ObjectMapper'
  pod 'FSCalendar'
  pod 'FCUUID'
  pod 'SDWebImage'
  pod 'DTCoreText'
  pod 'TabPageViewController'
  pod 'FCUUID'
  pod 'Firebase'
  pod 'FirebaseCoreInternal'
  pod 'GoogleUtilities'
  pod 'FirebaseCore'
  pod 'FirebaseSessions'
  pod 'FirebaseCoreExtension'
  pod 'FirebaseInstallations'
  pod 'FirebaseMessaging'
  pod 'FirebaseCrashlytics'
  pod 'GoogleDataTransport'
  pod 'nanopb'
  pod 'Firebase/Database'
  pod 'FirebaseAuth'
  pod 'Firebase/Auth'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Firestore'
  pod 'Firebase/Analytics'
  pod 'GoogleSignIn'
  pod 'GoogleTagManager'
  pod 'CryptoSwift'
  pod 'FBSDKCoreKit','~> 17.4.0'
  pod 'FBSDKShareKit','~> 17.4.0'
  pod 'FBSDKLoginKit','~> 17.4.0'
  pod 'FBAEMKit'
  pod 'lottie-ios'
  pod 'PNChart'
  pod 'MJRefresh'
  pod 'SnapKit'
  pod 'Realm'
  pod 'RealmSwift'
  pod 'Hero'
  pod 'youtube-ios-player-helper'
  pod 'CGMath'
  pod 'Cosmos'
  pod 'DGCharts'
  pod 'SwiftJWT'
  pod 'EliteOTPField'
  pod 'gRPC-Core'
  pod 'gRPC-C++'
  pod 'BoringSSL-GRPC'
  pod 'ScreenShield'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'


  target 'ratchakanTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ratchakanUITests' do
    # Pods for testing
  end

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
   config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
   config.build_settings['SWIFT_VERSION'] = '5.1'
   config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
   config.build_settings['ENABLE_BITCODE'] = 'NO'
  end
 end
end
