$disksObject = @()
$mbrVolumesCount = (Get-Disk | Where-Object -FilterScript {$_.PartitionStyle -Eq "MBR"} | Measure-Object).Count
Get-WmiObject Win32_Volume -Filter "DriveType='3'" | ForEach-Object {
    $VolObj = $_
    $ParObj = Get-Partition | Where-Object { $_.AccessPaths -contains $VolObj.DeviceID } | Where-Object -FilterScript {$_.Type -Eq "IFS"}
    if ( $ParObj ) {
        $disksobject += [pscustomobject][ordered]@{
            DriveLetter = $VolObj.DriveLetter
            Name = $VolObj.Label
            Size = ([Math]::Round(($VolObj.Capacity / 1GB),2))
            Text = "This is MBR"
            }
        }
    }

Write-Host Count of MBR volumes: $mbrVolumesCount
$disksObject | Sort-Object DriveLetter | Format-Table -AutoSize

$Disks = Get-Disk | Where-Object -FilterScript {($_.Size/1GB)}
    foreach ($Disk in $Disks) {
    $SizeGB = [math]::Round($Disk.Size/1GB,2)

    if ($Disk.PartitionStyle -eq 'MBR' -and $SizeGB -gt 1500) {
        Write-Host "tutaj"
        exit 1
    }
    }
    Write-Host 'to nie ten'   
    exit 0
