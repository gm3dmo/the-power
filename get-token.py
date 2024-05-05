from playwright.sync_api import sync_playwright
import json
import time

def run(playwright):
    browser = playwright.chromium.launch(headless=False)
    page = browser.new_page()
    
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
    
    page.goto(f"https://{base_url}/settings/tokens/new")

    # Wait for the token description input to be ready and fill it
    page.wait_for_selector('input[name="oauth_access[description]"]')  # Ensure the input is ready
    # make "the-power" a template variable with a unix timestamp onthe end

    description_value = 'the-power-' + str(int(time.time()))
    page.fill('input[name="oauth_access[description]"]', description_value)

    checkboxes = page.query_selector_all('input[type="checkbox"]')
    for checkbox in checkboxes:
        checkbox.check()

    page.click('button.btn-primary:has-text("Generate token")', timeout=5000)

    # Wait for the token to be visible and retrieve its value
    token_value = page.inner_text('#new-oauth-token')
    print(f"Retrieved token: {token_value}")

    # Load the current environment.json into memory
    with open('environment.json', 'r') as f:
        data = json.load(f)

    # Update the token field with the new token value
    data['token'] = token_value

    # Write the updated dictionary back to environment.json
    with open('environment.json', 'w') as f:
        json.dump(data, f, indent=4)

with sync_playwright() as playwright:
    run(playwright)
