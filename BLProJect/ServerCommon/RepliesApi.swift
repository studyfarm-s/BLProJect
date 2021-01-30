//
//  RepliesApi.swift
//  BLProJect
//
//  Created by Kim dohyun on 2021/01/28.
//  Copyright © 2021 김도현. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


struct RepliesResponse: Codable {
    var result: RepliesResult
}
struct RepliesResult: Codable {
    var content: [RepliesContent]
}
struct RepliesContent: Codable {
    let seq: Int?
    let content,dateFormat: String?
    let is_parent,is_my_reply: Bool?
    let children: [RepliesChildrenCotainer]?
    
    enum CodingKeys: String,CodingKey {
        case seq
        case content,dateFormat
        case is_parent,is_my_reply
        case children
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.seq = try? values.decode(Int.self, forKey: .seq)
        self.content = try? values.decode(String.self, forKey: .content)
        self.dateFormat = try? values.decode(String.self, forKey: .dateFormat)
        self.is_parent = try? values.decode(Bool.self, forKey: .is_parent)
        self.is_my_reply = try? values.decode(Bool.self, forKey: .is_my_reply)
        self.children = try? values.decode([RepliesChildrenCotainer].self, forKey: .children)
    }
}
struct RepliesContainer: Codable {
    var users_seq: Int
    var email: String
    var nickname: String
    var gender: String
    var age: Int
    var interesting: [RepliesInterestingContainer]
    var simple_introduce: String
    var profile: String
    var user_info_process: Bool
    var user_city_info: [RepliesCityInfoContainer]
    var user_created_at: String
    var user_updated_at: String
    var user_active: Bool
    
}

struct RepliesChildrenCotainer:Codable {
    var seq: Int
    var writer: RepliesChildreninWriterContainer
}
struct RepliesChildreninWriterContainer: Codable {
    var users_seq: Int
    var email: String
    var nickname: String
    var gender: String
    var age: Int
    var interesting: [RepliesChildreninInterestingContainer]
    var simple_introduce: String
    var profile: String
    var user_info_process: Bool
    var user_city_info: [RepliesChildreninCityInfoContainer]
    var user_created_at: String
    var user_updated_at: String
    var user_active: String
    
}
struct RepliesChildreninInterestingContainer: Codable {
    var name: String
    var skill_level: Int
    
}

struct RepliesChildreninCityInfoContainer: Codable {
    var state_code: Int
    var state_name: String
    var city_code: Int
    var city_name: String
}

struct RepliesInterestingContainer: Codable {
    var code: Int
    var name: String
    var skill_level: Int
    var parent_code: Int
}
struct RepliesCityInfoContainer: Codable {
    var state_code: Int
    var state_name: String
    var city_code: Int
    var city_name: String
}

struct RepliesParams: Encodable {
    var size: Int
    var page: Int
}

class RepliesApi {
    static let shared = RepliesApi()
    
    public let TestHeaders : HTTPHeaders = ["Content-Type":"application/hal+json;charset=UTF-8","Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkb3FuZG5mZm8xQGdtYWlsLmNvbSIsImlzcyI6InN0dWR5ZmFybSIsImlhdCI6MTU5NzgwNDkyNCwibmFtZSI6IuyViOyerOyEsTEiLCJzZXEiOjEsImV4cCI6MTg4NTgwNDkyNH0.DxhHnJZ1rUQeyD7fRPhEy3XdngmOeSXno39s8u3YP1Y","Accept":"application/hal+json"]
    public func StudyRepliesCall(study_seq: Int, RepliesParamter:Parameters,completionHandler: @escaping(RepliesResult) -> Void) {
        AF.request("http://3.214.168.45:8080/api/v1/study-replies/study/\(study_seq)", method: .get, parameters: RepliesParamter, encoding: URLEncoding.queryString, headers: TestHeaders)
            .validate()
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    do {
                        let RepliesData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let RepliesInstace = try JSONDecoder().decode(RepliesResponse.self, from: RepliesData)
                        completionHandler(RepliesInstace.result)
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
}

extension Encodable {
    func asParamters() throws -> Parameters? {
        let data = try JSONEncoder().encode(self)
        let params = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Parameters
        return params
    }
}
