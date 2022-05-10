# Define Variables
$AVM = "server_fqdn"
$username = "User"
$password = "Pass"

# Avoid Invalid Certificate
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
# For Windows Server 2012 Security Protocol 
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")
$headers.Add("Accept", "application/json")

$body = "{
`n	`"username`": `"$username`",
`n    `"password`": `"$password`"
`n}"

$loginuri = "https://" + $AVM + "/app_volumes/sessions"

$response = Invoke-RestMethod $loginuri -Method 'POST' -Headers $headers -Body $body -SessionVariable WebSession

#Logged In
$response | Format-List
write-host "Successfully Logged In"

#Save the AV session state to a varable - contains cookies with session information
$script:WebSession = $WebSession

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Accept", "application/json")

$loginuri = "https://" + $AVM + "/app_volumes/writables"

# Get Writables Volumes

$writable = Invoke-RestMethod $loginuri -Method 'GET' -Headers $headers -WebSession $WebSession
write-host "Writables Volumes"
$writable.data | Format-Table -AutoSize -Property @{Name = 'ID'; Expression = {$_.id}},@{Name = 'Owner Name'; Expression = {$_.owner_name}},`
    @{Name = 'Owner UPN'; Expression = {$_.owner_upn}},@{Name = 'Type'; Expression = {$_.owner_type}},@{Name = 'Size in MB'; Expression = {$_.Size_mb}},`
    @{Name = '% Available'; Expression = {$_.percent_available}},@{Name = 'Total MB'; Expression = {$_.total_mb}},@{Name = 'Last Mounted'; Expression = {$_.mounted_at_human}},`
    @{Name = 'Attached?'; Expression = {$_.attached}},@{Name = 'Enabled?'; Expression = {$_.Status}},@{Name = 'Type'; Expression = {$_.type}}
