from .common import *
from lib.selenium import EC, \
    WebDriverWait

GHES_LOGIN_PAGE_TITLE = "Sign in to your account · GitHub"

def validate_config(config, config_file, debug):
    """make sure the config file looks like what we expect"""
    if debug:
        printdebug(f"validating config file '{config_file}'")
    validate_ghes_config_section(config, config_file, debug)
    # Too much of a pain to validate classic pat config section
    # the way I've been doing.
    #
    # Need to find a way to do this more efficiently, in bulk.
    # Until then, this is going to be commented out,
    # and invalid classic pat config settings may break this script.
    #
    #validate_classic_pat_config_section(config, config_file, debug)
    validate_selenium_config_section(config, config_file, debug)


def validate_classic_pat_config_section(config, config_file, debug):
    """validate classic-pat config section"""
    if debug:
        printdebug('validating classic-pat section in ' +
                   f"config file '{config_file}'")
    if 'classic-pat' in config:
        validate_note_in_classic_pat_section(config, config_file, debug)
        validate_scopes_in_classic_pat_section(config, config_file, debug)
        validate_repo_in_classic_pat_scopes_section(config, config_file, debug)
        validate_workflow_in_classic_pat_scopes_section(config, config_file, debug)
        validate_write_packages_scope_for_classic_pat(config, config_file, debug)
        validate_read_packages_scope_for_classic_pat(config, config_file, debug)
        validate_repo_scope_in_classic_pat_scopes_section(config, config_file, debug)
        validate_repo_status_in_classic_pat_scopes_repo_scopes_section(config, config_file, debug)
        validate_repo_deployment_in_classic_pat_scopes_repo_scopes(config, config_file, debug)
        validate_public_repo_in_classic_pat_scopes_repo_scopes(config, config_file, debug)
        validate_repo_invite_in_classic_pat_scopes_repo_scopes(config, config_file, debug)
        validate_security_events_in_classic_pat_scopes_repo_scopes(config, config_file, debug)
    else:
        printerr_exit(f"[classic-pat] section must exist in {config_file}")


def validate_ghes_config_section(config, config_file, debug):
    """validate ghes config section"""
    if debug:
        printdebug(f"validating ghes section in config file '{config_file}'")
    if 'ghes' in config:
        if 'password' not in config['ghes']:
            printerr_exit(
                f"password must exist in the [ghes] section in {config_file}")
        if 'url' not in config['ghes']:
            printerr_exit(
                f"url must exist in the [ghes] section in {config_file}")
        if 'username' not in config['ghes']:
            printerr_exit(
                f"username must exist in the [ghes] section in {config_file}")
    else:
        printerr_exit(f"[ghes] section must exist in {config_file}")


def validate_note_in_classic_pat_section(config, config_file, debug):
    """validate note in classic-pat section in config"""
    if debug:
        printdebug("validating note in classic-pat section")
    if 'note' not in config['classic-pat']:
        printerr_exit(
            'note must exist in the [classic-pat] section' +
            f"in {config_file}")
    else:
        if not isinstance(config['classic-pat']['note'], str):
            printerr_exit(
                "note in [classic-pat] section must be a string " +
                f"in {config_file}")
        if config['classic-pat']['note'] == "":
            printerr_exit(
                f"[classic-pat] note must not be empty in {config_file}")


def validate_public_repo_in_classic_pat_scopes_repo_scopes(config,
                                                               config_file,
                                                               debug):
    """validate public_repo in [classic-pat.scopes.repo-scope] section
    in config"""
    if debug:
        printdebug('validating public_repo in ' +
                   '[classic-pat.scopes.repo-scope] section')
    if 'public_repo' not in config['classic-pat']['scopes']['repo-scope']:
        printerr_exit(
            'public_repo must exist in the [classic-pat.scopes.repo-scope] section' +
            f"in {config_file}")
    else:
        if not isinstance(
                config['classic-pat']['scopes']['repo-scope']['public_repo'],
                bool):
            printerr_exit(
                'public_repo in the [classic-pat.scopes.repo-scope] section ' +
                f"must be true or false in {config_file}")


