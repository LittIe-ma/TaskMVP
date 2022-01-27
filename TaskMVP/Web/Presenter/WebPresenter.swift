//
//  WebPresenter.swift
//  TaskMVP
//
//  Created by Masato Yasuda on 2022/01/28.
//

import Foundation

protocol WebPresenterInput {
  func viewDidLoaded()
}

protocol WebPresenterOutput: AnyObject {
  func load(request: URLRequest)
}

final class WebPresenter {
  private weak var output: WebPresenterOutput!
  private var githubModel: GithubModel

  init(output: WebPresenterOutput, githubModel: GithubModel) {
    self.output = output
    self.githubModel = githubModel
  }
}

extension WebPresenter: WebPresenterInput {
  func viewDidLoaded() {
    guard let url = URL(string: githubModel.urlStr) else { return }
    self.output.load(request: URLRequest(url: url))
  }
}
