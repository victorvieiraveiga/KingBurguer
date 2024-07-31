//
//  SignInViewController.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 23/04/24.
//

import Foundation
import UIKit

class SignInViewController: UIViewController {
    
    let scroll: UIScrollView = {
        let sc = UIScrollView()
        sc.translatesAutoresizingMaskIntoConstraints = false
  
        sc.showsVerticalScrollIndicator = true
        sc.showsHorizontalScrollIndicator = true
        return sc
    }()
    
    let container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var email: TextField = {
        let ed = TextField()
        ed.placeholder = "Entre com seu e-mail"
        ed.returnKeyType = .next
        ed.error = "Email inválido"
        ed.failure = {
            return !(ed.text?.isEmail() ?? true)
        }
        ed.delegate = self
        ed.keyboardType = .emailAddress
        ed.bitmask = SignInForm.email.rawValue
        return ed
    }()
    
    lazy var password: TextField = {
        let ed = TextField()
        ed.placeholder = "Entre com sua senha"
        ed.returnKeyType = .done
        ed.error = "Senha deve ter no minimo 8 caracteres"
        ed.failure = {
            return self.password.text?.count ?? 0 <= 7
        }
        ed.delegate = self
        ed.secureTextEntry = true
        ed.bitmask = SignInForm.password.rawValue
        return ed
    }()
    
    lazy var send: LoadingButton = {
        let btn = LoadingButton()
        btn.title = "Entrar"
        btn.titleColor = .white
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 10
        btn.enable(false)
        btn.addTarget(self, action: #selector(sendDidTap))
        return btn
    }()
    
    lazy var register: UIButton = {
        let btn = UIButton()
        btn.setTitle("Criar conta", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(registerDidTap), for: .touchUpInside)
        return btn
    }()
    
    var viewModel: SignInViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    func validation() -> Bool {
        return email.text?.count ?? 0 <= 3
    }
    
    var bitmaskResult: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Login"
        
        container.addSubview(email)
        container.addSubview(password)
        container.addSubview(send)
        container.addSubview(register)
        
        scroll.addSubview(container)
        view.addSubview(scroll)
        
        let scrollConstraints = [
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let heightConstraint = container.heightAnchor.constraint(equalTo: view.heightAnchor)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        
        let containerConstraints = [
            container.widthAnchor.constraint(equalTo: view.widthAnchor),
            container.topAnchor.constraint(equalTo: scroll.topAnchor),
            container.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            
            container.heightAnchor.constraint(equalToConstant: 490)
        ]
        
        
        let emailConstraints = [
            email.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            email.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            email.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -150),
        ]
        
        let passwordConstraints = [
            password.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            password.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10.0),
        ]
        
        let sendConstraints = [
            send.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            send.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            send.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 10.0),
            send.heightAnchor.constraint(equalToConstant: 50.0)
        ]
        
        let registerConstraints = [
            register.leadingAnchor.constraint(equalTo: email.leadingAnchor),
            register.trailingAnchor.constraint(equalTo: email.trailingAnchor),
            register.topAnchor.constraint(equalTo: send.bottomAnchor, constant: 10.0),
            register.heightAnchor.constraint(equalToConstant: 50.0)
        ]
        
        NSLayoutConstraint.activate(emailConstraints)
        NSLayoutConstraint.activate(passwordConstraints)
        NSLayoutConstraint.activate(sendConstraints)
        NSLayoutConstraint.activate(registerConstraints)
        
        NSLayoutConstraint.activate(scrollConstraints)
        NSLayoutConstraint.activate(containerConstraints)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardNotification),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardNotification),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func onKeyboardNotification(_ notification: Notification) {
        let visible = notification.name == UIResponder.keyboardWillShowNotification
       
        let keyboardFrame = visible
        ? UIResponder.keyboardFrameEndUserInfoKey
        : UIResponder.keyboardFrameBeginUserInfoKey
        
        if let keyboardSize = (notification.userInfo?[keyboardFrame] as? NSValue)?.cgRectValue {
            onKeyboardChanged(visible, height: keyboardSize.height)
        }
    }
    
    func onKeyboardChanged(_ visible: Bool, height: CGFloat) {
        if (!visible) {
            scroll.contentInset = .zero
            scroll.scrollIndicatorInsets = .zero
        } else {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: height, right: 0.0)
            scroll.contentInset = contentInsets
            scroll.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func dismissKeyboard(_ view: UITapGestureRecognizer) {
        self.view?.endEditing(true)
    }
    
    @objc func sendDidTap(_ sender: UIButton) {
        guard let email = email.text, let password = password.text else { return }
        viewModel?.login(userName: email, password: password)
    }
    
    @objc func registerDidTap(_ sender: UIButton) {
        viewModel?.goToSignUp()
    }
}

extension SignInViewController: SignInViewModelDelegate {
    func viewModelDidChanged(state: SignInState) {
        switch(state) {
        case .none:
            break
        case .loading:
            send.startLoading(true)
            break
        case .goToHome:
            viewModel?.goToHome()
            break
        case .error(let msg):
            let alert = UIAlertController(title: "Erro", message: msg, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(alert, animated: true)
            DispatchQueue.main.async {
                self.send.startLoading(false)
            }
        }
    }
}

extension SignInViewController: TextFieldDelegate {
    func textFieldDidChanged(isValid: Bool, bitmask: Int, text: String) {
        if isValid {
            self.bitmaskResult = self.bitmaskResult | bitmask
            print("bitmaskResult is: \(self.bitmaskResult)")
        } else {
            self.bitmaskResult = self.bitmaskResult & ~bitmask
        }
        
        self.send.enable((SignInForm.email.rawValue & self.bitmaskResult != 0 ) && (SignInForm.password.rawValue & self.bitmaskResult != 0))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType == .done) {
            view.endEditing(true)
        } else {
            password.gainFocus()
        }
        return false
    }
}

enum SignInForm: Int {
    case email = 1
    case password = 2
}
