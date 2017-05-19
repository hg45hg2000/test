//
//  MenuNavigationController.swift
//  knock4games
//
//  Created by CHEN HENG Lin on 2017/5/17.
//  Copyright © 2017年 CHEN HENG Lin. All rights reserved.
//

import UIKit

class MenuNavigationController: UINavigationController {
    
    let animationDuration : TimeInterval = 0.3
    
    var timer : Timer?
    
    var tableview : UITableView = {
        let tableViewWidth = UIScreen.main.bounds.width/2
        let tableViewHeight = UIScreen.main.bounds.height
        let navigationbarAndStateBar : CGFloat = 64
        let tableView =  UITableView(frame: CGRect(x: -tableViewWidth, y: navigationbarAndStateBar, width: tableViewWidth, height: tableViewHeight - navigationbarAndStateBar))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    var didOpenTableView = false
    
    var menuDatas = ["Logout","Get member list","Create a member"]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        addMenuButtton(rootViewController: rootViewController)
        tableview.delegate = self
        tableview.dataSource = self
        self.view.addSubview(tableview)
        self.loginAPI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func  loginAPI(){
        LoginAPI(name: "ken", passWord: "hello").requestAPI {[weak self] (response) in
            self?.timerStart(timeInterval: TimeInterval(response.expTime - response.iatTime))
        }
    }
    
    private func timerStart(timeInterval:TimeInterval){
        self.timer  = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(loginAPI), userInfo: nil, repeats: false)
    }
    
    fileprivate func addMenuButtton(rootViewController: UIViewController){
        let menubutton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action:#selector(moveTableView))
        rootViewController.navigationItem.leftBarButtonItem = menubutton
    }
    
    func moveTableView(){
        UIView.animate(withDuration: animationDuration) {
            self.tableview.frame.origin.x += self.didOpenTableView ? -self.tableview.frame.size.width : self.tableview.frame.size.width
        }
        didOpenTableView = !didOpenTableView
    }
}
extension  MenuNavigationController: UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return menuDatas.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuDatas[indexPath.row]
        return cell
    }
}
extension MenuNavigationController : UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        var controller = UIViewController ()
        switch indexPath.row {
        case 0:
            LoginAPIResponseData.removeToken()
        case 1:
            controller = MemberListController(nibName:"MemberListController", bundle: nil)
        case 2:
            MemberAPI.requestCreateMemberAPI(parameter: ["name" : "XXXXXXX"], completion: { (MemberAPIResponseData) in
                
            })
            
        default:break
        }
        addMenuButtton(rootViewController: controller)
        self.viewControllers = [controller]
        moveTableView()
    }
}

