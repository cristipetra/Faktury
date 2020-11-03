//
//  Network.swift
//  Faktury
//
//  Created by Factury co Test on 15/07/2017.
//  Copyright © 2017 Test Project. All rights reserved.
//

import UIKit

class Netowrk {
    
    public static func checkStatusCode(for url: URL) -> Int{
        let request = URLRequest(url: url)
        
        do {
            var response: URLResponse?
            _ = try NSURLConnection.sendSynchronousRequest(request, returning: &response) as NSData?
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode
            }
        } catch {
            
        }
        
        return -1
    }
    
    public static func performLoginRequest(with webView: UIWebView, username: String, password: String) {
        let url = URL(string: "https://www.faktury.co/faktury/site/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "type=login&LoginForm[username]=\(username)&LoginForm[password]=\(password)&yt0=Zaloguj&username_password_remind="
        request.httpBody = body.data(using: .utf8)
        webView.loadRequest(request)
    }
    
    class func downloadFileFromServer(downloadFileURL: URL, filename: String, extension: String, completion: @escaping (URL?, String?) -> ()) {
        var updatedFilename = filename
        if !filename.contains(".\(`extension`)") {
            updatedFilename.append(".\(`extension`)")
        }
        guard let destFileURL: URL = FileManager.getDocumentDirectoryFileURL(with: updatedFilename) else {
            completion(nil, "Unable to create file to download data. Please check internet connection.")
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let task = session.downloadTask(with: downloadFileURL) { (tempLocalURL, response, error) in
            guard let tempLocalURL = tempLocalURL else {
                return completion(nil, "download file doesn't exist.")
            }
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                }
                return
            }
            if FileManager.doesFileExist(at: destFileURL.absoluteString) {
                do {
                    try FileManager.default.removeItem(at: destFileURL)
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error.localizedDescription)
                    }
                    return
                }
            }
            
            do {
                try FileManager.default.copyItem(at: tempLocalURL, to: destFileURL)
                DispatchQueue.main.async {
                    completion(destFileURL, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
