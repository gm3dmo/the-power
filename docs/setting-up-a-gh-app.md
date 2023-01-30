# Using a GitHub App with The Power

1. Go to your organization -> Developer Settings -> GitHub App

2. Register a new app, give it a snappy name like `test-app`, a snappy homepage like `https://example.com` and a snappy webhook URL like `https://example.com/webhook`

3. Give it some permissions to start, any, you can change them later (see below), then hit create

4. Scroll down to generate a private key, we will use that later

5. On the left click `install app` and hammer that install button

6. Now we will set it up to work with ___The Power___

7. Go to your cloned repo where you've [set up the power](setup.md)

8. `vi .gh-api-examples.conf` and change the following things:
	1. Make sure the org is the correct one under `### [Organization](https://docs.github.com/en/rest/orgs)`
	2. Under `### [GitHub Apps](https://docs.github.com/en/rest/apps)` change the following:
		1. Point `private_pem_file` to the location of the file downloaded in step 4
		2. `default_app_id` is the App ID under `https://github.com/organizations/<YOURORG>/settings/apps/<SNAPPYAPPNAME>`
		3. `client_id` is the Client ID at the above address
		4. `default_installation_id` is the installation ID of the app, found under `https://github.com/organizations/<YOURORG>/settings/installations/<installationID>`, you can get there by clicking install app and then the little gear next to your app

9. Now run `./tiny-dump-app-token.sh` and it should look something like this:

```
		++++++++++++++++++++++ App Token ++++++++++++++++++++++
		
		ghs_w0wTh1sReAlLyIsAToKeN0rSomETH1nGLoOKSgrEAt (<- not a real token)
		
		+++++++++++++++++++++++++++++++++++++++++++++++++++++++
```

10. Put that in your GraphiQL header or set your GITHUB_TOKEN to use the REST API

## REMINDER

When updating app permissions, remember to approve them! To do that go to this page `https://github.com/organizations/<YOURORG>/settings/installations/<installationID>` and review request -> Accept new permissions

Otherwise the permission change will be for naught.
