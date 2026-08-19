$files = Get-ChildItem -Recurse -Filter '*.html' | Where-Object { $_.FullName -notmatch '\\blog\\' -or $_.Extension -eq '.html' }
$count = 0
foreach ($fi in $files) {
    $c = [System.IO.File]::ReadAllText($fi.FullName, [System.Text.Encoding]::UTF8)
    $orig = $c

    # Fix BulkSigner modal link
    $c = $c -replace 'href="\./BulkSigner\.html" class="product-card-modal"', 'href="https://bulksigner.signuluone.com" target="_blank" class="product-card-modal"'
    $c = $c -replace 'href="\.\./BulkSigner\.html" class="product-card-modal"', 'href="https://bulksigner.signuluone.com" target="_blank" class="product-card-modal"'
    # Also fix sg-prod-card style (used in old-style pages)
    $c = $c -replace 'href="\./BulkSigner\.html" class="sg-prod-card"', 'href="https://bulksigner.signuluone.com" target="_blank" class="sg-prod-card"'
    $c = $c -replace 'href="\./signing-solutions\.html" class="sg-prod-card"', 'href="https://signulu.com/index.php/about" target="_blank" class="sg-prod-card"'

    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($fi.FullName, $c, [System.Text.Encoding]::UTF8)
        Write-Host "Updated: $($fi.Name)"
        $count++
    }
}
Write-Host "Done. $count files updated."
