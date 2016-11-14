#!/bin/bash

usage="$(basename "$0") projectname [-h] [-g] -- init django project with default settings

where:
    -h  show this help text
    -g  init empty git repo"

if [ "$#" == "0" ]; then
    echo "$usage"
    exit 1
fi

PROJECT="$1"
if [ "$PROJECT" == "-h" ]; then
    echo "$usage"
    exit 1
fi
shift

while getopts ':gh' option; do
    case "${option}" in
        h) echo "$usage"
           exit
           ;;
        g) git init .
            ;;
        \?) echo "type 'git init .' for creating empty git repo."
           ;; 
    esac
done


# git init .
pip install django psycopg2
mkdir static
mkdir media
mkdir -p templates/$PROJECT
touch templates/$PROJECT/index.html
touch templates/base.html
mkdir src
cd src
django-admin startproject $PROJECT .
cd $PROJECT
touch models.py
touch views.py

# MODELS.PY

cat >models.py<<EOL
from django.db import models
#from django.db.models import Q
EOL

# VIEWS.PY 

cat >views.py<<EOL
from django.shortcuts import render
#from $PROJECT.models import # add you models here
#from $PROJECT.forms import # add you forms here
EOL

# SETTINGS.PY

cat >>settings.py<<EOL
STATIC_ROOT = os.path.join(os.path.dirname(BASE_DIR), 'static')

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(os.path.dirname(BASE_DIR), 'media')
"""
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, 'static'),
]
"""
STATICFILES_FINDERS = (                                                            
    'django.contrib.staticfiles.finders.FileSystemFinder',                         
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',                     
    #'django.contrib.staticfiles.finders.DefaultStorageFinder',                    
)
EOL
sed -i -e "s/'DIRS': \[\]/'DIRS': \[os.path.join(os.path.dirname(BASE_DIR), 'templates')\]/g" settings.py

# URLS.PY SECTION
sed -i -e "s/\]/\] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)/" urls.py
sed -i -e "s/urlpatterns = \[/from django.conf import settings\nfrom django.conf.urls.static import static\n\nurlpatterns = \[/" urls.py
cat >>urls.py<<EOL
# add in import section: 
# from django.conf import settings
# from django.conf.urls.static import static
EOL

