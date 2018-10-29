Configuration TechDaysDemo1
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
            Name                  = 'WINRMHttp'
            DisplayName           = 'WINRM access over HTTP'
            Group                 = 'WinRM'
            Protocol              = 'TCP'
            LocalPort             = ('5985')
            Service               = 'Any'
            Direction             = 'Inbound'
            Ensure                = 'Present'
            Enabled               = 'True'
            Profile               = 'Any'
        }
    }
}
