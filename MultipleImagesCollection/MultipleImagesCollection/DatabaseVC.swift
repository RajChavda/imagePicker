//
//  DatabaseVC.swift
//  MultipleImagesCollection
//
//  Created by Rudrarajsinh Chavda on 06/08/19.
//  Copyright © 2019 Rudrarajsinh Chavda. All rights reserved.
//

import UIKit

class DatabaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let str_Sql_Insert = NSString(format: "INSERT INTO tbl_contact(FirstName,LastName,email,ContactNo) VALUES ('%@','%@','%@','%@')","Rudrarajsinh","Chavda","rajchavda2511@gmail.com","7600001612") as String
        Database.share().insert(str_Sql_Insert)
        self.perform(#selector(self.getData), with: nil, afterDelay: 1.0)
        self.perform(#selector(self.updateData), with: nil, afterDelay: 2.0)
    }

    @objc func getData() {

        let str_sql = NSString(format:"select * from tbl_contact") as String
        print(Database.share()?.selectAll(fromTable: str_sql)! as Any)
    }

    @objc func updateData() {

        let str_sqlUpdate = NSString(format: "UPDATE tbl_contact SET ContactNo = 9586475734 WHERE email = 'rajchavda2511@gmail.com'") as String
        Database.share()?.update(str_sqlUpdate)
        self.perform(#selector(self.getData), with: nil, afterDelay: 1.0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
