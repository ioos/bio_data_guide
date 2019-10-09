# ioos_bio_data_scripts
Bio data scripts &amp; code samples related to the IOOS code sprint Biological Data Session.

Each subdirectory is focuses on a particular problem/question.
The subdirectories may contain R `DESCRIPTION` and/or python `requirements.txt` files to help with installing dependencies.
Subdirectories can also contain their own README files.

There are no hard rules here; it's just a quick and easy place to drop your scripts/examples.

## Installation: Python
If you're munging through data in Python, you might want to consider using a virtual environment to install your dependencies in.

### Virtual Environment Using `pip`
On a Mac or Linux machine, you can quickly create a virtual environment with the commands below.

```
$ python3 -m venv env
$ source env/bin/activate # activate the environment
$ pip install -U pip # upgrade pip version
$ pip install -r requirements.txt
```

If you're installing and using `jupyter` notebooks this way, you'll also want to ensure that
the user is specified so your installed packages are found properly:

```
python -m ipykernel install --user
```

Now, you should be ready to fire up Python and start exploring!

The `install.sh` (and `install_*.sh`) files in the root dir are helpers which comb through the subdirs and try to install all dependencies.
They aren't pretty.

Highlights:

* data_to_dwc : Abby's example data transformations
* obis_subset : Pull data out of OBIS using robis then make some plots in R & in python. 
