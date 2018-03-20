# Curve-iOS-Challenge

## Build Environment

Built using Xcode 9.2, dependencies fetched with Cocoapods 1.4.0

Pod directory included, and Podfile.lock contains specific versions

## Dependencies

RxSwift & RxCocoa for bindings. The architecture is MVVM-C which is a lot simpler with bindings

SwiftLint is there to give some warnings. Main config change is to increase the maximum size of lines since UIKit can get a bit verbose

Kingfisher is used for image caching

## Testing

Unit tests covering the view model, mapping, mapping helpers and a few other small parts 

There is a single UI test which is not a very good one since it doesn't stub the network. Given time I would setup a communication layer between the test app and app under test, which would let me setup scenarios (e.g. long loading time, or loading last page etc)

## Other stuff

Not all of the UI is done to match the design, though the components and layout are there (e.g. nav bar colour). The favourite button on detail is missing but the one in the cell works (it's just a coloured square, no icon: red = no fave, green = faved. persistence is via user defaults)

Strings are localised. I wanted to use something like SwiftGen to convert the stringly typed code to types but didnt have time. 
