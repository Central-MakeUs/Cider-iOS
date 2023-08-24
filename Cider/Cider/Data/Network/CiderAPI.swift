//
//  CiderAPI.swift
//  Cider
//
//  Created by 임영선 on 2023/07/11.
//

import Foundation
import Moya
import UIKit

enum CiderAPI {
    case signInApple(paramters: [String: Any])
    case signInKakao(paramters: [String: Any])
    case getRandomNickname
    case getDuplicateNickname(nickname: String)
    case patchOnboarding(paramters: [String: Any])
    case getHomeChallenge
    case getHomeCategory(category: String)
    case getPopularChallenge(filter: String)
    case getAllChallenge(filter: String)
    case getPublicChallenge(filter: String)
    case getHomeFeed
    case postLikeChallenge(parameters: [String: Any])
    case deleteLikeChallenge(challengeId: String)
    case postLikeFeed(parameters: [String: Any])
    case deleteLikeFeed(certifyId: String)
    case getMypage
    case getMyLikeChallenge
    case patchProfileImage(image: UIImage)
    case patchProfile(parameters: [String: Any])
    case getMyParticipateChallenge
    case getMyCerify(challengeId: Int)
    case postCertify(parameters: [String: Any])
    case postCertifyImage(image: UIImage, certifyId: Int)
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
        case .getHomeCategory(let category):
            return "/api/challenge/home/\(category)"
        case .getPopularChallenge(let filter):
            return "/api/challenge/popular/\(filter)"
        case .getAllChallenge(let filter):
            return "/api/challenge/\(filter)"
        case .getPublicChallenge(let filter):
            return "/api/challenge/official/\(filter)"
        case .getHomeFeed:
            return "/api/certify/home"
        case .postLikeChallenge:
            return "/api/challenge/like"
        case .deleteLikeChallenge(let challengeId):
            return "/api/challenge/like/\(challengeId)"
        case .postLikeFeed:
            return "/api/certify/like"
        case .deleteLikeFeed(let certifyId):
            return "/api/certify/like/\(certifyId)"
        case .getMypage:
            return "/api/member/mypage"
        case .getMyLikeChallenge:
            return "/api/challenge/like"
        case .patchProfileImage:
            return "/api/member/profile/image"
        case .patchProfile:
            return "/api/member/profile"
        case .getMyParticipateChallenge:
            return "/api/challenge/participate"
        case .getMyCerify(let challengeId):
            return "/api/certify/mypage/\(challengeId)"
        case .postCertify:
            return "/api/certify"
        case .postCertifyImage(_, let certifyId):
            return "/api/certify/images/\(certifyId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signInApple,
             .signInKakao,
             .postLikeChallenge,
             .postLikeFeed,
             .postCertify,
             .postCertifyImage:
            return .post
            
        case .getRandomNickname,
             .getDuplicateNickname,
             .getHomeChallenge,
             .getHomeCategory,
             .getPopularChallenge,
             .getAllChallenge,
             .getPublicChallenge,
             .getHomeFeed,
             .getMypage,
             .getMyLikeChallenge,
             .getMyCerify,
             .getMyParticipateChallenge:
            return .get
            
        case .patchOnboarding,
             .patchProfileImage,
             .patchProfile:
            return .patch
            
        case .deleteLikeChallenge,
             .deleteLikeFeed:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signInApple(let parameters),
             .signInKakao(let parameters),
             .patchOnboarding(let parameters),
             .postLikeChallenge(let parameters),
             .postLikeFeed(let parameters),
             .patchProfile(let parameters),
             .postCertify(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    
        case .patchProfileImage(let image):
            let data = image.jpegData(compressionQuality: 0.1)!
            let imageData = MultipartFormBodyPart(provider: .data(data), name: "profileImage", fileName: "image.jpeg", mimeType: "image/jpeg")
            let multipartData: MultipartFormData = [imageData]
            return .uploadMultipartFormData(multipartData)
            
        case .postCertifyImage(let image, _):
            let data = image.jpegData(compressionQuality: 0.1)!
            let imageData = MultipartFormBodyPart(provider: .data(data), name: "certifyImages", fileName: "image.jpeg", mimeType: "image/jpeg")
            let multipartData: MultipartFormData = [imageData]
            return .uploadMultipartFormData(multipartData)
            
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
