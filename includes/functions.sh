enumerate_subdomains(){
    echo "Enumerating subdomains of $1 using Sublist3r..."
    python3 $SUBLIST3R_PATH -o "$2/sublist3r.txt" -d $1 || true
    if [[ -f "$2/sublist3r.txt" ]]; then
        cat "$2/sublist3r.txt" >> "$2/subdomains.txt"
    fi
    echo "Enumerating subdomains of $1 using SubDomainizer..."
    python3 $SUBDOMAINIZER_PATH -u $1 -o "$2/subdomainizer.txt" || true
    if [[ -f "$2/subdomainizer.txt" ]]; then
        cat "$2/subdomainizer.txt" >> "$2/subdomains.txt"
    fi
    sort -u -o "$2/subdomains.txt" "$2/subdomains.txt"
    rm -f "$2/sublist3r.txt $2/subdomainizer.txt"
}

probe_subdomains(){
    target_name=$(basename "$1")
    echo "Probing subdomains of $target_name using httpx..."
    httpx -verbose -l "$1/subdomains.txt" -o "$1/tmp_httpx.txt"
    cat "$1/tmp_httpx.txt" >> "$1/httpx.txt"
    sort -u -o "$1/httpx.txt" "$1/httpx.txt" 
    rm -f "$1/tmp_httpx.txt"
}

cloud_bucket_enum(){
    target_name=$(basename "$1")
    echo "Checking cloud buckets of $target_name using cloud_enum..."
    python3 $CLOUD_ENUM_PATH -kf "$1/subdomains.txt" -l "$1/cloud_enum.txt" || true
    echo "Checking S3 buckets of $target_name using S3Scanner..."
    python3 $S3SCANNER_PATH -o "$1/s3scanner.txt" "$1/subdomains.txt" || true
}

git_hound(){
    target_name=$(basename "$1")
    echo "Checking for possible leaked secrets of $target_name on GitHub using githound..."
    git-hound --dig-files --dig-commits --many-results --threads 100 \
    --subdomain-file "$1/subdomains.txt" | tee "$1/githound.txt"
}

nuclei_scan(){
    nuclei_dir="$1/nuclei"
    if [[ ! -d $nuclei_dir ]]; then
        mkdir $nuclei_dir
    fi
    target_name=$(basename "$1")
    echo "Scanning for low-hanging issues of $target_name assets using nuclei..."
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/cves" -o "$nuclei_dir/cves.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/subdomain-takeover" -o "$nuclei_dir/subdomain-takeover.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/default-credentials" -o "$nuclei_dir/default-credentials.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/dns" -o "$nuclei_dir/dns.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/workflows" -o "$nuclei_dir/workflows.txt"
}

xss_scan(){
    target_name=$(basename "$1")
    echo "Scanning for XSS on $target_name assets using nuclei..."
    nuclei -silent -pbar -l "$1/urls.txt" -t "$NUCLEI_TEMPLATES_PATH/generic-detections/basic-xss-prober.yaml" -o "$1/basic_xss.txt"
    nuclei -silent -pbar -l "$1/urls.txt" -t "$NUCLEI_TEMPLATES_PATH/generic-detections/top-15-xss.yaml" -o "$1/top_15_xss.txt"
}

xss_strike(){
    # Note: configure blind XSS payload in xsstrike/core/config.py
    target_name=$(basename "$1")
    echo "Scanning for XSS on $target_name urls using xsstrike..."
    if [[ ! -f $XSSTRIKE_PATH ]]; then return; fi
    if [[ ! -d "$1/xsstrike" ]]; then
        mkdir "$1/xsstrike"
    fi
    while IFS= read -r site; do
        echo "Testing: $site"
        logfile=${site//[\/,:]/_}
        python3 $XSSTRIKE_PATH \
            --crawl --blind --params --skip \
            --file-log-level VULN --log-file $logfile \
            -u $site || true
    done < "$1/httpx.txt"
}

take_screenshots(){
    screenshots_dir="$1/screenshots"
    if [[ ! -d $screenshots_dir ]]; then
        mkdir $screenshots_dir
    fi
    target_name=$(basename "$1")
    echo "Taking screenshots of $target_name sites using aquatone..."
    cat "$1/httpx.txt" | aquatone -debug -ports=80,443 -resolution=800,600 -chrome-path=$CHROME_PATH -out $screenshots_dir
}

diff_handler(){
    sort -u -o "$1/tmp_$2.txt" "$1/tmp_$2.txt"
    if [[ ! -f "$1/$2.txt" ]]; then
        mv "$1/tmp_$2.txt" "$1/$2.txt"
    else
        diff -u "$1/$2.txt" "$1/tmp_$2.txt" | tee "$1/$2.diff"
        rm -f "$1/$2.txt"
        mv "$1/tmp_$2.txt" "$1/$2.txt"
        sort -u -o "$1/$2.txt" "$1/$2.txt"
    fi
}

notify_changes(){
    target_name=$(basename "$1")
    if [[ ! -s "$1/$2.diff" ]]; then
        echo "No changes detected in $1/$2.txt"
        return
    fi
    comment="Changes detected in $2.txt of $target_name"
    curl -F file="@$1/$2.diff" \
    -F "initial_comment=$comment" \
    -F "channels=$3" \
    -H "Authorization: Bearer $SLACKBOT_TOKEN" \
    https://slack.com/api/files.upload
    echo ""
}

notify_xss(){
    target_name=$(basename "$1")
    if [[ ! -f "$1/$2.txt" ]]; then
        return
    fi
    comment="XSS detected in $2.txt of $target_name"
    curl -F file="@$1/$2.txt" \
    -F "initial_comment=$comment" \
    -F "channels=$3" \
    -H "Authorization: Bearer $SLACKBOT_TOKEN" \
    https://slack.com/api/files.upload
    echo ""
}

crawl_urls(){
    target_name=$(basename "$1")
    echo "Fetching urls of $target_name using hakrawler..."
    cat "$1/httpx.txt" | hakrawler -plain -wayback -sitemap -robots -urls -insecure -depth 1 > "$1/tmp_urls.txt"
    diff_handler $1 "urls"
}

crawl_js(){
    target_name=$(basename "$1")
    echo "Fetching JS files of $target_name using hakrawler..."
    cat "$1/httpx.txt" | hakrawler -plain -js -insecure -depth 1 > "$1/tmp_js.txt"
    diff_handler $1 "js"
}
