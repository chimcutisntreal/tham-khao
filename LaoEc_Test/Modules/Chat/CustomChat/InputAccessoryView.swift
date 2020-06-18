//
//  InputAccessoryView.swift
//  LaoEc_Test
//
//  Created by MacOne on 12/6/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class InputAccessoryView: UIView {
    static let maxHeight: CGFloat = 200
    static let minHeight: CGFloat = 50
    static let paddingTop: CGFloat = 8
    static let paddingBottom: CGFloat = 8
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    static func inputAccessoryView(target: UIViewController, text: String? = nil, placeholder: String? = "New Message",action: Selector) -> InputAccessoryView? {
        
        if let view = InputAccessoryView().loadNib() as? InputAccessoryView {
            view.sendButton.setImage(UIImage(named: "send"), for: .normal)
            view.sendButton.addTarget(target, action: action, for: .touchUpInside)
            view.placeholder.text = placeholder
            view.textView.delegate = view.self
            if text != nil, text?.isEmpty == false {
                view.placeholder.isHidden = true
                view.textView.text = text
                
            } else {
                view.sendButton.isEnabled = false
            }
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.gray.cgColor
            return view
        } else {
            return nil
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.textView.isScrollEnabled = false
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat(MAXFLOAT)))
        let totalHeight = size.height + InputAccessoryView.paddingTop + InputAccessoryView.paddingBottom
        if totalHeight <= InputAccessoryView.maxHeight {
            return CGSize(width: self.bounds.width, height: max(totalHeight, InputAccessoryView.minHeight))
        } else {
            self.textView.isScrollEnabled = true
            return CGSize(width: self.bounds.width, height: InputAccessoryView.maxHeight)
        }
    }
    
    private func isReadAllMessage(){
        SocketIOManager.sharedInstance.isReadAllMessage()
        NotificationCenter.default.addObserver(self, selector: #selector(isReadAll), name: .ReadAllMessage, object: nil)
    }
    @objc func isReadAll(_ notification: Notification){
        let received = notification.object as! [Any]
        print("recx \(received)")
    }
    
    func showKeyboard(){
        NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func hideKeyboard(){
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension InputAccessoryView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        showKeyboard()
        hideKeyboard()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        showHidePlaceholder(in: textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.invalidateIntrinsicContentSize()
        updateConstraints()
        showHidePlaceholder(in: textView)
    }
    
    func showHidePlaceholder(in textView: UITextView) {
        if !textView.hasText || textView.text.isEmpty {
            sendButton.setImage(UIImage(named: "send"), for: .normal)
            sendButton.isEnabled = false
            placeholder?.isHidden = false
        } else {
            // hide
            sendButton.setImage(UIImage(named: "sent"), for: .normal)
            sendButton.isEnabled = true
            placeholder?.isHidden = true
        }
    }
}

extension UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InputAccessoryView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
