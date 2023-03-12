# PageViewController
Finally a fixed version of UIPageViewController! 🎉

## Setup

Add the following to `Package.swift`:

```swift
.package(url: "https://github.com/stateman92/PageViewController", exact: .init(0, 0, 8))
```

[Or add the package in Xcode.](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

## Usage

```swift
let page = PageViewController(
    viewControllers: [
        firstViewController,
        secondViewController,
        thirdViewController
    ]
)
// ...
page.transition = { completedPercent, currentIndex, nextIndex in
    guard let currentIndex, let nextIndex else { return }
    print("current index: \(currentIndex)")
    print("current percent: \(completedPercent)")
    print("next index: \(nextIndex)")

    if currentIndex < nextIndex {
        print("\(currentIndex). --\(String(format: "%.3f", completedPercent))--> \(nextIndex).")
    } else {
        print("\(nextIndex). <-\(String(format: "%.3f", completedPercent))-- \(currentIndex).")
    }
}
```

For details see the Example app.

## Example

<p style="text-align:center;"><img src="https://github.com/stateman92/PageViewController/blob/main/Resources/screenrecording.gif?raw=true" width="50%" alt="Example"></p>
