//
//  NoteDashboardViewController.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 13/7/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit
import TabPageViewController

class NoteDashboardViewController: CustomUIViewControllerWithNav {
    
    private let navigationView: CustomNav = {
        let nav = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
        if #available(iOS 16.0, *) {
            nav.leftButton.isHidden = true
        } else {
            // Fallback on earlier versions
        }
        nav.viewModel = CustomViewModelFromNav(withNav: Nav(title: "", isBack: false, isRight: false, color: UIColor.navbrandcolor))
        return nav
    }()
    
    
    private let searchIconImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "searchIcon"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = /*.sarabunL14*/ .kanitLight14
        textField.textColor = .white
        textField.textAlignment = .left
        textField.returnKeyType = .search
        return textField
    }()
    
    private let searchPlaceholder: UILabel = {
        let label = UILabel()
        label.font = /*.sarabunL14*/ .kanitLight14
        label.textColor = .white
        label.text = "ค้นหาโน้ต"
        return label
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "clearIcon"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    var tabPageViewController: TabPageViewController!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brandcolor_bg
        hideKeyboardWhenTappedAround()
        setupTabPage()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchPlaceholder.isHidden = false
        searchIconImage.isHidden = false
        clearButton.isHidden = true
        
        searchTextField.text = ""
    }
    
    private func setupTabPage() {
        tabPageViewController = TabPageViewController()
        let allNote = AllNoteViewController()
        let myNote = MyNoteViewController()
        
        tabPageViewController.tabItems = [(allNote, "โน้ตทั้งหมด"), (myNote, "โน้ตของฉัน")]
        
        tabPageViewController.option = {
            var option = TabPageOption()
            option.tabHeight = PAGEBAR_HEIGHT
            option.currentColor = .brandcolor1
            option.defaultColor = .guestcolor
            option.pageBackgoundColor = .brandcolor_bg
            option.tabWidth = view.frame.width / 2
            return option
        }()
        
        insertChildController(tabPageViewController, intoParentView: view, below: navigationView, withFrame: CGRect())
    }
    
    private func setupUI() {
        navigationView.toolBar.hide()
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(TOP_VIEW)
        }
        
        let searchView: UIView = {
            let view = UIView()
            view.backgroundColor = .blackAlpha(alpha: 0.2)
            view.cornerView(radius: 5)
            return view
        }()
        
        navigationView.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.height.equalTo(28)
            make.leading.equalTo(navigationView.snp.leading).offset(MARGIN)
            make.trailing.equalTo(navigationView.snp.trailing).offset(-MARGIN)
            make.bottom.equalTo(navigationView.snp.bottom).offset(-9)
        }
        
        searchView.addSubview(searchTextField)
        searchTextField.delegate = self
        searchTextField.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.top)
            make.bottom.equalTo(searchView.snp.bottom)
            make.leading.equalTo(searchView.snp.leading).offset(MARGIN)
            make.trailing.equalTo(searchView.snp.trailing).offset(-MARGIN)
        }
        
        searchView.addSubview(searchPlaceholder)
        searchPlaceholder.snp.makeConstraints { (make) in
            make.centerX.equalTo(searchView.snp.centerX)
            make.centerY.equalTo(searchView.snp.centerY)
        }
        
        searchView.addSubview(searchIconImage)
        searchIconImage.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.centerY.equalTo(searchView.snp.centerY)
            make.leading.equalTo(searchView.snp.leading).offset(MARGIN)
        }
        
        clearButton.addTarget(self, action: #selector(clearSearchFieldText(_:)), for: .touchUpInside)
        searchView.addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.centerY.equalTo(searchView.snp.centerY)
            make.trailing.equalTo(searchView.snp.trailing).offset(-MARGIN)
        }
        
        tabPageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    @objc func clearSearchFieldText(_ sender: UIButton) {
        view.endEditing(true)
        searchTextField.text = ""
        textFieldDidEndEditing(searchTextField)
    }

}

extension NoteDashboardViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchPlaceholder.isHidden = true
        searchIconImage.isHidden = true
        clearButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchPlaceholder.isHidden = !(textField.text ?? "").isEmpty
        searchIconImage.isHidden = !(textField.text ?? "").isEmpty
        clearButton.isHidden = (textField.text ?? "").isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let moreNote = MoreNoteViewController()
        moreNote.viewModel = MoreNoteViewModel(type: .search, searchParam: textField.text ?? "")
        navigationController?.pushViewController(moreNote, animated: true)
        return true
    }
}
