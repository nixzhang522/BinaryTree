//
//  BalanceViewController.swift
//  BinaryTree
//
//  Created by xinpin on 2018/10/25.
//  Copyright © 2018年 Nix. All rights reserved.
//

import UIKit

enum BBalTreeFlag {
    case LH
    case EH
    case RH
}

class BBalTreeNode {
    var value: Int?
    var bf: BBalTreeFlag?
    var leftNode: BBalTreeNode?
    var rightNode: BBalTreeNode?
    
    init(value: Int) {
        self.value = value
    }
}

class BBalTree {
    var rootNode: BBalTreeNode?
    
    func createBalanceBinaryTree(items: [Int]) {
        var taller: Bool?
        for item in items {
            _ = insert(root: &rootNode, item: item, taller: &taller)
        }
    }
    
    func insert(root: inout BBalTreeNode?, item: Int, taller: inout Bool?) -> Int {
        if root == nil {
            root = BBalTreeNode.init(value: item)
            root?.bf = .EH
            taller = true
        }
        else if (item == root?.value) {
            taller = false
            return 0
        }
        else if (item < (root?.value)!) {
            //如果插入过程，不会影响树本身的平衡，则直接结束
            if insert(root: &root!.leftNode, item: item, taller: &taller) == 0 {
                return 0
            }
            //判断插入过程是否会导致整棵树的深度 +1
            if (taller)! {
                //判断根结点 T 的平衡因子是多少，由于是在其左子树添加新结点的过程中导致失去平衡，所以当 T 结点的平衡因子本身为 1 时，需要进行左子树的平衡处理，否则更新树中各结点的平衡因子数
                switch (root?.bf) {
                case .LH?:
                    leftBalance(root: &root)
                    taller = false
                    break
                case .EH?:
                    root?.bf = .LH
                    taller = true
                    break
                case .RH?:
                    root?.bf = .EH
                    taller = false
                    break
                default:
                    break
                }
            }
        }
        else {
            if insert(root: &root!.rightNode, item: item, taller: &taller) == 0 {
                return 0
            }
            if (taller)! {
                switch (root?.bf) {
                case .LH?:
                    root?.bf = .EH
                    taller = false
                    break
                case .EH?:
                    root?.bf = .RH
                    taller = true
                    break
                case .RH?:
                    rightBalance(root: &root)
                    taller = false
                    break
                default:
                    break
                }
            }
        }
        return 1
    }
    
    /// 左高右低 -> 右旋
    ///
    /// - Parameter root: 当前根节点
    func RRotate(root: inout BBalTreeNode?) {
        let left = root?.leftNode
        root?.leftNode = left?.rightNode
        left?.rightNode = root
        root = left
    }
    
    /// 左低右高 -> 左旋
    ///
    /// - Parameter root: 当前根节点
    func LRotate(root: inout BBalTreeNode?) {
        let right = root?.rightNode
        root?.rightNode = right?.leftNode
        right?.leftNode = root
        root = right
    }
    
    func leftBalance(root: inout BBalTreeNode?) {
        let left: BBalTreeNode? = root?.leftNode
        var right: BBalTreeNode?
        switch left?.bf {
        case .LH?:
            root?.bf = BBalTreeFlag.EH
            left?.bf = BBalTreeFlag.EH
            RRotate(root: &root)
            break
        case .RH?:
            right = left?.rightNode
            switch(right?.bf) {
            case .LH?:
                root?.bf = .RH
                left?.bf = .EH
                break
            case .EH?:
                root?.bf = .EH
                left?.bf = .EH
                break;
            case .RH?:
                root?.bf = .EH
                left?.bf = .LH
                break;
            default:
                break
            }
            right?.bf = .EH
            LRotate(root: &root!.leftNode)
            RRotate(root: &root)
            break;
        default:
            break
        }
    }
    
    func rightBalance(root: inout BBalTreeNode?) {
        var left: BBalTreeNode?
        let right = root?.rightNode
        switch (right?.bf) {
        case .RH?:
            root?.bf = .EH
            right?.bf = .EH
            LRotate(root: &root)
            break;
        case .LH?:
            left = right?.leftNode
            switch(left?.bf) {
            case .LH?:
                root?.bf = .EH
                right?.bf = .RH
                break
            case .EH?:
                root?.bf = .EH
                right?.bf = .EH
                break
            case .RH?:
                root?.bf = .EH
                right?.bf = .LH
                break
            default:
                break
            }
            left?.bf = .EH
            RRotate(root: &root!.rightNode)
            LRotate(root: &root)
            break;
        default:
            break
        }
    }
    
    func findNode(root: BBalTreeNode?, item: Int, pos: inout BBalTreeNode?) -> Bool {
        var pt: BBalTreeNode? = root
        pos = nil
        while((pt) != nil) {
            if (pt?.value == item) {
                //找到节点，pos指向该节点并返回true
                pos = pt
                return true
            }
            else if ((pt?.value)! > item) {
                pt = pt?.leftNode
            }
            else {
                pt = pt?.rightNode
            }
        }
        return false
    }
    
    
    
    
    // MARK: - Traverse
    func preOrderTraverse(_ tree: BBalTreeNode?) {
        if let currentNode: BBalTreeNode = tree {
            print(currentNode.value ?? "none")
            self.preOrderTraverse(currentNode.leftNode)
            self.preOrderTraverse(currentNode.rightNode)
        }
    }
    
    func inOrderTraverse(_ tree: BBalTreeNode?) {
        if let currentNode: BBalTreeNode = tree {
            self.inOrderTraverse(currentNode.leftNode)
            print(currentNode.value ?? "none")
            self.inOrderTraverse(currentNode.rightNode)
        }
    }
    
    func levelTraverse(_ tree: BBalTreeNode?) {
        guard let root = tree else {
            return
        }
        var queue = [BBalTreeNode]()
        queue.append(root)
        while (queue.count > 0) {
            let node = queue.removeFirst()
            print(node.value ?? "none")
            if let left = node.leftNode {
                queue.append(left)
            }
            if let right = node.rightNode {
                queue.append(right)
            }
        }
    }

}

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
        /*
            5
          *
        2
          *
            4
        ****** 先让因子一致，左旋，然后右旋 ******
            5 右旋->      4
           *           *   *
          4           2     5
         *
        2
         */
         /*
                         4
                      *     *
                    2          6
                  *   *       *  *
                0       3    5     8
                  *              *   *
                   1            7      9
         */
//        let array = [5, 2, 4, 6, 9, 0, 3, 7, 8, 1]
        let array = [5, 2, 4]
        let tree = BBalTree.init()
        tree.createBalanceBinaryTree(items: array)
        print("--------------preOrderTraverse-------------------")
        tree.preOrderTraverse(tree.rootNode)
        print("--------------inOrderTraverse-------------------")
        tree.inOrderTraverse(tree.rootNode)
        print("--------------levelTraverse-------------------")
        tree.levelTraverse(tree.rootNode)
        
        var pos: BBalTreeNode?
        let result = tree.findNode(root: tree.rootNode, item: 2, pos: &pos)
        print("result:\(result),", pos?.value ?? "not found this node")
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
