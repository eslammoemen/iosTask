//
//  Service.swift
//  iOSTask
//
//  Created by eslam mohamed on 3/25/25.
//
import Alamofire
import Combine
import Foundation
import Transform

struct ServerDomainModel<T: Codable>: Codable, Error {
    let data: T?
    let message: Message?
    let status: Int?
    
}
struct Message: Codable {
    let txt: [String?]
}

protocol AllCategoriesServiceProtocol {
    func getALlCategoriesList() async throws -> ServerDomainModel<AllCategoriesModel>
    func getSubCategories(id: Int) async throws -> ServerDomainModel<[SubCategoryModel]>
}


class AllCategoriesService {
    
    init(apiRequest: APIRequest) {
        self.apiRequest = apiRequest
    }
    
    deinit {
        debugPrint("service deinited")
    }
    
    // MARK: Private‹QESW
    
    private var apiRequest: APIRequest
}

// MARK: RegistrationServicesProtocols

extension AllCategoriesService: AllCategoriesServiceProtocol {
    func getSubCategories(id: Int) async throws -> ServerDomainModel<[SubCategoryModel]> {
        let apiResponse = try await apiRequest.request(AllCategories.subCategories(id)).validateApiResponses()
        return try JSONDecoder().decode(ServerDomainModel<[SubCategoryModel]>.self, from: apiResponse)
    }
    
    func getALlCategoriesList() async throws -> ServerDomainModel<AllCategoriesModel> {
        let apiResponse = try await apiRequest.request(AllCategories.allCategories).validateApiResponses()
        
        return try JSONDecoder().decode(ServerDomainModel<AllCategoriesModel>.self, from: apiResponse)
    }
    func getOptionsProperities(id: Int) async throws -> ServerDomainModel<[SubCategoryModel]> {
        let apiResponse = try await apiRequest.request(AllCategories.categoryProperities(id)).validateApiResponses()
        return try JSONDecoder().decode(ServerDomainModel<[SubCategoryModel]>.self, from: apiResponse)
    }
  
    
}

extension AllCategoriesService {
    enum AllCategories: NetworkRouter {
        case allCategories
        case subCategories(Int)
        case categoryProperities(Int)
        
        // MARK: Internal
        
        var path: String {
            switch self {
            case .allCategories:
                return "all-categories/ios"
            case let .subCategories(id):
                return "properties/\(id)"
            case let .categoryProperities(id):
                return "option-properties/\(id)"
            }
           
        }
        
        var headers: [String: String]? {
            return RequestHeaderBuilder.shared
                .addAcceptEncodingHeaders(type: .gzip)
                .addAcceptHeaders(type: .applicationJson)
                .addConnectionHeader(type: .keepAlive)
                .addContentTypeHeader(type: .applicationJsonUTF8)
                .addCustomHeaders(headers: ["platform": "Postman",
                                            "content-language": "en",
                                            "private-key": "Tg$LXgp7uK!D@aAj^aT3TmWY9a9u#qh5g&xgEETJ"
                                           ])
                .build()
        }
        
        var method: RequestMethod? {
            return .get
        }
        
        var encoding: ParameterEncoding? {
            return JSONEncoding.default
        }
        
        var params: [String: Any]? {
            
            return nil
        }
    }
}

