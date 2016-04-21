//
//  TileDootLinkedListTests.swift
//  TileDoot
//
//  Created by Garry Kling on 4/21/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import XCTest
@testable import TileDoot

class TileDootLinkedListTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_LLInsert()
    {
        let testLL = LinkedList<Int>()
        
        testLL.insert(0)
        testLL.insert(1)
        testLL.insert(2)
        testLL.insert(3)
        
        //testLL.printKeys()
        XCTAssert(testLL.head.key == 3)
        print(testLL.head.key)
        XCTAssert(testLL.head.previous == nil)
        
        var iter : LLNode<Int>? = testLL.head
        var i=iter!.key!
        
        while iter?.next != nil
        {
            XCTAssert(iter!.key == i)
            i -= 1
            iter = iter?.next
        }
        
    }
    
    func test_LLFind()
    {
        let testLL = LinkedList<Int>()
        
        testLL.insert(0)
        testLL.insert(1)
        testLL.insert(2)
        testLL.insert(3)
        
        let found = testLL.findNode(2)
        
        XCTAssert(found!.key == 2)
        XCTAssert(found!.key == testLL.head.next!.key)
    }
    
    func test_LLDelete()
    {
        let testLL = LinkedList<Int>()
        
        testLL.insert(0)
        testLL.insert(1)
        testLL.insert(2)
        testLL.insert(3)
        
        testLL.delete(testLL.findNode(2)!)
        
        XCTAssert(testLL.head.next!.key == 1)
        
        testLL.delete(testLL.findNode(3)!)
        XCTAssert(testLL.head.key == 1)
        
    }
    
    


}
