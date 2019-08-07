//
//  Utilies.swift
//  MultipleImagesCollection
//
//  Created by Rudrarajsinh Chavda on 06/08/19.
//  Copyright © 2019 Rudrarajsinh Chavda. All rights reserved.
//

import Foundation
import SDWebImage
import Alamofire
import SwiftyJSON


var obj_database = Database()

let block_image: SDExternalCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
}

func getApiWithHeaderCalled(_ str_eventName: String, headers: HTTPHeaders, resolve: @escaping (_ name: AnyObject) -> Void)
{
    let str_url = URL.init(string: str_eventName)
    Alamofire.request(str_url!, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseData) -> Void in
        let httpStatusCode = responseData.response?.statusCode
        int_HttpStatusCode = httpStatusCode!

        resolve(responseData.result.value! as AnyObject)
    }
}
func PostApiCalled(_ str_eventName: String, parameter: AnyObject , headers: HTTPHeaders, resolve:@escaping (_ name: AnyObject) -> Void)
{
    let str_url = URL.init(string: str_eventName)
    Alamofire.request(str_url!, method: .post, parameters: parameter as? Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseData) -> Void in
        let httpStatusCode = responseData.response?.statusCode
        int_HttpStatusCode = httpStatusCode!
        if responseData.result.value != nil
        {
            int_HttpStatusCode = httpStatusCode!
            resolve(responseData.result.value! as AnyObject)
        }
        else
        {
            print(responseData)
            resolve(["errorMessage":str_serverError] as AnyObject)
        }
    }
}


extension String
{
    func replace(_ string:String, replacement:String) -> String
    {
        let str_re = self.replacingOccurrences(of: string, with: replacement, options: .literal, range: nil)
        return str_re
    }
    func removeWhitespace() -> String {
        let str_re = self.replace(" ", replacement: "")
        return str_re.replacingOccurrences(of: "'", with: "")
    }
}
