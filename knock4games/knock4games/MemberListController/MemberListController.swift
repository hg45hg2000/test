//
//  MemberListController.swift
//  knock4games
//
//  Created by CHEN HENG Lin on 2017/5/18.
//  Copyright © 2017年 CHEN HENG Lin. All rights reserved.
//

import UIKit

class MemberListController: UIViewController {

    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    
    var memberListData : MemberAPIResponseData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestMemberList()
        // Do any additional setup after loading the view.
    }
    
    
    private func requestMemberList(){
        MemberAPI.requestMemberListAPI(sourceView: self.view, completion: {[weak self] (MemberAPIResponseData) in
            self?.memberListData = MemberAPIResponseData
            self?.tableView.reloadData()
        })
    }
}
extension  MemberListController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard self.memberListData == nil else {
            return self.memberListData.MemberDataArray.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.memberListData.MemberDataArray[indexPath.row].name
        return cell
    }
    

}
