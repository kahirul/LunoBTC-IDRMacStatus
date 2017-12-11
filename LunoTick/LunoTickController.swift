import Cocoa

class LunoTickController: NSObject {
  @IBOutlet weak var statusMenu: NSMenu!
  
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  let lunoAPI = LunoAPI()
  var timer = Timer()
  
  var askingPrice = "..."
  var flag: Int = 0
  
  @IBAction func quitClicked(_ sender: NSMenuItem) {
    NSApplication.shared.terminate(self)
  }
  
  override func awakeFromNib() {
    let icon = NSImage(named: NSImage.Name(rawValue: "bitcoinIcon"))
    icon?.isTemplate = true
    statusItem.image = icon
    statusItem.menu = statusMenu
    updateTitle()
    updateTicker()
  
    timer = Timer.scheduledTimer(
      timeInterval: 45,
      target: self,
      selector: (#selector(LunoTickController.updateTicker)),
      userInfo: nil,
      repeats: true)
  }
  
  func updateTitle() {
    flag += 1
    statusItem.title = "\(askingPrice)~\(flag % 5)"
  }
  
  @objc func updateTicker() {
    lunoAPI.fetch() { askingPrice in
      DispatchQueue.main.async {
        self.askingPrice = askingPrice
        self.updateTitle()
      }
    }
  }
  
}
