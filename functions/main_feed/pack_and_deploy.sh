#!/bin/bash

rm ${PWD##*/}.tar.gz
# pack to .tar.gz archive
echo "pack the function into an archive"
tar -zcvf ${PWD##*/}.tar.gz -C *

# deploy to local
echo "deploing..."
appwrite functions create-deployment \
    --function-id=main_feed \
    --entrypoint='lib/main_feed.dart' \
    --code="." \
    --activate=true