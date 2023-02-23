from .common import *

# Logging for Selenium
import logging


# Selenium-related imports
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver import ChromeOptions
# Note: the "#type: ignore" below will keep mypy from complaining about:
#   error: Skipping analyzing "webdriver_manager.chrome":
#          module is installed, but missing library stubs
#          or py.typed marker  [import]
from webdriver_manager.chrome import ChromeDriverManager  # type: ignore

# Logging for Selenium
#
# Note: the "#type: ignore" below will keep mypy from complaining about:
#   error: Skipping analyzing "webdriver_manager.core.logger":
#          module is installed, but missing library stubs
#          or py.typed marker  [import]
from webdriver_manager.core.logger import set_logger  # type: ignore


def get_driver(config, debug):
    """start the webdriver and return it as an object"""
    if 'chrome' == config['selenium']['driver']:
        if debug:
            printdebug("starting chrome webdriver")
        chrome_options = ChromeOptions()
        if config['selenium']['headless']:
            chrome_options.add_argument("--headless")
            headless_window_size = config['selenium']['headless_window_size']
            chrome_options.add_argument(f"--window-size={headless_window_size}")
        driver = webdriver.Chrome(
            service=ChromeService(ChromeDriverManager().install()),
            chrome_options=chrome_options)
        driver.maximize_window();
        return driver
    printerr_exit(
        "Only the 'chrome' selenium driver is currently implemented")
    return None


def setup_logging(config, debug):
    """configure logging for selenium"""
    if config['selenium']['logging']:
        log_file = config['selenium']['log_file']
        if debug:
            printdebug(f"sending selenium logs to '{log_file}'")
        logger = logging.getLogger("custom_logger")
        logger.setLevel(logging.DEBUG)
        logger.addHandler(logging.StreamHandler())
        logger.addHandler(logging.FileHandler(log_file))

        set_logger(logger)
