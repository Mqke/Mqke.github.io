param([string] $path, [string] $recursive, [string] $importedPaths)

$files = @()

if($importedPaths -eq "")
{
    $recursiveBool = [bool]::Parse($recursive)
    $files = Get-ChildItem -Path $path -File -Recurse:$recursiveBool -Force -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
}
else
{
    $files = Get-Content -Path $importedPaths
}

$unsignedFiles = @()

foreach ($file in $files) {
    $certificate = (Get-AuthenticodeSignature -FilePath $file -ErrorAction SilentlyContinue).Status
    
    if ($certificate -eq 'NotSigned')
    { 
        $unsignedFiles += $file
    }
}

New-Item -Path "C:\ProgramData\ScannerUI\BinarySignature.txt"

foreach($unsignedFile in $unsignedFiles)
{
    $unsignedFile | Out-File -Append -FilePath "C:\ProgramData\ScannerUI\BinarySignature.txt"
}