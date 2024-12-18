[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)][System.IO.FileInfo]$File,
    [Parameter(Mandatory=$true)][string]$Version,
    [Parameter(Mandatory=$false)][switch]$Dynamic,
    [Parameter(Mandatory=$false)][System.UInt32]$Threads
)

if ($Version -notin @("20b", "30", "40", "41", "50", "51")) {
	return
}

$fileList = $File.OpenText()
while ($null -ne ($line = $fileList.ReadLine())) {
	if ($line -match '^\s*$' -or $line -match '^\s*//') {
		continue
	}

	# Create a vmt file from template for each shader
	$baseName = [System.IO.Path]::GetFileNameWithoutExtension($line) -replace "_ps2x$", ""
	$templatePath = Join-Path $PSScriptRoot "../../../materials/effects/shaders/template.vmt"
	$vmtPath = Join-Path $PSScriptRoot "../../../materials/effects/shaders/$baseName.vmt"

	if (Test-Path $templatePath) {
		$content = Get-Content $templatePath -Raw
		$content = $content -replace '\$pixshader\s+"[^"]*"', "`$pixshader `"$baseName`_ps20`""
		Set-Content -Path $vmtPath -Value $content
	}

	if ($Dynamic) {
		& "$PSScriptRoot\ShaderCompile" "-dynamic" "-ver" $Version "-shaderpath" $File.DirectoryName $line
		continue
	}

	if ($Threads -ne 0) {
		& "$PSScriptRoot\ShaderCompile" "-threads" $Threads "-ver" $Version "-shaderpath" $File.DirectoryName $line
		continue
	}

	& "$PSScriptRoot\ShaderCompile" "-ver" $Version "-shaderpath" $File.DirectoryName $line
}
$fileList.Close()
