function Send-PSNotification {
    [cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)]
        [object[]]
        $Body,

        [String]
        $Summary = 'PowerShell Notification',

        [ValidateSet('low', 'normal', 'critical')]
        $Urgency,

        [int]
        $ExpireTime,

        [string[]]
        $Icon = "powershell-logo",

        [ValidateSet("device","device.added","device.error","device.removed",
        "email","email.arrived","email.bounced",
        "im","im.error","im.received",
        "network","network.connected","network.disconnected","network.error",
        "presence","presence.offline","presence.online",
        "transfer","transfer.complete","transfer.error")]
        [string[]]
        $Category
    )
    begin {
        $notifySendArgs = @()

        if ($Urgency) {
            $notifySendArgs += "--urgency=$Urgency"
        }

        if ($ExpireTime) {
            $notifySendArgs += "--expire-time=$ExpireTime"
        }

        if ($Icon) {
            if ($Icon -eq "powershell-logo" -and !(Test-Path "$HOME/.local/share/icons/powershell-logo.png")) {
                if (!(Test-Path "$HOME/.local/share/icons")) {
                    New-Item -ItemType Directory -Path "$HOME/.local/share/icons"
                }
                Copy-Item "$PSScriptRoot/../powershell-logo.png" "$HOME/.local/share/icons"
            }
            $notifySendArgs += "--icon=$($Icon -join ',')"
        }

        if ($Catagory) {
            $notifySendArgs += "--category=$($Catagory -join ',')"
        }

        $notifySendArgs += $Summary
        $notifySendArgs += ""
    }

    process {
        $notifySendArgs[$notifySendArgs.Length - 1] = $Body
        If ($PSCmdlet.ShouldProcess("notify-send $($notifySendArgs -join ' ')")) {
            & "notify-send" $notifySendArgs
        }
    }

    end {}
}
