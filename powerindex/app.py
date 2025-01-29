from flask import Flask, render_template, request
import os
import glob
import string

app = Flask(__name__)

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
                    # Strip quotes and whitespace from value
                    value = value.strip().strip('"\'')
                    config[key.strip()] = value
    except Exception as e:
        print(f"Error reading config file: {str(e)}")
    
    return config

# Load config when app starts
config = read_config()

def get_shell_scripts():
    # Get the parent directory path
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    # Find all .sh files in the parent directory
    shell_scripts = glob.glob(os.path.join(parent_dir, '*.sh'))
    # Extract just the filenames from the full paths
    return [os.path.basename(script) for script in shell_scripts]

def render_script_with_variables(content, config_dict):
    try:
        # Create a template from the content
        template = string.Template(content)
        # Substitute variables from config
        rendered_content = template.safe_substitute(config_dict)
        return rendered_content
    except Exception as e:
        return f"Error rendering script: {str(e)}"

def get_script_content(filename):
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    file_path = os.path.join(parent_dir, filename)
    try:
        with open(file_path, 'r') as file:
            content = file.read()
            # Get the third line and check if it's a URL comment
            lines = content.split('\n')
            doc_url = lines[2].strip('# ') if len(lines) > 2 and lines[2].startswith('# http') else ''
            return content, doc_url
    except Exception as e:
        return f"Error reading file: {str(e)}", ''

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
    app.run(debug=True, host='0.0.0.0', port=5000) 