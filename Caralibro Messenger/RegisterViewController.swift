//
//  CreateViewController.swift
//  Caralibro Messenger
//
//  Created by Ana Gabriela Yucra Vila on 23/06/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController:UIViewController{
    
    @IBOutlet weak var txtFieldName: UITextField!
    
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    @IBOutlet weak var txtFieldEmail: UITextField!

    @IBOutlet weak var txtFieldPhone: UITextField!
    
    private let db = Firestore.firestore()
    
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    
    @IBAction func clickBtnCloseRegister(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func tapCloseKeyboardRegister(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func swipeCloseKeyboardRegister(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func swipetoOpenKeyboardRegister(_ sender: Any) {
        self.txtFieldName.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func clickBtnRegister(_ sender: Any) {
        view.endEditing(true)
        if let email = txtFieldEmail.text, let password = txtFieldPassword.text, let name = txtFieldName.text, let phone = txtFieldPhone.text{
            Auth.auth().createUser(withEmail: email, password: password){
                (result, error) in
                
                if let result = result, error == nil{
                    
                    self.saveDataUser(name: name, email: email, phone: phone)
                    self.showAlert("Aviso", message: "Registro exitoso", accept: "Aceptar")
                    
                    self.navigationController?.pushViewController(HomeViewController(email:
                        result.user.email!, provider: .basic), animated: true)
                    
                }else{
                    self.showAlert("Error", message: "No se ha podido registrar usuario", accept: "Aceptar")
                }
                    
            }
            
        }
        
    }
    
    private func saveDataUser(name:String,email:String,phone:String){
        db.collection("users").document(email).setData([
            "name" : name,
            "email" : email,
            "phone" : phone,
            "state" : "activo",
            "type" : "usuario"
        ])
    }
}


extension RegisterViewController{
    
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
