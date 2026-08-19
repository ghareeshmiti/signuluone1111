$dir = "c:\Hareesh\SignuluONE\mi.signulu.website"

# Pages still with old productsDropdown nav
$targetFiles = @(
    "$dir\index.html",
    "$dir\pricing.html",
    "$dir\signing-solutions.html",
    "$dir\why-signulu.html"
)

# New Products dropdown content (replaces old 4-column Products mega-menu)
$newProductsLi = @'
        <li class="nav-item dropdown dropdown-mega">
          <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Products</a>
          <div class="dropdown-menu dropdown-mega-menu">
            <div class="row">
              <div class="col-md-4"><div class="mega-menu-title">E-Signature</div><a class="mega-menu-item" href="./signing-solutions.html"><div class="mega-menu-icon"><i class="bi bi-pen"></i></div><div><div class="mega-menu-item-title">Signulu e-Sign</div><div class="mega-menu-item-desc">Sign contracts digitally with AI verification</div></div></a></div>
              <div class="col-md-4"><div class="mega-menu-title">Document Management</div><a class="mega-menu-item" href="./Dms.html"><div class="mega-menu-icon"><i class="bi bi-folder2-open"></i></div><div><div class="mega-menu-item-title">DMS</div><div class="mega-menu-item-desc">Centralized document storage &amp; workflows</div></div></a></div>
              <div class="col-md-4"><div class="mega-menu-title">Bulk Signing</div><a class="mega-menu-item" href="./BulkSigner.html"><div class="mega-menu-icon"><i class="bi bi-file-earmark-check"></i></div><div><div class="mega-menu-item-title">BulkSigner</div><div class="mega-menu-item-desc">DSC-based bulk document signing tool</div></div></a></div>
            </div>
          </div>
        </li>
'@

# New Why Signulu dropdown content (replaces old Why Signulu mega-menu)
$newWhyLi = @'
        <li class="nav-item dropdown dropdown-mega">
          <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Why Signulu</a>
          <div class="dropdown-menu dropdown-mega-menu">
            <div class="row">
              <div class="col-md-3">
                <div class="mega-menu-title">Security</div>
                <a class="mega-menu-item" href="./why-signulu.html#esignatures"><div class="mega-menu-icon"><i class="bi bi-shield-lock"></i></div><div><div class="mega-menu-item-title">Secure e-Signatures</div><div class="mega-menu-item-desc">AES-256 encryption &amp; TLS 1.3</div></div></a>
                <a class="mega-menu-item" href="./why-signulu.html#audit"><div class="mega-menu-icon"><i class="bi bi-journal-check"></i></div><div><div class="mega-menu-item-title">Audit Trail</div><div class="mega-menu-item-desc">Full tamper-proof activity log</div></div></a>
              </div>
              <div class="col-md-3">
                <div class="mega-menu-title">Automation</div>
                <a class="mega-menu-item" href="./why-signulu.html#workflows"><div class="mega-menu-icon"><i class="bi bi-diagram-3"></i></div><div><div class="mega-menu-item-title">Workflow Automation</div><div class="mega-menu-item-desc">Multi-level approval sequences</div></div></a>
                <a class="mega-menu-item" href="./why-signulu.html#templates"><div class="mega-menu-icon"><i class="bi bi-file-earmark-text"></i></div><div><div class="mega-menu-item-title">Templates</div><div class="mega-menu-item-desc">Reusable document templates</div></div></a>
              </div>
              <div class="col-md-3">
                <div class="mega-menu-title">Access &amp; Storage</div>
                <a class="mega-menu-item" href="./why-signulu.html#multidevice"><div class="mega-menu-icon"><i class="bi bi-devices"></i></div><div><div class="mega-menu-item-title">Multi-Device Access</div><div class="mega-menu-item-desc">Web, iOS &amp; Android</div></div></a>
                <a class="mega-menu-item" href="./why-signulu.html#cloud"><div class="mega-menu-icon"><i class="bi bi-cloud"></i></div><div><div class="mega-menu-item-title">Cloud Storage</div><div class="mega-menu-item-desc">Integrated with major cloud providers</div></div></a>
              </div>
              <div class="col-md-3">
                <div class="mega-menu-title">Compliance</div>
                <a class="mega-menu-item" href="./why-signulu.html#rbac"><div class="mega-menu-icon"><i class="bi bi-person-lock"></i></div><div><div class="mega-menu-item-title">RBAC</div><div class="mega-menu-item-desc">Role-based access control</div></div></a>
                <a class="mega-menu-item" href="./why-signulu.html#otp"><div class="mega-menu-icon"><i class="bi bi-phone"></i></div><div><div class="mega-menu-item-title">OTP Verification</div><div class="mega-menu-item-desc">SMS/Email signer authentication</div></div></a>
              </div>
            </div>
          </div>
        </li>
