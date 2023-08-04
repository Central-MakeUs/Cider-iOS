//
//  CiderAPI.swift
//  Cider
//
//  Created by 임영선 on 2023/07/11.
//

import Foundation
import Moya

enum CiderAPI {
    case signInApple(paramters: [String: Any])
    case signInKakao(paramters: [String: Any])
    case getRandomNickname
    case getDuplicateNickname(nickname: String)
    case patchOnboarding(paramters: [String: Any])
    case getHomeChallenge
}

extension CiderAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL(string: "http://cider.ap-northeast-2.elasticbeanstalk.com")!
    }
    
    var path: String {
        switch self {
        case .signInApple,
             .signInKakao:
            return "/api/oauth/login"
        case .getRandomNickname:
            return "/api/member/nicknames"
        case .getDuplicateNickname(let nickname):
            return "/api/member/nicknames/exists/\(nickname)"
        case .patchOnboarding:
            return "/api/member"
        case .getHomeChallenge:
            return "/api/challenge/home"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signInApple,
             .signInKakao:
            return .post
            
        case .getRandomNickname,
             .getDuplicateNickname,
             .getHomeChallenge:
            return .get
            
        case .patchOnboarding:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signInApple(let parameters),
             .signInKakao(let parameters),
             .patchOnboarding(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getRandomNickname,
             .getDuplicateNickname:
            return nil
        default:
            guard let token = Keychain.loadToken() else {
                return nil
            }
            return ["Authorization": token]
        }
    }
    
    var authorizationType: Moya.AuthorizationType? {
        return .none
    }
    
    
}

extension CiderAPI {
    
    private static func getAuthPlugin() -> AccessTokenPlugin {
        let tokenClosure: (TargetType) -> String = { _ in
            guard let token = Keychain.loadToken() else {
                print(LoginError.noToken)
                return ""
            }
            return token
        }
        return AccessTokenPlugin(tokenClosure: tokenClosure)
    }
    
    static func request<T: Decodable>(target: CiderAPI, dataType: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<CiderAPI>()
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try JSONDecoder().decode(T.self, from: response.data)
                        continuation.resume(returning: data)
                        print("finishRequestAPI \(response.request?.url?.absoluteString ?? "")")
                    } catch(let error) {
                        print(error)
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}


protocol MoyaCacheable {
    typealias MoyaCacheablePolicy = URLRequest.CachePolicy
    var cachePolicy: MoyaCacheablePolicy { get }
}

final class MoyaCacheablePlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let moyaCachableProtocol = target as? MoyaCacheable {
            var cachableRequest = request
            cachableRequest.cachePolicy = moyaCachableProtocol.cachePolicy
            return cachableRequest
        }
        return request
    }
}
