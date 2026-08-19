$pages = @('pricing.html', 'Blog.html')
foreach ($f in $pages) {
    $c = [System.IO.File]::ReadAllText((Resolve-Path $f).Path, [System.Text.Encoding]::UTF8)
    $changed = $false

    # Add sg-topnav class to nav tag
    $old = 'class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top"'
    $new = 'class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top sg-topnav"'
    if ($c -match [regex]::Escape($old)) {
        $c = $c.Replace($old, $new)
        $changed = $true
    }

    # Fix nav-link font rule
    if ($c -match '\.nav-link \{ font-weight: \d+; \}') {
        $c = $c -replace '\.nav-link \{ font-weight: \d+; \}', '.navbar-nav > li > .nav-link { font-weight: 700 !important; font-family: Lato, sans-serif !important; font-size: 15px !important; color: #333 !important; }'
        $changed = $true
    }

    # Inject sg-topnav CSS if missing
    if ($c -notmatch '\.sg-topnav \{') {
        $ins = "      .sg-topnav .nav-link { font-weight: 700 !important; color: #333 !important; font-family: Lato, sans-serif !important; font-size: 15px !important; padding: 8px 14px !important; }`n      .sg-topnav .nav-link:hover { color: #5A30F1 !important; }"
        $c = $c -replace '(<style[^>]*>)', "`$1`n$ins"
        $changed = $true
    }

    if ($changed) {
        [System.IO.File]::WriteAllText((Resolve-Path $f).Path, $c, [System.Text.Encoding]::UTF8)
        Write-Host "Fixed: $f"
    } else {
        Write-Host "SKIP: $f"
    }
}
Write-Host "Done."
