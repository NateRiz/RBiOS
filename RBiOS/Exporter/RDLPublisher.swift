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
    let rdlExporter = RDLExporter()
    
    func publish(ui: [BIToolContainerView], overwrite: Bool = false) {
        rdlExporter.generate(ui: ui)
        sendRequest(overwrite: overwrite)
    }
    
    func sendRequest(overwrite: Bool){
        let headers: HTTPHeaders = ["Content-Type":"multipart/form-data"]
        let parameters = ["file":rdlExporter.rdl]
        let url = "https://api.powerbi.com/v1.0/myorg/groups/GROUPID/imports?datasetDisplayName=FILENAME&nameConflict=\(overwrite ? "overwrite" : "abort")"
        AF.request(URL.init(string: url)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
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
}
