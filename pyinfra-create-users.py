import json
import sys

from pyinfra import host
from pyinfra.operations import server, files
from pyinfra.api import deploy


# the argument you want
ghes_hostname: str = ""
users_file: str = ""

# more arguments with defaults
DEFAULTS = {"github_dotcom": "github.com",  "users_file": "users.json"}

print(f"Configuring for ghes_hostname: {host.data.ghes_hostname}")
print(f"Generate users from : {host.data.users_file}")
ghes_hostname = f"{host.data.ghes_hostname}"
users_file = f"{host.data.users_file}"

# Load users from the JSON file
with open(users_file, 'r') as file:
    users = json.load(file)

for user in users:
    username = user['username']
    ssh_public_key = user.get('ssh_public_key', '')  # Assuming SSH key is optional

    # Construct the home directory dynamically
    home_directory = f"/home/{username}"
    ssh_config_filename=f"{home_directory}/.ssh/config"

    # Create the user
    server.user(
        name=f"Ensure the user {username} exists",
        user=username,
        home=home_directory,
        shell="/bin/bash",
        _sudo=True
    )


    # Add the public SSH key to authorized_keys if provided
    files.file(
        name=f"Create {username} ssh authorized_keys_file",
        path=f"{home_directory}/.ssh/authorized_keys",
        mode="400",
        user=username,
        group=username,
        touch=True,
        create_remote_dir=True,
        _sudo = True
    )

    # Add the public SSH key to authorized_keys if provided
    files.put(
        name=f"put {username} ssh key",
        src=f"tmp/ed25519_{username}",
        dest=f"{home_directory}/.ssh/ed25519_{username}",
        mode="400",
        user=username,
        group=username,
        force=True,
        _sudo = True
    )

    if ssh_public_key:
        files.line(
            name=f"Ensure SSH key is in {username}'s authorized_keys",
            path=f"{home_directory}/.ssh/authorized_keys",
            line=ssh_public_key,
            present=True,
            _sudo=True
        )
    else:
       print("Skip")


    # Create an ssh config file
    files.template(
        name="SSH Config file for {username}",
        src="test-data/ssh_config.template",
        dest=ssh_config_filename,
        user=username,
        group=username,
        mode="400",
        ghes_hostname=ghes_hostname,
        username=username,
        ssh_port = 22,
        vulnerable_kex_algorithm = "ecdh-sha2-nistp256",
        _sudo = True
)

    # Create the the-power-runtimes directory
    files.directory(
        name=f"Ensure the the-power-runtimes directory exists for {username}",
        path=f"{home_directory}/the-power-runtimes",
        user=username,
        group=username,
        _sudo=True
    )
    # Create the the-power-runtimes directory
    files.directory(
        name=f"Ensure the bin directory exists for {username}",
        path=f"{home_directory}/bin",
        user=username,
        group=username,
        _sudo=True
    )

    # Ensure correct permissions and ownership for the authorized_keys file
    files.block(
        name="Ensure correct permissions bash profile",
        path=f"{home_directory}/.bash_profile",
        content="PATH=$PATH:~/bin ; export PATH",
        _sudo=True
    )

    # Set the Bash prompt (PS1) to include the username
    bashrc_path = f"{home_directory}/.bashrc"
    prompt_command = f'echo "export PS1=\'\\u@\\h:\\w$ \'" >> {bashrc_path}'
    
    server.shell(
        name=f"Set Bash prompt for {username}",
        commands=prompt_command,
        _sudo=True,
        _sudo_user=username  # Execute as the user to ensure correct file ownership
    )
