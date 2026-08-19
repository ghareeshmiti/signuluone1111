$dir = "c:\Hareesh\SignuluONE\mi.signulu.website"

# Only process these specific locked files that couldn't be saved
$targetFiles = @(
    "$dir\about.html",
    "$dir\contact.html",
    "$dir\BulkSigner.html",
    "$dir\Dms.html"
)

$biCSS = '    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">'

$navStyle = @'
    <style>
      /* SignuluOne standard navbar overrides */
      .sg-topnav { background: #fff !important; box-shadow: 0 2px 12px rgba(0,0,0,.08); }
      .sg-topnav .navbar-brand img { height: 40px; }
      .sg-topnav .nav-link { font-weight: 600 !important; color: #333 !important; padding: 8px 14px !important; }
      .sg-topnav .nav-link:hover { color: #5A30F1 !important; }
      .sg-topnav .dropdown-mega { position: static !important; }
      .sg-topnav .dropdown-mega-menu { width: 100% !important; left: 0 !important; right: 0 !important; padding: 24px !important; border: none !important; box-shadow: 0 8px 32px rgba(0,0,0,0.12) !important; border-top: 3px solid #5A30F1 !important; }
      .sg-topnav .sg-mm-title { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: #5A30F1; border-bottom: 2px solid #5A30F1; padding-bottom: 8px; margin-bottom: 12px; }
      .sg-topnav .sg-mm-item { display: flex !important; align-items: flex-start; padding: 8px 10px; border-radius: 8px; text-decoration: none !important; color: #333 !important; transition: background 0.2s; }
      .sg-topnav .sg-mm-item:hover { background: #f0ebff; color: #5A30F1 !important; }
      .sg-topnav .sg-mm-icon { width: 36px; height: 36px; border-radius: 8px; background: #f0ebff; display: flex; align-items: center; justify-content: center; flex-shrink: 0; margin-right: 10px; }
      .sg-topnav .sg-mm-icon i { color: #5A30F1; font-size: 16px; }
      .sg-topnav .sg-mm-item-title { font-weight: 700; font-size: 13px; margin-bottom: 2px; }
      .sg-topnav .sg-mm-item-desc { font-size: 11px; color: #777; }
      .sg-prod-card { border: 2px solid #e9ecef; border-radius: 12px; padding: 20px; text-align: center; text-decoration: none; color: #333; transition: border-color 0.2s, transform 0.2s; display: block; }
      .sg-prod-card:hover { border-color: #5A30F1; transform: translateY(-2px); color: #333; }
      .sg-prod-icon { width: 56px; height: 56px; border-radius: 50%; background: #f0ebff; display: flex; align-items: center; justify-content: center; margin: 0 auto 12px; }
      .sg-prod-icon i { font-size: 24px; color: #5A30F1; }
    </style>
'@

$newNavLines = @(
'<!-- SignuluOne Standard Navbar -->'
'<nav class="navbar navbar-expand-lg navbar-light sticky-top sg-topnav" style="padding:12px 0;">'
'  <div class="container">'
'    <a class="navbar-brand" href="./index.html"><img src="./img/new-signulu-logo.png" alt="SignuluOne" style="height:40px;"></a>'
'    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#sgMainNav"><span class="navbar-toggler-icon"></span></button>'
'    <div class="collapse navbar-collapse" id="sgMainNav">'
'      <ul class="navbar-nav me-auto">'
'        <li class="nav-item dropdown dropdown-mega">'
'          <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Products</a>'
'          <div class="dropdown-menu dropdown-mega-menu">'
'            <div class="row">'
'              <div class="col-md-4"><div class="sg-mm-title">E-Signature</div><a class="sg-mm-item" href="./signing-solutions.html"><div class="sg-mm-icon"><i class="bi bi-pen"></i></div><div><div class="sg-mm-item-title">Signulu e-Sign</div><div class="sg-mm-item-desc">Sign contracts digitally</div></div></a></div>'
'              <div class="col-md-4"><div class="sg-mm-title">Document Management</div><a class="sg-mm-item" href="./Dms.html"><div class="sg-mm-icon"><i class="bi bi-folder2-open"></i></div><div><div class="sg-mm-item-title">DMS</div><div class="sg-mm-item-desc">Centralized document storage</div></div></a></div>'
'              <div class="col-md-4"><div class="sg-mm-title">Bulk Signing</div><a class="sg-mm-item" href="./BulkSigner.html"><div class="sg-mm-icon"><i class="bi bi-file-earmark-check"></i></div><div><div class="sg-mm-item-title">BulkSigner</div><div class="sg-mm-item-desc">DSC-based bulk signing</div></div></a></div>'
'            </div>'
'          </div>'
'        </li>'
'        <li class="nav-item dropdown dropdown-mega">'
'          <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Why Signulu</a>'
'          <div class="dropdown-menu dropdown-mega-menu">'
'            <div class="row">'
'              <div class="col-md-3">'
'                <div class="sg-mm-title">Security</div>'
'                <a class="sg-mm-item" href="./why-signulu.html#esignatures"><div class="sg-mm-icon"><i class="bi bi-shield-lock"></i></div><div><div class="sg-mm-item-title">Secure e-Signatures</div><div class="sg-mm-item-desc">AES-256 encryption &amp; TLS 1.3</div></div></a>'
'                <a class="sg-mm-item" href="./why-signulu.html#audit"><div class="sg-mm-icon"><i class="bi bi-journal-check"></i></div><div><div class="sg-mm-item-title">Audit Trail</div><div class="sg-mm-item-desc">Full tamper-proof activity log</div></div></a>'
'              </div>'
'              <div class="col-md-3">'
'                <div class="sg-mm-title">Automation</div>'
'                <a class="sg-mm-item" href="./why-signulu.html#workflows"><div class="sg-mm-icon"><i class="bi bi-diagram-3"></i></div><div><div class="sg-mm-item-title">Workflow Automation</div><div class="sg-mm-item-desc">Multi-level approval sequences</div></div></a>'
'                <a class="sg-mm-item" href="./why-signulu.html#templates"><div class="sg-mm-icon"><i class="bi bi-file-earmark-text"></i></div><div><div class="sg-mm-item-title">Templates</div><div class="sg-mm-item-desc">Reusable document templates</div></div></a>'
'              </div>'
'              <div class="col-md-3">'
'                <div class="sg-mm-title">Access &amp; Storage</div>'
'                <a class="sg-mm-item" href="./why-signulu.html#multidevice"><div class="sg-mm-icon"><i class="bi bi-devices"></i></div><div><div class="sg-mm-item-title">Multi-Device Access</div><div class="sg-mm-item-desc">Web, iOS &amp; Android</div></div></a>'
'                <a class="sg-mm-item" href="./why-signulu.html#cloud"><div class="sg-mm-icon"><i class="bi bi-cloud"></i></div><div><div class="sg-mm-item-title">Cloud Storage</div><div class="sg-mm-item-desc">Integrated with major cloud providers</div></div></a>'
'              </div>'
'              <div class="col-md-3">'
'                <div class="sg-mm-title">Compliance</div>'
'                <a class="sg-mm-item" href="./why-signulu.html#rbac"><div class="sg-mm-icon"><i class="bi bi-person-lock"></i></div><div><div class="sg-mm-item-title">RBAC</div><div class="sg-mm-item-desc">Role-based access control</div></div></a>'
'                <a class="sg-mm-item" href="./why-signulu.html#otp"><div class="sg-mm-icon"><i class="bi bi-phone"></i></div><div><div class="sg-mm-item-title">OTP Verification</div><div class="sg-mm-item-desc">SMS/Email signer authentication</div></div></a>'
'              </div>'
'            </div>'
'          </div>'
'        </li>'
'        <li class="nav-item"><a class="nav-link" href="./Blog.html">Blog</a></li>'
'        <li class="nav-item"><a class="nav-link" href="./pricing.html">Pricing</a></li>'
'        <li class="nav-item"><a class="nav-link" href="./about.html">About</a></li>'
'      </ul>'
'      <div class="d-flex gap-2">'
'        <a href="./contact.html" class="btn btn-outline-secondary" style="font-size:14px;">Contact Sales</a>'
'        <a href="#" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#productSelectModal" style="background:#5A30F1;border-color:#5A30F1;font-size:14px;">Try for Free</a>'
'      </div>'
'    </div>'
'  </div>'
'</nav>'
)

$modalBlock = @'
<!-- SignuluOne Product Modal -->
<div class="modal fade" id="productSelectModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header border-0 pb-0">
        <h5 class="modal-title fw-bold">Which product would you like to try?</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body pt-3 pb-4">
        <div class="row g-3">
          <div class="col-md-4"><a href="https://app.signulu.com/account/register" class="sg-prod-card"><div class="sg-prod-icon"><i class="bi bi-pen"></i></div><div class="fw-bold mb-1">Signulu e-Sign</div><div style="font-size:13px;color:#777;">Sign contracts digitally</div></a></div>
          <div class="col-md-4"><a href="https://dms.signulu.com/auth" class="sg-prod-card"><div class="sg-prod-icon"><i class="bi bi-folder2-open"></i></div><div class="fw-bold mb-1">DMS</div><div style="font-size:13px;color:#777;">Document Management System</div></a></div>
          <div class="col-md-4"><a href="./BulkSigner.html" class="sg-prod-card"><div class="sg-prod-icon"><i class="bi bi-file-earmark-check"></i></div><div class="fw-bold mb-1">BulkSigner</div><div style="font-size:13px;color:#777;">DSC Bulk Signing Tool</div></a></div>
        </div>
      </div>
    </div>
  </div>
</div>
'@

foreach ($filePath in $targetFiles) {
    $fileName = Split-Path $filePath -Leaf
    Write-Host "Processing: $fileName"
    $content = Get-Content $filePath -Raw -Encoding UTF8

    # Skip if already processed
    if ($content -like "*sg-topnav*") {
        Write-Host "  -> Already has sg-topnav, skipping nav replacement"
    } else {
        # Add Bootstrap Icons CSS if not present
        if ($content -notlike "*bootstrap-icons*") {
            $content = $content -replace '(?i)(</head>)', "$biCSS`n`$1"
        }
        # Add navbar CSS
        $content = $content -replace '(?i)(</head>)', "$navStyle`n`$1"

        # Upgrade Bootstrap CSS 5.1.3 -> 5.3.7
        $content = $content -replace 'href="https://cdn\.jsdelivr\.net/npm/bootstrap@5\.1\.3/dist/css/[^"]*"[^>]*>', 'href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">'
        # Upgrade Bootstrap JS 5.1.3 -> 5.3.7
        $content = $content -replace 'src="https://cdn\.jsdelivr\.net/npm/bootstrap@5\.1\.3/dist/js/[^"]*"[^>]*>', 'src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous">'

        # Replace <header>...</header> for about.html and contact.html
        if ($content -like "*offcanvasNavbar*") {
            $lines = $content -split "`n"
            $headerStart = -1; $headerEnd = -1
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -match '^\s*<header>' -and $headerStart -eq -1) { $headerStart = $i }
                if ($headerStart -ne -1 -and $lines[$i] -match '^\s*</header>') { $headerEnd = $i; break }
            }
            if ($headerStart -ne -1 -and $headerEnd -ne -1) {
                $before = if ($headerStart -gt 0) { $lines[0..($headerStart - 1)] } else { @() }
                $after = if ($headerEnd -lt $lines.Count - 1) { $lines[($headerEnd + 1)..($lines.Count - 1)] } else { @() }
                $content = ($before + $newNavLines + $after) -join "`n"
                Write-Host "  -> Replaced <header> nav"
            }
        }
        # Replace <!-- Navigation with Mega Menu --> ... </nav> for Dms.html and BulkSigner.html
        elseif ($content -like "*productsDropdown*") {
            $lines = $content -split "`n"
            $startIdx = -1; $endIdx = -1; $depth = 0
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($startIdx -eq -1 -and $lines[$i] -like "*Navigation with Mega Menu*") { $startIdx = $i; $depth = 0 }
                if ($startIdx -ne -1) {
                    $depth += ([regex]::Matches($lines[$i], '<nav[\s>]')).Count
                    $depth -= ([regex]::Matches($lines[$i], '</nav>')).Count
                    if ($depth -le 0 -and $i -gt $startIdx) { $endIdx = $i; break }
                }
            }
            if ($startIdx -ne -1 -and $endIdx -ne -1) {
                $before = if ($startIdx -gt 0) { $lines[0..($startIdx - 1)] } else { @() }
                $after = if ($endIdx -lt $lines.Count - 1) { $lines[($endIdx + 1)..($lines.Count - 1)] } else { @() }
                $content = ($before + $newNavLines + $after) -join "`n"
                Write-Host "  -> Replaced mega-menu nav"
            }
        }
    }

    # Add modal if missing
    if ($content -notlike "*productSelectModal*") {
        $content = $content -replace '(?i)(</body>)', "$modalBlock`$1"
        Write-Host "  -> Added product modal"
    }

    Set-Content $filePath -Value $content -Encoding UTF8 -NoNewline
    Write-Host "  -> Saved OK"
}
Write-Host "Done."
