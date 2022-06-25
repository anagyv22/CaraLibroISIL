//
//  RecoverViewController.swift
//  Caralibro Messenger
//
//  Created by Ana Gabriela Yucra Vila on 23/06/22.
//

import UIKit
import FirebaseAuth

class RecoveryViewController:UIViewController{
    @IBOutlet weak var txtEmailLogin: UITextField!
    
    @IBAction func clickBtnCloseRecovery(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func tapCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func swipetoOpenKeyboardRegister(_ sender: Any) {
        self.txtEmailLogin.becomeFirstResponder()
    }
    
    @IBAction func swipeCloseKeyboardLogin(_ sender: Any) {
        self.view.endEditing(true)
    }
     
    @IBAction func clickBtnRecoveryEmail(_ sender: Any) {
        if let email:String = txtEmailLogin.text{
        Auth.auth().sendPasswordReset(withEmail: email) {
           error in
        if error == nil {
           self.showAlert("Restablecimiento", message: "Se enviado un correo de restablecimiento", accept: "Aceptar")
        }else{
            
            self.showAlert("Email desconocido", message: "El email no se encuentra registrado", accept: "Aceptar")
        }
    }
    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardEvents()
    }
}

extension RecoveryViewController{
    
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
           
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        print("Se cerro el teclado")
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
           
            self.view.layoutIfNeeded()
        }
    }
}
