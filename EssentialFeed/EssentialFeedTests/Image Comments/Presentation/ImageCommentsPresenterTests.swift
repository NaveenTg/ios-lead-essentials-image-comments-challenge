//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsPresenterTests: XCTestCase {
	func test_title_isLocalized() {
		XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
	}

	func test_map_createsViewModel() {
		let calendar = Calendar(identifier: .gregorian)
		let locale = Locale(identifier: "en_US_POSIX")
		let now = Date()
		let comments = [
			ImageComment(id: UUID(),
			             message: "First Message",
			             createdAt: now.adding(minutes: -5, calendar: calendar),
			             username: "First UserName"),
			ImageComment(id: UUID(),
			             message: "Second Message",
			             createdAt: now.adding(days: -1, calendar: calendar),
			             username: "Second UserName")
		]

		let viewModel = ImageCommentsPresenter.map(comments,
		                                           date: now,
		                                           calendar: calendar,
		                                           locale: locale)

		XCTAssertEqual(viewModel.comments, [
			ImageCommentViewModel(
				message: "First Message",
				date: "5 minutes ago",
				username: "First UserName"
			),
			ImageCommentViewModel(
				message: "Second Message",
				date: "1 day ago",
				username: "Second UserName"
			)
		])
	}

	// MARK: - Helpers

	private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
		let table = "ImageComments"
		let bundle = Bundle(for: ImageCommentsPresenter.self)
		let value = bundle.localizedString(forKey: key, value: nil, table: table)
		if value == key {
			XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
		}
		return value
	}
}
