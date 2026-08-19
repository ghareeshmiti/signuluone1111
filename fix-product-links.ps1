$allPages = @(
    'Blog.html', 'pricing.html', 'index.html', 'why-signulu.html', 'signing-solutions.html',
    'blog\construction-plan-approval.html', 'blog\improve-health-assistance.html',
    'blog\esign-approve-orders.html', 'blog\access-documents-anywhere.html',
    'blog\patient-consent-form.html', 'blog\faster-onboarding.html',
    'blog\digital-patient-records.html', 'blog\validate-procurement.html',
    'blog\reduce-paper-go-electronic.html', 'blog\store-retrieve-documents.html'
)

foreach ($f in $allPages) {
    if (-not (Test-Path $f)) { Write-Host "MISSING: $f"; continue }
    $c = [System.IO.File]::ReadAllText((Resolve-Path $f).Path, [System.Text.Encoding]::UTF8)
    $orig = $c

    # e-Sign: signing-solutions.html -> signulu.com (with target blank)
    $c = $c -replace 'class="mega-menu-item" href="\./signing-solutions\.html"', 'class="mega-menu-item" href="https://signulu.com/index.php/about" target="_blank"'
    $c = $c -replace 'class="mega-menu-item" href="\.\./signing-solutions\.html"', 'class="mega-menu-item" href="https://signulu.com/index.php/about" target="_blank"'

    # BulkSigner: BulkSigner.html -> bulksigner.signuluone.com (with target blank)
    $c = $c -replace 'class="mega-menu-item" href="\./BulkSigner\.html"', 'class="mega-menu-item" href="https://bulksigner.signuluone.com" target="_blank"'
    $c = $c -replace 'class="mega-menu-item" href="\.\./BulkSigner\.html"', 'class="mega-menu-item" href="https://bulksigner.signuluone.com" target="_blank"'

    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText((Resolve-Path $f).Path, $c, [System.Text.Encoding]::UTF8)
        Write-Host "Updated: $f"
    } else {
        Write-Host "SKIP: $f"
    }
}

# Also update sg-mm-item links used in about/contact/industry pages
$sgPages = Get-ChildItem -Filter '*.html' | Where-Object { $_.Name -notin @('Blog.html','pricing.html','index.html','why-signulu.html','signing-solutions.html') }
foreach ($fi in $sgPages) {
    $c = [System.IO.File]::ReadAllText($fi.FullName, [System.Text.Encoding]::UTF8)
    $orig = $c
    $c = $c -replace 'class="sg-mm-item" href="\./signing-solutions\.html"', 'class="sg-mm-item" href="https://signulu.com/index.php/about" target="_blank"'
    $c = $c -replace 'class="sg-mm-item" href="\./BulkSigner\.html"', 'class="sg-mm-item" href="https://bulksigner.signuluone.com" target="_blank"'
    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($fi.FullName, $c, [System.Text.Encoding]::UTF8)
        Write-Host "Updated (sg): $($fi.Name)"
    }
}
Write-Host "Done."
