# Create AppVolumes In-Guest VHD Folder Structure

# APPVOl Folder Name for which you coppied from ISO - Hypervisor\In-Guest VHD folder
$APPVolVHD = "c:\cloudvolumes"

$Path_apps = "$APPVolVHD\apps"
$Path_apps_templates = "$APPVolVHD\apps_templates"
$Path_writable = "$APPVolVHD\writable"
$Path_writable_templates = "$APPVolVHD\writable_templates"

## 
## Run the PowerShell Script to create it automatically

# Create SMB Share APPVOL Share Folders

# Apps Folder
New-SmbShare -Name "apps" `
             -Path $Patch_apps `
             -FullAccess Administrators `
             -ChangeAccess 'Everyone' `
             -ReadAccess Users 

# Apps Templates Folder
New-SmbShare -Name "apps_templates" `
             -Path $Patch_apps_templates `
             -FullAccess Administrators `
             -ChangeAccess 'Everyone' `
             -ReadAccess Users 

# Writable Folder
New-SmbShare -Name "writables" `
             -Path $Patch_writable `
             -FullAccess Administrators `
             -ChangeAccess 'Everyone' `
             -ReadAccess Users 

# Writable Templates Folder
New-SmbShare -Name "writables_templates" `
             -Path $Patch_writable_templates `
             -FullAccess Administrators `
             -ChangeAccess 'Everyone' `
             -ReadAccess Users 


# Check ACL from Appvol Share
Get-Acl -Path $Path_apps | Format-Table -Wrap
Get-Acl -Path $Path_apps_templates | Format-Table -Wrap
Get-Acl -Path $Path_writable | Format-Table -Wrap
Get-Acl -Path $Path_writable_templates | Format-Table -Wrap