def validate_repo_deployment_in_classic_pat_scopes_repo_scopes(config,
                                                               config_file,
                                                               debug):
    """validate repo_deployment in [classic-pat.scopes.repo-scope] section
    in config"""
    if debug:
        printdebug('validating repo_deployment in ' +
                   '[classic-pat.scopes.repo-scope] section')
    if 'repo_deployment' not in config['classic-pat']['scopes']['repo-scope']:
        printerr_exit(
            'repo_deployment must exist in the [classic-pat.scopes.repo-scope] section' +
            f"in {config_file}")
    else:
        if not isinstance(
                config['classic-pat']['scopes']['repo-scope']['repo_deployment'],
                bool):
            printerr_exit(
                'repo_deployment in the [classic-pat.scopes.repo-scope] section ' +
                f"must be true or false in {config_file}")


def validate_repo_in_classic_pat_scopes_section(config, config_file, debug):
    """validate repo in classic-pat scopes section in config"""
    if debug:
        printdebug("validating repo in [classic-pat.scopes] section")
    if 'repo' not in config['classic-pat']['scopes']:
        printerr_exit(
            "repo must exist in the [classic-pat.scopes] section " +
            f"in {config_file}")
    else:
        if not isinstance(
                config['classic-pat']['scopes']['repo'], bool):
            printerr_exit(
                'repo in the [classic-pat.scopes] section ' +
                f"must be true or false in {config_file}")


def validate_repo_invite_in_classic_pat_scopes_repo_scopes(config,
                                                               config_file,
                                                               debug):
    """validate repo:invite in [classic-pat.scopes.repo-scope] section
    in config"""
    if debug:
        printdebug('validating repo:invite in ' +
                   '[classic-pat.scopes.repo-scope] section')
    if 'repo:invite' not in config['classic-pat']['scopes']['repo-scope']:
        printerr_exit(
            'repo:invite must exist in the [classic-pat.scopes.repo-scope] section' +
            f"in {config_file}")
    else:
        if not isinstance(
                config['classic-pat']['scopes']['repo-scope']['repo:invite'],
                bool):
            printerr_exit(
                'repo:invite in the [classic-pat.scopes.repo-scope] section ' +
                f"must be true or false in {config_file}")


def validate_repo_scope_in_classic_pat_scopes_section(config, config_file, debug):
    """validate repo-scope in [classic-pat.scopes] section in config"""
    if debug:
        printdebug("validating repo-scope in [classic-pat.scopes] section")
    if 'repo-scope' not in config['classic-pat']['scopes']:
        printerr_exit(
            'repo-scope must exist in the [classic-pat.scopes] section' +
            f"in {config_file}")


def validate_repo_status_in_classic_pat_scopes_repo_scopes_section(config,
                                                                   config_file,
                                                                   debug):
    """validate repo:status in [classic-pat.scopes.repo-scope] section
    in config"""
    if debug:
        printdebug('validating repo:status in ' +
                   '[classic-pat.scopes.repo-scope] section')
    if 'repo:status' not in config['classic-pat']['scopes']['repo-scope']:
        printerr_exit(
            'repo:status must exist in the [classic-pat.scopes.repo-scope] section' +
            f"in {config_file}")
    else:
        if not isinstance(
                config['classic-pat']['scopes']['repo-scope']['repo:status'],
                bool):
            printerr_exit(
                'repo:status in the [classic-pat.scopes.repo-scope] section ' +
                f"must be true or false in {config_file}")


def validate_scopes_in_classic_pat_section(config, config_file, debug):
    """validate scopes in classic-pat section in config"""
    if debug:
        printdebug("validating scopes in classic-pat section")
    if 'scopes' not in config['classic-pat']:
        printerr_exit(
            'scopes must exist in the [classic-pat] section' +
            f"in {config_file}")


