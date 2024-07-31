//
//  SignUpViewController.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 23/04/24.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
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
    
    lazy var name: TextField = {
        let ed = TextField()
        ed.placeholder = "Entre com seu nome"
        ed.returnKeyType = .next
        ed.delegate = self
        ed.tag = 1
        ed.error = "NOME DEVE TER NO minimo 3 caracteres"
        ed.failure = {
            return self.name.text?.count ?? 0 <= 3
        }
        ed.bitmask = SignUpForm.name.rawValue
        return ed
    }()
    
    lazy var  email: TextField = {
        let ed = TextField()
        ed.placeholder = "Entre com seu email"
        ed.returnKeyType = .next
        ed.delegate = self
        ed.tag = 2
        ed.error = "E-mail inválido"
        ed.failure = {
            return !(ed.text?.isEmail() ?? false)
        }
        ed.bitmask = SignUpForm.email.rawValue
        ed.keyboardType = .emailAddress
        return ed
    }()
    
    lazy var  password: TextField = {
        let ed = TextField()
        ed.placeholder = "Entre com sua senha"
        ed.returnKeyType = .next
        ed.delegate = self
        ed.tag = 3
        ed.error = "Senha deve ter no minimo 8 caracteres"
        ed.failure = {
            return self.password.text?.count ?? 0 <= 7
        }
        ed.bitmask = SignUpForm.password.rawValue
        ed.secureTextEntry = true
        return ed
    }()
    
    lazy var document: TextField = {
        let ed = TextField()
        ed.placeholder = "Entre com seu CPF"
        ed.returnKeyType = .next
        ed.delegate = self
        ed.tag = 4
        ed.error = "CPF deve ter no minimo 11 digitos."
        ed.failure = {
            return self.document.text?.count ?? 0 != 14
        }
        ed.maskField = Mask(mask: "###.###.###-##")
        ed.bitmask = SignUpForm.document.rawValue
        ed.keyboardType = .numberPad
        return ed
    }()
    
    lazy var birthday: TextField = {
        let ed = TextField()
        ed.placeholder = "Entre com sua data de nascimento"
        ed.returnKeyType = .done
        ed.delegate = self
        ed.tag = 5
        ed.error = "Data de nascimento deve ser dd/MM/yyyy"
        ed.failure = {
            let invalidCount = ed.text?.count ?? 0 != 10
            
            let dt = DateFormatter()
            dt.locale = Locale(identifier: "en_US_POSIX")
            dt.dateFormat = "dd/MM/yyyy"
            
            let date = dt.date(from: ed.text ?? "")
            let invalidDate = date == nil
            
            return invalidDate || invalidCount
        }
        ed.maskField = Mask(mask: "##/##/####")
        ed.bitmask = SignUpForm.birthDay.rawValue
        ed.keyboardType = .numberPad
        return ed
    }()
    
    lazy var send: LoadingButton = {
        let btn = LoadingButton()
        btn.title = "Entrar"
        btn.titleColor = .white
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(sendDidTap))
        btn.enable(false)
        return btn
    }()
    
    var viewModel: SignUpViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    var bitmaskResult: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        container.addSubview(name)
        container.addSubview(email)
        container.addSubview(password)
        container.addSubview(document)
        container.addSubview(birthday)
        container.addSubview(send)
        
        scroll.addSubview(container)
        view.addSubview(scroll)
        
        scroll.alwaysBounceVertical = true
        scroll.alwaysBounceHorizontal = true
        
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
            container.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            container.topAnchor.constraint(equalTo: scroll.topAnchor),
            container.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 490)
        ]
        
        let nameConstraints = [
            name.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            name.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -150.0),
        ]
        
        let emailConstraints = [
            email.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            email.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            email.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10.0),
        ]
        
        let passwordConstraints = [
            password.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            password.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10.0),
        ]
        
        let documentConstraints = [
            document.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            document.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            document.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 10.0),
        ]
        
        let birthdayConstraints = [
            birthday.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            birthday.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            birthday.topAnchor.constraint(equalTo: document.bottomAnchor, constant: 10.0),
        ]
        
        let sendConstraints = [
            send.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            send.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            send.topAnchor.constraint(equalTo: birthday.bottomAnchor, constant: 10.0),
            send.heightAnchor.constraint(equalToConstant: 50.0)
        ]
        
        NSLayoutConstraint.activate(nameConstraints)
        NSLayoutConstraint.activate(emailConstraints)
        NSLayoutConstraint.activate(passwordConstraints)
        NSLayoutConstraint.activate(documentConstraints)
        NSLayoutConstraint.activate(birthdayConstraints)
        NSLayoutConstraint.activate(sendConstraints)
        
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
    
    @objc func dismissKeyboard(_ view: UITapGestureRecognizer) {
        self.view?.endEditing(true)
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
    
    
    @objc func sendDidTap(_ sender: UIButton) {
        viewModel?.send()
    }
}

extension SignUpViewController: SignUpViewModelDelegate {
    func viewModelDidChanged(state: SignUpState) {
        switch(state) {
        case .none:
            break
        case .loading:
            send.startLoading(true)
        case .goToLogin:
            
            let alert = UIAlertController(title: "Erro", message: "Usuario cadastrado com sucesso", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.viewModel?.goToLogin()
            }))
            
            self.present(alert, animated: true)
            
            break
        case .error(let msg):
            let alert = UIAlertController(title: "Erro", message: msg, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(alert, animated: true)
        }
    }
}

extension SignUpViewController: TextFieldDelegate {
    func textFieldDidChanged(isValid: Bool, bitmask: Int, text: String) {
        if isValid {
            self.bitmaskResult = self.bitmaskResult | bitmask
            print("bitmaskResult is: \(self.bitmaskResult)")
        } else {
            self.bitmaskResult = self.bitmaskResult & ~bitmask
        }
        
        self.send.enable((SignUpForm.email.rawValue & self.bitmaskResult != 0 ) &&
                         (SignUpForm.password.rawValue & self.bitmaskResult != 0) &&
                         (SignUpForm.name.rawValue & self.bitmaskResult != 0 ) &&
                         (SignUpForm.document.rawValue & self.bitmaskResult != 0 ) &&
                         (SignUpForm.birthDay.rawValue & self.bitmaskResult != 0 ))
        
        
        if bitmask == SignUpForm.name.rawValue {
            viewModel?.name = text
        } else if bitmask == SignUpForm.password.rawValue {
            viewModel?.password = text
        } else if bitmask == SignUpForm.email.rawValue {
            viewModel?.email = text
        } else if bitmask == SignUpForm.document.rawValue {
            viewModel?.document = text
        } else if bitmask == SignUpForm.birthDay.rawValue {
            viewModel?.birthday = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType == .done) {
            view.endEditing(true)
            print("Save!")
            return false
        }
        
        let nextTag = textField.tag + 1
        let component = container.findViewByTag(tag: nextTag) as? TextField
        
        if component != nil {
            component?.gainFocus()
        } else {
            view.endEditing(true)
        }
        
        return false
    }
}

//TODO: Organizar o projeto sepradno a extension utilitária

extension UIView {
    func findViewByTag(tag: Int) -> UIView? {
        for subview in subviews {
            if subview.tag == tag {
                return subview
            }
        }
        return nil
    }
}

enum SignUpForm: Int {
    case name = 1
    case email = 2
    case password = 3
    case document = 4
    case birthDay = 5
}
