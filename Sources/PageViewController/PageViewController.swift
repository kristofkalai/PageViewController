//
//  PageViewController.swift
//  
//
//  Created by Kristof Kalai on 2022. 12. 09..
//

import UIKit

public final class PageViewController: UIPageViewController {
    public var transition: (_ completedPercent: CGFloat, _ currentIndex: Int?, _ nextIndex: Int?) -> Void = { _, _, _ in }
    public let storedViewControllers: [UIViewController]
    public let enableOverScroll: Bool

    public init(viewControllers: [UIViewController],
                enableOverScroll: Bool = true,
                navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
                options: [UIPageViewController.OptionsKey: Any]? = nil) {
        storedViewControllers = viewControllers
        self.enableOverScroll = enableOverScroll
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
        if enableOverScroll || viewControllers.count > 1 {
            dataSource = self
        }
        storedViewControllers.first.map { setViewControllers([$0], direction: .forward, animated: false) }
    }

    public convenience init(viewController: UIViewController,
                            enableOverScroll: Bool = false,
                            navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
                            options: [UIPageViewController.OptionsKey: Any]? = nil) {
        self.init(viewControllers: [viewController],
                  enableOverScroll: enableOverScroll,
                  navigationOrientation: navigationOrientation,
                  options: options)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        scrollViews.forEach { $0.delegate = self }
    }
}

extension PageViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var percentComplete: CGFloat
        let point: CGFloat
        let size: CGFloat
        switch navigationOrientation {
        case .horizontal:
            point = scrollView.contentOffset.x
            size = view.frame.size.width
        case .vertical:
            point = scrollView.contentOffset.y
            size = view.frame.size.height
        @unknown default:
            point = .zero
            size = .zero
        }
        percentComplete = (point - size) / size

        if !enableOverScroll {
            let preBounce: Bool = {
                let currentIndexIsZero = (currentIndex ?? .zero) <= .zero
                return currentIndexIsZero && point <= size
            }()
            let postBounce: Bool = {
                let currentIndexIsLast = (currentIndex ?? .zero) >= storedViewControllers.count - 1
                return currentIndexIsLast && point > .zero
            }()
            scrollViews.forEach {
                $0.bounces = !(preBounce || postBounce)
            }
        }

        guard percentComplete != .zero else { return }
        let nextIndex = percentComplete > .zero ? currentIndex?.advanced(by: 1) : currentIndex?.advanced(by: -1)
        transition(percentComplete,
                   percentComplete == 1 ? nextIndex : currentIndex,
                   percentComplete == 1 ? nil : nextIndex)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        self.viewController(of: index(of: viewController)?.advanced(by: -1))
    }

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        self.viewController(of: index(of: viewController)?.advanced(by: 1))
    }
}

extension PageViewController {
    private var scrollViews: [UIScrollView] {
        view.subviews.compactMap { $0 as? UIScrollView }
    }

    private var currentIndex: Int? {
        index(of: viewControllers?.first)
    }

    private func index(of viewController: UIViewController?) -> Int? {
        guard let viewController else { return nil }
        return storedViewControllers.firstIndex(of: viewController)
    }

    private func viewController(of index: Int?) -> UIViewController? {
        guard let index, storedViewControllers.indices.contains(index) else { return nil }
        return storedViewControllers[index]
    }
}
