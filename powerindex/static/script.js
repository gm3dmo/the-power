function searchConfig() {
    const input = document.getElementById('configSearch');
    const filter = input.value.toLowerCase();
    const table = document.getElementById('configTable');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {  // Start from 1 to skip header
        const row = rows[i];
        const cells = row.getElementsByTagName('td');
        const key = cells[0].textContent || cells[0].innerText;
        const value = cells[1].textContent || cells[1].innerText;
        
        if (key.toLowerCase().indexOf(filter) > -1 || 
            value.toLowerCase().indexOf(filter) > -1) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    }
}

function copyToClipboard(text) {
    const evt  = event;
    navigator.clipboard.writeText(text).then(function() {
        const button = evt.target;
        const originalText = button.textContent;
        button.textContent = 'Copied!';
        setTimeout(() => {
            button.textContent = originalText;
        }, 2000);
    }).catch(function(err) {
        console.error('Failed to copy text: ', err);
    });
}

function copyScriptContent(elementId) {
    const evt = event;
    const content = document.getElementById(elementId).textContent;
    navigator.clipboard.writeText(content).then(function() {
        const button = evt.target;
        const originalText = button.textContent;
        button.textContent = 'Copied!';
        setTimeout(() => {
            button.textContent = originalText;
        }, 2000);
    }).catch(function(err) {
        console.error('Failed to copy text: ', err);
    });
}

function searchOutput(elementId) {
    const searchText = document.getElementById(elementId + 'Search').value.toLowerCase();
    const outputElement = document.getElementById(elementId);
    let content = outputElement.textContent;  // Use textContent instead of innerHTML for initial content

    // Clear any existing highlights
    content = content.replace(/<mark class="highlight-search">/g, '')
                    .replace(/<\/mark>/g, '');

    if (!searchText) {
        outputElement.innerHTML = content;
        return;
    }

    // Simple text replacement with highlighting
    const regex = new RegExp(searchText, 'gi');
    content = content.replace(regex, match => 
        `<mark class="highlight-search">${match}</mark>`
    );

    outputElement.innerHTML = content;
}

function executeScript(scriptName) {
    const button = document.querySelector('.execute-button');
    button.disabled = true;
    button.textContent = 'Executing...';

    // Clear both search boxes when executing new script
    document.getElementById('stdoutSearch').value = '';
    document.getElementById('headersSearch').value = '';

    fetch('/execute', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ script: scriptName })
    })
    .then(response => response.json())
    .then(data => {
        const stdoutElement = document.getElementById('stdout');
        const headersElement = document.getElementById('headers');
        
        if (data.is_json) {
            stdoutElement.innerHTML = data.stdout;
        } else {
            stdoutElement.textContent = data.stdout || '';
        }
        
        // Always use innerHTML for headers as it contains highlighted JSON
        headersElement.innerHTML = data.headers || '';
        
        document.getElementById('stderr').textContent = data.stderr || '';
        button.textContent = 'Execute';
        button.disabled = false;
    })
    .catch(error => {
        console.error('Error:', error);
        document.getElementById('stderr').textContent = 'Error executing script: ' + error;
        button.textContent = 'Execute';
        button.disabled = false;
    });
} 