# oschecker
This tool identify the Windows OS Version from a Windows Disk Image.
<br>
This tool uses the raw disk image of windows to extract the version information of windows.<br><br>
dependancy: [The Sleuth Kit](https://github.com/sleuthkit/sleuthkit),[hivex](https://github.com/libguestfs/hivex)<br>
<br>
## exmple
```
# ./oschecker.sh win95.raw
win95.raw
"ProductName"="Microsoft Windows 95"
# ./oschecker.sh win98.raw
win98.raw
"ProductName"="Microsoft Windows 98"
# ./oschecker.sh winMe.raw
winMe.raw
"ProductName"="Microsoft Windows ME"
# ./oschecker.sh winXPsimple.raw
winXPsimple.raw
"ProductName"="Microsoft Windows XP"
"CSDVersion"="Service Pack 3"
"ProductId"="*****-***-*******-*****"
# ./oschecker.sh winVista.raw
winVista.raw
"ProductName"="Windows Vista (TM) Enterprise"
"ProductId"="*****-***-*******-*****"
"CSDVersion"="Service Pack 2"
# ./oschecker.sh win7simple.raw
win7simple.raw
"ProductName"="Windows 7 Enterprise"
"ProductId"="*****-***-*******-*****"
"CSDVersion"="Service Pack 1"
# ./oschecker.sh win8simple.raw
win8simple.raw
"ProductName"="Windows 8 Enterprise N"
"ProductId"="*****-*****-*****-*****"
# ./oschecker.sh win10simple.raw
win10simple.raw
"ProductName"="Windows 10 Enterprise Evaluation"
"ReleaseId"="1909"
"ProductId"="*****-*****-*****-*****"
```
<br><br>
Japanese Abstract -> https://zarat.hatenablog.com/entry/2020/02/01/004844
