//
//  KeyboardObservingViewController.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation
import UIKit

///A UIViewController which responds to UIKeyboard events and adjusts its view to accommodate the onscreen keyboard.
///Must set either 'contentScrollView' or 'bottomViewConstraint' from subclass.
class KeyboardObservingViewController: UIViewController {
    
    //values for coordinating table view's appearance with keyboard events (cached when keyboard is first shown, and again whenever device orientation changes)
    var keyboardFrame: CGRect?
    private var keyboardAnimationDuration: TimeInterval?
    private var originalViewFrame: CGRect!
    private var originalScrollViewContentInset: UIEdgeInsets!
    private var originalBottomConstraintConstant: CGFloat!
    private var adjustingScrollView: Bool!
    
    ///The scroll view which will be adjusted to accommodate the onscreen keyboard.  Set from subclass.
    var contentScrollView: UIScrollView! {
        didSet {
            adjustingScrollView = true
            originalScrollViewContentInset = contentScrollView.contentInset
        }
    }
    
    ///The bottom screen constraint which will be adjusted to accommodate the onscreen keyboard.  Set from subclass.
    var bottomViewConstraint: NSLayoutConstraint! {
        didSet {
            adjustingScrollView = false
            originalBottomConstraintConstant = bottomViewConstraint.constant
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    //override for custom logic when keyboard appears
    func keyboardAppeared() {}
    func keyboardDisappeared() { }
    func keyboardWillDisappear() {}
    func keyboardWillAppear() {}
}

// MARK: - Keyboard Observation
extension KeyboardObservingViewController {
    private func refreshKeyboardConstants(_ notification: Notification) {
        //refresh constants before using them to adjust the view's appearance
        keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? CGRect.zero)
        keyboardAnimationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.0)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        keyboardWillAppear()
        refreshKeyboardConstants(notification)
        UIView.animate(withDuration: keyboardAnimationDuration ?? 0.0, animations:  { [unowned self] in
            if self.adjustingScrollView {
                //adjust scroll view's content insets to accomodate keyboard
                let originalBottomY = (self.contentScrollView.superview?.convert(self.contentScrollView.frame.origin, to: nil).y ?? 0.0) + self.contentScrollView.frame.size.height
                let verticalTranslation = originalBottomY - (self.keyboardFrame?.origin.y ?? 0.0)
                let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: verticalTranslation > 0 ? verticalTranslation : 0.0, right: 0.0)
                self.contentScrollView.contentInset = contentInset
                self.contentScrollView.scrollIndicatorInsets = contentInset
                self.contentScrollView.layoutIfNeeded()
            } else {
                //adjust bottom constraint to accomodate keyboard
                self.bottomViewConstraint.constant = -(self.keyboardFrame?.height ?? 0.0)
                self.view.layoutIfNeeded()
            }
            }, completion: {
                [weak self] _ in
                self?.keyboardAppeared()
        })
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        keyboardWillDisappear()
        UIView.animate(withDuration: keyboardAnimationDuration ?? 0.0, animations:  { [unowned self] in
            if self.adjustingScrollView {
                //restore original content insets when keyboard is dismissed
                self.contentScrollView.contentInset = self.originalScrollViewContentInset
                self.contentScrollView.scrollIndicatorInsets = self.originalScrollViewContentInset
                self.contentScrollView.layoutIfNeeded()
            } else {
                //restore original bottom constraint constant when keyboard is dismissed
                self.bottomViewConstraint.constant = self.originalBottomConstraintConstant
                self.view.layoutIfNeeded()
            }
        }, completion: {
                [weak self] _ in
                self?.keyboardDisappeared()
        })
    }
}
