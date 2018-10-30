//
//  BalanceViewController.swift
//  BinaryTree
//
//  Created by xinpin on 2018/10/25.
//  Copyright © 2018年 Nix. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "平衡二叉树、AV树"
        self.view.backgroundColor = UIColor.white

        /*
        平衡二叉树，又称为 AVL 树。实际上就是遵循以下两个特点的二叉树：
        1.每棵子树中的左子树和右子树的深度差不能超过 1；
        2.二叉树中每棵子树都要求是平衡二叉树；
         
         平衡因子：每个结点都有其各自的平衡因子，表示的就是其左子树深度同右子树深度的差。平衡二叉树中各结点平衡因子的取值只可能是：0、1 和 -1。
         */
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
