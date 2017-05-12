//
//  ImageControllerTests.swift
//  Random User
//
//  Created by Jeff Norton on 5/12/17.
//  Copyright © 2017 Jeff Norton. All rights reserved.
//

import XCTest
@testable import Random_User

class ImageControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testImageForURLReturnsImageForValidImageURL() {
        
        let validImageURLString = "https://randomuser.me/api/portraits/thumb/men/32.jpg"
        var resultImage: UIImage? = nil
        
        _ = ImageController.imageForURL(urlString: validImageURLString) { (image) in
            
            if let image = image {
                resultImage = image
            }
            
            XCTAssertNotNil(resultImage, "The image should not be nil.")
        }
    }
    
    func testImageForURLReturnsNilForInvalidImageURL() {
        
        let invalidImageURLString = "http://www.bogusimage.com/images/yeah-right.jpg"
        
        _ = ImageController.imageForURL(urlString: invalidImageURLString) { (image) in
            XCTAssertNil(image, "The image should be nil.")
        }
    }
    
}
