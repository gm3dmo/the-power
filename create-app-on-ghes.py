#!/usr/bin/env python3

from playwright.sync_api import sync_playwright
import json
import time
import argparse
import thepower

def run(playwright):
    browser = playwright.chromium.launch(headless=False)
    page = browser.new_page()

    power_config = thepower.read_dotcom_config(args.power_config)
    args.org = args.org or power_config.get('dummy_section','org').strip('\"')
    args.app_name = power_config.get('dummy_section','default_app_name').strip('\"')
    #args.repo = args.repo or power_config.get('dummy_section','repo').strip('\"')

    
    # Load environment.json for URL and admin_user
    with open('environment.json') as f:
        data = json.load(f)
    base_url = data['hostname']
    admin_user = data['admin_user']
    token_field = 'token'


    
    # Navigate to the URL
    page.goto(f"https://{base_url}")
    
    # Sign in
    page.wait_for_selector('input[name="login"]')  # Ensure login input is ready
    page.fill('input[name="login"]', admin_user)
    page.fill('input[name="password"]', data['admin_password'])
    
    # Click the sign-in button using a more specific selector
    page.click('input[type="submit"][name="commit"][value="Sign in"]', timeout=5000)
    
    page.goto(f"https://{base_url}/organizations/{args.org}/settings/apps/new")
    page.click('#integration_name');
    page.fill('#integration_name', args.app_name);

    page.click('#integrator_description');
    description_text = f"The Power {args.app_name}"
    page.fill('#integrator_description', description_text);

    page.click('#integration_url');
    homepage_url = f"http://example.com/homepage/{args.app_name}"
    page.fill('#integration_url', homepage_url);

    page.click('#integration_application_callback_urls_attributes_0_url');
    callback_url = f"http://example.com/callback/{args.app_name}"
    page.fill('#integration_application_callback_urls_attributes_0_url', callback_url);

    page.click('#integration_hook_attributes_url');
    app_webhook_url = f"http://example.com/webhook/{args.app_name}"
    page.fill('#integration_hook_attributes_url', app_webhook_url);

    page.click('input[type="submit"][value="Create GitHub App"]');

    time.sleep(100)

def main(args):
    with sync_playwright() as playwright:
        run(playwright)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--power-config", action="store", dest="power_config", default=".gh-api-examples.conf", help="This is the config file to use to access variables for the power.")
    parser.add_argument("-e", "--extension", action="store", dest="extension", default="c")

    parser.add_argument(
        "--repos",
        action="store",
        dest="number_of_repos",
        default=False,
        help="The number of repos to create.",
    )
    parser.add_argument(
        "--prefix",
        action="store",
        dest="repo_prefix",
        default=False,
        help="the prefix for the repo name.",
    )
    parser.add_argument(
        "--org",
        action="store",
        dest="org",
        default=False,
        help="the organization name."
    )

    args = parser.parse_args()

    main(args)

