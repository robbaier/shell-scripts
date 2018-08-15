#!/bin/bash
# -----------------------------------------------------------------------------
# This script checks a list of URLs and returns the HTTP response code as well
# as the redirected URL, if applicable. The input text file should be formatted
# with a single URL on each line.
#
# USAGE: cat urls.txt | xargs -P 4 -L1 ./checkurls.sh > urls-status.csv
# -----------------------------------------------------------------------------

# Set the output format. Default is CSV. Setting this to anything else will
# result in space-delimited values.
FORMAT="CSV"

# Pass URLs as file input
URL=${1?Pass URL as parameter!}

# Get the initial HTTP response code and store it in a variable. This is done
# separately because the next step follows redirects, which causes the
# response codes to always be 200. This stores the initial response code.
RESULT="$(curl -o /dev/null --silent --head --write-out %{response_code} $URL)"

# Get the redirected URL, if applicable, and write the output in the correct
# format, as set above.
if [ "$FORMAT" = "CSV" ]
then
    curl -L -o /dev/null --silent --head --write-out "\"$URL\",\"$RESULT\",\"%{url_effective}\"\n" "$URL"
else
    curl -L -o /dev/null --silent --head --write-out "$URL $RESULT %{url_effective}\n" "$URL"
fi
