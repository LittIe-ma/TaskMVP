//
//  MVCViewController.swift
//  TaskMVP
//
//  Created by  on 2021/3/10.
//

import UIKit

/*
 MVC構成になっています、MVP構成に変えてください

 Viewから何かを渡す、Viewが何かを受け取る　以外のことを書かない
 if, guard, forといった制御を入れない
 Presenter以外のクラスを呼ばない
 itemsといった変化するパラメータを持たない(状態を持たない)
*/
final class MVPSearchViewController: UIViewController {

  @IBOutlet private weak var searchTextField: UITextField!
  @IBOutlet private weak var searchButton: UIButton! {
    didSet {
      searchButton.addTarget(self, action: #selector(tapSearchButton(_sender:)), for: .touchUpInside)
    }
  }

  @IBOutlet private weak var indicator: UIActivityIndicatorView!

  @IBOutlet private weak var tableView: UITableView! {
    didSet {
      tableView.register(UINib.init(nibName: MVPTableViewCell.className, bundle: nil), forCellReuseIdentifier: MVPTableViewCell.className)
      tableView.delegate = self
      tableView.dataSource = self
    }
  }

  private var presenter: MVPSearchPresenterInput!
  func inject(presenter: MVPSearchPresenterInput) {
    self.presenter = presenter
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.isHidden = true
    indicator.isHidden = true
  }

  @objc func tapSearchButton(_sender: UIResponder) {
    self.presenter.searchText(searchTextField.text)
  }
}

extension MVPSearchViewController: MVPSearchPresenterOutput {
  func update(loading: Bool) {
    DispatchQueue.main.async {
      self.tableView.isHidden = loading
      self.indicator.isHidden = !loading
    }
  }

  func update(githubModels: [GithubModel]) {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

  func get(error: Error) {
    DispatchQueue.main.async {
      print(error.localizedDescription)
    }
  }

  func showWeb(githubModel: GithubModel) {
    DispatchQueue.main.async {
      Router.shared.showWeb(from: self, githubModel: githubModel)
    }
  }
}

extension MVPSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presenter.didSelect(index: indexPath.row)
  }
}

extension MVPSearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter.numberOfItems
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MVPTableViewCell.className) as? MVPTableViewCell else {
      fatalError()
    }
    let githubModel = presenter.item(index: indexPath.row)
    cell.configure(githubModel: githubModel)
    return cell
  }
}
