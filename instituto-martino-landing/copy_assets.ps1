$brainDir = "C:\Users\USER\.gemini\antigravity\brain\f787f65d-905d-4f9f-bd3c-234ff28c06ae"
$projectDir = "C:\Users\USER\.gemini\antigravity\scratch\instituto-martino-landing"
$imagesDir = "$projectDir\images"
$cssDir = "$projectDir\css"

# Create directories
New-Item -ItemType Directory -Force -Path $imagesDir
New-Item -ItemType Directory -Force -Path $cssDir

Write-Output "Project directories created."

# Copy doctor photos
$doctors = @{
    "media__1779487257993.jpg" = "dr-carlos-martino.jpg"
    "media__1779487258006.jpg" = "dr-claudio-martino.jpg"
    "media__1779487258020.jpg" = "dr-franco-giovannini.jpg"
}

foreach ($src in $doctors.Keys) {
    $srcPath = Join-Path $brainDir $src
    $destPath = Join-Path $imagesDir $doctors[$src]
    if (Test-Path $srcPath) {
        Copy-Item -Path $srcPath -Destination $destPath -Force
        Write-Output "Copied $src to $($doctors[$src])"
    } else {
        Write-Output "Source file not found: $srcPath"
    }
}

# Scan content.md for image URLs
$contentPath = "$brainDir\.system_generated\steps\10\content.md"
if (Test-Path $contentPath) {
    Write-Output "`nScanning website content for images and logo..."
    $content = Get-Content -Raw -Path $contentPath
    
    # Simple regex to find src="..."
    $matches = [regex]::Matches($content, 'src="([^"]+)"')
    $urls = @()
    foreach ($match in $matches) {
        $urls += $match.Groups[1].Value
    }
    
    # Simple regex to find srcSet="..."
    $matchesSet = [regex]::Matches($content, 'srcSet="([^"]+)"')
    foreach ($match in $matchesSet) {
        $parts = $match.Groups[1].Value -split ','
        foreach ($part in $parts) {
            $url = ($part.Trim() -split ' ')[0]
            $urls += $url
        }
    }
    
    $uniqueUrls = $urls | Select-Object -Unique
    Write-Output "Found image URLs on website:"
    foreach ($url in $uniqueUrls) {
        if ($url -like "*logo*" -or $url -like "*martin*" -or $url -like "*vector*" -or $url -like "*instituto*") {
            Write-Output "- $url"
        }
    }
} else {
    Write-Output "`nWebsite content file not found at $contentPath"
}
