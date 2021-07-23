//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class ImageCommentsUIComposer {
	private init() {}

	private typealias ImageCommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], ImageCommentViewAdapter>

	public static func imageCommentsComposedWith(
		commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>
	) -> ListViewController {
		let presentationAdapter = ImageCommentsPresentationAdapter(loader: commentsLoader)

		let imageCommentsController = makeImageCommentsViewController(title: ImageCommentsPresenter.title)
		imageCommentsController.onRefresh = presentationAdapter.loadResource

		presentationAdapter.presenter = LoadResourcePresenter(
			resourceView: ImageCommentViewAdapter(
				controller: imageCommentsController),
			loadingView: WeakRefVirtualProxy(imageCommentsController),
			errorView: WeakRefVirtualProxy(imageCommentsController),
			mapper: { ImageCommentsPresenter.map($0) })

		return imageCommentsController
	}

	private static func makeImageCommentsViewController(title: String) -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
		let imageCommentController = storyboard.instantiateInitialViewController() as! ListViewController
		imageCommentController.title = title
		return imageCommentController
	}
}

private final class ImageCommentViewAdapter: ResourceView {
	private weak var controller: ListViewController?

	init(controller: ListViewController) {
		self.controller = controller
	}

	func display(_ viewModel: ImageCommentsViewModel) {
		controller?.display(viewModel.comments.map { viewModel in
			CellController(id: viewModel, ImageCommentCellController(model: viewModel))
		})
	}
}
