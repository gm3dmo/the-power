import os
import glob
import string
import re
import subprocess
import sqlite3
from flask import Flask, render_template, request, jsonify
from pygments import highlight
from pygments.lexers import BashLexer, JsonLexer
from pygments.formatters import HtmlFormatter
import json

def update_curl_flags():
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    config_path = os.path.join(parent_dir, '.gh-api-examples.conf')
    
    old_flag = 'curl_custom_flags="--fail-with-body --no-progress-meter"'
    new_flag = 'curl_custom_flags="--fail-with-body --no-progress-meter --write-out %output{a.txt}%{json}%output{b.txt}%{header_json}"'
    
    try:
        # Read the current content
        with open(config_path, 'r') as file:
            content = file.read()
        
        # Replace the line if it exists
        if old_flag in content:
            content = content.replace(old_flag, new_flag)
            
            # Write the updated content back
            with open(config_path, 'w') as file:
                file.write(content)
            print("Updated curl flags in config file")
    except Exception as e:
        print(f"Error updating config file: {str(e)}")

# Run the update immediately
update_curl_flags()

# Initialize the database
def init_db():
    db_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'the-power.db')
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Create FTS5 table
    cursor.execute('''
        CREATE VIRTUAL TABLE IF NOT EXISTS scripts_fts USING fts5(
            script,
            body
        )
    ''')
    
    # Clear existing entries
    cursor.execute('DELETE FROM scripts_fts')
    
    # Load all scripts into the database
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    shell_scripts = glob.glob(os.path.join(parent_dir, '*.sh'))
    
    for script_path in shell_scripts:
        script_name = os.path.basename(script_path)
        try:
            with open(script_path, 'r') as file:
                content = file.read()
                cursor.execute('INSERT INTO scripts_fts (script, body) VALUES (?, ?)',
                             (script_name, content))
        except Exception as e:
            print(f"Error loading script {script_name}: {str(e)}")
    
    conn.commit()
    conn.close()
    print(f"Database initialized at {db_path}")

# Add database initialization before Flask app creation
init_db()

app = Flask(__name__)

# Add this at the top level for use in the template
app.jinja_env.globals['highlight_style'] = HtmlFormatter().get_style_defs('.highlight')

def scrub_github_token(value):
    """Helper function to scrub GitHub tokens"""
    # Look for both ghX_ and github_pat_ patterns
    gh_pattern = r'(gh[a-zA-Z]_[a-zA-Z0-9]+)'
    pat_pattern = r'(github_pat_[a-zA-Z0-9_]+)'
    
    # Check for ghX_ pattern
    value = re.sub(gh_pattern, lambda m: f"{m.group(1)[:3]}_***{m.group(1)[-8:]}", value)
    
    # Check for github_pat_ pattern
    value = re.sub(pat_pattern, lambda m: f"github_pat_***{m.group(1)[-8:]}", value)
    
    return value

def scrub_password(key, value):
    """Helper function to scrub password values with specific replacements"""
    password_replacements = {
        'admin_password': 'an_admin_password',
        'mgmt_password': 'an_mgmt_password'
    }
    return password_replacements.get(key, value)

def read_config():
    config = {}
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    config_path = os.path.join(parent_dir, '.gh-api-examples.conf')
    
    try:
        with open(config_path, 'r') as file:
            for line in file:
                # Strip whitespace and skip empty lines or comments
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                    
                # Split on first occurrence of '=' and store in config dict
                if '=' in line:
                    key, value = line.split('=', 1)
                    key = key.strip()
                    # Strip quotes and whitespace from value
                    value = value.strip().strip('"\'')
                    
                    # Scrub passwords with specific replacements
                    if key in ['admin_password', 'mgmt_password']:
                        value = scrub_password(key, value)
                    else:
                        # Scrub any GitHub tokens in the value
                        value = scrub_github_token(value)
                    
                    config[key] = value
    except Exception as e:
        print(f"Error reading config file: {str(e)}")
    
    return config

# Load config when app starts
config = read_config()

def get_shell_scripts():
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    shell_scripts = glob.glob(os.path.join(parent_dir, '*.sh'))
    return [os.path.basename(script) for script in shell_scripts]

