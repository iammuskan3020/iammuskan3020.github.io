# iammuskan3020.github.io

## Footer Credit Redirect Fix

This repository contains tools and documentation to help you identify and remove malicious redirect code from your website.

### 🚨 Problem

Some website templates include hidden JavaScript code that redirects visitors to another website when you try to modify or remove footer credits. This is an unethical practice that can harm your website's reputation and user experience.

### ✅ Solution

This repository provides:

1. **Comprehensive Guide** (`FOOTER_REDIRECT_FIX_GUIDE.md`) - Detailed explanation of common malicious patterns and how to fix them
2. **Clean Template** (`index.html`) - A safe, redirect-free HTML template you can use as a starting point
3. **Scanner Script** (`scan_for_redirects.sh`) - Automated tool to scan your files for malicious code

### 🔍 How to Use

#### Option 1: Use the Clean Template
Simply use the provided `index.html` as your starting point. It's a clean, modern template with no malicious code.

#### Option 2: Fix Your Existing Code

1. **Add your existing HTML/JS files** to this repository
2. **Run the scanner**:
   ```bash
   ./scan_for_redirects.sh
   ```
3. **Review the findings** and check `FOOTER_REDIRECT_FIX_GUIDE.md` for guidance
4. **Remove malicious code** following the guide
5. **Test your changes** to ensure no redirects occur

### 📚 Documentation

- [Footer Redirect Fix Guide](FOOTER_REDIRECT_FIX_GUIDE.md) - Complete guide with examples

### 🌐 Live Site

This site is hosted at: [bharatverseh.me](https://bharatverseh.me)

### 🛠️ Common Malicious Patterns

The scanner looks for:
- `window.location` redirects
- `MutationObserver` that monitors DOM changes
- Obfuscated code using `eval()`, `atob()`, `btoa()`
- `setInterval`/`setTimeout` with redirects
- Meta refresh tags
- DOM event listeners (DOMNodeRemoved, DOMSubtreeModified)

### 📝 Next Steps

If you have files with redirect issues:
1. Add them to this repository
2. Run the scanner
3. Follow the guide to clean them up
4. Test thoroughly before deploying

### 💡 Need Help?

If you need assistance:
1. Add your problematic files to this repo
2. Open an issue describing the problem
3. We can help identify and remove the malicious code

---

**Note**: This is a safe, clean repository. The provided template and tools are free from any malicious code.