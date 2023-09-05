//
//  NetworkLogger.swift
//  Movies
//
//  Created by Cristian Chertes on 16.08.2023.
//

import Foundation
import Alamofire
import FirebaseCrashlytics

extension Crashlytics: CrashRecord {
    func recordCrash(error: NSError) {
        record(error: error)
    }
}

class NetworkLogger: EventMonitor {
    enum LogLevel: Int {
        case none = 0
        case basic = 1
        case headers = 2
        case body = 3
    }
    
    private var logLevel: LogLevel
    private let crashRecord: CrashRecord?
    
    init(logLevel: LogLevel, crashRecord: CrashRecord?) {
        self.logLevel = logLevel
        self.crashRecord = crashRecord
    }
    
    func requestDidResume(_ request: Request) {
        if logLevel == .none { return }
        
        if logLevel.rawValue >= LogLevel.basic.rawValue {
            NSLog("\(request)")
        }
        
        if logLevel.rawValue >= LogLevel.headers.rawValue {
            var headers = request.request.flatMap {
                $0.allHTTPHeaderFields.map {
                    $0.description
                }
            } ?? ""
            NSLog("\(headers)")
        }
        
        if logLevel.rawValue >= LogLevel.body.rawValue {
            var body = request.request.flatMap {
                $0.httpBody.map {
                    String(decoding: $0, as: UTF8.self)
                }
            } ?? ""
            NSLog("\(body)")
        }
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        if logLevel == .none { return }
        
        if logLevel.rawValue >= LogLevel.basic.rawValue {
            NSLog("\(request)")
        }
        
        if logLevel.rawValue >= LogLevel.headers.rawValue {
            NSLog("\(String(describing: response.response?.allHeaderFields))")
        }
        
        if logLevel.rawValue >= LogLevel.body.rawValue {
            NSLog("\(response.debugDescription)")
        }
        
        let range = 200...300
        if let statusCode = response.response?.statusCode, !range.contains(statusCode) {
            let userInfo = ["statusCode" : "\(statusCode)", "url" : response.response?.url?.absoluteURL ?? ""] as [String : Any]
            let error = NSError.init(domain: NSCocoaErrorDomain, code: -1001, userInfo: userInfo)
            crashRecord?.recordCrash(error: error)
        }
    }
}

