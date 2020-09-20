enumerate_subdomains(){
    echo "Enumerating subdomains of $1 using Sublist3r..."
    python3 $SUBLIST3R_PATH -o "$2/sublist3r.txt" -d $1
    echo "Enumerating subdomains of $1 using SubDomainizer..."
    python3 $SUBDOMAINIZER_PATH -u $1 -o "$2/subdomainizer.txt"
    cat "$2/sublist3r.txt" >> "$2/subdomains.txt"
    cat "$2/subdomainizer.txt" >> "$2/subdomains.txt"
    sort -u -o "$2/subdomains.txt" "$2/subdomains.txt"
    rm -f sublist3r.txt subdomainizer.txt
}

probe_subdomains(){
    echo "Probing subdomains using httpx..."
    httpx -verbose -l "$1/subdomains.txt" -o "$1/httpx.txt"
}

cloud_bucket_enum(){
    echo "Checking cloud buckets using cloud_enum..."
    python3 $CLOUD_ENUM_PATH -kf "$1/subdomains.txt" -l "$1/cloud_enum.txt" || true
    echo "Checking S3 buckets using S3Scanner..."
    python3 $S3SCANNER_PATH -o "$1/s3scanner.txt" "$1/subdomains.txt" || true
}

nuclei_scan(){
    nuclei_dir="$1/nuclei"
    if [[ ! -d $nuclei_dir ]]; then
        mkdir $nuclei_dir
    fi
    echo "Scanning for low-hanging fruits using nuclei..."
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/cves" -o "$nuclei_dir/cves.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/subdomain-takeover" -o "$nuclei_dir/subdomain-takeover.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/default-credentials" -o "$nuclei_dir/default-credentials.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/generic-detections" -o "$nuclei_dir/generic-detections.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/dns" -o "$nuclei_dir/dns.txt"
    nuclei -pbar -l "$1/httpx.txt" -t "$NUCLEI_TEMPLATES_PATH/files" -o "$nuclei_dir/files.txt"
}

take_screenshots(){
    screenshots_dir="$1/screenshots"
    if [[ ! -d $screenshots_dir ]]; then
        mkdir $screenshots_dir
    fi
    echo "Taking screenshots..."
    cat "$1/httpx.txt" | aquatone -debug -ports=80,443 -resolution=800,600 -chrome-path=$CHROME_PATH -out $screenshots_dir
}
