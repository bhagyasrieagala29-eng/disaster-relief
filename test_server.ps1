$endpoints = @(
    "http://localhost:8080/",
    "http://localhost:8080/manifest.json",
    "http://localhost:8080/sw.js",
    "http://localhost:8080/schema.sql",
    "http://localhost:8080/css/style.css",
    "http://localhost:8080/js/app.js",
    "http://localhost:8080/js/supabase.js",
    "http://localhost:8080/js/speech.js",
    "http://localhost:8080/js/data.js",
    "http://localhost:8080/js/map.js",
    "http://localhost:8080/js/audio.js",
    "http://localhost:8080/js/store.js",
    "http://localhost:8080/js/triage.js"
)

foreach ($url in $endpoints) {
    try {
        $resp = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 5
        Write-Host "PASS: $url => HTTP $($resp.StatusCode), $($resp.Content.Length) bytes, Content-Type: $($resp.Headers['Content-Type'])"
    } catch {
        Write-Host "FAIL: $url => $_"
    }
}
