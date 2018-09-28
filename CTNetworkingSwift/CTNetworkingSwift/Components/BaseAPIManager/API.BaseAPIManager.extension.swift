//
//  API.BaseAPIManager.extension.swift
//  CTNetworking.Swift
//
//  Created by casa on 2018/9/21.
//

import Foundation

extension CTNetworkingBaseAPIManager {
    @objc public func loadData() {
        guard let methodname = self.child?.methodName() else { return }
        guard let requestType = self.child?.requestType() else { return }
        guard let service = self.child?.service else { return }

        isLoading = true
        
        let params = paramSource?.params(for: self)
        guard let _request = service.request(params: params, methodName: methodname, requestType: requestType) else {
            return
        }
        
        if let _child = child {
            print("\(_request.logString(apiName: _child.methodName(), service: _child.service))")
        }

        service.sessionManager.request(_request).response { (response) in
            self.isLoading = false
            self.response = response
            guard service.handleCommonError(self) else {
                return
            }

            guard response.error != nil else {
                self.success()
                return
            }
            
            self.fail()
        }
    }
}
