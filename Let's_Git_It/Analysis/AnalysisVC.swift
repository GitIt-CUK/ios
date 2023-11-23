import SwiftUI
import UIKit

class AnalysisViewController: UIViewController {
    private var hostingController: UIHostingController<AnalysisView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SwiftUI 뷰를 호스팅하는 UIHostingController 인스턴스 생성
        let swiftUIView = AnalysisView()
        hostingController = UIHostingController(rootView: swiftUIView)
        
        guard let hostingControllerView = hostingController?.view else { return }
        
        // 호스팅 컨트롤러를 현재 뷰 컨트롤러의 자식으로 추가
        addChild(hostingController!)
        view.addSubview(hostingControllerView)
        
        hostingControllerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 호스팅 컨트롤러 뷰의 제약조건 설정
        NSLayoutConstraint.activate([
            hostingControllerView.topAnchor.constraint(equalTo: view.topAnchor),
            hostingControllerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingControllerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingControllerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        hostingController?.didMove(toParent: self)
    }
}
