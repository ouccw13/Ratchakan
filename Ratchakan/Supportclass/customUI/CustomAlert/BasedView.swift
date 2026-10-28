//
//  BasedView.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 22/2/2566 BE.
//  Copyright © 2566 BE Chatcha.sobtid. All rights reserved.
//

import UIKit

class BasedView: UIView, NibFileOwnerLoadable {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViewWithNib()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewWithCode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewWithCode()
    }
    
    func setupViewWithCode() {
        loadViewFromXib()
    }
    
    func setupViewWithNib() {
        loadViewFromXib()
    }
}

protocol NibFileOwnerLoadable {
    init()
}

//extension NibFileOwnerLoadable where Self: UIViewController {
//    init() { self.init(nibName: Self.reuseIdentifier, bundle: nil) }
//}

extension NibFileOwnerLoadable where Self: UIView {
    var view: UIView { return loadViewFromXib() }
    
    @discardableResult
    func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        self.addSubview(view)
        return view
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func moveViewWhenKeyboradAppear(_ appear: Selector = #selector(ViewController.keyboardWillShow), disappear: Selector = #selector(ViewController.keyboardWillHide), target: Any = UIViewController.self) {
        NotificationCenter.default.addObserver(target, selector: appear, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(target, selector: disappear, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

var getWindow: UIWindow {
//    return UIApplication.shared.keyWindow!
    return UIApplication
        .shared
        .connectedScenes
        .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
        .first { $0.isKeyWindow } as! UIWindow
}

public enum PopupViewAnimation {
    case `default`
    case fade
    case fromTop, fromBottom
    case bounceFromTop, bounceFromBottom, scale, scaleWithBounce
}

public protocol PopupViewDelegate {
    func show(for contentView: UIView,
              animation: PopupViewAnimation)
    
    func dismiss(for contentView: UIView,
                 animation: PopupViewAnimation,
                 completion: (()->Void)?)
    
    var backgroundView: UIView {get}
}

extension PopupViewDelegate where Self: UIView {
    
    /// Description
    ///
    /// - Parameters:
    ///   - view: viewController.view
    ///   - contentView: UIView for animation
    ///     - Example AlertView.contentView
    ///   - animation: IamsnowAlertViewAnimation.default
    ///   - timeInterval: 0.1 is default
    public func show(for contentView: UIView, animation: PopupViewAnimation = .default){
        self.backgroundView.alpha = 0
        getWindow.addSubview(self)
        //        view.addSubview(self)
        /*
         if var topController = UIApplication.shared.delegate?.window??.rootViewController {
         while let presentedViewController = topController.presentedViewController {
         topController = presentedViewController
         }
         topController.view.addSubview(self)
         }
         */
        
        func animateDismiss(withDuration: TimeInterval) {
            UIView.animate(withDuration: withDuration, animations: {
                self.backgroundView.alpha = 0.33
            })
        }
        
        func animationScale(withDuration: TimeInterval, scaleX: CGFloat, y: CGFloat) {
            contentView.alpha = 0
            contentView.transform = CGAffineTransform(scaleX: scaleX, y: y)
            
            UIView.animate(withDuration: withDuration, animations: {
                contentView.transform = CGAffineTransform.identity
                contentView.alpha = 1.0
            }, completion: nil)
        }
        
        
        func animationScaleWithDamping(withDuration: TimeInterval, delay: TimeInterval, usingSpringWithDamping timeInterval: CGFloat, options: UIView.AnimationOptions, scaleX: CGFloat, y: CGFloat) {
            
            contentView.alpha = 0
            contentView.transform = CGAffineTransform(scaleX: scaleX, y: y)
            UIView.animate(withDuration: withDuration, delay: delay, usingSpringWithDamping: timeInterval, initialSpringVelocity: 0.0, options: options, animations: {
                contentView.transform = CGAffineTransform.identity
                contentView.alpha = 1.0
            }, completion: nil)
        }
        
        func animationWithPosition(from: CGFloat, to: CGFloat, withDuration: TimeInterval, delay: TimeInterval, usingSpringWithDamping timeInterval: CGFloat, options: UIView.AnimationOptions) {
            contentView.center.y = from
            
            contentView.alpha = 0.0
            UIView.animate(withDuration: withDuration, delay: delay, usingSpringWithDamping: timeInterval, initialSpringVelocity: 0.0, options: options, animations: {
                contentView.center.y = to
                contentView.alpha = 1.0
            }, completion: nil)
        }
        
        func animationWithPosition(from: CGFloat, to: CGFloat, withDuration: TimeInterval) {
            contentView.center.y = from
            contentView.alpha = 0.0
            UIView.animate(withDuration: withDuration, animations: {
                contentView.center.y = to
                contentView.alpha = 1.0
            }, completion: nil)
        }
        
        switch animation {
        case .default:
            animateDismiss(withDuration: 0.0)
        case .fade:
            animateDismiss(withDuration: 0.33)
            animationScale(withDuration: 0.33, scaleX: 1, y: 1)
        case .scale:
            animateDismiss(withDuration: 0.33)
            animationScale(withDuration: 0.25, scaleX: 0.0, y: 0.0)
        case .scaleWithBounce:
            animateDismiss(withDuration: 0.33)
            animationScaleWithDamping(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.6, options: [.allowUserInteraction], scaleX: 0.0, y: 0.0)
        case .bounceFromTop:
            animateDismiss(withDuration: 0.33)
            animationWithPosition(from: -getWindow.bounds.height, to: getWindow.bounds.height, withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.6, options: [.allowUserInteraction])
        case .bounceFromBottom:
            animateDismiss(withDuration: 0.33)
            animationWithPosition(from: getWindow.bounds.height, to: -getWindow.bounds.height, withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.6, options: [.allowUserInteraction])
        case .fromTop:
            animateDismiss(withDuration: 0.33)
            animationWithPosition(from: -getWindow.bounds.height, to: getWindow.bounds.height, withDuration: 0.33)
        case .fromBottom:
            animateDismiss(withDuration: 0.33)
            animationWithPosition(from: getWindow.bounds.height, to: -getWindow.bounds.height, withDuration: 0.33)
        }
    }
    
    public func dismiss(for contentView: UIView, animation: PopupViewAnimation = .default, completion: (()->Void)?){
        
        func animateDismiss(withDuration: TimeInterval, delay: TimeInterval) {
            UIView.animate(withDuration: withDuration, delay: delay, options: [], animations: {
                self.backgroundView.alpha = 0
            }) { (completed) in
                self.removeFromSuperview()
            }
        }
        
        func animationScale(withDuration: TimeInterval, scaleX: CGFloat, y: CGFloat) {
            contentView.alpha = 1.0
            UIView.animate(withDuration: withDuration, animations: {
                contentView.transform = CGAffineTransform(scaleX: scaleX, y: y)
                contentView.alpha = 0.0
            }, completion: nil)
            
        }
        
        
        switch animation {
        case .default:
            animateDismiss(withDuration: 0.0, delay: 0.0)
        case .fade:
            animationScale(withDuration: 0.33, scaleX: 1, y: 1)
            animateDismiss(withDuration: 0.33, delay: 0.0)
        case .scale:
            animationScale(withDuration: 0.25, scaleX: 0.1, y: 0.1)
            animateDismiss(withDuration: 0.33, delay: 0.0)
        case .scaleWithBounce:
            UIView.animate(withDuration: 0.25, animations: {
                contentView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            })
            
            UIView.animate(withDuration: 0.25, delay: 0.25, options: [], animations: {
                contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                contentView.alpha = 0.0
            }) { (completed) in }
            
            animateDismiss(withDuration: 0.66, delay: 0.0)
        case .bounceFromTop:
            
            contentView.alpha = 1.0
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                contentView.center.y += 100.0
            }, completion: { _ in })
            
            UIView.animate(withDuration: 0.25, delay: 0.25, options: [], animations: {
                contentView.center.y -= getWindow.bounds.height
            }, completion: { _ in })
            
            animateDismiss(withDuration: 0.6, delay: 0.0)
            
        case .bounceFromBottom:
            
            contentView.alpha = 1.0
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                contentView.center.y -= 100.0
            }, completion: { _ in })
            
            UIView.animate(withDuration: 0.25, delay: 0.25, options: [], animations: {
                contentView.center.y += getWindow.bounds.height
            }, completion: { _ in })
            
            animateDismiss(withDuration: 0.6, delay: 0.0)
            
        case .fromTop:
            
            contentView.alpha = 1.0
            UIView.animate(withDuration: 0.5, animations: {
                contentView.center.y -= getWindow.bounds.height
                contentView.alpha = 0.0
            }, completion: nil)
            
            animateDismiss(withDuration: 0.6, delay: 0.0)
        case .fromBottom:
            contentView.alpha = 1.0
            UIView.animate(withDuration: 0.5, animations: {
                contentView.center.y += getWindow.bounds.height
                contentView.alpha = 0.0
            }, completion: nil)
            animateDismiss(withDuration: 0.6, delay: 0.0)
        }
        
        completion?()
    }
    
    
    
}

