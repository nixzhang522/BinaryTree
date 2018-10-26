//
//  ConceptViewController.swift
//  BinaryTree
//
//  Created by xinpin on 2018/10/25.
//  Copyright © 2018年 Nix. All rights reserved.
//

import UIKit

class BTreeNode {
    var leftNode: BTreeNode?
    var rightNode: BTreeNode?
    var value: String?
    
    init(value: String) {
        self.value = value
    }
}

class BTree {
    var rootNode: BTreeNode?

    var index = 0
    var items: [String]?
    
    init(items: [String]) {
        self.items = items
        self.rootNode = self.createTree()
    }
    /*
    // ["A", "B", "D", "", "", "E", "", "", "C", "F", "", "", "G", "", ""]
    //   |    |    |      |     |      |     |    |     |      |      |
    //   r   A.L  B.L  (D.LR)  B.R  (E.LR)  A.R  C.L  (F.LR)  C.R   (G.LR)
    //   A  A.L(B)  A.R(C)
    //   B  B.L(D)  B.R(E)
    //   C  C.L(F)  C.R(G)
    */
    func createTree() -> BTreeNode? {
        if index < (items?.count)! && index >= 0 {
            let item = items![index]
            if item == "" {
                return nil
            }
            else {
                let node = BTreeNode.init(value: item)
                index += 1
                node.leftNode = createTree()
                index += 1
                node.rightNode = createTree()
                return node
            }
        }
        return nil
    }
    
    /*
    前序遍历  （根节点->左子树->右子树）
    a. 访问结点p，并将结点p入栈；
    b. 判断结点p的左孩子是否为空，若为空，则取栈顶结点并进行出栈操作，并将栈顶结点的右孩子置为当前的结点p，循环置a；若不为空，则将p的左孩子置为当前结点p；
    c. 直到p为空，并且栈为空，则遍历结束。
    */
    func preOrderTraverse(_ tree: BTreeNode?) {
        if let currentNode: BTreeNode = tree {
            print(currentNode.value ?? "none")
            self.preOrderTraverse(currentNode.leftNode)
            self.preOrderTraverse(currentNode.rightNode)
        }
    }
    
    /*
     中序遍历  （左子树->根节点->右子树）
     先中序遍历左子树，然后再访问根结点，最后再中序遍历右子树即左—根—右。
     */
    func inOrderTraverse(_ tree: BTreeNode?) {
        if let currentNode: BTreeNode = tree {
            self.inOrderTraverse(currentNode.leftNode)
            print(currentNode.value ?? "none")
            self.inOrderTraverse(currentNode.rightNode)
        }
    }
    
    /*
     后序遍历  （左子树->右子树->根节点）
     先后序遍历左子树，然后再后序遍历右子树，最后再访问根结点即左—右—根。
     */
    func postOrderTraverse(_ tree: BTreeNode?) {
        if let currentNode: BTreeNode = tree {
            self.postOrderTraverse(currentNode.leftNode)
            self.postOrderTraverse(currentNode.rightNode)
            print(currentNode.value ?? "none")
        }
    }
}


class ConceptViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "二叉树、基本概念"
        self.view.backgroundColor = UIColor.white
        
        /*
                     A
                  *     *
                B          C
              *   *      *    *
            D       E   F       G
        */

        let tree = BTree(items: ["A", "B", "D", "", "", "E", "", "", "C", "F", "", "", "G", "", ""])
        /*
         前序遍历  A B D E C F G
         */
        tree.preOrderTraverse(tree.rootNode)
        print("*****************")
        /*
         中序遍历 左—根—右 D B E A F C G
         */
        tree.inOrderTraverse(tree.rootNode)
        print("*****************")
        /*
         后序遍历 左—右—根  D E B F G C A
         */
        tree.postOrderTraverse(tree.rootNode)
        
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
