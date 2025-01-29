from flask import Flask, render_template, request
import os
import glob
import string
import re

app = Flask(__name__)

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
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    file_path = os.path.join(parent_dir, filename)
    try:
        with open(file_path, 'r') as file:
            content = file.read()
            lines = content.split('\n')
            doc_url = lines[2].strip('# ') if len(lines) > 2 and lines[2].startswith('# http') else ''
            return content, doc_url
    except Exception as e:
        return f"Error reading file: {str(e)}", ''

def render_script_with_variables(content, config_dict):
    try:
        template = string.Template(content)
        rendered_content = template.safe_substitute(config_dict)
        return rendered_content
    except Exception as e:
        return f"Error rendering script: {str(e)}"

@app.route('/', methods=['GET'])
def index():
    global config
    search_query = request.args.get('search', '').lower()
    selected_script = request.args.get('script', '')
    scripts = get_shell_scripts()
    
    if search_query:
        scripts = [script for script in scripts if search_query in script.lower()]
    
    script_content = ''
    rendered_content = ''
    doc_url = ''
    if selected_script:
        script_content, doc_url = get_script_content(selected_script)
        rendered_content = render_script_with_variables(script_content, config)
    
    return render_template('index.html', 
                         scripts=scripts, 
                         search_query=search_query,
                         selected_script=selected_script,
                         script_content=script_content,
                         rendered_content=rendered_content,
                         doc_url=doc_url,
                         config=config)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000) 
