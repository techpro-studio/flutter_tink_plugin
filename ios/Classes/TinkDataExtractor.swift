//
//  TinkDataExtractor.swift
//  tink_plugin
//
//  Created by Alex on 28.01.2021.
//

import Foundation


enum TinkAuthData {
    case success(data: Dictionary<String, String>)
    case error(data: Dictionary<String, String>)
    case userCancelled

    func asJSONString()-> String {
        var jsonObject: [String: Any]
        switch self {
        case .success(let data):
            jsonObject = ["state": "success", "data": data]
        case .error(let data):
            jsonObject = ["state": "error", "data": data]
        case .userCancelled:
            jsonObject = ["state": "user_cancelled"]
        }
        return String(data: try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted), encoding: .utf8)!
    }
}


extension URL {
    func getQueryParameter(name: String) -> String? {
        return URLComponents(url: self, resolvingAgainstBaseURL: true)?.param(name: name)
    }
}

extension URLComponents {
    func param(name: String)-> String? {
        return self.queryItems?.first(where: { $0.name == name })?.value
    }

    func toDict() -> Dictionary<String, String> {
        var result = [String: String]()
        for item in (self.queryItems ?? []) {
            result[item.name] = item.value ?? "null"
        }
        return result
    }
}

class TinkAuthDataExtractor {
    static func extract(url: URL) -> TinkAuthData?{
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        if components.param(name: "code") != nil{
            return TinkAuthData.success(data: components.toDict())
        }

        if let errorCode = components.param(name: "error"), !errorCode.isEmpty {
            if errorCode == "USER_CANCELLED" {
                return TinkAuthData.userCancelled
            }
            return TinkAuthData.error(data: components.toDict())
        }
        return nil
    }
}
