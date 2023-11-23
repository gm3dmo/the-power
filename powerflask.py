import os
from flask import Flask, render_template, request
from flask_wtf import FlaskForm
from wtforms import SelectField

from pygments import highlight
from pygments.lexers import JsonLexer
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

    if request.method == 'POST' and form.validate_on_submit():
        # Get the selected script filename from the form
        script_filename = form.script.data
        # Execute the script and capture the output
        output = os.popen(f"sh {SCRIPTS_DIR}/{script_filename}").read()
        colorized_output = highlight(output, JsonLexer(), HtmlFormatter())

    return render_template('index.html', form=form, output=output, colorized_output=colorized_output)

if __name__ == '__main__':
    app.run(debug=True)

