//
//  SortViewController.swift
//  BinaryTree
//
//  Created by xinpin on 2018/10/30.
//  Copyright © 2018年 Nix. All rights reserved.
//

import UIKit

class BSTreeNode: NSObject {
    var leftNode: BSTreeNode?
    var rightNode: BSTreeNode?
    var value: Int?
    
    init(value: Int) {
        self.value = value
    }
}

class BSTree {
    var rootNode: BSTreeNode?
    
    func searchBinaryTree(items: [Int]) {
        for item in items {
            _ = insert(item: item)
        }
    }

    // 增
    func insert(item: Int) -> Bool {
        if rootNode == nil {
            rootNode = BSTreeNode.init(value: item)
            return true
        }
        var cur = rootNode
        var par: BSTreeNode?
        var flag = -1
        while cur != nil {
            par = cur
            if cur?.value == item {
                return false
            }
            if (cur?.value)! < item {
                cur = cur?.rightNode
                flag = 1
            } else if ((cur?.value)! > item) {
                cur = cur?.leftNode
                flag = 0
            }
        }
        cur = BSTreeNode.init(value: item)
        if flag == 1 {
            par?.rightNode = cur
        } else if flag == 0 {
            par?.leftNode = cur
        }
        return true
    }
    
    // 删
    func remove(item: Int) -> Bool {
        //左为NULL
        //右为NULL
        //左右都不为NULL
        var cur = self.rootNode
        var parent: BSTreeNode?
        while(cur != nil) {
            if(cur?.value == item) {
                var preNode: BSTreeNode? = cur
                if(cur?.leftNode != nil && cur?.rightNode != nil) {
                    //删除左右孩子都不为NULL的情况
                    //可以选择左树的最右结点或者右树的最左结点交换删除
                    var minright = cur?.rightNode
                    if minright?.leftNode == nil {
                        cur?.value = minright?.value
                        cur?.rightNode = minright?.rightNode
                        return true
                    }
                    while(minright?.leftNode != nil) {
                        preNode = minright
                        minright = minright?.leftNode
                    }
                    cur?.value = minright?.value
                } else if(cur?.leftNode == nil) {
                    //有一种情况是，删除根节点时，根节点只有一个子树，即按照左子树为NULL
                    //或者右子树为NULL的情况处理，此时根节点的parent是NULL，所以需要单独处理！
                    if(parent == nil) {
                        rootNode = rootNode?.rightNode
                    } else {
                        if((parent?.value)! < item) {
                            parent?.rightNode = cur?.rightNode
                        } else {
                            parent?.leftNode = cur?.rightNode
                        }
                    }
                } else if(cur?.rightNode == nil) {
                    if(parent == nil) {
                        rootNode = cur?.leftNode
                    } else {
                        if((parent?.value)! < item) {
                            parent?.rightNode = cur?.leftNode
                        } else {
                            parent?.leftNode = cur?.leftNode
                        }
                    }
                }
                preNode?.leftNode = nil
                return true
            } else if((cur?.value)! < item) {
                parent = cur
                cur = cur?.rightNode
            } else if((cur?.value)! > item) {
                parent = cur
                cur = cur?.leftNode
            }
        }
        return false
    }
    
    func removeRecursive(root: inout BSTreeNode?, item: Int) -> Bool {
        if (root == nil) {
            return false
        }
        if (root!.value! < item) {
            return self.removeRecursive(root: &(root!.rightNode), item: item)
        } else if (root!.value! > item) {
            return self.removeRecursive(root: &(root!.leftNode), item:item)
        } else {
            var preNode: BSTreeNode? = root
            if (root?.leftNode == nil) {
                root = root?.rightNode
            } else if (root?.rightNode == nil) {
                root = root?.leftNode
            } else {
                var minright = root //寻找右树的最左结点进行key值的交换
                minright = root?.rightNode
                if minright?.leftNode == nil {
                    root?.value = minright?.value
                    root?.rightNode = minright?.rightNode
                    return true
                }
                while (minright?.leftNode != nil) {
                    preNode = minright
                    minright = minright?.leftNode
                }
                root?.value = minright?.value
            }
            preNode?.leftNode = nil
            return true
        }
    }
    
    //查找  递归
    func findRecursive(rootNode: BSTreeNode?, item: Int) -> Bool {
        if (rootNode == nil) {
            return false
        }
        if((rootNode?.value)! > item) {
            return findRecursive(rootNode: rootNode?.leftNode, item: item)
        } else if((rootNode?.value)! < item) {
            return findRecursive(rootNode: rootNode?.rightNode, item: item)
        } else {
            return true
        }
    }
    
    // 查
    func find(item: Int) -> Bool {
        var cur = rootNode
        while (cur != nil) {
            if(cur?.value == item) {
                return true
            } else if ((cur?.value)! < item) {
                cur = cur?.rightNode
            } else {
                cur = cur?.leftNode
            }
        }
        return false
    }
    
    // MARK: - Traverse
    func preOrderTraverse(_ tree: BSTreeNode?) {
        if let currentNode: BSTreeNode = tree {
            print(currentNode.value ?? "none")
            self.preOrderTraverse(currentNode.leftNode)
            self.preOrderTraverse(currentNode.rightNode)
        }
    }
    
    func depthOrderTraverse(_ tree: BSTreeNode?) {
        guard let root = tree else {
            return
        }
        var queue = [BSTreeNode]()
        queue.append(root)
        while (queue.count > 0) {
            let node = queue.removeLast()
            print(node.value ?? "none")
            if let right = node.rightNode {
                queue.append(right)
            }
            if let left = node.leftNode {
                queue.append(left)
            }
        }
    }
    
    /*
     层次遍历
     */
    func levelTraverse(_ tree: BSTreeNode?) {
        guard let root = tree else {
            return
        }
        var queue = [BSTreeNode]()
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


class SortViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "二叉排序树"
        self.view.backgroundColor = UIColor.white
        /*
         二叉排序树：
         即一个二叉树，它的每一个结点的左孩子的key值比当前结点的key值小，而右孩子结点的key值比当前结点的key值大，
         这样的一个树就是二叉排序树，也叫二叉搜索树
        */
        /*
                        5
                     *     *
                   2         6
                 *   *         *
               0       4         9
                *     *         *
                 1   3         7
                                *
                                 8
        */
        let array = [5, 2, 4, 6, 9, 0, 3, 7, 8, 1]
        let tree = BSTree.init()
        tree.searchBinaryTree(items: array)
        //5 2 6 0 4 9 1 3 7 8
        tree.levelTraverse(tree.rootNode)
        print("************************")
        //5 2 0 1 4 3 6 9 7 8
        tree.preOrderTraverse(tree.rootNode)
        print("************************")
        //5 2 0 1 4 3 6 9 7 8
        tree.depthOrderTraverse(tree.rootNode)
        
        let findResult1 = tree.find(item: 3)
        let findResult2 = tree.findRecursive(rootNode: tree.rootNode, item: 3)
        print("findResult1=\(findResult1), findResult2=\(findResult2)")
        
        print("===========removeRecursive=============")
        let result1 = tree.removeRecursive(root: &(tree.rootNode), item: 5)
        tree.levelTraverse(tree.rootNode)
        
        let tree2 = BSTree.init()
        tree2.searchBinaryTree(items: array)
        let result2 = tree2.remove(item: 5)
        print("***********remove*************")
        tree2.levelTraverse(tree2.rootNode)
        print("result1=\(result1), result2=\(result2)")

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
