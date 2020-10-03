import Foundation

struct nvram: Codable {
    var add: nAdd
    var delete: nDelete
    var legacyEnable: Bool = false
    var legacyOverwrite: Bool = false
    var legacySchema: legacySchema
    var writeFlash: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case add = "Add"
        case delete = "Delete"
        case legacyEnable = "LegacyEnable"
        case legacyOverwrite = "LegacyOverwrite"
        case legacySchema = "LegacySchema"
        case writeFlash = "WriteFlash"
    }
}

struct nAdd: Codable {
    var addAppleVendorVariableGuid: addAppleVendorVariableGuid
    var addAppleVendorGuid: addAppleVendorGuid
    var addAppleBootVariableGuid: addAppleBootVariableGuid
    
    enum CodingKeys: String, CodingKey {
        case addAppleVendorVariableGuid = "4D1EDE05-38C7-4A6A-9CC6-4BCCA8B38C14"
        case addAppleVendorGuid = "4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102"
        case addAppleBootVariableGuid = "7C436110-AB2A-4BBB-A880-FE41995C9F82"
    }
}

struct addAppleVendorVariableGuid: Codable {
    var defaultBackgroundColor: Data
    var uiScale: Data
    
    enum CodingKeys: String, CodingKey {
        case defaultBackgroundColor = "DefaultBackgroundColor"
        case uiScale = "UIScale"
    }
}

struct addAppleVendorGuid: Codable {
    var rtcBlacklist: Data
    
    enum CodingKeys: String, CodingKey {
        case rtcBlacklist = "rtc-blacklist"
    }
}

struct addAppleBootVariableGuid: Codable {
    var systemAudioVolume: Data
    var bootArgs: String
    var csrActiveConfig: Data
    var prevLangKbd: Data
    var runefiupdater: String
    
    enum CodingKeys: String, CodingKey {
        case systemAudioVolume = "SystemAudioVolume"
        case bootArgs = "boot-args"
        case csrActiveConfig = "csr-active-config"
        case prevLangKbd = "prev-lang:kbd"
        case runefiupdater = "run-efi-updater"
    }
}

struct nDelete: Codable {
    var blockAppleVendorVariableGuid: [String]
    var blockAppleVendorGuid: [String]
    var blockAppleBootVariableGuid: [String]
    
    enum CodingKeys: String, CodingKey {
        case blockAppleVendorVariableGuid = "4D1EDE05-38C7-4A6A-9CC6-4BCCA8B38C14"
        case blockAppleVendorGuid = "4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102"
        case blockAppleBootVariableGuid = "7C436110-AB2A-4BBB-A880-FE41995C9F82"
    }
}

struct legacySchema: Codable {
    var legacyAppleBootVariableGuid: [String]
    var legacyEfiGlobalVariable: [String]
    
    enum CodingKeys: String, CodingKey {
        case legacyAppleBootVariableGuid = "7C436110-AB2A-4BBB-A880-FE41995C9F82"
        case legacyEfiGlobalVariable = "8BE4DF61-93CA-11D2-AA0D-00E098032B8C"
    }
}
