//
//  NetworkRequest+Ext.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import Foundation

extension NetworkRequest {
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
    var headers: [String : String]? { nil }
    var withAuthorization: Bool { false }
}

extension NetworkRequest where Response: Decodable {
    func decode(_ data: Data, using decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}

extension NetworkRequest where Response == Void {
    func decode(_ data: Data, using decoder: JSONDecoder) throws -> Response {
        return
    }
}

extension NetworkRequest {
    func decode(_ data: Data, using decoder: JSONDecoder) throws -> Response {
        guard let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            fatalError()
        }
        return dict as! Response
    }
}

extension NetworkRequest {
    func buildURLRequest(credentials: Credentials?) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        
        var request = URLRequest(url: components.url!)
        
        request.httpMethod = method.rawValue
        
        if let queryItems, !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        if let body { request.httpBody = body }

        request.allHTTPHeaderFields = getHeaders(credentials: credentials, withAuthorization: withAuthorization)
        
#if DEBUG
        print(requestDescription(components: components, request: request))
#endif
        return request
    }
    
    private func getHeaders(credentials: Credentials?, withAuthorization: Bool) -> [String: String] {
        var allHeaders: [String : String] = [:]
        if let headers, !headers.isEmpty {
            for (key, value) in headers {
                allHeaders[key] = value
            }
        }
        
        if let credentials, withAuthorization {
            allHeaders["Authorization"] = "Bearer \(credentials.token)"
            print("Bearer \(credentials.token)")
        }
        
        allHeaders["Content-Type"] = "application/json"
        
        return allHeaders
    }
    
    private func requestDescription(components: URLComponents, request: URLRequest) -> String {
        var output: String = "\n\n========== Request =========="
        guard let url = components.url else {
            output += "\n🤦🏼‍♂️ empty url?!"
            return output
        }
        output += "\nURL: \(url)"
        
        guard let method = request.httpMethod else {
            output += "\n🌚 httpMethod is missing."
            return output
        }
        output += "\nHTTPMethod: \(method)"
        
        if let headers = request.allHTTPHeaderFields {
            output += "\nHeaders: ["
            headers.forEach { dict in
                output += "\n   \(dict.key): \(dict.value)"
            }
            output += "\n]"
        }
        
        if let queryItems = components.queryItems, !queryItems.isEmpty {
            output += "\nQueryItems: {"
            queryItems.forEach { item in
                output += "\n    \(item.name): \(item.value ?? "nil")"
            }
            output += "\n}"
        }
        
        if let data = request.httpBody, let bodyString = String(data: data, encoding: .utf8) {
            output += "\nBody: \(bodyString)"
        }
  
      return output
    }
}
