//
//  EmailInputVC.swift
//  firebase_auth_example
//
//  Created by 林 明虎 on 2024/12/09.
//

import UIKit

class EmailInputVC: UIViewController {
    enum AEEmailAuthMode {
        case login
        case signUp
    }
    
    private let mode: AEEmailAuthMode
    private let emailTextField = AEInputField(placeholder: "メールアドレス")
    private let passwordTextField = AEInputField(placeholder: "パスワード", isSecure: true)
    private let authService = AEEmailAuthService()
    
    private lazy var actionButton: AECardButton = {
        let title = (mode == .login) ? "ログイン" : "登録"
        return AECardButton(title: title) { [weak self] in
            self?.authenticate()
        }
    }()
    
    private lazy var clearButton: AECardButton = {
        AECardButton(title: "クリア") { [weak self] in
            self?.clearInputFields()
        }
    }()
    
    init(mode: AEEmailAuthMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // スタックビューの作成
        let buttonStackView = UIStackView(arrangedSubviews: [clearButton, actionButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 16
        buttonStackView.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, buttonStackView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func clearInputFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func authenticate() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "入力エラー", message: "メールアドレスまたはパスワードを入力してください。")
            return
        }

        showLoading() // 操作を無効化し、ローディング表示を開始

        let authMode: AEEmailAuthService.AuthMode = (mode == .login) ? .login : .signUp
        authService.authenticate(email: email, password: password, mode: authMode) { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoading() // 操作を有効化し、ローディング表示を終了
                switch result {
                case .success:
                    self?.showAlert(title: "成功", message: (authMode == .login) ? "ログインしました！" : "確認メールのURLから認証を完了してください")
                case .failure(let error):
                    if error == .emailNotVerified {
                        self?.authService.showResendVerificationAlert(on: self!, email: email)
                    } else {
                        self?.showAlert(title: "エラー", message: error.localizedDescription)
                    }
                }
            }
        }
    }

}