def get_script_content(filename):
    from werkzeug.utils import secure_filename
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    
    # Sanitize the filename
    safe_filename = secure_filename(filename)
    file_path = os.path.normpath(os.path.join(parent_dir, safe_filename))
    
    # Ensure the file path is within the parent directory
    if not file_path.startswith(parent_dir):
        return "Error: Access to the requested file is not allowed.", '', ''
    
    try:
        with open(file_path, 'r') as file:
            content = file.read()
            lines = content.split('\n')
            doc_url = lines[2].strip('# ') if len(lines) > 2 and lines[2].startswith('# http') else ''
            
            # Highlight the original script
            highlighted_content = highlight(content, BashLexer(), HtmlFormatter())
            
            return content, doc_url, highlighted_content
    except Exception as e:
        return f"Error reading file: {str(e)}", '', ''

def render_script_with_variables(content, config):
    """Replace variables in script content with their values from config"""
    if not content:
        return ''
    
    # Replace each config variable in the content
    rendered = content
    for key, value in config.items():
        if key == 'GITHUB_API_BASE_URL':
            rendered = rendered.replace('"${' + key + '}"', value)
            rendered = rendered.replace('${' + key + '}', value)
        else:
            rendered = rendered.replace('${' + key + '}', value)
    
    # Apply syntax highlighting to the rendered script
    try:
        highlighted = highlight(rendered, BashLexer(), HtmlFormatter())
        return highlighted
    except Exception as e:
        print(f"Error highlighting rendered script: {str(e)}")
        return rendered

@app.route('/', methods=['GET'])
def index():
    global config
    search_query = request.args.get('search', '').lower()
    selected_script = request.args.get('script', '')
    scripts = sorted(get_shell_scripts())  # Sort the scripts alphabetically
    
    if search_query:
        scripts = [script for script in scripts if search_query in script.lower()]
    
    script_content = ''
    doc_url = ''
    highlighted_content = ''
    rendered_content = ''
    if selected_script:
        script_content, doc_url, highlighted_content = get_script_content(selected_script)
        rendered_content = render_script_with_variables(script_content, config)
    
    return render_template('index.html', 
                         scripts=scripts,
                         search_query=search_query,
                         selected_script=selected_script,
                         script_content=script_content,
                         rendered_content=rendered_content,
                         highlighted_content=highlighted_content,
                         doc_url=doc_url,
                         config=config)

@app.route('/execute', methods=['POST'])
def execute_script():
    script = request.json.get('script')
    if not script:
        return jsonify({'error': 'No script specified'}), 400
    
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    script_path = os.path.join(parent_dir, script)
    
    try:
        # Run the script
        process = subprocess.Popen(
            ['bash', script_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            cwd=parent_dir,
            text=True
        )
        stdout, stderr = process.communicate()
        
        # Scrub sensitive data from stderr
        stderr = scrub_github_token(stderr)
        
        # Try to read and highlight headers from b.txt
        headers_path = os.path.join(parent_dir, 'b.txt')
        headers_content = ''
        if os.path.exists(headers_path):
            with open(headers_path, 'r') as f:
                headers_content = f.read()
                try:
                    # Parse and format as JSON
                    headers_json = json.loads(headers_content)
                    headers_content = json.dumps(headers_json, indent=2)
                    headers_content = highlight(headers_content, JsonLexer(), HtmlFormatter())
                except json.JSONDecodeError:
                    # If not valid JSON, leave as is
                    pass

        # Handle stdout JSON highlighting as before
        try:
            json_obj = json.loads(stdout)
            formatted_json = json.dumps(json_obj, indent=2)
            highlighted_stdout = highlight(formatted_json, JsonLexer(), HtmlFormatter())
        except json.JSONDecodeError:
            highlighted_stdout = stdout

        return jsonify({
            'stdout': highlighted_stdout,
            'stderr': stderr,
            'headers': headers_content,
            'returncode': process.returncode,
            'is_json': True if 'highlighted_stdout' in locals() else False
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.template_filter('highlight_search')
def highlight_search(text, search):
    if not search:
        return text
    pattern = re.compile(f'({re.escape(search)})', re.IGNORECASE)
    return pattern.sub(r'<span class="highlight">\1</span>', text)

@app.route('/search', methods=['GET'])
def search():
    query = request.args.get('q', '')
    results = []
    
    if query:
        # Use the same database path as init_db()
        db_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'the-power.db')
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        # Use FTS5 match to find results and highlight matching text
        cursor.execute('''
            SELECT script, snippet(scripts_fts, 1, '<mark>', '</mark>', '...', 50) 
            FROM scripts_fts 
            WHERE body MATCH ? 
            ORDER BY rank
        ''', (query,))
        
        results = cursor.fetchall()
        conn.close()
    
    return render_template('search.html', query=query, results=results)

if __name__ == '__main__':
    app.run(debug=False , host='localhost', port=8001) 
