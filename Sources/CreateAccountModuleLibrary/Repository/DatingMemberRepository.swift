//
//  File.swift
//  
//
//  Created by Edward Suwirya on 1/15/22.
//

import Foundation
import BaseNetworkLibrary
import Moya
import CoreDataLibrary
import CoreData

protocol DatingMemberRepositoryProtocol{
    func callRegistrationApi(_ request:MemberRegistrationRequest,completion: @escaping (String?)->())
}

struct DatingMemberRepository : DatingMemberRepositoryProtocol{
    var provider: MoyaProvider<DatingAppApi>?
    var dbContext: NSManagedObjectContext?
    init(provider:MoyaProvider<DatingAppApi>,dbContext: NSManagedObjectContext){
        self.provider = provider
        self.dbContext = dbContext
    }
    
    
    func callRegistrationApi(_ request: MemberRegistrationRequest, completion: @escaping (String?) -> ()) {
        guard let ctx = self.dbContext else{
            completion(nil)
            return
        }
        self.provider!.request(.callRegistration(request)){ result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filter(statusCodes: 200...299)
                    let json = try filteredResponse.map(CommonResponse<MemberRegistrationResponse>.self)
                    print("xxx=> \(json.data.memberId)")
                    let memberId = json.data.memberId
                    
                    let memberEntity = MemberEntity(context: ctx)
                    memberEntity.member_id = memberId
                    memberEntity.is_signin = false
                    try ctx.save()
                    completion(memberId)
                }
                catch let error {
                    print("response ===> \(error)")
                    completion(nil)
                }
            case let .failure(error):
                print("response ===> \(error)")
                completion(nil)
            }
        }
        
    }
}
