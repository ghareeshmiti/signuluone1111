$blogDir = "c:\Hareesh\SignuluONE\mi.signulu.website\blog"
$files = Get-ChildItem "$blogDir\*.html"

# The duplicated block to find: two consecutive Why Signulu dropdowns before Pricing
# Strategy: replace the doubled Why Signulu comment occurrences

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $count = ([regex]::Matches($content, '<!-- Why Signulu -->') ).Count

    if ($count -gt 1) {
        Write-Host "Fixing duplicate in: $($file.Name) (found $count)"

        # Remove everything from first <!-- Why Signulu --> up to (but not including) the second one
        # Pattern: first Why Signulu block ends just before the second <!-- Why Signulu -->
        $pattern = '(?s)        <!-- Why Signulu -->.*?        <!-- Why Signulu -->'
        $replacement = '        <!-- Why Signulu -->'
        $content = [regex]::Replace($content, $pattern, $replacement)

        Set-Content $file.FullName -Value $content -Encoding UTF8 -NoNewline

        $newCount = ([regex]::Matches($content, '<!-- Why Signulu -->')).Count
        Write-Host "  -> now has $newCount occurrence(s)"
    } else {
        Write-Host "OK: $($file.Name) (count=$count)"
    }
}
Write-Host "Done."
