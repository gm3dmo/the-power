# Scaling and Performance Testing
Whilst The Power is not designed to do scaling/performance/load testing it has some capabilities that can be used for this.

## Creating a "large" environment.

- 30 repos using `create-many-repos.sh`

```
./create-many-repos.sh  1.95s user 0.75s system 8% cpu 32.277 total
```

- 30 repos using `python-create-many-repos-connection-reuse.py`

```
time python3 python-create-many-repos-connection-reuse.py
python3 python-create-many-repos-connection-reuse.py  0.13s user 0.05s system 1% cpu 16.075 total
```

- 1000 repos using `python-create-many-repos-connection-reuse.py`

```
time python3 python-create-many-repos-connection-reuse.py --repos 1000 --prefix mtst1 --org acme                       I   12:26:54  
python3 python-create-many-repos-connection-reuse.py --repos 1000 --prefix     1.11s user 0.35s system 0% cpu 9:12.72 total
```


- 1000 organizations using `python-create-many-orgs-connection-reuse.py`
```
time python3 python-create-many-orgs-connection-reuse.py_id
python3 python-create-many-orgs-connection-reuse.py --orgs 1000 --prefix thou  0.88s user 0.24s system 0% cpu 7:19.29 total
```


If you keep within the GitHub recommendations about [file sizes](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github) on your GitHub repos and total size of your repo then you'll probably never need to look at performance. If you don't do that then you probably have a host of other problems.

