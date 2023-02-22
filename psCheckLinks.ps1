[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$FilePath,
    [Parameter()]
    [string]$OutputFile = "link_check_results.txt"
)

# Search for all hyperlinks in the markdown file
$md_file_content = Get-Content $FilePath
$links = [regex]::Matches($md_file_content, '\[(.*?)\]\((https?://|www\.)(.*?)\)') | ForEach-Object {
    #$link = $_.Value
    $link = $_.Groups[2].Value + $_.Groups[3].Value + $_.Groups[4].Value
    if ($link.StartsWith("www.")) {
        $link = "http://${link}"
    }
    $link
}

# Check each link for a valid response and save the result to the output file
$results = @()
$errorOccurred = $false
foreach ($link in $links) {
    try {
        $uri = New-Object System.Uri($link)
        $response = Invoke-WebRequest $uri
        if ($response.StatusCode -ne 200) {
            $results += "Link $link is not accessible (status code $($response.StatusCode))"
            $errorOccurred = $true
        }
        else {
            $results += "Link ok: $link"
        }
    }
    catch {
        $results += "Error accessing link ${link}" #: $_  --> Error-Message removed, since it sometimes contains html-elements
        #$results += "Status: $($response.StatusCode)"
        $errorOccurred = $true
    }
}
$results | Out-File $OutputFile

if ($errorOccurred) {
    Write-Output "Error: One or more links are not accessible. See $OutputFile for details."
    #Write-Output "Links: $links"
    Exit 1
}
else {
    Write-Output "All links were successfully checked."
    Exit 0
}
