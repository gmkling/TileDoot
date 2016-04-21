//
//  LinkedList.swift
//  TileDoot
//
//  Created by Garry Kling on 4/21/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation

class LLNode<T>
{
    var key: T?
    var next: LLNode?
    var previous: LLNode?
}

// T should be equatable so findKey will work
class LinkedList<T : Equatable> {
    
    var head: LLNode<T> = LLNode<T>()
    
    func insert(key: T)
    {
        let newNode = LLNode<T>()
        newNode.key = key
        newNode.next = head
        
        if (head.key != nil)
        {
            head.previous = newNode
        }
        
        head = newNode
        newNode.previous = nil
    }
    
    func delete(node: LLNode<T>)
    {
        // if the key is not the head, attach next to previous
        if node.previous != nil
        {
            node.previous?.next = node.next
        } else{
            // if it is the head, make next the head
            self.head = node.next!
        }
        
        // if the key is not the tail, attach next to the previous (which will be nil if next is the new head)
        if node.next != nil
        {
            node.next?.previous = node.previous
        }
    }
    
    func findNode(value: T) -> LLNode<T>?
    {
        var x : LLNode<T>? = self.head
        
        while x != nil && x?.key != value
        {
            x = x?.next
        }
        
        return x
    }
    
    func printKeys()
    {
        var current: LLNode<T>? = head
        
        while current != nil
        {
            print("Node value is \(current!.key)")
            current = current!.next
        }
    }
}
