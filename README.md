django-init
=

django-init bash script for auto creating inital django startproject.

will be created automatically:
===
* `templates` dir
* `static` dir for `collectstatic` command
* create default app with `views.py` and `models.py`
* configure `settings.py` for `TEMPLATES['DIRS']`
* configure `urls.py` for static

Usage
===
    ./django-init.sh myproject -g 
If you need empty git repository 

OR
    ./django-init.sh myproject
If you don't need.
    
