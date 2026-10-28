//
//  IntroductionViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 28/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class IntroductionViewController: CustomUIViewControllerNoNavNoTabbar, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
	
	lazy var api = API()
	
	var introLoadComplete: Bool = false
	
	var pageView: UIPageViewController!
	var pageControl: UIPageControl!
	var arrayPageViewController: [IntroView]!
	
	var skipButton: UIButton!
	var loadingView: LoadingView!
	
	var currentIndex: Int?
	private var pendingIndex: Int?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .white
		
		skipButton = UIButton()
		skipButton.setParameter(string.th_start, textColor: .brandcolor3_dark, font: .kanitReg14, backgroundColor: .clear)
		skipButton.addTarget(self, action: #selector(skipAction(sender:)), for: .touchUpInside)
		
		pageControl = UIPageControl()
		pageControl.pageIndicatorTintColor = .brandcolor3
		pageControl.currentPageIndicatorTintColor = .brandcolor1
		
		arrayPageViewController = []
		pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
		pageView.delegate = self
		pageView.dataSource = self
		
		
		view.addSubview(skipButton)
		skipButton.snp.makeConstraints({ (make) in
			make.size.equalTo(CGSize(width: 45, height: 25))
			make.trailing.equalTo(view.snp.trailing).offset(-25)
			make.bottom.equalTo(view.snp.bottom).offset(-25)
		})
		
		loadingView = LoadingView(withSuperview: view)
		loadingView.startLoading()
		api.getIntro { (finished, response) in
			self.loadingView.stopLoading()
			self.introLoadComplete = true
			if finished {
				let pagesData = Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(response!, with: "result"), withInt: "order", ascending: true)
				for page in pagesData {
					let introView = IntroView(parameter: page)
					self.arrayPageViewController.append(introView)
				}
				self.pageControl.numberOfPages = pagesData.count
				self.pageControl.currentPage = 0
				if self.arrayPageViewController.count != 0 {
					self.pageView.setViewControllers([self.arrayPageViewController.first!], direction: .forward, animated: false, completion: nil)
				}
				self.view.addsubviews([self.pageView.view, self.pageControl])
				self.pageView.view.snp.makeConstraints({ (make) in
					make.edges.equalTo(self.view.snp.edges)
				})
				self.pageControl.snp.makeConstraints({ (make) in
					make.centerX.equalTo(self.view.snp.centerX)
					make.centerY.equalTo(self.skipButton.snp.centerY)
				})
                self.view.bringSubviewToFront(self.skipButton)
			}
		}
        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !introLoadComplete {
			loadingView.startLoading()
		}
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    @objc func skipAction(sender: UIButton) {
        let loginView = SignInViewController()
        loginView.modalPresentationStyle = .fullScreen
        present(loginView, animated: true, completion: nil)
    }
	
	// MARK: - UIPageViewController delegates
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		let currentIndex = arrayPageViewController.index(of: viewController as! IntroView)!
		if currentIndex == 0 {
			return nil
		}
		let previousIndex = abs((currentIndex - 1) % arrayPageViewController.count)
		return arrayPageViewController[previousIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		let currentIndex = arrayPageViewController.index(of: viewController as! IntroView)!
		if currentIndex == arrayPageViewController.count-1 {
			return nil
		}
		let nextIndex = abs((currentIndex + 1) % arrayPageViewController.count)
		return arrayPageViewController[nextIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
		pendingIndex = arrayPageViewController.index(of: pendingViewControllers.first! as! IntroView)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if completed {
			currentIndex = pendingIndex
			if let index = currentIndex {
				pageControl.currentPage = index
			}
		}
	}
}
