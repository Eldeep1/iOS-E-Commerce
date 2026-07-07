//
//  PaymobWebView.swift
//  Buyza App
//
//  Created by depo on 06/07/2026.
//

import SwiftUI
import WebKit

struct PaymobWebView: UIViewRepresentable {
    let url: URL
    let onResult: (Bool) -> Void
    let onDismiss: () -> Void

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: PaymobWebView

        init(_ parent: PaymobWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            let urlString = url.absoluteString.lowercased()
            print("PaymobWebView Navigating to: \(urlString)")

            // Check if Paymob redirected back with a success parameter
            if urlString.contains("success=true") || urlString.contains("success=true") {
                print("PaymobWebView: SUCCESS DETECTED!")
                parent.onResult(true)
                decisionHandler(.cancel)
                return
            } else if urlString.contains("success=false") {
                print("PaymobWebView: FAILURE DETECTED!")
                parent.onResult(false)
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }
    }
}
