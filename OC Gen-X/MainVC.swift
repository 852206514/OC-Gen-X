import Cocoa

class MainVC: NSViewController {
    
    @IBOutlet weak var generateButton: NSButton!
    @IBOutlet weak var ivyBridgeChecked: NSButton!
    @IBOutlet weak var haswellChecked: NSButton!
    @IBOutlet weak var skylakeChecked: NSButton!
    @IBOutlet weak var kabylakeChecked: NSButton!
    @IBOutlet weak var haswellEChecked: NSButton!
    @IBOutlet weak var broadwellEChecked: NSButton!
    @IBOutlet weak var ryzenChecked: NSButton!
    @IBOutlet weak var coffeelakeChecked: NSButton!
    @IBOutlet weak var liluChecked: NSButton!
    @IBOutlet weak var virtualSMCChecked: NSButton!
    @IBOutlet weak var smcProcessorChecked: NSButton!
    @IBOutlet weak var smcSuperIOChecked: NSButton!
    @IBOutlet weak var smcLightSensorChecked: NSButton!
    @IBOutlet weak var smcBatteryManagerChecked: NSButton!
    @IBOutlet weak var whatevergreenChecked: NSButton!
    @IBOutlet weak var appleALCChecked: NSButton!
    @IBOutlet weak var intelMausiChecked: NSButton!
    @IBOutlet weak var smallTreeChecked: NSButton!
    @IBOutlet weak var atherosChecked: NSButton!
    @IBOutlet weak var realTekChecked: NSButton!
    @IBOutlet weak var usbInjectAllChecked: NSButton!
    @IBOutlet weak var airportBrcmChecked: NSButton!
    @IBOutlet weak var appleMCEReporterChecked: NSButton!
    @IBOutlet weak var openRuntimeChecked: NSButton!
    @IBOutlet weak var openUSBChecked: NSButton!
    @IBOutlet weak var nvmExpressChecked: NSButton!
    @IBOutlet weak var xhciChecked: NSButton!
    @IBOutlet weak var textfield: HyperlinkTextField!
    @IBOutlet weak var hfsPlusChecked: NSButton!
    @IBOutlet weak var snInput: NSTextField!
    @IBOutlet weak var mlbInput: NSTextField!
    @IBOutlet weak var smuuidInput: NSTextField!
    @IBOutlet weak var modelInput: NSTextField!
    @IBOutlet weak var wegLabel: NSTextField!
    @IBOutlet weak var wegBootargsTextfield: NSTextField!
    @IBOutlet weak var appleALCBootargs: NSTextField!
    @IBOutlet weak var appleALCInputfield: NSTextField!
    @IBOutlet weak var bootargsLabel: NSTextField!
    @IBOutlet weak var bootargsInputfield: NSTextField!
    @IBOutlet weak var lucyRTLChecked: NSButton!
    @IBOutlet weak var brcmPatchRam3Checked: NSButton!
    @IBOutlet weak var brcmPatchRam2Checked: NSButton!
    @IBOutlet weak var brcmBtInjectorChecked: NSButton!
    @IBOutlet weak var brcmFirmwareDataChecked: NSButton!
    @IBOutlet weak var cometLakeChecked: NSButton!
    @IBOutlet weak var casecadeChecked: NSButton!
    @IBOutlet weak var proxintoshChecked: NSButton!
    @IBOutlet weak var threadripperChecked: NSButton!
    var ryzenPatches = [kPatch]()
    var threadripperPatches = [kPatch]()
    var config = Root(
        acpi: acpi(add: [acpiAdd()], delete: [acpiDelete()], patch: [acpiPatch()], quirks: acpuQuirks()),
                      
        booter: booter(mmioWhitelist: [mmioWhitelist()], quirks: booterQuirks()),
        
        deviceProperties: deviceProperties(add: dpAdd(), delete: dpDelete()),
                    
        kernel: kernel(kAdd: [kAdd()], kBlock: [kBlock()], emulate: emulate(), force: [force()], kPatch: [kPatch()], kQuirks: kQuirks(), scheme: scheme()),
                    
        misc: misc(blessOverRide: [blessOverRide()], boot: boot(), debug: debug(), entries: [entries()], security: security(), tools: [tools()]),
                    
        nvram: nvram(add: nAdd(addAppleVendorVariableGuid: addAppleVendorVariableGuid(), addAppleVendorGuid: addAppleVendorGuid(), addAppleBootVariableGuid: addAppleBootVariableGuid()), delete: nDelete(), legacySchema: legacySchema()),
                    
        platFormInfo: platFormInfo(generic: generic()),
                    
        uefi: uefi(apfs: apfs(), audio: audio(), input: input(), output: output(), protocols: protocols(), quirks: uQuirks(), reservedMemory: [reservedMemory()])
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateButton.isEnabled = false
        applyDesktopGuideHyperlink()
        let ryzenUrlString = "https://raw.githubusercontent.com/Pavo-IM/trx40_amd_macos/master/EFI/OC/ryzen_17h_sample.plist"
        if let url = URL(string: ryzenUrlString) {
            if let data = try? Data(contentsOf: url) {
                ryzenParse(plist: data)
            }
        }
        let threadripperUrlString = "https://raw.githubusercontent.com/Pavo-IM/trx40_amd_macos/master/EFI/OC/threadripper_Gen3_sample.plist"
        if let url = URL(string: threadripperUrlString) {
            if let data = try? Data(contentsOf: url) {
                threadripperParse(plist: data)
            }
        }
    }
    
