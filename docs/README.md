# The Power

![the-power](https://github.com/gm3dmo/the-power/actions/workflows/the-power.yml/badge.svg)


## Table of Contents

1. [What is the Power?](#what-is-the-power)
2. [Setup Instructions](setup.md)
3. [Contributing to The Power](CONTRIBUTING.md)
4. [Known Issues/Problems/Solutions](known-issues.md)
5. [Testcases](testcases.md)
6. [Setting up a GitHub App to use with The Power](setting-up-a-gh-app.md)
7. [GitHub API Learning Resources](resources.md)
8. [Scaling to create larger environments](scale.md)

## What is The Power?
*The Power* is a simple test framework for GitHub's API's. It's goal is to help you learn to interact with and understand GitHub API's by building test scenarios such as; a repository with a pull request, teams and users on a testing instance of [GitHub Enterprise](https://docs.github.com/en/enterprise-server/admin/overview/about-github-enterprise-server) or GitHub.com a pre-existing [Organization](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/about-organizations) and [Enterprise Account](https://docs.github.com/en/get-started/onboarding/getting-started-with-github-enterprise-cloud).

The Power can create the following on a blank appliance or organization in <=30 seconds:

* An [Organization](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/about-organizations).
* Users
* A [team](https://docs.github.com/en/github/setting-up-and-managing-organizations-and-teams/about-teams) of users.
* A private [repository](https://docs.github.com/en/repositories) named *testrepo* with a [branch](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-and-deleting-branches-within-your-repository) called *new_branch*,
* [Branch protection](https://docs.github.com/en/github/administering-a-repository/about-protected-branches) rules on branch `main`.
* [*CODEOWNERS*](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/about-code-owners) file configured for the *README.md* and `.gitattributes` files.
* An [Issue](https://github.com/features/issues) with the [label](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels) `bug`.
* A [pull request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) with a code owner requested for review. The pull request contains 2 commits against 2 files and activates the tree view.
* A manifest file for a package manager file with a vulnerability to trigger [Dependabot](https://docs.github.com/en/code-security/dependabot).
* A [webhook](https://docs.github.com/en/developers/webhooks-and-events/about-webhooks) on *testrepo* that outputs to it's own [smee.io](https://smee.io) url.
* A [Release](https://docs.github.com/en/github/administering-a-repository/managing-releases-in-a-repository).
* [GitHub Pages](https://docs.github.com/en/pages) configured for *testrepo*.
* A [Gist](https://docs.github.com/en/github/writing-on-github/creating-gists).
* Mermaid diagrams using [create-commit-mermaid.sh](create-commit-mermaid.sh) to demonstrate the GitHub supported diagram types on [the mermaid project](https://mermaid-js.github.io/mermaid/#/n00b-gettingStarted).

There are many other features and test-cases you can use or adapt to build scenarios of your own.

> [!NOTE]  
> The power is not intended as an example of how to write shell scripts.


### The Power is a tool for learning
- Designed to be as simple as possible to understand. To keep things simple we exclusively uses only `curl` and `jq` to complete most tasks. Only a few of the more complex scenarios have other dependencies.

### The Power is vast and deep
There are hundreds of pre-baked scripts to:

* Create commits, secrets, hooks, issue comments, environments.
* Bulk up your appliance by creating hundreds or thousands of users/orgs/repos/teams/pull requests.
* Set up a Tiny [GitHub App](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps) in less than 1 minute.
* Demonstrate [GitHub Actions](https://docs.github.com/en/actions).
* Demonstrate [Code scanning](https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning).

### The Power is fast
You can stitch together scripts to create demos of features or rapidly test a bug or capability.

- [The Base Testcase: build-testcase](https://www.youtube.com/watch?v=yB55AVjM7DY) demo of the features of The Power's base test case `build-testcase`.
- [Push Protection Speed Run](https://www.youtube.com/watch?v=0rzGeNt0Na0) a speed run demo of GitHub Push Protection feature.
- [Secret Scanning Speed Run](https://www.youtube.com/watch?v=CvEMjQ0YZ0I) creates a repository, enables secret scanning, clones the repository and leaves you ready to commit secrets using [build-testcase-secret-scanning](https://github.com/gm3dmo/the-power/blob/main/build-testcase-secret-scanning).
- [GitHub App Commit Signing Demo](https://www.youtube.com/watch?v=xRLtkkl4w7I) uses the [run-testcase-tiny-app-commit-signing](https://github.com/gm3dmo/the-power/blob/main/run-testcase-tiny-app-commit-signing) testcase to demonstrate a GitHub App.

### The Power is highly configurable
The configuration file `.gh-api.examples.conf` is the green fuse that drives The Power. The configuration file format is a simple list of key value pairs:

```
### [Branches](https://docs.github.com/en/rest/commits/commits)
# https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/
proposing-changes-to-your-work-with-pull-requests/about-branches
branch_name="new_branch"
protected_branch_name="main"
required_approving_reviewers=1
required_status_check_name="ci-test/this-check-is-required"
enforce_admins="false"
base_branch=main
```

#### The Power's configuration can be shared with other tools
The use of `kv` pairs in `.gh-api-examples.conf` provides maximum flexibility and simplicity. It allows the configuration file to provide the basic descriptors for other more advanced tools like Apache JMeter or [hurl](https://hurl.dev/)

##### Hurl using the `.gh-api-examples.conf file`
[hurl-repo-characteristics.sh](https://github.com/gm3dmo/the-power/blob/main/hurl-repo-characteristics.sh) shows [hurl](https://hurl.dev) provisioned with values `.gh-api-examples.conf`:

```
hurl --test --variables-file .gh-api-examples.conf --json hurl-tests/repo-characteristics.hurl | jq -r
```
The `hurl-tests/repo-characteristics` file looks like:

```
GET {{ GITHUB_API_BASE_URL }}/repos/{{ org }}/{{ repo }}
Accept: application/vnd.github.v3+json
Authorization: token {{ GITHUB_TOKEN }}

HTTP/2 200

[Asserts]
status >= 200
status < 300
header "Content-Type" == "application/json; charset=utf-8"
header "x-github-request-id" isString
jsonpath "$.name" == "{{ repo }}"
jsonpath "$.full_name" == "{{ org}}/{{ repo }}"
```

### Why The Power
There are lots of great tools like [JMeter](https://jmeter.apache.org/) for interacting with API's and building testsuites and many of the latest API's come with their own interactive documentation built-in like the [swagger petstore](https://petstore.swagger.io/). The Power is a solution for times and places where those tools just aren't available.
