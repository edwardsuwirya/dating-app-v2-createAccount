//
//  File.swift
//  
//
//  Created by Edward Suwirya on 1/15/22.
//

import Foundation
import BaseNetworkLibrary
import RxSwift

struct MemberRegistrationUseCase{
    var datingMemberRepository:DatingMemberRepositoryProtocol!
    
    init(datingMemberRepository:DatingMemberRepositoryProtocol){
        self.datingMemberRepository = datingMemberRepository
    }
    
    func call(newMember:MemberRegistrationRequest)-> Observable<String>{
        return datingMemberRepository.callRegistrationApi(newMember)
    }
}
