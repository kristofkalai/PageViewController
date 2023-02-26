# PageViewController
Finally a fixed version of UIPageViewController! 🎉

### How to use

First you should create the page:

```swift
let page = PageViewController(
    viewControllers: [
        firstViewController,
        secondViewController,
        thirdViewController
    ]
)
```

Then after you added the page to a view, you can use the callback:

```swift
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

For details see the Example app.

### Example

<p style="text-align:center;"><img src="https://github.com/stateman92/PageViewController/blob/main/Resources/screenrecording.gif?raw=true" width="50%" alt="Example"></p>
