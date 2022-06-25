//
//  LoginViewController.swift
//  Caralibro Messenger
//
//  Created by Ana Gabriela Yucra Vila on 22/06/22.
//

import UIKit
import FirebaseAuth
import FirebaseAnalytics
import GoogleSignIn

class LoginViewController : UIViewController{
   
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    
    @IBAction func clickBtnClose(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
 
    @IBAction func tapCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func swipetoOpenKeyboardRegister(_ sender: Any) {
        self.txtFieldEmail.becomeFirstResponder()
    }
    
    @IBAction func swipeCloseKeyboardLogin(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message" : "Integracion de Firebase"])
        
        //Comprobar la session del usuario autenticado
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String,
           let provider = defaults.value(forKey: "provider") as? String{
            navigationController?.pushViewController(HomeViewController(email:email,provider: ProviderType.init(rawValue: provider)!), animated: false)
        }
        //Google Auth
        //GIDSignIn.sharedInstance?.presentingViewController = self
        //GIDSignIn.sharedInstance?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardEvents()
        //stack.isHidden = false bloquear vista si esta logeado
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardEvents()
    }
      
    @IBAction func clickBtnLogin(_ sender: Any) {
        
        if let email = txtFieldEmail.text, let password = txtFieldPassword.text{
            Auth.auth().signIn(withEmail: email, password: password){
                (result, error) in
                
                if let result = result, error == nil{
                    self.showAlert("Login", message: "Datos correctos", accept: "Bienvenido")
                    self.navigationController?.pushViewController(HomeViewController(email:
                                            result.user.email!, provider: .basic), animated: true)
                }else{
                    self.showAlert("Error", message: "Datos incorrectos, vuelva a ingresarlos", accept: "Aceptar")
                }
                    
            }
            
        }
        
    }
    
    
 
}

extension LoginViewController{
    
    private func registerKeyboardEvents() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterKeyboardEvents() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        print("Se abrio el teclado")
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        print(keyboardFrame.height)
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            self.constraintBottomScroll.constant = keyboardFrame.height + 10
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        print("Se cerro el teclado")
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            self.constraintBottomScroll.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
    
