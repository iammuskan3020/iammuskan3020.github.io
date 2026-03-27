# Footer Credit Redirect Fix Guide

## Problem Description
Some website templates include malicious JavaScript code that redirects users to another website when they try to modify or remove footer credits. This is an unethical practice used by some template creators to force attribution.

## Common Malicious Patterns to Look For

### 1. **DOM Mutation Observers**
JavaScript that watches for changes to footer elements:
```javascript
// Example malicious code
var observer = new MutationObserver(function() {
    window.location.href = "http://malicious-site.com";
});
observer.observe(document.querySelector('footer'), {childList: true, subtree: true});
```

### 2. **Obfuscated JavaScript**
Base64 encoded or heavily minified code that's hard to read:
```javascript
// Example
eval(atob("d2luZG93LmxvY2F0aW9uLmhyZWY9Imh0dHA6Ly9leGFtcGxlLmNvbSI="));
```

### 3. **Interval Checks**
Code that periodically checks if footer credits still exist:
```javascript
// Example malicious code
setInterval(function() {
    if (!document.querySelector('.footer-credit')) {
        window.location.href = "http://malicious-site.com";
    }
}, 1000);
```

### 4. **Event Listeners**
Hidden event handlers on footer elements:
```javascript
// Example
document.querySelector('footer').addEventListener('DOMNodeRemoved', function() {
    window.location.href = "http://malicious-site.com";
});
```

### 5. **Hidden Meta Refresh or iFrames**
```html
<meta http-equiv="refresh" content="0;url=http://malicious-site.com" style="display:none">
<iframe src="http://malicious-site.com" style="display:none"></iframe>
```

## How to Fix Your Website

### Step 1: Find All JavaScript Files
Search through all `.js` files and `<script>` tags in your HTML files.

### Step 2: Look for Suspicious Code
- Search for keywords: `window.location`, `location.href`, `location.replace`, `meta refresh`, `MutationObserver`, `setInterval`, `setTimeout`
- Look for obfuscated code: `eval()`, `atob()`, `btoa()`, heavily minified code
- Check for references to external domains in redirects

### Step 3: Remove Malicious Code
1. **Back up your files first**
2. Remove any suspicious JavaScript that matches the patterns above
3. Remove any hidden iframes or meta refresh tags
4. Clean up obfuscated code

### Step 4: Replace Footer Credits
Once malicious code is removed, you can safely modify footer credits:
```html
<footer>
    <p>&copy; 2025 Your Name. All rights reserved.</p>
</footer>
```

## Prevention

1. **Use reputable templates** from trusted sources
2. **Review all code** before deploying
3. **Use browser developer tools** to monitor network requests for unexpected redirects
4. **Test thoroughly** after making changes

## Need Help?

If you have existing HTML/JS files with this issue:
1. Share the files in this repository
2. We can help identify and remove the malicious code
3. Create a clean version of your site

## Example Clean Template

A basic clean template without any malicious code is provided in `index.html` in this repository.
