//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsMapperTests: XCTestCase {
	func test_map_throwsErrorOnNon200HTTPResponse() throws {
		let json = makeItemsJSON([])
		let samples = [199, 130, 300, 400, 500]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
			)
		}
	}

	func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
		let invalidJSON = Data("invalid json".utf8)
		let samples = [200, 201, 250, 270, 299]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: code))
			)
		}
	}

	func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
		let emptyListJSON = makeItemsJSON([])
		let samples = [200, 201, 250, 270, 299]
		try samples.forEach { code in
			let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: code))
			XCTAssertEqual(result, [])
		}
	}

	func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
		let item1 = makeComment(
			id: UUID(),
			message: "First Message",
			createdAt: (Date(timeIntervalSince1970: 1627042700), "2021-07-23T12:18:20+00:00"),
			userName: "First UserName")

		let item2 = makeComment(
			id: UUID(),
			message: "Second Message",
			createdAt: (Date(timeIntervalSince1970: 1627042700), "2021-07-23T12:18:20+00:00"),
			userName: "Second UserName")

		let json = makeItemsJSON([item1.json, item2.json])
		let samples = [200, 201, 250, 270, 299]
		try samples.forEach { code in
			let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
			XCTAssertEqual(result, [item1.model, item2.model])
		}
	}

	// MARK: - Helpers

	private func makeComment(id: UUID, message: String, createdAt: (date: Date, iso8601String: String), userName: String) -> (model: ImageComment, json: [String: Any]) {
		let item = ImageComment(id: id,
		                        message: message,
		                        createdAt: createdAt.date,
		                        userName: userName)
		let json: [String: Any] = [
			"id": id.uuidString,
			"message": message,
			"createdAt": createdAt.iso8601String,
			"author": [
				"userName": userName
			]
		].compactMapValues { $0 }

		return (item, json)
	}
}
