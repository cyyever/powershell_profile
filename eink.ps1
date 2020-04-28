function Decode {
    If ($args[0] -is [System.Array]) {
      return  [System.Text.Encoding]::ASCII.GetString($args[0])
    }
    return ""
}
#"""Get-WmiObject Win32_DesktopMonitor            
ForEach ($Monitor in Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorId) {
    if ((Decode $Monitor.UserFriendlyName -notmatch 0).contains("Paperlike")) {
    exit 0
      }

}
exit -1
