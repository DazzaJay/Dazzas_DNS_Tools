:: @echo off
cd C:\

setlocal enabledelayedexpansion
 
:: Set the variables below to your desired values
set "primaryDNSIPv4=94.140.14.14"
set "secondaryDNSIPv4=94.140.15.15"
set "primaryDNSIPv6=2a10:50c0::ad1:ff"
set "secondaryDNSIPv6=2a10:50c0::ad2:ff"
 
:: Get a list of all network interfaces
for /f "tokens=1,2*" %%i in ('netsh interface show interface') do (
    if not "%%j"=="" (
        set "name=%%j %%k"
        
        :: Configure primary and secondary DNS servers for IPv4
        netsh interface ipv4 set dns name="!name!" static %primaryDNSIPv4% primary
        netsh interface ipv4 add dns name="!name!" %secondaryDNSIPv4% index=2
 
        :: Configure primary and secondary DNS servers for IPv6
        netsh interface ipv6 set dns name="!name!" static %primaryDNSIPv6% primary
        netsh interface ipv6 add dns name="!name!" %secondaryDNSIPv6% index=2
    )
)
 
endlocal
 