# Standard modal HTML matching the design
$modal = @'
<!-- Product Selection Modal -->
<div class="modal fade" id="productSelectModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content border-0" style="border-radius:16px; box-shadow:0 20px 60px rgba(0,0,0,0.15);">
      <div class="modal-header border-0 pb-0 px-4 pt-4">
        <div>
          <h5 class="modal-title fw-bold" style="font-size:1.4rem;">Which product would you like to try?</h5>
          <p class="text-muted mb-0" style="font-size:14px;">Select a product to begin your free trial or registration.</p>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body px-4 py-4">
        <div class="row g-3">
          <div class="col-md-4">
            <a href="https://app.signulu.com/account/register" target="_blank" class="sg-prod-card d-block text-center text-decoration-none p-4" style="border:2px solid #e9ecef;border-radius:12px;color:#333;transition:border-color 0.2s,transform 0.2s;">
              <div style="width:60px;height:60px;border-radius:50%;background:#f0ebff;display:flex;align-items:center;justify-content:center;margin:0 auto 14px;">
                <i class="bi bi-pen" style="font-size:26px;color:#5A30F1;"></i>
              </div>
              <div class="fw-bold mb-1" style="font-size:15px;">Signulu e-Sign</div>
              <div style="font-size:12px;color:#888;">Sign contracts digitally. Legally binding &amp; secure.</div>
            </a>
          </div>
          <div class="col-md-4">
            <a href="https://dms.signulu.com/auth" target="_blank" class="sg-prod-card d-block text-center text-decoration-none p-4" style="border:2px solid #e9ecef;border-radius:12px;color:#333;transition:border-color 0.2s,transform 0.2s;">
              <div style="width:60px;height:60px;border-radius:50%;background:#e8f5e9;display:flex;align-items:center;justify-content:center;margin:0 auto 14px;">
                <i class="bi bi-folder2-open" style="font-size:26px;color:#2E7D32;"></i>
              </div>
              <div class="fw-bold mb-1" style="font-size:15px;">DMS</div>
              <div style="font-size:12px;color:#888;">Document Management System. Digitize &amp; organize.</div>
            </a>
          </div>
          <div class="col-md-4">
            <a href="https://bulksigner.signuluone.com" target="_blank" class="sg-prod-card d-block text-center text-decoration-none p-4" style="border:2px solid #e9ecef;border-radius:12px;color:#333;transition:border-color 0.2s,transform 0.2s;">
              <div style="width:60px;height:60px;border-radius:50%;background:#fff8e1;display:flex;align-items:center;justify-content:center;margin:0 auto 14px;">
                <i class="bi bi-file-earmark-check" style="font-size:26px;color:#F9A825;"></i>
              </div>
              <div class="fw-bold mb-1" style="font-size:15px;">BulkSigner</div>
              <div style="font-size:12px;color:#888;">DSC Bulk Signing Tool. Sign PDFs with Class 3 DSC.</div>
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
'@

# Also update CSS hover effect via JS
$hoverScript = @'
<script>
document.querySelectorAll('.sg-prod-card').forEach(function(el){
  el.addEventListener('mouseenter',function(){ this.style.borderColor='#5A30F1'; this.style.transform='translateY(-2px)'; });
  el.addEventListener('mouseleave',function(){ this.style.borderColor='#e9ecef'; this.style.transform=''; });
});
</script>
'@

# Pages missing the modal
$missing = @('about.html','contact.html','index.html','BulkSigner.html','Dms.html')

foreach ($f in $missing) {
    if (-not (Test-Path $f)) { Write-Host "MISSING FILE: $f"; continue }
    $c = [System.IO.File]::ReadAllText((Resolve-Path $f).Path, [System.Text.Encoding]::UTF8)
    if ($c -match 'productSelectModal.*modal-body') { Write-Host "SKIP (has modal): $f"; continue }

    # Inject modal + hover script before </body>
    $inject = "`n$modal`n$hoverScript`n"
    $c = $c -replace '</body>', "$inject</body>"
    [System.IO.File]::WriteAllText((Resolve-Path $f).Path, $c, [System.Text.Encoding]::UTF8)
    Write-Host "Injected modal: $f"
}

# Now update ALL existing modals to use new design (replace old product-card-modal content)
$allHtml = Get-ChildItem -Recurse -Filter '*.html'
foreach ($fi in $allHtml) {
    $c = [System.IO.File]::ReadAllText($fi.FullName, [System.Text.Encoding]::UTF8)
    if ($c -notmatch 'productSelectModal') { continue }
    $orig = $c

    # Update e-Sign card description
    $c = $c -replace '(<div[^>]*fw-bold[^>]*>Signulu e-Sign</div>\s*)<div[^<]*</div>', '$1<div style="font-size:12px;color:#888;">Sign contracts digitally. Legally binding &amp; secure.</div>'
    # Update DMS description
    $c = $c -replace '(<div[^>]*fw-bold[^>]*>DMS</div>\s*)<div[^<]*</div>', '$1<div style="font-size:12px;color:#888;">Document Management System. Digitize &amp; organize.</div>'
    # Update BulkSigner description
    $c = $c -replace '(<div[^>]*fw-bold[^>]*>BulkSigner</div>\s*)<div[^<]*</div>', '$1<div style="font-size:12px;color:#888;">DSC Bulk Signing Tool. Sign PDFs with Class 3 DSC.</div>'

    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($fi.FullName, $c, [System.Text.Encoding]::UTF8)
        Write-Host "Updated descriptions: $($fi.Name)"
    }
}

Write-Host "Done."
