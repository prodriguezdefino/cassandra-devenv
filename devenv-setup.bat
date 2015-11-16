REM install virtualbox for our virtualized development environment

ECHO "Installing VirtualBox..." 
choco install virtualbox --version 4.3 -force -y
setx PATH "%%PATH%%;C:\PROGRA~1\Oracle\VirtualBox"

ECHO "Installing Vagrant..." 
choco install vagrant --version 1.7.2 -force -y
setx PATH "%%PATH%%;C:\HashiCorp\Vagrant\bin"

ECHO "Installing cygwin package manager..."
choco install cyg-get -force -y
setx PATH "%%PATH%%;C:\tools\cygwin\bin"

ECHO "Installing ssh command tools"
cyg-get openssh

ECHO "Installation finished!" 
