//
//  HomeController.swift
//  Caralibro Messenger
//
//  Created by Ana Gabriela Yucra Vila on 23/06/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

enum ProviderType:String{
    case basic
    case google
}

class HomeViewController: UIViewController {

    @IBOutlet weak var lblFieldEmail: UILabel!
    
    @IBOutlet weak var lblFieldFullName: UILabel!
    
    @IBOutlet weak var lblFieldProvider: UILabel!
    private let db = Firestore.firestore()
    
    private let email:String
    private let provider:ProviderType
    
    @IBAction func clickBtnCloseHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    init(email:String, provider:ProviderType){
        self.email = email
        self.provider = provider
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lblFieldEmail.text = email
        lblFieldProvider.text = provider.rawValue
        //Guardo los datos de usuario en la app
        let defaults = UserDefaults.standard
        defaults.set(email,forKey: "email")
        defaults.set(provider.rawValue,forKey: "provider")
        defaults.synchronize()
        //Traigo ddatos de firestore
        db.collection("users").document(email).getDocument{(documentSnapshot,error) in
            if let document = documentSnapshot, error == nil{
                if let name = document.get("name") as? String{
                self.lblFieldFullName.text = name
                }
            }
        }
        
    }
    
    @IBAction func clickBtnCloseSession(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        
        
        switch provider {
        case .basic, .google:
                do {
                    try Auth.auth().signOut()
                    navigationController?.popViewController(animated: true)
                    
                } catch {
                    //Se ha producido un error
                }
            
        }
    }
    
   
    @IBAction func clickBtnLogOut(_ sender: Any) {
        
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        navigationController?.popViewController(animated: true)
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
    }
    
}
