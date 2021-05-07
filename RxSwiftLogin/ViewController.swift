//
//  ViewController.swift
//  RxSwiftLogin
//
//  Created by Jeff Umandap on 5/7/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.becomeFirstResponder()
        
        usernameField.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.usernameTextPublishSubject).disposed(by: disposeBag)
        passwordField.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.passwordTextPublishSubject).disposed(by: disposeBag)
        
        loginViewModel.isValid().bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isValid().map { $0 ? 1 : 0.1 }.bind(to: loginBtn.rx.alpha).disposed(by: disposeBag)
    }

    
    @IBAction func loginTapped(_ sender: UIButton) {
        print("Login Tapped")
    }
    
}

class LoginViewModel {
    let usernameTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        Observable.combineLatest(usernameTextPublishSubject.asObservable().startWith(""), passwordTextPublishSubject.asObservable().startWith("")).map { username, password in
            return username.count > 3 && password.count > 3
        }.startWith(false)
    }
}
