import Flutter
import UIKit
import ComScore

public class FlutterComscorePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_comscore", binaryMessenger: registrar.messenger())
        let instance = FlutterComscorePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setup":
            guard let args = call.arguments as? String else {
                result("Empty arguments")
                return
            }
            
            do {
                try startComscore(args: JSONDecoder().decode(StartComscoreArgs.self, from: Data(args.utf8)))
            } catch {
                result("Error starting comscore: \(error)")
                return
            }
            
            result(nil)
        case "notifyViewEvent":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startComscore(args: StartComscoreArgs) throws {
        let infoDict = Bundle.main.infoDictionary
        guard let infoDict, let pubId = infoDict["FLUTTER_COMSCORE_PUBLISHER_ID"] as? String else {
            throw ComscoreError.pubIdNotFound
        }
        
        let myPublisherConfig = SCORPublisherConfiguration(builderBlock: { builder in
            builder?.publisherId = pubId
            
            if let userConsent = args.userConsent {
                builder?.persistentLabels = ["cs_ucfr": userConsent]
            }
        })
        
        SCORAnalytics.configuration().addClient(with:myPublisherConfig)
        SCORAnalytics.configuration().usagePropertiesAutoUpdateMode = .foregroundAndBackground
        
        if args.isChildDirected {
            SCORAnalytics.configuration().enableChildDirectedApplicationMode()
        }
        
        if args.debug {
            SCORAnalytics.configuration().enableImplementationValidationMode()
        }
        
        SCORAnalytics.start()
        
    }
    
    enum ComscoreError: Error {
        case pubIdNotFound
    }
}
