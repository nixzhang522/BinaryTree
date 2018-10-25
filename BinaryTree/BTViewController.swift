//
//  BTViewController.swift
//  BinaryTree
//
//  Created by xinpin on 2018/10/25.
//  Copyright © 2018年 Nix. All rights reserved.
//

import UIKit

class BTViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let dataArray = [["text": "二叉树", "vc": "ConceptViewController"],
                     ["text": "平衡二叉树", "vc": "BalanceViewController"],
                     ["text": "B树", "vc": "BViewController"],
                     ["text": "B+树", "vc": "BAddViewController"],
                     ["text": "B-树", "vc": "BMinusViewController"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "二叉树学习"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let item = dataArray[indexPath.row]
        cell?.textLabel?.text = item["text"]
        return cell!
    }
}

extension BTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = dataArray[indexPath.row]
        let vcString = item["vc"]
        self.pushToViewController(viewController: vcString!, animation: true, param: nil)
    }
}

extension UIViewController {
    func pushToViewController(viewController: String, animation: Bool, param: ((_ vc: UIViewController)-> ())?) {
        
        let projectName = Bundle.main.infoDictionary!["CFBundleExecutable"]! as! String
        let vcString = projectName + "." + viewController
        let cls: AnyClass? = NSClassFromString(vcString)
        guard let nextClass = cls as? UIViewController.Type else {
            return
        }
        let vc = nextClass.init()
        if let vcBack = param {
            vcBack(vc)
        }
        self.navigationController?.pushViewController(vc, animated: animation)
    }
}

