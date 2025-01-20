//
//  DeviceUtil.swift
//  Ruguo
//
//  Created by Jason Yu on 8/30/16.
//  Copyright © 2016 若友网络科技有限公司. All rights reserved.
//

import Foundation

public extension OperatingSystemVersion {
    var stringForHeader: String {
        [ProcessInfo.processInfo.operatingSystemVersion.majorVersion,
         ProcessInfo.processInfo.operatingSystemVersion.minorVersion,
         ProcessInfo.processInfo.operatingSystemVersion.patchVersion].map { "\($0)" }.joined(separator: ".")
    }
}

public class AppInfoUtil {
    public enum AppConfiguration {
        case debug
        case testFlight
        case appStore
    }

    public static var appConfiguration: AppConfiguration {
#if DEBUG
        return .debug
#else
        if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
            return .testFlight
        } else {
            return .appStore
        }
#endif
    }

    public class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    public class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    }

    public class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()

        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }

    public class var modelName: String {
        var sysinfo = utsname()
        uname(&sysinfo)

        let modelCode = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?.trimmingCharacters(in: .controlCharacters)

        return modelCode ?? ""
    }

    public class var newModelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

// Simulators
#if targetEnvironment(simulator)
        if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simModelCode
        }
#endif

        return identifier
    }

    private init() {}
}
