kubectl exec --stdin --tty mongodb -- /bin/bash

mongo -u mongodbuser -p your_mongodb_root_password

use flaskdb

db.createUser({user: 'flaskuser', pwd: 'your_mongodb_password', roles: [{role: 'readWrite', db: 'flaskdb'}]})

exit

mongoimport --host localhost --db flaskdb --collection restaurant --type json --file ./restaurant.json -u flaskuser -p your_mongodb_password --authenticationDatabase flaskdb