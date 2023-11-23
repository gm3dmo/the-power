import os
import json
import subprocess

from flask import Flask, render_template, request
from flask_wtf import FlaskForm
from wtforms import SelectField

from pygments import highlight
from pygments.lexers import HttpLexer
from pygments.lexers import JsonLexer
from pygments.lexers import get_lexer_by_name

from pygments.formatters import HtmlFormatter
from pygments.formatters import HtmlFormatter

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret_key'

# Specify the directory where the scripts are located
SCRIPTS_DIR = '.'

# Define a form with a dropdown list of script filenames
class ScriptForm(FlaskForm):
    script = SelectField('Select Script', choices=[])

# Populate the dropdown list with script filenames
def populate_scripts():
    scripts = []
    for filename in sorted(os.listdir(SCRIPTS_DIR)):
        if filename.endswith('.sh'):
            scripts.append((filename, filename))
    return scripts

# Define a route for the index page
@app.route('/', methods=['GET', 'POST'])
def index():
    # Create an instance of the script form
    form = ScriptForm()
    form.script.choices = populate_scripts()

    # Initialize the output variable
    output = None
    colorized_output = None
    headers = None
    colorized_error = None

    if request.method == 'POST' and form.validate_on_submit():
        # Get the selected script filename from the form
        script_filename = form.script.data
        process = subprocess.Popen(["sh", f"{SCRIPTS_DIR}/{script_filename}"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output1, error = process.communicate()
        output1 = output1.decode('utf-8')  # decode from bytes to string
        error = error.decode('utf-8')  # decode from bytes to string
        print(f"""output1: {output1}\n""")

        print(f"""error: {error}\n""")

        #output = os.popen(f"sh {SCRIPTS_DIR}/{script_filename}").read()
        output = output1
        colorized_output = highlight(output, JsonLexer(), HtmlFormatter())
        lexer = get_lexer_by_name("http", stripall=True)
        colorized_error = highlight(error, lexer, HtmlFormatter())
        

    return render_template('index.html', form=form, colorized_output=colorized_output, colorized_error=colorized_error)

if __name__ == '__main__':
    app.run(debug=True)

