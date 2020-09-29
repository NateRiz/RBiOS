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
    static let BEARER = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImppYk5ia0ZTU2JteFBZck45Q0ZxUms0SzRndyIsImtpZCI6ImppYk5ia0ZTU2JteFBZck45Q0ZxUms0SzRndyJ9.eyJhdWQiOiJodHRwczovL2FuYWx5c2lzLndpbmRvd3MubmV0L3Bvd2VyYmkvYXBpIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvNzJmOTg4YmYtODZmMS00MWFmLTkxYWItMmQ3Y2QwMTFkYjQ3LyIsImlhdCI6MTYwMTM1NDY2OSwibmJmIjoxNjAxMzU0NjY5LCJleHAiOjE2MDEzNTg1NjksImFjY3QiOjAsImFjciI6IjEiLCJhaW8iOiJBVlFBcS84UkFBQUFKenN0UStCb2t1WGRFdTVaUWVQUmxEcWpMcVFpaDlHZTVVbHIyK1pWQUJNVDJSbDludkYxNFE3em13Uit6OHFDZFVGTVZqcDEya0NueHJnZnpSVzEvL2EweFcxTjVmTm9OSzZPUzJjeFVDdz0iLCJhbXIiOlsicHdkIiwibWZhIl0sImFwcGlkIjoiODcxYzAxMGYtNWU2MS00ZmIxLTgzYWMtOTg2MTBhN2U5MTEwIiwiYXBwaWRhY3IiOiIyIiwiZmFtaWx5X25hbWUiOiJSaXppayIsImdpdmVuX25hbWUiOiJOYXRoYW4iLCJpbl9jb3JwIjoidHJ1ZSIsImlwYWRkciI6IjI0LjM1LjkzLjI0IiwibmFtZSI6Ik5hdGhhbiBSaXppayIsIm9pZCI6IjlhYTBmNzAyLWRhOWEtNDUwNS1iY2JhLTdkZmMwYjE2ZWJjYyIsIm9ucHJlbV9zaWQiOiJTLTEtNS0yMS0yMTI3NTIxMTg0LTE2MDQwMTI5MjAtMTg4NzkyNzUyNy00MDc0NDYzOCIsInB1aWQiOiIxMDAzMjAwMDk4QzBBRTlEIiwicmgiOiIwLkFSb0F2NGo1Y3ZHR3IwR1JxeTE4MEJIYlJ3OEJISWRoWHJGUGc2eVlZUXAta1JBYUFLZy4iLCJzY3AiOiJ1c2VyX2ltcGVyc29uYXRpb24iLCJzdWIiOiJpaURqSVlKNVJKWVJOcnczc0RERmRpV3BmZElFamRDbkRsR0QtOHF4VktzIiwidGlkIjoiNzJmOTg4YmYtODZmMS00MWFmLTkxYWItMmQ3Y2QwMTFkYjQ3IiwidW5pcXVlX25hbWUiOiJucml6aWtAbWljcm9zb2Z0LmNvbSIsInVwbiI6Im5yaXppa0BtaWNyb3NvZnQuY29tIiwidXRpIjoiSmdHYXJEazU2VVNWNDlhZU5mS21BQSIsInZlciI6IjEuMCIsIndpZHMiOlsiYjc5ZmJmNGQtM2VmOS00Njg5LTgxNDMtNzZiMTk0ZTg1NTA5Il19.qsmI-pcfnpNgiP0BNbuyYriyIMCH-PHoyC8JxlRTZy4S4R2zWivLQ0DVOCMOGP0ukK8Gtmpv5oQUTVoCTcXLGWs7Jl3G_HnXUUk-Dc0uNNTja9S70g9ovzH9u5W45QmIR4IuJ5fYVBWVXSws4zjWzRGIjpG-nMkv69mNOGIOjt9y2YXU5iin0kTPDifXvBsPOrmFt7BWjHZOu6p3OOo_ghSjDU1Jea8_sYKOw5vUBABCGMWw_BNPw_aAYtauX8Nf78tYqTjXY1oMT0nXyXn3eO4qOd9JQwfvGtKnepz26oArGTs_xd-UZ91C_WfNVMS8d_sQFjC3jDn9zA_BxVoLjA"
    let rdlExporter = RDLExporter()
    
    func publish(ui: [BIToolContainerView], groupId: String, reportName: String, overwrite: Bool = false) {
        rdlExporter.generate(ui: ui)
        sendRequest(groupId: groupId, reportName: reportName, overwrite: overwrite)
    }
       
    func sendRequest(groupId: String, reportName: String, overwrite: Bool){
        let headers: HTTPHeaders = ["Content-Type":"multipart/form-data", "authorization":RDLPublisher.BEARER]
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
