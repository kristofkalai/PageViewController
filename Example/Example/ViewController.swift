//
//  ViewController.swift
//  Example
//
//  Created by Kristof Kalai on 2022. 12. 09..
//

import PageViewController
import UIKit

class ViewController: UIViewController {
    private let firstViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .green
        return viewController
    }()
    private let secondViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .blue
        return viewController
    }()
    private let thirdViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .red
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let page = PageViewController(
            viewControllers: [
                firstViewController,
                secondViewController,
                thirdViewController
            ]
        )

        addChild(page)
        view.addSubview(page.view)
        page.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        page.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        page.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        page.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        page.didMove(toParent: self)

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
    }
}
