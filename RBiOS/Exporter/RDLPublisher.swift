//
//  RDLPublisher.swift
//  RBiOS
//
//  Created by Nathan Rizik on 9/26/20.
//  Copyright © 2020 Nathan Rizik. All rights reserved.
//

import UIKit
import Alamofire

class RDLPublisher: NSObject {
    static let BEARER = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImppYk5ia0ZTU2JteFBZck45Q0ZxUms0SzRndyIsImtpZCI6ImppYk5ia0ZTU2JteFBZck45Q0ZxUms0SzRndyJ9.eyJhdWQiOiJodHRwczovL2FuYWx5c2lzLndpbmRvd3MubmV0L3Bvd2VyYmkvYXBpIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvNzJmOTg4YmYtODZmMS00MWFmLTkxYWItMmQ3Y2QwMTFkYjQ3LyIsImlhdCI6MTYwMTI3MjE2OCwibmJmIjoxNjAxMjcyMTY4LCJleHAiOjE2MDEyNzYwNjgsImFjY3QiOjAsImFjciI6IjEiLCJhaW8iOiJBVlFBcS84UkFBQUF6OXhwckd1R1lVbnF0OWdqQUJOMGZJTnFYWGJJRUh2eUE5ZmZVWThjcTRkbzVPRUdNRUU0R1RzUW5IYmlyekNEVmRSRytyWWFjdi9LTm50YkRJQ0xwWmNsNCsrTHFIbWZ6a0Z6SG5MdlNQWT0iLCJhbXIiOlsicHdkIiwibWZhIl0sImFwcGlkIjoiODcxYzAxMGYtNWU2MS00ZmIxLTgzYWMtOTg2MTBhN2U5MTEwIiwiYXBwaWRhY3IiOiIyIiwiZmFtaWx5X25hbWUiOiJSaXppayIsImdpdmVuX25hbWUiOiJOYXRoYW4iLCJpbl9jb3JwIjoidHJ1ZSIsImlwYWRkciI6IjI0LjM1LjkzLjI0IiwibmFtZSI6Ik5hdGhhbiBSaXppayIsIm9pZCI6IjlhYTBmNzAyLWRhOWEtNDUwNS1iY2JhLTdkZmMwYjE2ZWJjYyIsIm9ucHJlbV9zaWQiOiJTLTEtNS0yMS0yMTI3NTIxMTg0LTE2MDQwMTI5MjAtMTg4NzkyNzUyNy00MDc0NDYzOCIsInB1aWQiOiIxMDAzMjAwMDk4QzBBRTlEIiwicmgiOiIwLkFSb0F2NGo1Y3ZHR3IwR1JxeTE4MEJIYlJ3OEJISWRoWHJGUGc2eVlZUXAta1JBYUFLZy4iLCJzY3AiOiJ1c2VyX2ltcGVyc29uYXRpb24iLCJzdWIiOiJpaURqSVlKNVJKWVJOcnczc0RERmRpV3BmZElFamRDbkRsR0QtOHF4VktzIiwidGlkIjoiNzJmOTg4YmYtODZmMS00MWFmLTkxYWItMmQ3Y2QwMTFkYjQ3IiwidW5pcXVlX25hbWUiOiJucml6aWtAbWljcm9zb2Z0LmNvbSIsInVwbiI6Im5yaXppa0BtaWNyb3NvZnQuY29tIiwidXRpIjoidk5zckk0clVMa3VBNzRXa3d3Q01BQSIsInZlciI6IjEuMCIsIndpZHMiOlsiYjc5ZmJmNGQtM2VmOS00Njg5LTgxNDMtNzZiMTk0ZTg1NTA5Il19.B4tEqc1ZJqWfRXZ0WrS_mmOmbKmmRs5KasvsbYXWjwspky9wtP_0xi3ctyPCFUuPIvlpMQNB54-2scmmP9tdXD937dTwwO5aCBCWqFbCiFWeJK6G3rxOD87rQS7WAmmbhN8O1cfDSJwW_ZrWJEkuzRkn5yHUK39faf-B9Htjifybq4oRQZ4qqGRdYf2U3Fdl8RjxI3m7ONxCO_J8SnGW6PTOAUZoflqjKGBmYMb_VYHgKX18DHXNfa_rVeTQ9_GPeNIXFzpjUTNS2oZQLI6slabmcfXUx2WsF6IYwNyRUFuyoJDNoWiOILLD_QyKGwQS4hg2V6LK9JyfG2ogTyshAg"
    let rdlExporter = RDLExporter()
    
    func publish(ui: [BIToolContainerView], groupId: String, reportName: String, overwrite: Bool = false) {
        rdlExporter.generate(ui: ui)
        sendRequest(groupId: groupId, reportName: reportName, overwrite: overwrite)
    }
    
    func sendReqfuest(groupId: String, reportName: String, overwrite: Bool){
        let headers: HTTPHeaders = ["Content-Type":"multipart/form-data", "authorization":RDLPublisher.BEARER]
        let parameters = ["file":rdlExporter.rdl]
        let url = "https://api.powerbi.com/v1.0/myorg/groups/\(groupId)/imports?datasetDisplayName=\(sanitize(text: reportName)).rdl&nameConflict=\(overwrite ? "overwrite" : "abort")"
        AF.request(URL.init(string: url)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        print((json as! [String:AnyObject]))
                    }
                    break
                case .failure(let error):
                    print([error as Error])
                    break
                }
            }
    }
    
    func sendRequest(groupId: String, reportName: String, overwrite: Bool){
        let headers: HTTPHeaders = ["Content-Type":"multipart/form-data", "authorization":RDLPublisher.BEARER]
        let parameters = ["file":rdlExporter.rdl]
        let url = "https://api.powerbi.com/v1.0/myorg/groups/\(groupId)/imports?datasetDisplayName=\(sanitize(text: reportName)).rdl&nameConflict=\(overwrite ? "overwrite" : "abort")"
        AF.upload(
            multipartFormData: {multipartFormData in
                multipartFormData.append(Data(self.rdlExporter.rdl.utf8), withName: "file")
        }, to: url, headers: headers)
            .responseJSON { response in
                debugPrint(response)
            }
    }
    
    func sanitize(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890_")
        return String(text.filter{okayChars.contains($0) })
    }
}
