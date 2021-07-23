//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsEndpointTests: XCTestCase {
	func test_imageComments_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!
		let image = FeedImage(id: UUID(), description: "A Image Description", location: "World", url: anyURL())
		let receivedURL = ImageCommentsEndpoint.get(image).url(baseURL: baseURL)
		let expectedURL = URL(string: "http://base-url.com/v1/image/\(image.id)/comments")!

		XCTAssertEqual(receivedURL, expectedURL)
	}
}
