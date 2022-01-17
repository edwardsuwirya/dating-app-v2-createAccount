//
//  File.swift
//  
//
//  Created by Edward Suwirya on 1/15/22.
//

import Foundation
import UIKit
import AppViewLibrary
import BaseNetworkLibrary
import UtilLibrary

public class CreateAccountViewController:UIViewController{
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var emailTextField: AppTextField!
    @IBOutlet weak var passwordTextField: AppTextField!
    
    @IBOutlet weak var whatEmailLabel: UILabel!
    @IBOutlet weak var passowdLabel: UILabel!
    @IBOutlet weak var verificationEmailLabel: UILabel!
    
    
    var memberRegistrationUseCase : MemberRegistrationUseCase?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        createAccountButton.addTarget(self, action: #selector(didCreateAccountButtonClick), for: .touchUpInside)
        self.createAccountButton.setTitle(Constants.createAccountButtonTitle.localized,for: .normal)
        self.whatEmailLabel.text = Constants.whatEmailLabelTitle.localized
        self.passowdLabel.text = Constants.andPasswordLabelTitle.localized
        self.verificationEmailLabel.text = Constants.verifiedEmailNotifLabelTitle.localized
    }
    
    @objc func didCreateAccountButtonClick(_ sender: UIButton) {
        var newMember = BaseNetworkLibrary().memberRegistrationRequestFactory()
        newMember.email = emailTextField.text ?? ""
        newMember.password = passwordTextField.text ?? ""
 
        if newMember.email == "" || newMember.password == ""{
            AppAlert.present(title: "Error", message: "Please fill the form", from: self)
        }else{
            memberRegistrationUseCase!.call(newMember: newMember){ (result) in
                if (result != nil){
//                    let createProfileSb = UIStoryboard(name: "CreateProfile",bundle: nil)
//                    let createProfileVc = createProfileSb.instantiateInitialViewController()!
//                    createProfileVc.modalPresentationStyle = .overCurrentContext
//                    self.present(createProfileVc,animated: true)
                }else{
                    AppAlert.present(title: "Error", message: "Oops..Something's wrong", from: self)
                }
            }
        }
        
    }
}
