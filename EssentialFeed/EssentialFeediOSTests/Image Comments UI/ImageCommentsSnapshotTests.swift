//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class ImageCommentsSnapshotTests: XCTestCase {
	func test_ViewWithComments() {
		let sut = makeSUT()

		sut.display(imageComments())

		assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "IMAGE_COMMENTS_WITH_CONTENT_light")
		assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "IMAGE_COMMENTS_WITH_CONTENT_dark")
	}

	// MARK: - Helpers

	private func imageComments() -> [CellController] {
		feedImageWithAllComments().map {
			CellController(id: UUID(), $0)
		}
	}

	private func makeSUT() -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
		let controller = storyboard.instantiateInitialViewController() as! ListViewController
		controller.loadViewIfNeeded()
		controller.tableView.showsVerticalScrollIndicator = false
		controller.tableView.showsHorizontalScrollIndicator = false
		return controller
	}

	private func feedImageWithAllComments() -> [ImageCommentCellController] {
		return [
			ImageCommentCellController(
				model: ImageCommentViewModel(message: "East Side Gallery",
				                             date: "999 years ago",
				                             userName: "First Guy")),
			ImageCommentCellController(
				model: ImageCommentViewModel(message: "East Side Gallery\n is in Berlin Germany",
				                             date: "9 days ago",
				                             userName: "Second Guy")),
			ImageCommentCellController(
				model: ImageCommentViewModel(message: "A Nice Place",
				                             date: "9 minutes ago",
				                             userName: "Third Guy"))
		]
	}
}
