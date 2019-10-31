//
//  WebController.swift
//  True Story
//
//  Created by Maxim on 13/10/2019.
//  Copyright © 2019 big-lab.com. All rights reserved.
//

import UIKit

protocol WebControllerProtocol: class {
    func dataFromServer(data: Data?, error: Error?)
}

class WebController: NSObject {
    
    let attemptsCount: Int
    let delaySeconds: Double
    
    weak var presenter: WebControllerProtocol!
    
    init(_ presenter: WebControllerProtocol, attemptsCount: Int, delaySeconds: Double) {
        self.presenter = presenter
        self.attemptsCount = attemptsCount
        self.delaySeconds = delaySeconds
    }
    
    // MARK: - GET REQUEST
    func sendGetRequestToServer(url: String, attempt: Int = 0) {
    
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Secret", forHTTPHeaderField: "User-Agent")
        // Action for new attemp if error
        let repeatAction: (WebController, Data?, Error?) -> Void = { (web, data, error) in
            if attempt + 1 > self.attemptsCount {
                web.presenter?.dataFromServer(data: data, error: error)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.delaySeconds) {
                    web.sendGetRequestToServer(url: url, attempt: attempt + 1)
                }
            }
        }

        // Request to url, using URLSession
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        session.dataTask(with: request) { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil {
                if let httpResponse = response as? HTTPURLResponse {
                    DispatchQueue.main.async {
                        if httpResponse.statusCode == 200 {
                            self.presenter?.dataFromServer(data: data, error: nil)
                        } else {
                            let errorStatus = NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
                            repeatAction(self, data, errorStatus)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    repeatAction(self, nil, error)
                }
            }
        }.resume()
    }
}
