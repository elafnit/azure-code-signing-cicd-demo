$pfxFilePassword = ""

$pfxPath = @(
    (Get-ChildItem -Path Env:\|?{$_.Name.ToUpper() -eq "USERPROFILE"}).Value.ToString()
    ,"Documents"
    ,"OltivaBikesCodeSigning.pfx"
)

$pfxFileName = $pfxPath -join '\'

# Create a self-signed cert for code signing and store in current users cert store
$parms = @{
    DnsName = "www.oltivabikes.com"
    Type = "CodeSigningCert"
    CertStoreLocation = "Cert:\CurrentUser\My"
    Subject = "CN=Oltiva Bikes Inc., O=Oltiva Bikes Incorporated, C=US"
    KeyAlgorithm = "RSA"
    KeySpec = "Signature"
    KeyUsage = "DigitalSignature"
    TextExtension = @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")
    Provider = "Microsoft Enhanced Cryptographic Provider v1.0"
    KeyExportPolicy = "Exportable"
}

$cert = New-SelfSignedCertificate @parms

# Export the cert

$CertPassword = [System.Security.SecureString]@{}
if ($pfxFilePassword -ne "") { $CertPassword = ConvertTo-SecureString -String "$pfxFilePassword" -Force –AsPlainText }

Export-PfxCertificate -Cert "cert:\CurrentUser\My\$($cert.Thumbprint)" -FilePath "$($pfxFileName)" -Password $CertPassword