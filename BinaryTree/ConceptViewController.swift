//
//  ConceptViewController.swift
//  BinaryTree
//
//  Created by xinpin on 2018/10/25.
//  Copyright © 2018年 Nix. All rights reserved.
//

import UIKit


/*
 1.在二叉树的第i层上至多有2^(i-1)（i >= 1）个节点
 2.深度为k的二叉树至多有2^k-1（k>=1）个节点。  2^0 + 2^1 + 2^2 + 2^(k-1) = 2^k - 1。
 3.二叉树的叶子节点数为n0, 度为2的节点数为n2, 那么n0 = n2 + 1。
    度数为0的节点的个数为n0, 度数为1的节点为n1, 度数为2的节点n2。那么二叉树的节点总数 n = n0 + n1 + n2。
    因为除了根节点外其余的节点入度都为1，所以二叉树的度数为n-1，当然度的个数可以使用出度来算，即为2*n2+n1，所以n-1=2*n2+n1。
    以n=n0+n1+n2与n-1=2*n2+n1这两个公式我们很容易的推出n0 = n2 + 1。
 
    证明：首先，假设该二叉树有N 个节点，那么它会有多少条边呢？答案是N - 1，这是因为除了根节点，其余的每个节点都有且只有一个父节点，那么这N 个节点恰好为树贡献了N - 1 条边。这是从下往上的思考，而从上往下(从树根到叶节点)的思考，容易得到每个节点的度数和 0*n0 + 1*n1 + 2*n2 即为边的个数。
    因此，我们有等式 N - 1 = n1 + 2*n2，把N 用n0 + n1 + n2 替换，得到n0 + n1 + n2 - 1 = n1 + 2*n2，于是有
 　　　　　　　　n0 = n2 + 1。命题得证。
 4.具有n个结点的完全二叉树的深度为log2n + 1 （向下取整，比如3.5，就取3）。
    基于完全二叉树的特点，我们假设完全二叉树的深度为k, 那么二叉树的结点个数的范围为2(k-1)-1 <= n <= 2k-1。
 */
class BTreeNode: NSObject {
    var leftNode: BTreeNode?
    var rightNode: BTreeNode?
    var value: String?
    
    init(value: String) {
        self.value = value
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? BTreeNode else {
            return false
        }
        return leftNode == other.leftNode && rightNode == other.rightNode && value == other.value
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
     前序非递归遍历(根节点->左子树->右子树)
     */
    func preOrderTraverse2(_ tree: BTreeNode?) {
        var nodes = [BTreeNode]()
        var pNode = tree
        while (pNode != nil || nodes.count > 0) {
            if (pNode != nil) {
                print(pNode?.value ?? "none")
                nodes.append(pNode!)
                pNode = pNode?.leftNode
            } else { //pNode == nil && nodes.count > 0
                let node = nodes.removeLast()
                pNode = node.rightNode
            }
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
     中序非递归遍历（左子树->根节点->右子树）
     依据前序遍历的顺序，优先訪问根结点。然后在訪问左子树和右子树。所以。对于随意结点node。第一部分即直接訪问之，之后在推断左子树是否为空，不为空时即反复上面的步骤，直到其为空。若为空。则须要訪问右子树。注意。在訪问过左孩子之后。须要反过来訪问其右孩子。所以，须要栈这样的数据结构的支持。对于随意一个结点node，详细过程例如以下：
     
     a)訪问之，并把结点node入栈。当前结点置为左孩子；
     b)推断结点node是否为空，若为空。则取出栈顶结点并出栈，将右孩子置为当前结点；否则反复a)步直到当前结点为空或者栈为空（能够发现栈中的结点就是为了訪问右孩子才存储的）
     */
    func inOrderTraverse2(_ tree: BTreeNode?) {
        var nodes = [BTreeNode]()
        var pNode = tree
        while (pNode != nil || nodes.count > 0) {
            if (pNode != nil) {
                nodes.append(pNode!)
                pNode = pNode?.leftNode
            } else { //pNode == nil && nodes.count > 0
                let node = nodes.removeLast()
                print(node.value ?? "none")
                pNode = node.rightNode
            }
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
    
    /*
     后序非递归遍历 （左子树->右子树->根节点）
     后序遍历的非递归实现是三种遍历方式中最难的一种。由于在后序遍历中，要保证左孩子和右孩子都已被訪问而且左孩子在右孩子前訪问才訪问根结点，这就为流程的控制带来了难题。
     
     要保证根结点在左孩子和右孩子訪问之后才干訪问，因此对于任一结点P。先将其入栈。假设P不存在左孩子和右孩子。则能够直接訪问它；或者P存在左孩子或者右孩子。可是其左孩子和右孩子都已被訪问过了。则相同能够直接訪问该结点。若非上述两种情况。则将P的右孩子和左孩子依次入栈。这样就保证了每次取栈顶元素的时候，左孩子在右孩子前面被訪问。左孩子和右孩子都在根结点前面被訪问。
     */
    func postOrderTraverse2(_ tree: BTreeNode?) {
        var nodes = [BTreeNode]()
        var cur: BTreeNode?   //当前结点
        var pre: BTreeNode?   //前一次訪问的结点
        nodes.append(tree!)

        while(nodes.count > 0) {
            cur = nodes.last
            //假设当前结点没有孩子结点或者孩子节点都已被訪问过
            if((cur?.leftNode == nil && cur?.rightNode == nil) || (pre != nil && (pre == cur?.leftNode || pre == cur?.rightNode))) {
                print(cur?.value ?? "None")
                nodes.removeLast()
                pre = cur
            } else {
                if(cur?.rightNode != nil) {
                    nodes.append((cur?.rightNode)!)
                }
                if cur?.leftNode != nil {
                    nodes.append((cur?.leftNode)!)
                }
            }
        }
    }
    
    /*
     层次遍历  广度优先
     */
    func levelTraverse(_ tree: BTreeNode?) {
        guard let root = tree else {
            return
        }
        var queue = [BTreeNode]()
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
    
    /*
     深度优先遍历 事实上深度遍历就是 前序、中序和后序
     事实上就是 前序遍历
     */
    func depthOrderTraverse(_ tree: BTreeNode?) {
        guard let root = tree else {
            return
        }
        var queue = [BTreeNode]()
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
        tree.preOrderTraverse2(tree.rootNode)
        print("*****************")
        /*
         中序遍历 左—根—右 D B E A F C G
         */
        tree.inOrderTraverse(tree.rootNode)
        tree.inOrderTraverse2(tree.rootNode)
        print("*****************")
        /*
         后序遍历 左—右—根  D E B F G C A
         */
        tree.postOrderTraverse(tree.rootNode)
        tree.postOrderTraverse2(tree.rootNode)
        print("*****************")
        /*
         层级遍历 一层层遍历  A B C D E F G
         */
        tree.levelTraverse(tree.rootNode)
        print("*****************")
        /*
         深度优先遍历
         */
        tree.depthOrderTraverse(tree.rootNode)
        
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
