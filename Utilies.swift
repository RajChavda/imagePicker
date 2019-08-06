//
//  Utilies.swift
//  MultipleImagesCollection
//
//  Created by Rudrarajsinh Chavda on 06/08/19.
//  Copyright © 2019 Rudrarajsinh Chavda. All rights reserved.
//

import Foundation
import SDWebImage

var obj_database = Database()

let block_image: SDExternalCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
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
