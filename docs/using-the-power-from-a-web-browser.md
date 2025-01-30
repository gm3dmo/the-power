# Using The Power from a web browser

## Requirements

- Python >=3.9

## Setup

### Setup a python virtual environment
Create a python virtual environment called *powerindex*:

```shell
cd powerindex
python -m venv powerindex
```

Activate the *powerindex* virtual environment:
```shell
source powerindex/bin/activate
```

Install piptools and packages in the *powerindex* virtual environment:
```shell
pip install pip-tools
pip-compile requirements-powerindex.in
pip install -r requirements-powerindex.txt
```

## Configure `.gh-api-examples.conf

To generate the `.gh-api-examples.conf`, follow the [Configure The Power with configure.py](https://github.com/gm3dmo/the-power/blob/main/docs/setup.md#configure-the-power-with-configurepy) instruction.

## Run the web server script `app.py`
The tmux program is useful if this is going to be a long running test.

Activate your virtual environment:

```shell
source powerindex/bin/activate
```

Start the web server:

```shell
python app.py 
```

To access the web platform, open http://127.0.0.1:8001 with your browser.
