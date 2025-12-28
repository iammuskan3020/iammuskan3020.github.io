#!/bin/bash

# Script to scan HTML and JavaScript files for malicious redirect patterns
# This helps identify code that might redirect your site when footer credits are changed

echo "==========================================="
echo "Malicious Redirect Scanner"
echo "==========================================="
echo ""

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to scan a file
scan_file() {
    local file="$1"
    local found_issues=0
    
    echo "Scanning: $file"
    
    # Check for window.location redirects
    if grep -i "window\.location\|location\.href\|location\.replace" "$file" > /dev/null 2>&1; then
        echo -e "${RED}  ⚠ Found window.location usage${NC}"
        grep -n -i "window\.location\|location\.href\|location\.replace" "$file" | head -3
        found_issues=1
    fi
    
    # Check for MutationObserver
    if grep -i "MutationObserver" "$file" > /dev/null 2>&1; then
        echo -e "${YELLOW}  ⚠ Found MutationObserver (may monitor DOM changes)${NC}"
        grep -n -i "MutationObserver" "$file" | head -3
        found_issues=1
    fi
    
    # Check for eval/atob (obfuscation)
    if grep -E "eval\(|atob\(|btoa\(" "$file" > /dev/null 2>&1; then
        echo -e "${RED}  ⚠ Found eval/atob/btoa (possible obfuscation)${NC}"
        grep -n -E "eval\(|atob\(|btoa\(" "$file" | head -3
        found_issues=1
    fi
    
    # Check for setInterval/setTimeout with suspicious content
    if grep -i "setInterval\|setTimeout" "$file" > /dev/null 2>&1; then
        echo -e "${YELLOW}  ⚠ Found setInterval/setTimeout${NC}"
        grep -n -i "setInterval\|setTimeout" "$file" | head -3
        found_issues=1
    fi
    
    # Check for meta refresh
    if grep -i "meta.*refresh" "$file" > /dev/null 2>&1; then
        echo -e "${RED}  ⚠ Found meta refresh tag${NC}"
        grep -n -i "meta.*refresh" "$file" | head -3
        found_issues=1
    fi
    
    # Check for DOMNodeRemoved events
    if grep -i "DOMNodeRemoved\|DOMSubtreeModified" "$file" > /dev/null 2>&1; then
        echo -e "${RED}  ⚠ Found DOM modification event listeners${NC}"
        grep -n -i "DOMNodeRemoved\|DOMSubtreeModified" "$file" | head -3
        found_issues=1
    fi
    
    # Check for suspicious external URLs
    if grep -E "http[s]?://[a-zA-Z0-9.-]+\.(com|net|org|info)" "$file" | grep -v "github\|googleapis\|cloudflare\|jsdelivr\|unpkg" > /dev/null 2>&1; then
        echo -e "${YELLOW}  ⚠ Found external URLs (check if suspicious)${NC}"
        grep -n -E "http[s]?://[a-zA-Z0-9.-]+\.(com|net|org|info)" "$file" | grep -v "github\|googleapis\|cloudflare\|jsdelivr\|unpkg" | head -3
        found_issues=1
    fi
    
    if [ $found_issues -eq 0 ]; then
        echo -e "${GREEN}  ✓ No obvious malicious patterns found${NC}"
    fi
    
    echo ""
}

# Main scanning logic
total_issues=0
files_scanned=0

echo "Scanning HTML files..."
echo "-------------------------------------------"
# Enable globstar for ** pattern
shopt -s globstar nullglob 2>/dev/null || true
for file in *.html **/*.html; do
    if [ -f "$file" ] && [ "$file" != "$file" ]; then
        continue
    fi
    if [ -f "$file" ]; then
        # Count each file only once
        already_scanned=false
        if [ -n "${scanned_files[$file]}" ]; then
            already_scanned=true
        fi
        
        if [ "$already_scanned" = false ]; then
            scan_file "$file"
            files_scanned=$((files_scanned + 1))
            scanned_files[$file]=1
            if [ $found_issues -eq 1 ]; then
                ((total_issues++))
            fi
        fi
    fi
done

echo ""
echo "Scanning JavaScript files..."
echo "-------------------------------------------"
for file in *.js **/*.js; do
    if [ -f "$file" ]; then
        scan_file "$file"
        files_scanned=$((files_scanned + 1))
        if [ $found_issues -eq 1 ]; then
            ((total_issues++))
        fi
    fi
done

echo "==========================================="
echo "Scanned $files_scanned file(s)"
if [ $total_issues -gt 0 ]; then
    echo -e "${RED}Found potential issues in $total_issues file(s).${NC}"
    echo "Review the flagged code carefully."
    echo "See FOOTER_REDIRECT_FIX_GUIDE.md for details on fixing."
else
    echo -e "${GREEN}No obvious malicious patterns detected!${NC}"
fi
echo "==========================================="
