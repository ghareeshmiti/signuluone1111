$blogDir = "c:\Hareesh\SignuluONE\mi.signulu.website\blog"
$files = Get-ChildItem "$blogDir\*.html"

$oldStr = '        <li class="nav-item"><a class="nav-link" href="../pricing.html">Pricing</a></li>
        <li class="nav-item"><a class="nav-link" href="../Blog.html">Blog</a></li>
        <li class="nav-item"><a class="nav-link" href="../about.html">About</a></li>'

$newStr = '        <li class="nav-item"><a class="nav-link" href="../Blog.html">Blog</a></li>
        <li class="nav-item"><a class="nav-link" href="../pricing.html">Pricing</a></li>
        <li class="nav-item"><a class="nav-link" href="../about.html">About</a></li>'

$count = 0
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    if ($content -like "*$oldStr*") {
        $content = $content.Replace($oldStr, $newStr)
        Set-Content $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "Updated: $($file.Name)"
        $count++
    } else {
        Write-Host "SKIP: $($file.Name)"
    }
}
Write-Host "Done. Updated $count files."
