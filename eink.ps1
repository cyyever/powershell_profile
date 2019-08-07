function Decode {
    If ($args[0] -is [System.Array]) {
      return  [System.Text.Encoding]::ASCII.GetString($args[0])
    }
    return ""
}

ForEach ($Monitor in Get-WmiObject WmiMonitorID -Namespace root\wmi) {
    if ((Decode $Monitor.UserFriendlyName -notmatch 0).contains("Paperlike")) {
    exit 0
      }

}
exit -1