    func ryzenParse(plist: Data) {
        let decoder = PropertyListDecoder()
        if let plist = try? decoder.decode(Root.self, from: plist) {
            ryzenPatches = plist.kernel.kPatch
        }
    }
    
    func threadripperParse(plist: Data) {
        let decoder = PropertyListDecoder()
        if let plist = try? decoder.decode(Root.self, from: plist) {
            threadripperPatches = plist.kernel.kPatch
        }
    }
    
    private func applyDesktopGuideHyperlink() {
        // Keep it centered
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle : paragraphStyle, .font: textfield.font ?? NSFont.systemFontSize]
        
        guard let url = NSURL(string: "https://dortania.github.io/OpenCore-Install-Guide/") else { return }
        textfield.setHyperlinkWithTitle(title: "https://dortania.github.io/OpenCore-Install-Guide/", URL: url, additionalAttributes: attributes)
    }
    
    @IBAction func systemTypeChecked(_ sender: NSButton) {
        generateButton.isEnabled = (sender.isEnabled == true)
    }
    
    @IBAction func brcmPatchRam3Clicked(_ sender: NSButton) {
        switch brcmPatchRam3Checked.state {
        case .on:
            brcmBtInjectorChecked.state = NSControl.StateValue.on
            brcmPatchRam2Checked.isEnabled = (sender.isEnabled == false)
        default:
            brcmBtInjectorChecked.state = NSControl.StateValue.off
            brcmPatchRam2Checked.isEnabled = (sender.isEnabled == true)
        }
    }
    
    @IBAction func brcmpatchram2Clicked(_ sender: NSButton) {
        switch brcmPatchRam2Checked.state {
        case .on:
            brcmPatchRam3Checked.isEnabled = (sender.isEnabled == false)
            brcmPatchRam3Checked.state = NSControl.StateValue.off
        default:
            brcmPatchRam3Checked.isEnabled = (sender.isEnabled == true)
        }
    }
    
    
    @IBAction func appleALCClicked(_ sender: NSButton) {
        switch appleALCChecked.state {
        case .on:
            appleALCBootargs.isHidden = (sender.isHidden == true)
            appleALCInputfield.isHidden = (sender.isHidden == true)
        case .off:
            appleALCBootargs.isHidden = (sender.isHidden == false)
            appleALCInputfield.isHidden = (sender.isHidden == false)
        default:
            appleALCBootargs.isHidden = (sender.isHidden == false)
            appleALCInputfield.isHidden = (sender.isHidden == false)
        }
    }
    
    @IBAction func whatevergreenClicked(_ sender: NSButton) {
        switch whatevergreenChecked.state {
        case .on:
            wegLabel.isHidden = (sender.isHidden == true)
            wegBootargsTextfield.isHidden = (sender.isHidden == true)
        case .off:
            wegLabel.isHidden = (sender.isHidden == false)
            wegBootargsTextfield.isHidden = (sender.isHidden == false)
        default:
            wegLabel.isHidden = (sender.isHidden == false)
            wegBootargsTextfield.isHidden = (sender.isHidden == false)
        }
        
    }
    
    
    func kextCopy (kextname: String, item: String, location: URL) {
        let bundle = Bundle.main
        let fm = FileManager.default
        let kextname = bundle.path(forResource: "\(item)", ofType: ".kext")
        let kextnameURL = URL(fileURLWithPath: kextname!)
        let kextnameDir = "\(item).kext"
        do {
            try fm.copyItem(at: kextnameURL, to: location.appendingPathComponent(kextnameDir))
        }
        catch {
        }
    }
    
    func driverCopy (drivername: String, item: String, location: URL) {
        let bundle = Bundle.main
        let fm = FileManager.default
        let drivername = bundle.path(forResource: "\(item)", ofType: ".efi")
        let drivernameURL = URL(fileURLWithPath: drivername!)
        let drivernameDir = "\(item).efi"
        do {
            try fm.copyItem(at: drivernameURL, to: location.appendingPathComponent(drivernameDir))
        }
        catch {
        }
    }
    
    func efiCopy (efiname: String, item: String, location: URL) {
        let bundle = Bundle.main
        let fm = FileManager.default
        let efiname = bundle.path(forResource: "\(item)", ofType: ".efi")
        let efinameURL = URL(fileURLWithPath: efiname!)
        let efinameDir = "\(item).efi"
        do {
            try fm.copyItem(at: efinameURL, to: location.appendingPathComponent(efinameDir))
        }
        catch {
        }
    }
    
    func saveAlert () {
        let fileManager = FileManager.default
        let home = fileManager.homeDirectoryForCurrentUser
        let kextPath = "Desktop/EFI"
        let kextUrl = home.appendingPathComponent(kextPath)
        let alert = NSAlert()
        alert.messageText = "EFI Generation Complete!"
        alert.informativeText = "The EFI has been generated and saved to \(kextUrl.path)"
        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
    }
    
    func existAlert () {
        let fileManager = FileManager.default
        let home = fileManager.homeDirectoryForCurrentUser
        let kextPath = "Desktop/EFI"
        let kextUrl = home.appendingPathComponent(kextPath)
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Delete")
        alert.addButton(withTitle: "Cancel")
        alert.messageText = "EFI directory already exist!"
        alert.informativeText = "EFI directory already exist at \(kextUrl.path). Click the Delete button to delete the existing directory!"
        alert.beginSheetModal(for: self.view.window!, completionHandler: { (returnCode) -> Void in
            switch returnCode {
            case NSApplication.ModalResponse.alertFirstButtonReturn: do {
                try fileManager.removeItem(at: kextUrl)
            }
            catch {
                print(error.localizedDescription)
                }
            default:
                return
            }
        })
    }
    
    func addKextToConfig (item: String) {
        let kext = kAdd(arch: "x86_64", bundlePath: "\(item).kext", comment: "", enabled: true, executablePath: "Contents/MacOS/\(item)", maxKernel: "", minKernel: "", plistPath: "Contents/Info.plist")
        config.kernel.kAdd.append(kext)
    }
    
    func addKextInjectorToConfig (item: String) {
        let kext = kAdd(arch: "x86_64", bundlePath: "\(item).kext", comment: "", enabled: true, executablePath: "", maxKernel: "", minKernel: "", plistPath: "Contents/Info.plist")
        config.kernel.kAdd.append(kext)
    }
    
    func addKextInjectorPluginToConfig (pluginfor: String, injector: String) {
        let kext = kAdd(arch: "x86_64", bundlePath: "\(pluginfor).kext/Contents/PlugIns/\(injector).kext", comment: "", enabled: true, executablePath: "", maxKernel: "", minKernel: "", plistPath: "Contents/Info.plist")
        config.kernel.kAdd.append(kext)
    }
    
    func addKextPluginToConfig (pluginfor: String, pluginName: String) {
        let kext = kAdd(arch: "x86_64", bundlePath: "\(pluginfor).kext/Contents/PlugIns/\(pluginName).kext", comment: "", enabled: true, executablePath: "Contents/MacOS/\(pluginName)", maxKernel: "", minKernel: "", plistPath: "Contents/Info.plist")
        config.kernel.kAdd.append(kext)
    }
    
    @IBAction func generateClicked(_ sender: NSButton) {
        //TODO: Add UI element with dropdown menu to mount ESP of selected drive.
        //TODO: Add methods to copy items from Bundle to ESP.
        config.acpi.add.removeAll()
        config.acpi.delete.removeAll()
        config.acpi.patch.removeAll()
        config.booter.mmioWhitelist.removeAll()
        config.kernel.kAdd.removeAll()
        config.kernel.kBlock.removeAll()
        config.kernel.force.removeAll()
        config.kernel.kPatch.removeAll()
        config.misc.blessOverRide.removeAll()
        config.misc.entries.removeAll()
        config.misc.tools.removeAll()
        config.uefi.drivers.removeAll()
        config.uefi.reservedMemory.removeAll()
        
        switch ivyBridgeChecked.state {
        case .on:
            config.booter.quirks.rebuildAppleMemoryMap = true
            config.kernel.kQuirks.appleCpuPmCfgLock = true
            config.kernel.kQuirks.appleXcpmCfgLock = true
            config.kernel.kQuirks.disableIoMapper = true
            config.kernel.kQuirks.panicNoKextDump = true
            config.kernel.kQuirks.powerTimeoutKernelPanic = true
            config.kernel.kQuirks.xhciPortLimit = true
            config.misc.debug.appleDebug = true
            config.misc.debug.applePanic = true
            config.misc.debug.disableWatchDog = true
            config.misc.security.allowNvramReset = true
            config.misc.security.allowSetDefault = true
            config.nvram.add.addAppleVendorVariableGuid.defaultBackgroundColor = Data([0x00, 0x00, 0x00, 0x00])
            config.nvram.add.addAppleVendorVariableGuid.uiScale = Data([0x01])
            config.nvram.add.addAppleBootVariableGuid.bootArgs.removeAll()
            config.uefi.quirks.ignoreInvalidFlexRatio = true
        default:
            break
        }
        
        switch haswellChecked.state {
        case .on:
            config.booter.quirks.rebuildAppleMemoryMap = true
            config.kernel.kQuirks.appleCpuPmCfgLock = true
            config.kernel.kQuirks.appleXcpmCfgLock = true
            config.kernel.kQuirks.disableIoMapper = true
            config.kernel.kQuirks.panicNoKextDump = true
            config.kernel.kQuirks.powerTimeoutKernelPanic = true
            config.kernel.kQuirks.xhciPortLimit = true
            config.misc.debug.appleDebug = true
            config.misc.debug.applePanic = true
            config.misc.debug.disableWatchDog = true
            config.misc.security.allowNvramReset = true
            config.misc.security.allowSetDefault = true
            config.nvram.add.addAppleVendorVariableGuid.defaultBackgroundColor = Data([0x00, 0x00, 0x00, 0x00])
            config.nvram.add.addAppleVendorVariableGuid.uiScale = Data([0x01])
            config.uefi.quirks.ignoreInvalidFlexRatio = true
        default:
            break
        }
        
        switch skylakeChecked.state {
        case .on:
            config.booter.quirks.rebuildAppleMemoryMap = true
            config.booter.quirks.syncRuntimePermissions = true
            config.kernel.kQuirks.appleCpuPmCfgLock = true
            config.kernel.kQuirks.appleXcpmCfgLock = true
            config.kernel.kQuirks.disableIoMapper = true
            config.kernel.kQuirks.panicNoKextDump = true
            config.kernel.kQuirks.powerTimeoutKernelPanic = true
            config.kernel.kQuirks.xhciPortLimit = true
            config.misc.debug.appleDebug = true
            config.misc.debug.applePanic = true
            config.misc.debug.disableWatchDog = true
            config.misc.security.allowNvramReset = true
            config.misc.security.allowSetDefault = true
            config.nvram.add.addAppleVendorVariableGuid.defaultBackgroundColor = Data([0x00, 0x00, 0x00, 0x00])
            config.nvram.add.addAppleVendorVariableGuid.uiScale = Data([0x01])
        default:
            break
        }
        
        switch kabylakeChecked.state {
        case .on:
            config.booter.quirks.enableWriteUnprotector = true
            config.kernel.kQuirks.appleCpuPmCfgLock = true
            config.kernel.kQuirks.appleXcpmCfgLock = true
            config.kernel.kQuirks.disableIoMapper = true
            config.kernel.kQuirks.panicNoKextDump = true
            config.kernel.kQuirks.powerTimeoutKernelPanic = true
            config.kernel.kQuirks.xhciPortLimit = true
            config.misc.debug.appleDebug = true
            config.misc.debug.applePanic = true
            config.misc.debug.disableWatchDog = true
            config.misc.security.allowNvramReset = true
            config.misc.security.allowSetDefault = true
            config.nvram.add.addAppleVendorVariableGuid.defaultBackgroundColor = Data([0x00, 0x00, 0x00, 0x00])
            config.nvram.add.addAppleVendorVariableGuid.uiScale = Data([0x01])
        default:
            break
        }
        
        switch coffeelakeChecked.state {
        case .on:
            config.booter.quirks.devirtualiseMmio = true
            config.booter.quirks.rebuildAppleMemoryMap = true
            config.booter.quirks.syncRuntimePermissions = true
            config.kernel.kQuirks.appleCpuPmCfgLock = true
            config.kernel.kQuirks.appleXcpmCfgLock = true
            config.kernel.kQuirks.disableIoMapper = true
            config.kernel.kQuirks.panicNoKextDump = true
            config.kernel.kQuirks.powerTimeoutKernelPanic = true
            config.kernel.kQuirks.xhciPortLimit = true
            config.misc.debug.appleDebug = true
            config.misc.debug.applePanic = true
            config.misc.debug.disableWatchDog = true
            config.misc.security.allowNvramReset = true
            config.misc.security.allowSetDefault = true
            config.nvram.add.addAppleVendorVariableGuid.defaultBackgroundColor = Data([0x00, 0x00, 0x00, 0x00])
            config.nvram.add.addAppleVendorVariableGuid.uiScale = Data([0x01])
        default:
            break
        }
        
        switch cometLakeChecked.state {
        case .on:
            config.booter.quirks.avoidRuntimeDefrag = true
            config.booter.quirks.devirtualiseMmio = true
            config.booter.quirks.protectUefiServices = true
            config.booter.quirks.provideCustomSlide = true
            config.booter.quirks.rebuildAppleMemoryMap = true
            config.booter.quirks.setupVirtualMap = true
            config.booter.quirks.syncRuntimePermissions = true
            config.kernel.kQuirks.appleCpuPmCfgLock = true
            config.kernel.kQuirks.appleXcpmCfgLock = true
            config.kernel.kQuirks.disableIoMapper = true
            config.kernel.kQuirks.panicNoKextDump = true
            config.kernel.kQuirks.powerTimeoutKernelPanic = true
            config.kernel.kQuirks.xhciPortLimit = true
            config.misc.debug.appleDebug = true
            config.misc.debug.applePanic = true
            config.misc.debug.disableWatchDog = true
            config.misc.security.allowNvramReset = true
            config.misc.security.allowSetDefault = true
            config.nvram.add.addAppleVendorVariableGuid.defaultBackgroundColor = Data([0x00, 0x00, 0x00, 0x00])
            config.nvram.add.addAppleVendorVariableGuid.uiScale = Data([0x01])
        default:
            break
        }
        
        switch haswellEChecked.state {
        case .on:
            config.booter.quirks.devirtualiseMmio = true
            config.booter.quirks.disableVariableWrite = true
            config.booter.quirks.rebuildAppleMemoryMap = true
            config.kernel.kQuirks.appleCpuPmCfgLock = true
            config.kernel.kQuirks.appleXcpmCfgLock = true
            config.kernel.kQuirks.appleXcpmExtraMsrs = true
            config.kernel.kQuirks.disableIoMapper = true
            config.kernel.kQuirks.panicNoKextDump = true
            config.kernel.kQuirks.powerTimeoutKernelPanic = true
            config.kernel.kQuirks.xhciPortLimit = true
            config.misc.debug.appleDebug = true
            config.misc.debug.applePanic = true
            config.misc.debug.disableWatchDog = true
            config.misc.security.allowNvramReset = true
            config.misc.security.allowSetDefault = true
            config.nvram.add.addAppleVendorVariableGuid.defaultBackgroundColor = Data([0x00, 0x00, 0x00, 0x00])
            config.nvram.add.addAppleVendorVariableGuid.uiScale = Data([0x01])
            config.uefi.quirks.ignoreInvalidFlexRatio = true
        default:
            break
        }
        
        switch broadwellEChecked.state {
        case .on:
            config.booter.quirks.devirtualiseMmio = true
            config.booter.quirks.disableVariableWrite = true
            config.booter.quirks.rebuildAppleMemoryMap = true
            config.kernel.kQuirks.appleCpuPmCfgLock = true
            config.kernel.kQuirks.appleXcpmCfgLock = true
            config.kernel.kQuirks.appleXcpmExtraMsrs = true
            config.kernel.kQuirks.disableIoMapper = true
            config.kernel.kQuirks.panicNoKextDump = true
            config.kernel.kQuirks.powerTimeoutKernelPanic = true
            config.kernel.kQuirks.xhciPortLimit = true
            config.misc.debug.appleDebug = true
            config.misc.debug.applePanic = true
            config.misc.debug.disableWatchDog = true
            config.misc.security.allowNvramReset = true
            config.misc.security.allowSetDefault = true
            config.nvram.add.addAppleVendorVariableGuid.defaultBackgroundColor = Data([0x00, 0x00, 0x00, 0x00])
            config.nvram.add.addAppleVendorVariableGuid.uiScale = Data([0x01])
            config.uefi.quirks.ignoreInvalidFlexRatio = true
        default:
            break
        }
        
        switch casecadeChecked.state {
        case .on:
            config.booter.quirks.avoidRuntimeDefrag = true
            config.booter.quirks.devirtualiseMmio = true
            config.booter.quirks.provideCustomSlide = true
            config.booter.quirks.rebuildAppleMemoryMap = true
            config.booter.quirks.setupVirtualMap = true
            config.booter.quirks.syncRuntimePermissions = true
            config.kernel.kQuirks.appleCpuPmCfgLock = true
            config.kernel.kQuirks.appleXcpmCfgLock = true
            config.kernel.kQuirks.disableIoMapper = true
            config.kernel.kQuirks.panicNoKextDump = true
            config.kernel.kQuirks.powerTimeoutKernelPanic = true
            config.kernel.kQuirks.xhciPortLimit = true
            config.misc.debug.appleDebug = true
            config.misc.debug.applePanic = true
            config.misc.debug.disableWatchDog = true
            config.misc.security.allowNvramReset = true
            config.misc.security.allowSetDefault = true
            config.nvram.add.addAppleVendorVariableGuid.defaultBackgroundColor = Data([0x00, 0x00, 0x00, 0x00])
            config.nvram.add.addAppleVendorVariableGuid.uiScale = Data([0x01])
        default:
            break
        }
        
        switch ryzenChecked.state {
        case .on:
            config.booter.quirks.enableSafeModeSlide = true
            config.booter.quirks.provideCustomSlide = true
            config.booter.quirks.rebuildAppleMemoryMap = true
            config.booter.quirks.syncRuntimePermissions = true
            for i in ryzenPatches {
                config.kernel.kPatch.append(i)
            }
            config.kernel.kQuirks.panicNoKextDump = true
            config.kernel.kQuirks.powerTimeoutKernelPanic = true
            config.kernel.kQuirks.xhciPortLimit = true
            config.misc.debug.applePanic = true
            config.misc.debug.disableWatchDog = true
            config.misc.security.allowNvramReset = true
            config.misc.security.allowSetDefault = true
            config.nvram.add.addAppleVendorVariableGuid.defaultBackgroundColor = Data([0x00, 0x00, 0x00, 0x00])
            config.nvram.add.addAppleVendorVariableGuid.uiScale = Data([0x01])
            config.nvram.add.addAppleBootVariableGuid.bootArgs = "npci=0x2000"
            config.platFormInfo.generic.systemProductName = "iMacPro1,1"
        default:
            break
        }
        
        switch proxintoshChecked.state {
        case .on:
            config.booter.quirks.avoidRuntimeDefrag = true
            config.kernel.emulate.cpuid1Data = Data([0xEC,0x06,0x09,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00])
            config.kernel.emulate.cpuid1Mask = Data([0xFF,0xFF,0xFF,0xFF, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00])
            config.kernel.kPatch.append(secondRyzenPatch)
            config.kernel.kPatch.append(twelfthRyzenPatch)
            config.kernel.kQuirks.panicNoKextDump = true
            config.kernel.kQuirks.powerTimeoutKernelPanic = true
            config.misc.debug.appleDebug = true
            config.misc.debug.applePanic = true
            config.misc.debug.disableWatchDog = true
            config.misc.security.allowNvramReset = true
            config.misc.security.allowSetDefault = true
            config.nvram.add.addAppleVendorVariableGuid.defaultBackgroundColor = Data([0x00, 0x00, 0x00, 0x00])
            config.nvram.add.addAppleVendorVariableGuid.uiScale = Data([0x01])
            config.platFormInfo.generic.systemProductName = "iMacPro1,1"
        default:
            break
        }
        
        switch threadripperChecked.state {
        case .on:
            config.booter.quirks.avoidRuntimeDefrag = true
            config.booter.quirks.devirtualiseMmio = true
            config.booter.quirks.enableSafeModeSlide = true
            config.booter.quirks.provideCustomSlide = true
            config.booter.quirks.rebuildAppleMemoryMap = true
            config.booter.quirks.syncRuntimePermissions = true
            for i in threadripperPatches {
                config.kernel.kPatch.append(i)
            }
            config.kernel.kQuirks.panicNoKextDump = true
            config.kernel.kQuirks.powerTimeoutKernelPanic = true
            config.misc.debug.appleDebug = true
            config.misc.debug.applePanic = true
            config.misc.debug.disableWatchDog = true
            config.misc.security.allowNvramReset = true
            config.misc.security.allowSetDefault = true
            config.nvram.add.addAppleVendorVariableGuid.defaultBackgroundColor = Data([0x00, 0x00, 0x00, 0x00])
            config.nvram.add.addAppleVendorVariableGuid.uiScale = Data([0x01])
            config.platFormInfo.generic.systemProductName = "iMacPro1,1"
        default:
            break
        }
        
        switch liluChecked.state {
        case .on:
            let liluAdd = kAdd(bundlePath: "Lilu.kext", comment: "", enabled: true, executablePath: "Contents/MacOS/Lilu", maxKernel: "", minKernel: "", plistPath: "Contents/Info.plist")
            config.kernel.kAdd.append(liluAdd)
        default:
            break
        }
        
        switch virtualSMCChecked.state {
        case .on:
            addKextToConfig(item: "VirtualSMC")
        default:
            break
        }
        
        switch smcProcessorChecked.state {
        case .on:
            addKextToConfig(item: "SMCProcessor")
        default:
            break
        }
        
        switch smcSuperIOChecked.state {
        case .on:
            addKextToConfig(item: "SMCSuperIO")
        default:
            break
        }
        
        switch smcLightSensorChecked.state {
        case .on:
            addKextToConfig(item: "SMCLightSensor")
        default:
            break
        }
        
        switch smcBatteryManagerChecked.state {
        case .on:
            addKextToConfig(item: "SMCBatteryManager")
        default:
            break
        }
        
        switch whatevergreenChecked.state {
        case .on:
            addKextToConfig(item: "WhateverGreen")
            config.nvram.add.addAppleBootVariableGuid.bootArgs.append(contentsOf: " " + wegBootargsTextfield.stringValue)
        default:
            break
        }
        
        switch appleALCChecked.state {
        case .on:
            addKextToConfig(item: "AppleALC")
            config.nvram.add.addAppleBootVariableGuid.bootArgs.append(contentsOf: " " + appleALCInputfield.stringValue)
        default:
            break
        }
        
        switch smallTreeChecked.state {
        case .on:
            addKextToConfig(item: "SmallTreeIntel82576")
        default:
            break
        }
        
        switch atherosChecked.state {
        case .on:
            addKextToConfig(item: "AtherosE2200Ethernet")
        default:
            break
        }
        
        switch realTekChecked.state {
        case .on:
            addKextToConfig(item: "RealtekRTL8111")
        default:
            break
        }
        
        switch intelMausiChecked.state {
        case .on:
            addKextToConfig(item: "IntelMausi")
        default:
            break
        }
        
        switch lucyRTLChecked.state {
        case .on:
            addKextToConfig(item: "LucyRTL8125Ethernet")
        default:
            break
        }
        
        switch usbInjectAllChecked.state {
        case .on:
            addKextToConfig(item: "USBInjectAll")
        default:
            break
        }
        
        switch airportBrcmChecked.state {
        case .on:
            addKextInjectorPluginToConfig(pluginfor: "AirportBrcmFixup", injector: "AirPortBrcmNIC_Injector")
            addKextToConfig(item: "AirportBrcmFixup")
        default:
            break
        }
        
        switch brcmBtInjectorChecked.state {
        case .on:
            addKextInjectorToConfig(item: "BrcmBluetoothInjector")
        default:
            break
        }
        
        switch brcmFirmwareDataChecked.state {
        case .on:
            addKextToConfig(item: "BrcmFirmwareData")
        default:
            break
        }
        
        switch brcmPatchRam3Checked.state {
        case .on:
            addKextToConfig(item: "BrcmPatchRAM3")
        default:
            break
        }
        
        switch brcmPatchRam2Checked.state {
        case .on:
            addKextToConfig(item: "BrcmPatchRAM2")
        default:
            break
        }
        
        switch appleMCEReporterChecked.state {
        case .on:
            addKextInjectorToConfig(item: "AppleMCEReporterDisabler")
        default:
            break
        }
        
        switch openRuntimeChecked.state {
        case .on:
            config.uefi.drivers.append("OpenRuntime.efi")
        default:
            break
        }
        
        switch hfsPlusChecked.state {
        case .on:
            config.uefi.drivers.append("HfsPlus.efi")
        default:
            break
        }
        
        switch openUSBChecked.state {
        case .on:
            config.uefi.drivers.append("OpenUsbKbDxe.efi")
        default:
            break
        }
        
        switch nvmExpressChecked.state {
        case .on:
            config.uefi.drivers.append("NvmExpressDxe.efi")
        default:
            break
        }
        
        switch xhciChecked.state {
        case .on:
            config.uefi.drivers.append("XhciDxe.efi")
        default:
            break
        }
        
        let efidirName = "Desktop/EFI"
        let fm = FileManager.default
        let destDirURL = fm.homeDirectoryForCurrentUser
        let deskDirString: String = destDirURL.appendingPathComponent(efidirName).path
        if fm.fileExists(atPath: deskDirString) {
            existAlert()
        } else {
            do {
                try fm.createDirectory(at: destDirURL.appendingPathComponent(efidirName), withIntermediateDirectories: false, attributes: nil)
                let newdestDir = URL(fileURLWithPath: deskDirString)
                let ocBootDir = newdestDir.appendingPathComponent("BOOT")
                let ocDir = newdestDir.appendingPathComponent("OC")
                try fm.createDirectory(at: ocBootDir, withIntermediateDirectories: false, attributes: nil)
                try fm.createDirectory(at: ocDir, withIntermediateDirectories: false, attributes: nil)
                let ocACPIDir = ocDir.appendingPathComponent("ACPI")
                let ocBootstrapDir = ocDir.appendingPathComponent("Bootstrap")
                let ocDriversDir = ocDir.appendingPathComponent("Drivers")
                let ocKextsDir = ocDir.appendingPathComponent("Kexts")
                let ocResourcesDir = ocDir.appendingPathComponent("Resources")
                let ocToolsDir = ocDir.appendingPathComponent("Tools")
                try fm.createDirectory(at: ocACPIDir, withIntermediateDirectories: false, attributes: nil)
                try fm.createDirectory(at: ocBootstrapDir, withIntermediateDirectories: false, attributes: nil)
                try fm.createDirectory(at: ocDriversDir, withIntermediateDirectories: false, attributes: nil)
                try fm.createDirectory(at: ocKextsDir, withIntermediateDirectories: false, attributes: nil)
                try fm.createDirectory(at: ocResourcesDir, withIntermediateDirectories: false, attributes: nil)
                try fm.createDirectory(at: ocToolsDir, withIntermediateDirectories: false, attributes: nil)
                efiCopy(efiname: "opencore", item: "OpenCore", location: ocDir)
                efiCopy(efiname: "bootefi", item: "BOOTx64", location: ocBootDir)
                efiCopy(efiname: "bootstrap", item: "Bootstrap", location: ocBootstrapDir)
                if (bootargsInputfield != nil) {
                    config.nvram.add.addAppleBootVariableGuid.bootArgs.append(contentsOf: " " + bootargsInputfield.stringValue)
                }
                if (modelInput != nil) {
                    config.platFormInfo.generic.systemProductName = modelInput.stringValue
                }
                
                if (snInput != nil) {
                    config.platFormInfo.generic.systemSerialNumber = snInput.stringValue
                }
                
                if (mlbInput != nil) {
                    config.platFormInfo.generic.mlb = mlbInput.stringValue
                }
                
                if (smuuidInput != nil) {
                    config.platFormInfo.generic.systemUUID = smuuidInput.stringValue
                }
                
                if liluChecked.state == .on {
                    kextCopy(kextname: "lilu", item: "Lilu", location: ocKextsDir)
                }
                if virtualSMCChecked.state == .on {
                    kextCopy(kextname: "virtualsmc", item: "VirtualSMC", location: ocKextsDir)
                }
                if smcProcessorChecked.state == .on {
                    kextCopy(kextname: "smcprocessor", item: "SMCProcessor", location: ocKextsDir)
                }
                if smcSuperIOChecked.state == .on {
                    kextCopy(kextname: "smcSuperIO", item: "SMCSuperIO", location: ocKextsDir)
                }
                if smcLightSensorChecked.state == .on {
                    kextCopy(kextname: "smcLightSensor", item: "SMCLightSensor", location: ocKextsDir)
                }
                if smcBatteryManagerChecked.state == .on {
                    kextCopy(kextname: "SMCBatteryManager", item: "SMCBatteryManager", location: ocKextsDir)
                }
                if whatevergreenChecked.state == .on {
                    kextCopy(kextname: "whatevergreen", item: "WhateverGreen", location: ocKextsDir)
                }
                if appleALCChecked.state == .on {
                    kextCopy(kextname: "appleALC", item: "AppleALC", location: ocKextsDir)
                }
                if smallTreeChecked.state == .on {
                    kextCopy(kextname: "smallTree", item: "SmallTreeIntel82576", location: ocKextsDir)
                }
                if atherosChecked.state == .on {
                    kextCopy(kextname: "atheros", item: "AtherosE2200Ethernet", location: ocKextsDir)
                }
                if realTekChecked.state == .on {
                    kextCopy(kextname: "realTek", item: "RealtekRTL8111", location: ocKextsDir)
                }
                if intelMausiChecked.state == .on {
                    kextCopy(kextname: "IntelMausi", item: "IntelMausi", location: ocKextsDir)
                }
                if lucyRTLChecked.state == .on {
                    kextCopy(kextname: "LucyRTL8125Ethernet", item: "LucyRTL8125Ethernet", location: ocKextsDir)
                }
                if usbInjectAllChecked.state == .on {
                    kextCopy(kextname: "usbInjectAll", item: "USBInjectAll", location: ocKextsDir)
                }
                if airportBrcmChecked.state == .on {
                    kextCopy(kextname: "airportBrcm", item: "AirportBrcmFixup", location: ocKextsDir)
                }
                if brcmPatchRam2Checked.state == .on {
                    kextCopy(kextname: "brcmpatchram2", item: "BrcmPatchRAM2", location: ocKextsDir)
                }
                if brcmFirmwareDataChecked.state == .on {
                    kextCopy(kextname: "BrcmFirmwareData", item: "BrcmFirmwareData", location: ocKextsDir)
                }
                if brcmBtInjectorChecked.state == .on {
                    kextCopy(kextname: "BrcmBluetoothInjector", item: "BrcmBluetoothInjector", location: ocKextsDir)
                }
                if brcmPatchRam3Checked.state == .on {
                    kextCopy(kextname: "BrcmPatchRAM3", item: "BrcmPatchRAM3", location: ocKextsDir)
                }
                if appleMCEReporterChecked.state == .on {
                    kextCopy(kextname: "appleMCEReporter", item: "AppleMCEReporterDisabler", location: ocKextsDir)
                }
                if openRuntimeChecked.state == .on {
                    driverCopy(drivername: "openRuntime", item: "OpenRuntime", location: ocDriversDir)
                }
                if hfsPlusChecked.state == .on {
                    driverCopy(drivername: "hfsPlus", item: "HfsPlus", location: ocDriversDir)
                }
                if openUSBChecked.state == .on {
                    driverCopy(drivername: "openUSB", item: "OpenUsbKbDxe", location: ocDriversDir)
                }
                if nvmExpressChecked.state == .on {
                    driverCopy(drivername: "nvmExpress", item: "NvmExpressDxe", location: ocDriversDir)
                }
                if xhciChecked.state == .on {
                    driverCopy(drivername: "xhci", item: "XhciDxe", location: ocDriversDir)
                }
                do {
                    let plistEncoder = PropertyListEncoder()
                    plistEncoder.outputFormat = .xml
                    let configFilePath =  ocDir.appendingPathComponent("config.plist")
                    let configToEncode = config
                    let data = try plistEncoder.encode(configToEncode)
                    try data.write(to: configFilePath)
                    config.uefi.drivers.removeAll()
                    config.kernel.kAdd.removeAll()
                    config.kernel.kPatch.removeAll()
                    saveAlert()
                }
                catch {
                }
            }
            catch {
            }
        }
    }
}
