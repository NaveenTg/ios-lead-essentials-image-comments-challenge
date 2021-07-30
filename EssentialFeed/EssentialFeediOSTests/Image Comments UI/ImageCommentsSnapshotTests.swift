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
		assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSize: .extraExtraLarge)), named: "IMAGE_COMMENTS_CONTENT_light_extraExtraLarge")
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
				                             username: "First Guy")),
			ImageCommentCellController(
				model: ImageCommentViewModel(message: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
				                             date: "9 days ago",
				                             username: "Second Guy in  East Side Gallery\nMemorial in Berlin, Germany")),
			ImageCommentCellController(
				model: ImageCommentViewModel(message: "A Nice Place",
				                             date: "9 minutes ago",
				                             username: "Third Guy"))
		]
	}
}
