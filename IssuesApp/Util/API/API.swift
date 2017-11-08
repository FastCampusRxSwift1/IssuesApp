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
    typealias CommentResponsesHandler = (DataResponse<[Model.Comment]>) -> Void
    func getToekn(handler: @escaping (() -> Void))
    func tokenRefresh(handler: @escaping (() -> Void))
    func repoIssues(owner: String, repo: String) -> (Int, @escaping IssueResponsesHandler) -> Void
    func issueComment(owner: String, repo: String, number: Int) -> (Int, @escaping CommentResponsesHandler) -> Void
    func createComment(owner: String, repo: String, number: Int, comment: String, completionHandler: @escaping (DataResponse<Model.Comment>) -> Void )
    func closeIssue(owner: String, repo: String, number: Int, issue: Model.Issue, completionHandler: @escaping (DataResponse<Model.Issue>) -> Void)
    func openIssue(owner: String, repo: String, number: Int, issue: Model.Issue, completionHandler: @escaping (DataResponse<Model.Issue>) -> Void)
    func createIssue(owner: String, repo: String, title: String, body: String, completionHandler: @escaping (DataResponse<Model.Issue>) -> Void )
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
    
    func repoIssues(owner: String, repo: String) -> (Int, @escaping IssueResponsesHandler) -> Void {
        return { (page, handler) in
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
    
    func issueComment(owner: String, repo: String, number: Int) -> (Int, @escaping CommentResponsesHandler) -> Void {
        return { page, handler in
            let parameters: Parameters = ["page": page]
            GitHubRouter.manager.request(GitHubRouter.issueComment(owner: owner, repo: repo, number: number, parameters: parameters)).responseSwiftyJSON { (dataResponse: DataResponse<JSON>) in
                let result = dataResponse.map({ (json: JSON) -> [Model.Comment] in
                    return json.arrayValue.map {
                        Model.Comment(json: $0)
                    }
                })
                handler(result)
            }
        }
    }
    
    func createComment(owner: String, repo: String, number: Int, comment: String, completionHandler: @escaping (DataResponse<Model.Comment>) -> Void ) {
        let parameters: Parameters = ["body": comment]
        GitHubRouter.manager.request(GitHubRouter.createComment(owner: owner, repo: repo, number: number, parameters: parameters)).responseSwiftyJSON { (dataResponse: DataResponse<JSON>) in
            let result = dataResponse.map({ (json: JSON) -> Model.Comment in
                Model.Comment(json: json)
            })
            completionHandler(result)
        }
    }
    func closeIssue(owner: String, repo: String, number: Int, issue: Model.Issue, completionHandler: @escaping (DataResponse<Model.Issue>) -> Void) {
        var dict = issue.toDict
        dict["state"] = Model.Issue.State.closed.rawValue
        GitHubRouter.manager.request(GitHubRouter.editIssue(owner: owner, repo: repo, number: number, parameters: dict)).responseSwiftyJSON { (dataResponse: DataResponse<JSON>) in
            let result = dataResponse.map({ (json: JSON) -> Model.Issue in
                Model.Issue(json: json)
            })
            completionHandler(result)
        }
    }
    
    func openIssue(owner: String, repo: String, number: Int, issue: Model.Issue, completionHandler: @escaping (DataResponse<Model.Issue>) -> Void) {
        var dict = issue.toDict
        dict["state"] = Model.Issue.State.open.rawValue
        GitHubRouter.manager.request(GitHubRouter.editIssue(owner: owner, repo: repo, number: number, parameters: dict)).responseSwiftyJSON { (dataResponse: DataResponse<JSON>) in
            let result = dataResponse.map({ (json: JSON) -> Model.Issue in
                Model.Issue(json: json)
            })
            completionHandler(result)
        }
    }
    
    func createIssue(owner: String, repo: String, title: String, body: String, completionHandler: @escaping (DataResponse<Model.Issue>) -> Void ) {
        let parameters: Parameters = ["title": title, "body": body]
        GitHubRouter.manager.request(GitHubRouter.createIssue(owner: owner, repo: repo, parameters: parameters)).responseSwiftyJSON { (dataResponse: DataResponse<JSON>) in
            let result = dataResponse.map({ (json: JSON) -> Model.Issue in
                Model.Issue(json: json)
            })
            completionHandler(result)
        }
    }
}

enum GitHubRouter {
    case repoIssues(owner: String, repo: String, parameters: Parameters)
    case issueComment(owner: String, repo: String, number: Int, parameters: Parameters)
    case createComment(owner: String, repo: String, number: Int, parameters: Parameters)
    case editIssue(owner: String, repo: String, number: Int, parameters: Parameters)
    case createIssue(owner: String, repo: String, parameters: Parameters)
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
        case .repoIssues,
             .issueComment:
            return .get
        case .createComment,
             .createIssue:
            return .post
        case .editIssue
            :
            return .patch
        }
    }
    
    var path: String {
        switch self {
        case let .repoIssues(owner, repo, _):
            return "/repos/\(owner)/\(repo)/issues"
        case let .issueComment(owner, repo, number, _):
            return "/repos/\(owner)/\(repo)/issues/\(number)/comments"
        case let .createComment(owner, repo, number, _):
            return "/repos/\(owner)/\(repo)/issues/\(number)/comments"
        case let .editIssue(owner, repo, number, _):
            return "/repos/\(owner)/\(repo)/issues/\(number)"
        case let .createIssue(owner, repo, _):
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
        case let .issueComment(_, _, _, parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case let .createComment(_, _, _, parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        case let .editIssue(_, _, _, parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        case let .createIssue(_, _, parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
    
    
}
