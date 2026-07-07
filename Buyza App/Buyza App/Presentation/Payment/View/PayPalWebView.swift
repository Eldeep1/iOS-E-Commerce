//
//  PayPalWebView.swift
//  Buyza App
//

import SwiftUI
import WebKit

struct PayPalWebView: UIViewRepresentable {
    let url: URL
    let onResult: (Bool, String?) -> Void
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
        var parent: PayPalWebView

        init(_ parent: PayPalWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            let urlString = url.absoluteString.lowercased()
            print("PayPalWebView Navigating to: \(urlString)")

           
            if urlString.contains("buyza.com/callback") {
                if let components = URLComponents(string: url.absoluteString),
                   let token = components.queryItems?.first(where: { $0.name == "token" })?.value {
                    
                    if urlString.contains("success=true") {
                        print("PayPalWebView: SUCCESS DETECTED!")
                        parent.onResult(true, token)
                    } else {
                        print("PayPalWebView: FAILURE DETECTED!")
                        parent.onResult(false, token)
                    }
                } else {
                    // Fallback
                    if urlString.contains("success=true") {
                        parent.onResult(true, nil)
                    } else {
                        parent.onResult(false, nil)
                    }
                }
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }
    }
}
