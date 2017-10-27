//
//  GlobalState.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 10. 27..
//  Copyright © 2017년 intmain. All rights reserved.
//

import Foundation

final class GlobalState {
    static let instance = GlobalState()
    
    enum Constants: String {
        case tokenKey
        case refreshTokenKey
        case ownerKey
        case repoKey
    }
    
    var token: String? {
        get {
            let token = UserDefaults.standard.string(forKey: Constants.tokenKey.rawValue)
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.tokenKey.rawValue)
        }
    }
    var refreshToken: String? {
        get {
            let token = UserDefaults.standard.string(forKey: Constants.refreshTokenKey.rawValue)
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.refreshTokenKey.rawValue)
        }
    }
    var owner: String {
        get {
            let owner = UserDefaults.standard.string(forKey: Constants.ownerKey.rawValue) ?? ""
            return owner
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.ownerKey.rawValue)
        }
    }
    var repo: String {
        get {
            let repo = UserDefaults.standard.string(forKey: Constants.repoKey.rawValue) ?? ""
            return repo
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.repoKey.rawValue)
        }
    }
    var isLoggedIn: Bool {
        let isEmpty = token?.isEmpty ?? false
        return !isEmpty
    }
}

