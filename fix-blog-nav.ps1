$blogDir = "c:\Hareesh\SignuluONE\mi.signulu.website\blog"
$files = Get-ChildItem "$blogDir\*.html"

$oldStr = '        <li class="nav-item"><a class="nav-link" href="../pricing.html">Pricing</a></li>'

$newStr = '        <!-- Why Signulu -->
        <li class="nav-item dropdown dropdown-mega">
          <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Why Signulu</a>
          <div class="dropdown-menu dropdown-mega-menu">
            <div class="row">
              <div class="col-md-3">
                <div class="mega-menu-title">Security</div>
                <a class="mega-menu-item" href="../why-signulu.html#esignatures">
                  <div class="mega-menu-icon"><i class="bi bi-shield-lock"></i></div>
                  <div><div class="mega-menu-item-title">Secure e-Signatures</div><div class="mega-menu-item-desc">AES-256 encryption &amp; TLS 1.3</div></div>
                </a>
                <a class="mega-menu-item" href="../why-signulu.html#audit">
                  <div class="mega-menu-icon"><i class="bi bi-journal-check"></i></div>
                  <div><div class="mega-menu-item-title">Audit Trail</div><div class="mega-menu-item-desc">Full tamper-proof activity log</div></div>
                </a>
              </div>
              <div class="col-md-3">
                <div class="mega-menu-title">Automation</div>
                <a class="mega-menu-item" href="../why-signulu.html#workflows">
                  <div class="mega-menu-icon"><i class="bi bi-diagram-3"></i></div>
                  <div><div class="mega-menu-item-title">Workflow Automation</div><div class="mega-menu-item-desc">Multi-level approval sequences</div></div>
                </a>
                <a class="mega-menu-item" href="../why-signulu.html#templates">
                  <div class="mega-menu-icon"><i class="bi bi-file-earmark-text"></i></div>
                  <div><div class="mega-menu-item-title">Templates</div><div class="mega-menu-item-desc">Reusable document templates</div></div>
                </a>
              </div>
              <div class="col-md-3">
                <div class="mega-menu-title">Access &amp; Storage</div>
                <a class="mega-menu-item" href="../why-signulu.html#multidevice">
                  <div class="mega-menu-icon"><i class="bi bi-devices"></i></div>
                  <div><div class="mega-menu-item-title">Multi-Device Access</div><div class="mega-menu-item-desc">Web, iOS &amp; Android</div></div>
                </a>
                <a class="mega-menu-item" href="../why-signulu.html#cloud">
                  <div class="mega-menu-icon"><i class="bi bi-cloud"></i></div>
                  <div><div class="mega-menu-item-title">Cloud Storage</div><div class="mega-menu-item-desc">Integrated with major cloud providers</div></div>
                </a>
              </div>
              <div class="col-md-3">
                <div class="mega-menu-title">Compliance</div>
                <a class="mega-menu-item" href="../why-signulu.html#rbac">
                  <div class="mega-menu-icon"><i class="bi bi-person-lock"></i></div>
                  <div><div class="mega-menu-item-title">RBAC</div><div class="mega-menu-item-desc">Role-based access control</div></div>
                </a>
                <a class="mega-menu-item" href="../why-signulu.html#otp">
                  <div class="mega-menu-icon"><i class="bi bi-phone"></i></div>
                  <div><div class="mega-menu-item-title">OTP Verification</div><div class="mega-menu-item-desc">SMS/Email signer authentication</div></div>
                </a>
              </div>
            </div>
          </div>
        </li>
        <li class="nav-item"><a class="nav-link" href="../pricing.html">Pricing</a></li>'

$count = 0
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    if (($content -like "*$oldStr*") -and ($content -notlike "*Why Signulu*")) {
        $content = $content.Replace($oldStr, $newStr)
        Set-Content $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "Updated: $($file.Name)"
        $count++
    } else {
        Write-Host "SKIP (pattern not found): $($file.Name)"
    }
}
Write-Host "Done. Updated $count files."
