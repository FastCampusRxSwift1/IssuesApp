//
//  API.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 10. 27..
//  Copyright © 2017년 intmain. All rights reserved.
//

import Foundation
import OAuthSwift
import Alamofire
import SwiftyJSON

protocol API {
    typealias IssueResponsesHandler = (DataResponse<[Model.Issue]>) -> Void
    func getToekn(handler: @escaping (() -> Void))
    func tokenRefresh(handler: @escaping (() -> Void))
    func repoIssues(owner: String, repo: String, page: Int, handler: @escaping IssueResponsesHandler) -> Void
}

struct GitHubAPI: API {
    let oauth =  OAuth2Swift(consumerKey: "dc7db1de744aa3e82a47",
                             consumerSecret: "554a3e9b89f140736050a37e3e37379aa3bc7e39",
                             authorizeUrl: "https://github.com/login/oauth/authorize",
                             accessTokenUrl: "https://github.com/login/oauth/access_token",
                             responseType: "code")
    
    func getToekn(handler: @escaping (() -> Void)) {
        oauth.authorize(
            withCallbackURL: "IssuesApp://oauth-callback/github",
            scope: "user, repo",
            state: "state",
            success: { (credential, _, _) in
                GlobalState.instance.token = credential.oauthToken
                GlobalState.instance.refreshToken = credential.oauthRefreshToken
                print("token: \(credential.oauthToken)")
                handler()
        },
            failure:  { error in
                print(error.localizedDescription)
        })
    }
    func tokenRefresh(handler: @escaping (() -> Void)) {
        guard let refreshToken = GlobalState.instance.refreshToken else { return }
        oauth.renewAccessToken(
            withRefreshToken: refreshToken,
            success: { (credential, _, _) in
                GlobalState.instance.token = credential.oauthToken
                GlobalState.instance.refreshToken = credential.oauthRefreshToken
                handler()
        },
            failure: { error in
                print(error.localizedDescription)
        })
    }
    
    func repoIssues(owner: String, repo: String, page: Int, handler: @escaping IssueResponsesHandler) -> Void {
        let parameters: Parameters = ["page": page, "state": "all"]
        GitHubRouter.manager.request(GitHubRouter.repoIssues(owner: owner, repo: repo, parameters: parameters)).responseSwiftyJSON { (dataResponse: DataResponse<JSON>) in
            let result = dataResponse.map({ (json: JSON) -> [Model.Issue] in
                return json.arrayValue.map {
                    Model.Issue(json: $0)
                }
            })
            handler(result)
        }
    }
}

enum GitHubRouter {
    case repoIssues(owner: String, repo: String, parameters: Parameters)
}

extension GitHubRouter: URLRequestConvertible {
    static let baseURLString: String = "https://api.github.com"
    static let manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // seconds
        configuration.timeoutIntervalForResource = 30
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()
    
    var method: HTTPMethod {
        switch self {
        case .repoIssues:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case let .repoIssues(owner, repo, _):
            return "/repos/\(owner)/\(repo)/issues"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try GitHubRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        if let token = GlobalState.instance.token, !token.isEmpty {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
           case let .repoIssues(_, _, parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }


}
