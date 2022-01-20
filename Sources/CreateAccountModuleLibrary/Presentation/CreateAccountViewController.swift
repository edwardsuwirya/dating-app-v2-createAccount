//
//  File.swift
//  
//
//  Created by Edward Suwirya on 1/15/22.
//

import Foundation
import UIKit
import AppViewLibrary
import RxSwift
import UtilLibrary

public class CreateAccountViewController:UIViewController{
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var emailTextField: AppTextField!
    @IBOutlet weak var passwordTextField: AppTextField!
    
    @IBOutlet weak var whatEmailLabel: UILabel!
    @IBOutlet weak var passowdLabel: UILabel!
    @IBOutlet weak var verificationEmailLabel: UILabel!
    
    var createAccountViewModel: CreateAccountViewModel?
    let dispose = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        createAccountButton.addTarget(self, action: #selector(didCreateAccountButtonClick), for: .touchUpInside)
        self.createAccountButton.setTitle(Constants.createAccountButtonTitle.localized,for: .normal)
        self.whatEmailLabel.text = Constants.whatEmailLabelTitle.localized
        self.passowdLabel.text = Constants.andPasswordLabelTitle.localized
        self.verificationEmailLabel.text = Constants.verifiedEmailNotifLabelTitle.localized
        self.createAccountViewModel?.memberPublish
            .observe(on: MainScheduler.instance)
            .subscribe{ memberId in
                if memberId.element == ""{
                    AppAlert.present(title: "Error", message: "Oops..Something's wrong", from: self)
                }else{
                    print("Member ID : \(memberId.element ?? "")")
                }
            }
            .disposed(by: dispose)
    }
    
    @objc func didCreateAccountButtonClick(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if email == "" || password == ""{
            AppAlert.present(title: "Error", message: "Please fill the form", from: self)
        }else{
            createAccountViewModel?.doCreateAccount(email: email, password: password)
        }
        
    }
}
