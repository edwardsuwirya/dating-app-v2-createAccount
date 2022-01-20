//
//  File.swift
//  
//
//  Created by Edward Suwirya on 1/20/22.
//

import Foundation
import BaseNetworkLibrary
import RxSwift

class CreateAccountViewModel{
    var memberRegistrationUseCase : MemberRegistrationUseCase?
    var memberPublish = PublishSubject<String>()
    var useCaseObserver: Disposable? = nil
    
    func doCreateAccount(email:String,password:String){
        var newMember = BaseNetworkLibrary().memberRegistrationRequestFactory()
        newMember.email = email
        newMember.password = password
        
        useCaseObserver = memberRegistrationUseCase!.call(newMember: newMember).subscribe(onNext:{ (result) in
            print("VM => \(result)")
            if result == ""{
                self.memberPublish.onNext("")
            }else{
                self.memberPublish.onNext(result)
            }
        },onError: { (err) in
            print("Error")
        })
        
        //        memberRegistrationUseCase!.call(newMember: newMember){ (result) in
        //            if (result != nil){
        //                //                    let createProfileSb = UIStoryboard(name: "CreateProfile",bundle: nil)
        //                //                    let createProfileVc = createProfileSb.instantiateInitialViewController()!
        //                //                    createProfileVc.modalPresentationStyle = .overCurrentContext
        //                //                    self.present(createProfileVc,animated: true)
        //            }else{
        //                AppAlert.present(title: "Error", message: "Oops..Something's wrong", from: self)
        //            }
    }
    
    deinit{
        useCaseObserver?.dispose()
    }
}
