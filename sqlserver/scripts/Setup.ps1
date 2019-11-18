# This script enables TCP and named pipe protocols, allowing non-remote connections to the dB

Import-Module "sqlps"

$smo = 'Microsoft.SqlServer.Management.Smo.'  
$wmi = new-object ($smo + 'Wmi.ManagedComputer').  

# Enable the TCP protocol on the default instance.  
$uri = "ManagedComputer[@Name='" + (get-item env:\computername).Value + "']/ ServerInstance[@Name='MSSQLSERVER']/ServerProtocol[@Name='Tcp']"  
$Tcp = $wmi.GetSmoObject($uri)  
$Tcp.IsEnabled = $true  
$Tcp.Alter()  

# Enable the named pipes protocol for the default instance.  
$uri = "ManagedComputer[@Name='" + (get-item env:\computername).Value + "']/ ServerInstance[@Name='MSSQLSERVER']/ServerProtocol[@Name='Np']"  
$Np = $wmi.GetSmoObject($uri)  
$Np.IsEnabled = $true  
$Np.Alter()  

# Restart the SQL engine
CD SQLSERVER:\SQL\$((get-item env:\computername).Value)  
$Wmi = (get-item .).ManagedComputer  
$DfltInstance = $Wmi.Services['MSSQLSERVER']

$DfltInstance.Stop();  
Start-Sleep -s 4
$DfltInstance.Refresh();  

$DfltInstance.Start();  
Start-Sleep -s 4
