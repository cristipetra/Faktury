//
//  URL+Helpers.swift
//  Faktury
//
//  Created by Factury co Test on 15/07/2017.
//  Copyright © 2017 Test Project. All rights reserved.
//

import Foundation

extension URL {
    
    func isPdf() -> Bool {
        return self.absoluteString.range(of: "pdf", options: .caseInsensitive) != nil
    }
    
    func isUrlWithTransition() -> Bool {
        let urlString = self.absoluteString
        if urlString.isEmpty {
            return false
        }
        
        for url in Config.urlsWithoutTransitions {
            if urlString.range(of: url, options: NSString.CompareOptions.regularExpression) != nil {
                return false
            }
        }
        
        return true
    }
    
    func isUrlWithActivityIndicator() -> Bool {
        let urlString = self.absoluteString
        if urlString.isEmpty {
            return true
        }
        
        for url in Config.urlsWithActivityIndicator {
            if urlString.range(of: url, options: NSString.CompareOptions.regularExpression) != nil {
                return true
            }
        }
        
        return false
    }
    
    func isUrlWithBackGesture() -> Bool {
        let urlString = self.absoluteString
        if urlString.isEmpty {
            return false
        }
        
        for url in Config.urlsWithoutBackGesture {
            if urlString.range(of: url, options: NSString.CompareOptions.regularExpression) != nil {
                return false
            }
        }
        
        return true
    }
}
