$dir = "c:\Hareesh\SignuluONE\mi.signulu.website"

$latoLink = '    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700;900&display=swap" rel="stylesheet">'

# Updated sg-topnav CSS with Lato font forced
$newNavCss = '    <style>
      /* SignuluOne standard navbar overrides */
      .sg-topnav { background: #fff !important; box-shadow: 0 2px 12px rgba(0,0,0,.08); font-family: ''Lato'', sans-serif !important; }
      .sg-topnav .navbar-brand img { height: 40px; }
      .sg-topnav .nav-link { font-weight: 700 !important; color: #333 !important; padding: 8px 14px !important; font-family: ''Lato'', sans-serif !important; font-size: 15px !important; }
      .sg-topnav .nav-link:hover { color: #5A30F1 !important; }
      .sg-topnav .dropdown-mega { position: static !important; }
      .sg-topnav .dropdown-mega-menu { width: 100% !important; left: 0 !important; right: 0 !important; padding: 24px !important; border: none !important; box-shadow: 0 8px 32px rgba(0,0,0,0.12) !important; border-top: 3px solid #5A30F1 !important; font-family: ''Lato'', sans-serif !important; }
      .sg-topnav .sg-mm-title { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: #5A30F1; border-bottom: 2px solid #5A30F1; padding-bottom: 8px; margin-bottom: 12px; font-family: ''Lato'', sans-serif; }
      .sg-topnav .sg-mm-item { display: flex !important; align-items: flex-start; padding: 8px 10px; border-radius: 8px; text-decoration: none !important; color: #333 !important; transition: background 0.2s; font-family: ''Lato'', sans-serif; }
      .sg-topnav .sg-mm-item:hover { background: #f0ebff; color: #5A30F1 !important; }
      .sg-topnav .sg-mm-icon { width: 36px; height: 36px; border-radius: 8px; background: #f0ebff; display: flex; align-items: center; justify-content: center; flex-shrink: 0; margin-right: 10px; }
      .sg-topnav .sg-mm-icon i { color: #5A30F1; font-size: 16px; }
      .sg-topnav .sg-mm-item-title { font-weight: 700; font-size: 13px; margin-bottom: 2px; }
      .sg-topnav .sg-mm-item-desc { font-size: 11px; color: #777; }
      .sg-prod-card { border: 2px solid #e9ecef; border-radius: 12px; padding: 20px; text-align: center; text-decoration: none; color: #333; transition: border-color 0.2s, transform 0.2s; display: block; }
      .sg-prod-card:hover { border-color: #5A30F1; transform: translateY(-2px); color: #333; }
      .sg-prod-icon { width: 56px; height: 56px; border-radius: 50%; background: #f0ebff; display: flex; align-items: center; justify-content: center; margin: 0 auto 12px; }
      .sg-prod-icon i { font-size: 24px; color: #5A30F1; }
    </style>'

# Pages that use sg-topnav (old style pages)
$sgPages = Get-ChildItem "$dir\*.html" | Where-Object {
    (Get-Content $_.FullName -Raw -Encoding UTF8) -like "*sg-topnav*"
}

$count = 0
foreach ($file in $sgPages) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # Replace the old sg-topnav style block with the new one (with Lato forced)
    if ($content -like "*font-family: ''Lato''*" -and $content -like "*sg-topnav*") {
        Write-Host "SKIP (already has Lato): $($file.Name)"
        continue
    }

    # Replace the existing sg-topnav style block
    $content = [regex]::Replace($content, '(?s)    <style>\s*\/\* SignuluOne standard navbar overrides \*\/.*?</style>', $newNavCss)

    # Add Lato Google Font if not present
    if ($content -notlike "*Lato*") {
        $content = $content -replace '(?i)(</head>)', "$latoLink`n`$1"
    }

    Set-Content $file.FullName -Value $content -Encoding UTF8 -NoNewline
    Write-Host "Updated: $($file.Name)"
    $count++
}

# Also fix the "new style" pages (Blog.html, blog posts, pricing.html, etc.) to ensure
# Products/Why Signulu dropdown matches the same style
# These pages use .mega-menu-* classes - just ensure they have consistent CSS
$newStylePages = @(
    "$dir\Blog.html",
    "$dir\pricing.html",
    "$dir\signing-solutions.html",
    "$dir\why-signulu.html",
    "$dir\index.html"
)

$megaNavCssCheck = '.mega-menu-item { display: flex'
$megaNavCssBlock = '    <style>
      :root { --primary: #5A30F1; }
      .navbar { padding: 12px 0; }
      .navbar-brand img { height: 40px; }
      .nav-link { font-weight: 700 !important; color: #333 !important; padding: 8px 14px !important; font-family: ''Lato'', sans-serif !important; font-size: 15px !important; }
      .nav-link:hover { color: #5A30F1 !important; }
      .dropdown-mega { position: static !important; }
      .dropdown-mega-menu { width: 100%; left: 0 !important; right: 0 !important; padding: 24px; border: none; box-shadow: 0 8px 32px rgba(0,0,0,0.12); border-top: 3px solid #5A30F1; }
      .mega-menu-title { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: #5A30F1; border-bottom: 2px solid #5A30F1; padding-bottom: 8px; margin-bottom: 12px; }
      .mega-menu-item { display: flex; align-items: flex-start; padding: 8px 10px; border-radius: 8px; text-decoration: none; color: #333; transition: background 0.2s; }
      .mega-menu-item:hover { background: #f0ebff; color: #5A30F1; }
      .mega-menu-icon { width: 36px; height: 36px; border-radius: 8px; background: #f0ebff; display: flex; align-items: center; justify-content: center; flex-shrink: 0; margin-right: 10px; }
      .mega-menu-icon i { color: #5A30F1; font-size: 16px; }
      .mega-menu-item-title { font-weight: 700; font-size: 13px; margin-bottom: 2px; }
      .mega-menu-item-desc { font-size: 11px; color: #777; }
    </style>'

foreach ($fp in $newStylePages) {
    $content = Get-Content $fp -Raw -Encoding UTF8
    $changed = $false

    # Ensure nav-link font-weight is 700 and font-family is Lato
    if ($content -notlike "*font-weight: 700*" -or $content -notlike "*.nav-link*Lato*") {
        # Update existing .nav-link CSS to add font-family
        $content = $content -replace '\.nav-link \{ font-weight: 600;', '.nav-link { font-weight: 700; font-family: ''Lato'', sans-serif;'
        $content = $content -replace "\.nav-link \{ font-weight: 600 !important;", ".nav-link { font-weight: 700 !important; font-family: 'Lato', sans-serif !important;"
        $changed = $true
    }

    if ($changed) {
        Set-Content $fp -Value $content -Encoding UTF8 -NoNewline
        Write-Host "Font updated: $(Split-Path $fp -Leaf)"
    } else {
        Write-Host "OK: $(Split-Path $fp -Leaf)"
    }
}

# Fix blog posts too
$blogFiles = Get-ChildItem "$dir\blog\*.html"
foreach ($file in $blogFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    if ($content -like "*font-weight: 600;*" -and $content -like "*.nav-link*") {
        $content = $content -replace '\.nav-link \{ font-weight: 600;', '.nav-link { font-weight: 700; font-family: ''Lato'', sans-serif;'
        Set-Content $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "Blog font updated: $($file.Name)"
    }
}

Write-Host "Done. sg-topnav pages updated: $count"
