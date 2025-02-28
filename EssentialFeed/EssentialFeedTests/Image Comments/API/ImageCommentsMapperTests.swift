//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsMapperTests: XCTestCase {
	func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
		let json = makeItemsJSON([])
		let samples = [199, 130, 300, 400, 500]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
			)
		}
	}

	func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJSON() throws {
		let invalidJSON = Data("invalid json".utf8)
		let samples = [200, 201, 250, 270, 299]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: code))
			)
		}
	}

	func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
		let emptyListJSON = makeItemsJSON([])
		let samples = [200, 201, 250, 270, 299]
		try samples.forEach { code in
			let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: code))
			XCTAssertEqual(result, [])
		}
	}

	func test_map_deliversItemsOn2xxHTTPResponseWithJSONItems() throws {
		let item1 = makeComment(
			id: UUID(),
			message: "First Message",
			createdAt: (Date(timeIntervalSince1970: 1627042700), "2021-07-23T12:18:20+00:00"),
			userName: "First UserName")

		let item2 = makeComment(
			id: UUID(),
			message: "Second Message",
			createdAt: (Date(timeIntervalSince1970: 1627658894), "2021-07-30T15:28:14+00:00"),
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
		                        username: userName)
		let json: [String: Any] = [
			"id": id.uuidString,
			"message": message,
			"created_at": createdAt.iso8601String,
			"author": [
				"username": userName
			]
		]

		return (item, json)
	}
}
