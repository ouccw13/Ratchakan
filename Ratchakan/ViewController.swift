//
//  ViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 6/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CustomNavDelegate {

	@IBOutlet weak var topView: CustomNav!
	
	let nav: Nav = Nav(title: string.th_pretest, isBack: true, isRight: false, color: UIColor.cyan)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		fillUI()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	fileprivate func fillUI() {
		if !isViewLoaded {
			return
		}

		let navModel = CustomViewModelFromNav(withNav: self.nav)
		topView.viewModel = navModel
		topView.delegate = self
		
	}
	
	func back() {
		let exam = ExamViewController()
		self.present(exam, animated: true, completion: nil)
	}
	func next() {

	}
}

