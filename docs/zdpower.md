# Creating separate installations with the `zdpower` script
The `zdpower` script is a handy wrapper over configure.py for use in cases where multiple copies of the power are needed. 

```mermaid
graph TD
    subgraph Inputs
        A[Ticket Number] -->|provided as argument or prompted| Script[zdpower]
        B[power_config ~/.the-power-dotcom.conf] --> Script
        C[GitHub Repo URL https://github.com/gm3dmo/the-power] --> Script
    end

    subgraph Outputs
        Script --> D[Cloned Directory named after Ticket Number]
        D --> E[dotcom-configure.sh executed]
        E --> F[.gh-api-examples.conf file created]
    end
```


#. Make sure you have a home bin directory `mkdir -p ~/bin`
#. Copy `zdpower` to your home directory `cp zdpower ~/bin && chmod 500 ~/bin/zdpower` 
#. Copy this skeleton file to your ime directory `cp the-power-dotcom.skeleton  ~/.the-power-dotcom.conf`
#. Edit this new `~/.the-power-dotcom.conf` file with all of the appropriate values for your environment like your github_token, enterprise and organization name.
#. Run `dotcom-configure.sh` to set the power up to target your dotcom environment.

