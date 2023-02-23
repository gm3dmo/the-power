from .common import *
from .selenium import *
from .validate_config import *


def click_genrate_token(driver, debug):
    """click on the Generate Token button"""
    if debug:
        printdebug("finding the Generate Token button")
    xpath = "//button[contains(text(), 'Generate')]"
    generate_token_button = driver.find_element(By.XPATH, xpath)
    if debug:
        printdebug("clicking on the Generate Token button")
    generate_token_button.click()


def create_classic_pat(config, driver, debug):
    """create a classic PAT"""
    navigate_to_classic_pat_generation_page(config, driver, debug)
    wait_for_note_field_to_appear(driver, debug)
    type_note_for_classic_pat(config, driver, debug)
    select_scopes_for_classic_pat(config, driver, debug)
    click_genrate_token(driver, debug)
    newly_generated_pat = get_newly_generated_pat(driver, debug)
    print(newly_generated_pat)


def get_newly_generated_pat(driver, debug):
    """get newly generated PAT"""
    xpath = '//*[@id="new-oauth-token"]'
    if debug:
        printdebug("finding newly generated PAT")
    newly_generated_pat = driver.find_element(By.XPATH, xpath).get_attribute('innerHTML')
    return newly_generated_pat


def navigate_to_classic_pat_generation_page(config, driver, debug):
    """navigate to the classic PAT generation page"""
    if debug:
        printdebug("extracting domain from GHES URL")
    domain = urlparse(config['ghes']['url']).netloc
    classic_pat_generation_page = f"https://{domain}/settings/tokens/new"
    if debug:
        printdebug("navigating to classic PAT generation page")
    driver.get(classic_pat_generation_page)


def select_repo_scopes_for_classic_pat(config, driver, debug):
    """select repo scopes for classic PAT"""
    if debug:
        printdebug("selecting repo scopes for classic PAT")
    for scope in config['classic-pat']['scopes']:
        if scope:
            xpath = f"//input[@value='{scope}']"
            driver.find_element(By.XPATH, xpath).click()


def select_scopes_for_classic_pat(config, driver, debug):
    """select scopes for classic PAT"""
    if debug:
        printdebug("selecting scopes for classic PAT")
    select_repo_scopes_for_classic_pat(config, driver, debug)


def type_note_for_classic_pat(config, driver, debug):
    """type a note for a classic PAT"""
    if debug:
        printdebug('finding note field')
    oauth_access_description = driver.find_element(
        By.ID,
        'oauth_access_description')

    if config['classic-pat']['note'] == ">>>RANDOM<<<":
        if debug:
            printdebug('generating random note')
        note = "animal " + str(uuid.uuid4())
    else:
        if debug:
            printdebug('using note in config file')
        note = config['classic-pat']['note']

    if debug:
        printdebug('typing note in to note field')
    oauth_access_description.send_keys(note)


def wait_for_note_field_to_appear(driver, debug):
    """wait for the note field to appear on the page"""
    if debug:
        printdebug("waiting for note field to appear on the page")
    wait = WebDriverWait(driver, 10)
    wait.until(EC.visibility_of_element_located((By.ID,
                                                 'oauth_access_description')))
