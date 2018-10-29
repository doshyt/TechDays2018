Configuration TechDaysDemoHardened
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xWindowsUpdate
    Import-DscResource -ModuleName NetworkingDsc

    node "localhost"
    {
        xWindowsUpdateAgent ApplySecurityUpdates
        {
            IsSingleInstance = 'Yes'
            UpdateNow        = $true
            Source           = 'WindowsUpdate'
            Notifications    = 'ScheduledInstallation'
            Category         = @('Security','Important')
        }

        WindowsFeature WebServer
        {
            Name = 'Web-Server'
            Ensure = 'Present'
        }

        Firewall Firewall
        {
            Name                  = 'WINRMHttps'
            DisplayName           = 'WINRM access over HTTPS'
            Group                 = 'WinRM'
            Protocol              = 'TCP'
            LocalPort             = ('5986')
            Service               = 'Any'
            Direction             = 'Inbound'
            Ensure                = 'Present'
            Enabled               = 'True'
            Profile               = 'Any'
        }

        # https://gist.github.com/lukemurraynz/d6d2c753c72f917eb9aeab83e696b578
        # amazing work of lukemurraynz

        Registry 'EnhancedAntiSpoofing' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Biometrics\FacialFeatures'
            ValueName = 'EnhancedAntiSpoofing'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'DCSettingIndex' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51'
            ValueName = 'DCSettingIndex'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'ACSettingIndex' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51'
            ValueName = 'ACSettingIndex'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'DisableInventory' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\AppCompat'
            ValueName = 'DisableInventory'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'EnableVirtualizationBasedSecurity' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\DeviceGuard'
            ValueName = 'EnableVirtualizationBasedSecurity'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'AllowTelemetry' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\DataCollection'
            ValueName = 'AllowTelemetry'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'HypervisorEnforcedCodeIntegrity' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\DeviceGuard'
            ValueName = 'HypervisorEnforcedCodeIntegrity'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'LsaCfgFlags' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\DeviceGuard'
            ValueName = 'LsaCfgFlags'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'MaxSize' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\EventLog\Application'
            ValueName = 'MaxSize'
            ValueType = 'DWord'
            ValueData = '32768'
        }
        Registry 'MaxSize1' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\EventLog\Security'
            ValueName = 'MaxSize'
            ValueType = 'DWord'
            ValueData = '196608'
        }
        Registry 'MaxSize2' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\EventLog\System'
            ValueName = 'MaxSize'
            ValueType = 'DWord'
            ValueData = '32768'
        }
        Registry 'NoDataExecutionPrevention' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Explorer'
            ValueName = 'NoDataExecutionPrevention'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'NoHeapTerminationOnCorruption' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Explorer'
            ValueName = 'NoHeapTerminationOnCorruption'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'NoAutoplayfornonVolume' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Explorer'
            ValueName = 'NoAutoplayfornonVolume'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'NoGPOListChanges' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}'
            ValueName = 'NoGPOListChanges'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'NoBackgroundPolicy' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}'
            ValueName = 'NoBackgroundPolicy'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'EnableUserControl' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Installer'
            ValueName = 'EnableUserControl'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'AlwaysInstallElevated' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Installer'
            ValueName = 'AlwaysInstallElevated'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'AllowInsecureGuestAuth' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\LanmanWorkstation'
            ValueName = 'AllowInsecureGuestAuth'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry '\\*\NETLOGON' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths'
            ValueName = '\\*\NETLOGON'
            ValueType = 'String'
            ValueData = 'RequireMutualAuthentication=1, RequireIntegrity=1'
        }
        Registry '\\*\SYSVOL' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths'
            ValueName = '\\*\SYSVOL'
            ValueType = 'String'
            ValueData = 'RequireMutualAuthentication=1, RequireIntegrity=1'
        }
        Registry 'NoLockScreenSlideshow' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Personalization'
            ValueName = 'NoLockScreenSlideshow'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'NoLockScreenCamera' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Personalization'
            ValueName = 'NoLockScreenCamera'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'EnableScriptBlockInvocationLogging' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
            ValueName = 'EnableScriptBlockInvocationLogging'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'EnableScriptBlockLogging' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
            ValueName = 'EnableScriptBlockLogging'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'DontDisplayNetworkSelectionUI' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System'
            ValueName = 'DontDisplayNetworkSelectionUI'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'EnableSmartScreen' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System'
            ValueName = 'EnableSmartScreen'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'EnumerateLocalUsers' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System'
            ValueName = 'EnumerateLocalUsers'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'AllowIndexingEncryptedStoresOrItems' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Search'
            ValueName = 'AllowIndexingEncryptedStoresOrItems'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'AllowUnencryptedTraffic' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WinRM\Client'
            ValueName = 'AllowUnencryptedTraffic'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'AllowBasic' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WinRM\Client'
            ValueName = 'AllowBasic'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'AllowDigest' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WinRM\Client'
            ValueName = 'AllowDigest'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'AllowBasic1' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WinRM\Service'
            ValueName = 'AllowBasic'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'DisableRunAs' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WinRM\Service'
            ValueName = 'DisableRunAs'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'AllowUnencryptedTraffic1' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WinRM\Service'
            ValueName = 'AllowUnencryptedTraffic'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'DisableBehaviorMonitoring' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows Defender\Real-Time Protection'
            ValueName = 'DisableBehaviorMonitoring'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'DisableRemovableDriveScanning' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows Defender\Scan'
            ValueName = 'DisableRemovableDriveScanning'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'DisableEmailScanning' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows Defender\Scan'
            ValueName = 'DisableEmailScanning'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'SubmitSamplesConsent' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows Defender\Spynet'
            ValueName = 'SubmitSamplesConsent'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'LocalSettingOverrideSpynetReporting' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows Defender\Spynet'
            ValueName = 'LocalSettingOverrideSpynetReporting'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'SpynetReporting' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows Defender\Spynet'
            ValueName = 'SpynetReporting'
            ValueType = 'DWord'
            ValueData = '2'
        }
        Registry 'DisableAntiSpyware' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows Defender'
            ValueName = 'DisableAntiSpyware'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'DisableHTTPPrinting' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\Printers'
            ValueName = 'DisableHTTPPrinting'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'DisableWebPnPDownload' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\Printers'
            ValueName = 'DisableWebPnPDownload'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'MitigationOptions_FontBocking' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\MitigationOptions'
            ValueName = 'MitigationOptions_FontBocking'
            ValueType = 'String'
            ValueData = '1000000000000'
        }
        Registry 'RestrictRemoteClients' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\Rpc'
            ValueName = 'RestrictRemoteClients'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'MinEncryptionLevel' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\Terminal Services'
            ValueName = 'MinEncryptionLevel'
            ValueType = 'DWord'
            ValueData = '3'
        }
        Registry 'fDisableCdm' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\Terminal Services'
            ValueName = 'fDisableCdm'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'DisablePasswordSaving' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\Terminal Services'
            ValueName = 'DisablePasswordSaving'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'fPromptForPassword' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\Terminal Services'
            ValueName = 'fPromptForPassword'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'fEncryptRPCTraffic' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\Terminal Services'
            ValueName = 'fEncryptRPCTraffic'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'EnableFirewall' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
            ValueName = 'EnableFirewall'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'DefaultOutboundAction' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
            ValueName = 'DefaultOutboundAction'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'DefaultInboundAction' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
            ValueName = 'DefaultInboundAction'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'DefaultOutboundAction1' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
            ValueName = 'DefaultOutboundAction'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'EnableFirewall1' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
            ValueName = 'EnableFirewall'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'DefaultInboundAction1' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
            ValueName = 'DefaultInboundAction'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'EnableFirewall2' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
            ValueName = 'EnableFirewall'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'DefaultOutboundAction2' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
            ValueName = 'DefaultOutboundAction'
            ValueType = 'DWord'
            ValueData = '0'
        }
        Registry 'DefaultInboundAction2' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
            ValueName = 'DefaultInboundAction'
            ValueType = 'DWord'
            ValueData = '1'
        }
        Registry 'AdmPwdEnabled' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft Services\AdmPwd'
            ValueName = 'AdmPwdEnabled'
            ValueType = 'DWord'
            ValueData = '1'
        }
        WindowsFeature 'Telnet-Client' {
            Name   = 'Telnet-Client'
            Ensure = 'Absent'
        }
        WindowsFeature 'SMB1' {
            Name   = 'FS-SMB1'
            Ensure = 'Absent'
        }
    }
}
