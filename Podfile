platform :ios, '11.0'

target 'CurveChallenge' do
  use_frameworks!

  #RxSwift used for FRP bindings (useful for VM <-> V in MVVM)
  pod 'RxSwift', '~> 4.0'

  #RxCocoa adds UIKit / Foundation specific helpers on top of RxSwift (e.g. binding to a UILabel text, or creating an observable from URLSession request)
  pod 'RxCocoa', '~> 4.0'

  target 'CurveChallengeTests' do
    inherit! :search_paths
  end

  target 'CurveChallengeUITests' do
    inherit! :search_paths
  end

end
