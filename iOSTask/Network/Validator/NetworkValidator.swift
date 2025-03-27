//
//  NetworkValidator.swift
//  EmployeeShop
//
//  Created by eslam mohamed on 11/3/24.
//

import Foundation
import Alamofire

extension DataResponse {
    struct ErrorModel: Codable, Error {
        let message: [String]?
    }
    func validateApiResponses() throws -> Data {
        if let error = self.error {
            if let data = self.data,
               let serverErrorModel = try? JSONDecoder().decode(ServerDomainModel<ErrorModel>.self, from: data) {
                throw ServerDomainModel<ErrorModel>(data: nil, message: serverErrorModel.message, status: error.asAFError?.responseCode)
            }
            throw ServerDomainModel<ErrorModel>(data: nil, message: .init(txt: [error.localizedDescription]), status: error.asAFError?.responseCode)
        } else {
            return self.data ?? Data()
        }
    }
    
}
extension Data {
    
    func prettyPrinted() {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                print("Inavlid data")
                return
            }
            print(jsonString)
        } catch {
            print("Error: \(error.localizedDescription)")
            
        }
    }
}
