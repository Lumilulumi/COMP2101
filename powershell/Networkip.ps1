get-ciminstance win32_networkadapterconfiguration | where  ipenabled | select description, index, ippaddress, ipsubnet, dnsdomain, dnsserversearchorder | ft