# Voting App

This is a simple voting app showcasing a frontend, an API, and a MongoDB database. The application allows users to vote for their favorite programming languages.

## MongoDB Database Setup

1. Create the MongoDB StatefulSet with Persistent Volumes:

    ```bash
    kubectl apply -f manifests/mongo-statefulset.yaml
    ```

2. Create the MongoDB Service:

    ```bash
    kubectl apply -f manifests/mongo-service.yaml
    ```

3. Initialize the MongoDB Replica Set:

    ```bash
    kubectl exec -it mongo-0 -- mongo
    ```

    Run the following commands inside the MongoDB shell:

    ```javascript
    rs.initiate();
    sleep(2000);
    rs.add("mongo-1.mongo:27017");
    sleep(2000);
    rs.add("mongo-2.mongo:27017");
    sleep(2000);
    cfg = rs.conf();
    cfg.members[0].host = "mongo-0.mongo:27017";
    rs.reconfig(cfg, {force: true});
    sleep(5000);
    ```

4. Check if the Replica Set is implemented:

    ```bash
    kubectl exec -it mongo-0 -- mongo --eval "rs.status()" | grep "PRIMARY|SECONDARY"
    ```

5. Load Data into the Database:

    ```bash
    kubectl exec -it mongo-0 -- mongo
    ```

    Run the following commands inside the MongoDB shell to insert data:

    ```javascript
    use langdb;
    db.languages.insert({ ... });
    ```

## API Setup

1. Create the API Go Deployment:

    ```bash
    kubectl apply -f api-deployment.yaml
    ```

2. Expose the API Deployment through a Service:

    ```bash
    kubectl expose deploy api --name=api --type=LoadBalancer --port=80 --target-port=8080
    ```

3. Set the Service Endpoint as an Environment Variable:

    ```bash
    API_ELB_PUBLIC_FQDN=$(kubectl get svc api -ojsonpath="{.status.loadBalancer.ingress[0].hostname}")
    until nslookup $API_ELB_PUBLIC_FQDN >/dev/null 2>&1; do sleep 2 && echo "Waiting for DNS to propagate..."; done
    curl $API_ELB_PUBLIC_FQDN/ok
    ```

4. Test the API:

    ```bash
    curl -s $API_ELB_PUBLIC_FQDN/languages | jq .
    ```

## Frontend Setup

1. Create the Frontend Deployment:

    ```bash
    kubectl apply -f frontend-deployment.yaml
    ```

2. Expose the Frontend Deployment through a Service:

    ```bash
    kubectl expose deploy frontend --name=frontend --type=LoadBalancer --port=80 --target-port=8080
    ```

3. Confirm the Frontend ELB is Ready:

    ```bash
    FRONTEND_ELB_PUBLIC_FQDN=$(kubectl get svc frontend -ojsonpath="{.status.loadBalancer.ingress[0].hostname}")
    until nslookup $FRONTEND_ELB_PUBLIC_FQDN >/dev/null 2>&1; do sleep 2 && echo "Waiting for DNS to propagate..."; done
    curl -I $FRONTEND_ELB_PUBLIC_FQDN
    ```

4. Generate Frontend URL:

    ```bash
    echo "http://$FRONTEND_ELB_PUBLIC_FQDN"
    ```

5. Query MongoDB for Updated Vote Data:

    ```bash
    kubectl exec -it mongo-0 -- mongo langdb --eval "db.languages.find().pretty()"
    ```

## Contributing

Feel free to contribute by opening issues or pull requests. Your feedback is appreciated!