def validate_security_events_in_classic_pat_scopes_repo_scopes(config,
                                                               config_file,
                                                               debug):
    """validate security_events in [classic-pat.scopes.repo-scope] section
    in config"""
    if debug:
        printdebug('validating security_events in ' +
                   '[classic-pat.scopes.repo-scope] section')
    if 'security_events' not in config['classic-pat']['scopes']['repo-scope']:
        printerr_exit(
            'security_events must exist in the [classic-pat.scopes.repo-scope] section' +
            f"in {config_file}")
    else:
        if not isinstance(
                config['classic-pat']['scopes']['repo-scope']['security_events'],
                bool):
            printerr_exit(
                'security_events in the [classic-pat.scopes.repo-scope] section ' +
                f"must be true or false in {config_file}")


def validate_selenium_config_section(config, config_file, debug):
    """validate selenium config section"""
    if debug:
        printdebug(f"validating selenium section in config file '{config_file}'")
    if 'selenium' in config:
        if 'log_file' not in config['selenium']:
            printerr_exit(
                "log_file must exist " +
                f"in the [selenium] section in {config_file}")
        elif 'driver' not in config['selenium']:
            printerr_exit(
                "driver must exist " +
                f"in the [selenium] section in {config_file}")
    else:
        printerr_exit(f"[selenium] section must exist in {config_file}")


def validate_login_page(driver, debug):
    """make sure the login page looks like what we expect"""
    if debug:
        printdebug("validating login page")
    if debug:
        printdebug("checking login page title")
    wait = WebDriverWait(driver, 10)
    wait.until(EC.title_contains(GHES_LOGIN_PAGE_TITLE))
    if driver.title != GHES_LOGIN_PAGE_TITLE:
        printerr_exit(
            f"Login page expected to be '{GHES_LOGIN_PAGE_TITLE}', " +
            f"but got '{driver.title}'")


def validate_read_packages_scope_for_classic_pat(config, config_file, debug):
    """validate read:packages scope for ['classic-pat.scopes']"""
    if debug:
        printdebug("validating read:packages scope for ['classic-pat.scopes']")
    if 'read:packages' not in config['classic-pat']['scopes']:
        printerr_exit(
            "read:packages must exist in the [classic-pat.scopes] section " +
            f"in {config_file}")
    else:
        if not isinstance(config['classic-pat']['scopes']['read:packages'], bool):
            printerr_exit(
                "read:packages in the [classic-pat.scopes] section must be true or false " +
                f"in {config_file}")


def validate_write_packages_scope_for_classic_pat(config, config_file, debug):
    """validate write:packages scope for ['classic-pat.scopes']"""
    if debug:
        printdebug("validating write:packages scope for ['classic-pat.scopes']")
    if 'write:packages' not in config['classic-pat']['scopes']:
        printerr_exit(
            "write:packages must exist in the [classic-pat.scopes] section " +
            f"in {config_file}")
    else:
        if not isinstance(config['classic-pat']['scopes']['write:packages'], bool):
            printerr_exit(
                "write:packages in the [classic-pat.scopes] section must be true or false " +
                f"in {config_file}")


def validate_workflow_in_classic_pat_scopes_section(config, config_file, debug):
    """validate workflow in [classic-pat.scopes] section in config"""
    if debug:
        printdebug("validating workflow in [classic-pat.scopes] section")
    if 'workflow' not in config['classic-pat']['scopes']:
        printerr_exit(
            "workflow must exist in the [classic-pat.scopes] section " +
            f"in {config_file}")
    else:
        if not isinstance(
                config['classic-pat']['scopes']['workflow'], bool):
            printerr_exit(
                'workflow in the [classic-pat.scopes] section ' +
                f"must be true or false in {config_file}")
