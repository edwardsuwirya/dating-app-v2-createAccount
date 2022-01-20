//
//  File.swift
//  
//
//  Created by Edward Suwirya on 1/15/22.
//

import Foundation
import Swinject
import Moya
import BaseNetworkLibrary
import CoreDataLibrary
import CoreData

public class CreateAccountAssembly: Assembly{
    public func assemble(container: Container) {
        container.register(DatingMemberRepositoryProtocol.self, name: "DatingMemberRepo"){ r in
            DatingMemberRepository(provider: r.resolve(MoyaProvider<DatingAppApi>.self)!,dbContext: r.resolve(NSManagedObjectContext.self)!)
        }
        
        container.register(MemberRegistrationUseCase.self){ r in
            MemberRegistrationUseCase(datingMemberRepository: r.resolve(DatingMemberRepositoryProtocol.self,name:"DatingMemberRepo")!)
        }
        container.register(CreateAccountViewModel.self){ r in
            let vm = CreateAccountViewModel()
            vm.memberRegistrationUseCase = r.resolve(MemberRegistrationUseCase.self)!
            return vm
        }
        container.register(CreateAccountViewController.self){ r in
            let createAccountVc = CreateAccountViewController(nibName: "CreateAccount", bundle: Bundle.module.self)
            createAccountVc.createAccountViewModel = r.resolve(CreateAccountViewModel.self)
            return createAccountVc
        }
    }
}