'@

function Get-LiEnd($lines, $startIdx) {
    # Find closing </li> for a <li> that starts at $startIdx
    # by tracking nesting depth of <li>
    $depth = 0
    for ($i = $startIdx; $i -lt $lines.Count; $i++) {
        $depth += ([regex]::Matches($lines[$i], '<li[\s>]')).Count
        $depth -= ([regex]::Matches($lines[$i], '</li>')).Count
        if ($depth -le 0 -and $i -ge $startIdx) { return $i }
    }
    return -1
}

foreach ($filePath in $targetFiles) {
    $fileName = Split-Path $filePath -Leaf
    Write-Host "Processing: $fileName"
    $content = Get-Content $filePath -Raw -Encoding UTF8

    # Skip if already fixed
    if ($content -notlike "*productsDropdown*") {
        Write-Host "  -> Already fixed, skipping"
        continue
    }

    $lines = $content -split "`n"

    # Find and replace Products <li>
    $prodStart = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -like "*productsDropdown*" -and $prodStart -eq -1) {
            # Find the <li> start (go back to find opening <li>)
            for ($j = $i; $j -ge [Math]::Max(0, $i-5); $j--) {
                if ($lines[$j] -match '<li\s') { $prodStart = $j; break }
            }
            break
        }
    }

    $prodEnd = -1
    if ($prodStart -ne -1) {
        $prodEnd = Get-LiEnd $lines $prodStart
    }

    if ($prodStart -ne -1 -and $prodEnd -ne -1) {
        $before = if ($prodStart -gt 0) { $lines[0..($prodStart - 1)] } else { @() }
        $middle = $lines[($prodEnd + 1)..($lines.Count - 1)]
        $newProdLines = $newProductsLi -split "`n"
        $lines = $before + $newProdLines + $middle
        Write-Host "  -> Replaced Products dropdown (li $prodStart-$prodEnd)"
    } else {
        Write-Host "  -> Could not find Products li"
    }

    # Recalculate from new lines - find Why Signulu <li>
    $whyStart = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -like "*whySignuluDropdown*" -and $whyStart -eq -1) {
            for ($j = $i; $j -ge [Math]::Max(0, $i-5); $j--) {
                if ($lines[$j] -match '<li\s') { $whyStart = $j; break }
            }
            break
        }
    }

    $whyEnd = -1
    if ($whyStart -ne -1) {
        $whyEnd = Get-LiEnd $lines $whyStart
    }

    if ($whyStart -ne -1 -and $whyEnd -ne -1) {
        $before = if ($whyStart -gt 0) { $lines[0..($whyStart - 1)] } else { @() }
        $middle = $lines[($whyEnd + 1)..($lines.Count - 1)]
        $newWhyLines = $newWhyLi -split "`n"
        $lines = $before + $newWhyLines + $middle
        Write-Host "  -> Replaced Why Signulu dropdown (li $whyStart-$whyEnd)"
    } else {
        Write-Host "  -> Could not find Why Signulu li"
    }

    $content = $lines -join "`n"
    Set-Content $filePath -Value $content -Encoding UTF8 -NoNewline
    Write-Host "  -> Saved OK"
}
Write-Host "Done."
