from .common import *
from .selenium import *
import requests
import json


def check_org_list_response(response,
                            desired_org_name,
                            api_url,
                            domain,
                            debug):
    """make sure desired_org_name is not the list of orgs"""
    status_code = response.status_code
    if debug:
        printdebug(f"status {status_code} from '{api_url}'")
    if status_code == 200:
        if response.text == '':
            printerr_exit(f"empty response from '{api_url}'")
        else:
            if debug:
                printdebug(f"non-empty response from '{api_url}'")
            existing_orgs = response.json()
            check_existing_orgs(existing_orgs, desired_org_name, debug)
    elif status_code == 401:
        printerr_exit('401 status from server - probably caused by using an invalid PAT')
    else:
        error = 'unexpected status code ' + \
            f"'{status_code}' received from '{domain}'"
        printerr_exit(error)


def check_existing_orgs(existing_orgs, desired_org_name, debug):
    """check existing org to see if one of the matches desired org"""
    if debug:
        printdebug('checking every existing org name ' +
        'to see if it matches the one we want to create')
    for existing_org in existing_orgs:
        existing_org_name = existing_org['login']
        if existing_org_name == desired_org_name:
            printerr_exit(f"organization '{desired_org_name}' " +
                            'already exists')
    if debug:
        printdebug('no existing org name ' +
                    'matches the one we want to create')


def click_complete_setup(driver, debug):
    """click Complete setup"""
    if debug:
        printdebug("finding the 'Complete setup' button and waiting for it to be clickable")
    xpath = "//button[contains(text(), 'Complete setup')]"
    wait = WebDriverWait(driver, 10)
    complete_setup_button = \
        wait.until(EC.element_to_be_clickable((By.XPATH, xpath)))
    if debug:
        printdebug("clicking on the 'Complete setup' button")
    complete_setup_button.click()


def click_next_under_org_name_field(driver, debug):
    """click Next under org name field"""
    if debug:
        printdebug("finding the Next button and waiting for it to be clickable")
    xpath = '//*[@id="org-new-form"]/button'
    wait = WebDriverWait(driver, 10)
    next_button = \
        wait.until(EC.element_to_be_clickable((By.XPATH, xpath)))
    if debug:
        printdebug("clicking on the Next button")
    next_button.click()


def create_org(config, driver, debug):
    """create an organization"""
    make_sure_org_does_not_already_exist(config, driver, debug)
    navigate_to_org_creation_page(config, driver, debug)
    wait_for_org_name_field(driver, debug)
    type_org_name_in_to_org_name_field(config, driver, debug)
    click_next_under_org_name_field(driver, debug)
    click_complete_setup(driver, debug)


def make_sure_org_does_not_already_exist(config, driver, debug):
    """make sure the given org does not exist on the GHES instance"""
    if debug:
        printdebug('extracting domain from GHES URL')
    domain = urlparse(config['ghes']['url']).netloc
    desired_org_name = config['org']['name']
    pat = config['ghes']['pat']
    headers =  {"Accept":"application/vnd.github+json",
                "Authorization":f"Bearer {pat}",
                "X-GitHub-Api-Version":"2022-11-28"}
    api_url = f"https://{domain}/api/v3/organizations"
    if debug:
        printdebug(f"fetching '{api_url}'")
    response = requests.get(api_url, headers=headers)
    check_org_list_response(response,
                            desired_org_name,
                            api_url,
                            domain,
                            debug)


def navigate_to_org_creation_page(config, driver, debug):
    """navigate to the org creation page"""
    if debug:
        printdebug("extracting domain from GHES URL")
    domain = urlparse(config['ghes']['url']).netloc
    org_creation_page = f"https://{domain}/organizations/new"
    if debug:
        printdebug("navigating to org creation page")
    driver.get(org_creation_page)


def type_org_name_in_to_org_name_field(config, driver, debug):
    """type the org name in to the org name field"""
    if debug:
        printdebug("finding org name field")
    org_name_field = driver.find_element(By.ID, 'organization_profile_name')

    org_name = config['org']['name']
    if debug:
        printdebug(f"typing org name '{org_name}' in to org name field")
    org_name_field.send_keys(org_name)


def wait_for_org_name_field(driver, debug):
    """wait for the org name field to appear on the page"""
    if debug:
        printdebug("waiting for org name field to appear on the page")
    wait = WebDriverWait(driver, 10)
    wait.until(EC.visibility_of_element_located((By.ID,
                                                 'organization_profile_name')))
