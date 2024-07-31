//
//  TextField.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 24/05/24.
//

import UIKit

protocol TextFieldDelegate: UITextFieldDelegate {
    func textFieldDidChanged(isValid: Bool, bitmask: Int, text: String)
}

class TextField: UIView {
    
    lazy var editText: UITextField = {
        let ed = UITextField()
        ed.borderStyle = .roundedRect
        ed.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        ed.translatesAutoresizingMaskIntoConstraints = false
        
        return ed
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var placeholder: String? {
        willSet {
            editText.placeholder = newValue
        }
    }
    
    var keyboardType: UIKeyboardType = .default {
        willSet {
            if newValue == .emailAddress {
                editText.autocapitalizationType = .none
            }
            editText.keyboardType = newValue
        }
    }
    
    var secureTextEntry: Bool = false {
        willSet {
            editText.isSecureTextEntry = newValue
            editText.textContentType = .oneTimeCode
        }
    }
    
    var returnKeyType: UIReturnKeyType = .next {
        willSet {
            editText.returnKeyType = newValue
        }
    }
    
    var text: String? {
        get {
            return editText.text!
        }
    }
    
    override var tag: Int {
        willSet {
            super.tag = newValue
            editText.tag = newValue
        }
    }
    
    var delegate: TextFieldDelegate? {
        willSet {
            editText.delegate = newValue
        }
    }
    
    var failure: (() -> Bool)?
    
    var error: String?
    
    var heightConstraint: NSLayoutConstraint!
    
    func gainFocus() {
        editText.becomeFirstResponder()
    }
    
    var bitmask: Int = 0
    var maskField: Mask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(editText)
        addSubview(errorLabel)
        
        let editTextConstraints = [
            editText.leadingAnchor.constraint(equalTo: leadingAnchor),
            editText.trailingAnchor.constraint(equalTo: trailingAnchor),
            editText.heightAnchor.constraint(equalToConstant: 50.0)
        ]
        
        let errorLabeltConstraints = [
            errorLabel.leadingAnchor.constraint(equalTo: editText.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: editText.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: editText.bottomAnchor)
        ]
        
        heightConstraint = heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
        
        NSLayoutConstraint.activate(editTextConstraints)
        NSLayoutConstraint.activate(errorLabeltConstraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        if let mask = maskField {
            if let res = mask.process(value: textField.text!) {
                textField.text = res
            }
        }
        
        
        guard let failure = failure else { return }
        
        if let error = error {
            if failure() {
                errorLabel.text = error
                heightConstraint.constant = 70
                delegate?.textFieldDidChanged(isValid: false, bitmask: bitmask, text: textField.text!)
            }  else {
                errorLabel.text = ""
                heightConstraint.constant = 50
                delegate?.textFieldDidChanged(isValid: true, bitmask: bitmask, text: textField.text!)
            }
        }

        layoutIfNeeded()
    }
}
