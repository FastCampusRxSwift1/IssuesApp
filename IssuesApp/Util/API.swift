//
//  API.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 10. 27..
//  Copyright © 2017년 intmain. All rights reserved.
//

import Foundation
import OAuthSwift

protocol API {
    func getToekn(handler: @escaping (() -> Void))
    func tokenRefresh(handler: @escaping (() -> Void))
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
}
