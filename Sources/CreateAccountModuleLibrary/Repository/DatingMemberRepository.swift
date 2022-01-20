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
import RxMoya
import RxSwift
import UIKit

protocol DatingMemberRepositoryProtocol{
    func callRegistrationApi(_ request: MemberRegistrationRequest) -> Observable<String>
}

struct DatingMemberRepository : DatingMemberRepositoryProtocol{
    var provider: MoyaProvider<DatingAppApi>?
    var dbContext: NSManagedObjectContext?
    init(provider:MoyaProvider<DatingAppApi>,dbContext: NSManagedObjectContext){
        self.provider = provider
        self.dbContext = dbContext
    }
    
    
    func callRegistrationApi(_ request: MemberRegistrationRequest)->Observable<String>  {
        
        return Observable.create{ observer in
            self.provider!.request(.callRegistration(request)){ result in
                switch result {
                case let .success(moyaResponse):
                    do {
                        let filteredResponse = try moyaResponse.filter(statusCodes: 200...299)
                        let json = try filteredResponse.map(CommonResponse<MemberRegistrationResponse>.self)
                        print("xxx=> \(json.data.memberId)")
                        print("Dbcontext id Create Account: \(Unmanaged.passUnretained(self.dbContext!).toOpaque())")
                        let memberId = json.data.memberId
                        let memberEntity = MemberEntity(context: self.dbContext!)
                        memberEntity.member_id = memberId
                        memberEntity.is_signin = false
                        try self.dbContext!.save()
                        observer.onNext(memberId)
                        observer.onCompleted()
                    }
                    catch let error {
                        print("response ===> \(error)")
                        observer.onError(error)
                    }
                case let .failure(error):
                    print("response ===> \(error)")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }
}
