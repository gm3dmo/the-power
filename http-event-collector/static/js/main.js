document.addEventListener('DOMContentLoaded', function() {
    // Add event listeners for search form
    const searchForm = document.querySelector('.search-form');
    const searchInput = document.querySelector('input[name="q"]');

    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            if (!searchInput.value.trim()) {
                e.preventDefault();
                searchInput.focus();
            }
        });
    }

    // Add copy functionality to event data
    document.querySelectorAll('.event-data').forEach(eventData => {
        const copyButton = document.createElement('button');
        copyButton.textContent = 'Copy';
        copyButton.className = 'copy-button';
        copyButton.style.cssText = 'position: absolute; top: 10px; right: 10px; padding: 5px 10px; font-size: 12px;';
        
        eventData.style.position = 'relative';
        eventData.appendChild(copyButton);

        copyButton.addEventListener('click', function() {
            const text = eventData.querySelector('pre').textContent;
            navigator.clipboard.writeText(text).then(() => {
                const originalText = copyButton.textContent;
                copyButton.textContent = 'Copied!';
                setTimeout(() => {
                    copyButton.textContent = originalText;
                }, 2000);
            });
        });
    });

    // Add keyboard shortcut for search
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + K to focus search
        if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
            e.preventDefault();
            if (searchInput) {
                searchInput.focus();
            }
        }
    });
}); 