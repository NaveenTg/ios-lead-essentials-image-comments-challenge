//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class ImageCommentsUIComposer {
	private init() {}

	private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>

	public static func imageCommentsComposedWith(
		commentsLoader: @escaping () -> AnyPublisher<[FeedImage], Error>,
		selection: @escaping (FeedImage) -> Void = { _ in }
	) -> ListViewController {
		let presentationAdapter = FeedPresentationAdapter(loader: commentsLoader)

		let feedController = makeFeedViewController(title: FeedPresenter.title)
		feedController.onRefresh = presentationAdapter.loadResource

		presentationAdapter.presenter = LoadResourcePresenter(
			resourceView: FeedViewAdapter(
				controller: feedController,
				imageLoader: { _ in Empty<Data, Error>().eraseToAnyPublisher() },
				selection: selection),
			loadingView: WeakRefVirtualProxy(feedController),
			errorView: WeakRefVirtualProxy(feedController),
			mapper: FeedPresenter.map)

		return feedController
	}

	private static func makeFeedViewController(title: String) -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
		let feedController = storyboard.instantiateInitialViewController() as! ListViewController
		feedController.title = title
		return feedController
	}
}
