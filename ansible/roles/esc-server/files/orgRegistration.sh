#!/bin/bash

SERVER_ADDR="localhost"
ESC_URL=`curl -s --head http://$SERVER_ADDR:8080/beta/ | grep "Location: "`
FORM_ARGS=`cat $1`

if [[ $ESC_URL == *beta/pages/admin/createorganisation.jsp* ]] ; then
    # Redirect to the create organisation page. Let's create the organisation.
    curl $FORM_ARGS http://$SERVER_ADDR:8080/beta/pages/admin/create.jsp

    # Check if the registration has been successful
    ESC_URL=`curl -s --head http://$SERVER_ADDR:8080/beta/ | grep "Location: "`
    if [[ $ESC_URL != *beta/pages/front/welcome.jsp* ]]; then
        echo "Organisation registration has failed; e-SC URL = $ESC_URL"
        # Somethings wrong, no login screen and no create organisation.
        exit 2
    fi
elif [[ $ESC_URL != *beta/pages/front/welcome.jsp* ]]; then
    # Somethings wrong, no login screen and no create organisation.
    echo "No login screen recognised; e-SC URL = $ESC_URL"
    exit 1
else
    # All ok, the e-SC service running. No need to register the organisation.
    exit 0
fi

