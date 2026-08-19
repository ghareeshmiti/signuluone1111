$pages = @(
    'signing-solutions.html',
    'why-signulu.html',
    'blog\access-documents-anywhere.html',
    'blog\construction-plan-approval.html',
    'blog\digital-patient-records.html',
    'blog\esign-approve-orders.html',
    'blog\faster-onboarding.html',
    'blog\improve-health-assistance.html',
    'blog\patient-consent-form.html',
    'blog\reduce-paper-go-electronic.html',
    'blog\store-retrieve-documents.html',
    'blog\validate-procurement.html'
)

foreach ($f in $pages) {
    $c = [System.IO.File]::ReadAllText((Resolve-Path $f).Path, [System.Text.Encoding]::UTF8)
    if ($c -match 'n      /\* SignuluOne standard navbar overrides \*/') {
        $c = $c -replace 'n      /\* SignuluOne standard navbar overrides \*/', "<style>`n      /* SignuluOne standard navbar overrides */"
        [System.IO.File]::WriteAllText((Resolve-Path $f).Path, $c, [System.Text.Encoding]::UTF8)
        Write-Host "Fixed: $f"
    } elseif ($c -match 'n/\* SignuluOne|n  /\* SignuluOne') {
        $c = $c -replace 'n(\s*/\* SignuluOne standard navbar overrides \*/)', "<style>`n`$1"
        [System.IO.File]::WriteAllText((Resolve-Path $f).Path, $c, [System.Text.Encoding]::UTF8)
        Write-Host "Fixed (alt): $f"
    } else {
        Write-Host "SKIP: $f"
    }
}
Write-Host "Done."
