//
//  File.swift
//  
//
//  Created by Edward Suwirya on 1/15/22.
//

import Foundation
import BaseNetworkLibrary

struct MemberRegistrationUseCase{
    var datingMemberRepository:DatingMemberRepositoryProtocol!
    
    init(datingMemberRepository:DatingMemberRepositoryProtocol){
        self.datingMemberRepository = datingMemberRepository
    }
    
    func call(newMember:MemberRegistrationRequest, callBack: @escaping (String?)->()){
        datingMemberRepository.callRegistrationApi(newMember, completion : callBack)
    }
}
