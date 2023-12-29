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
    db.languages.insert({
        "name": "csharp",
        "codedetail": {
            "usecase": "system, web, server-side",
            "rank": 5,
            "compiled": false,
            "homepage": "https://dotnet.microsoft.com/learn/csharp",
            "download": "https://dotnet.microsoft.com/download/",
            "votes": 0
        }
    });

    db.languages.insert({
        "name": "python",
        "codedetail": {
            "usecase": "system, web, server-side",
            "rank": 3,
            "script": false,
            "homepage": "https://www.python.org/",
            "download": "https://www.python.org/downloads/",
            "votes": 0
        }
    });

    db.languages.insert({
        "name": "javascript",
        "codedetail": {
            "usecase": "web, client-side",
            "rank": 7,
            "script": false,
            "homepage": "https://en.wikipedia.org/wiki/JavaScript",
            "download": "n/a",
            "votes": 0
        }
    });

    db.languages.insert({
        "name": "go",
        "codedetail": {
            "usecase": "system, web, server-side",
            "rank": 12,
            "compiled": true,
            "homepage": "https://golang.org",
            "download": "https://golang.org/dl/",
            "votes": 0
        }
    });

    db.languages.insert({
        "name": "java",
        "codedetail": {
            "usecase": "system, web, server-side",
            "rank": 1,
            "compiled": true,
            "homepage": "https://www.java.com/en/",
            "download": "https://www.java.com/en/download/",
            "votes": 0
        }
    });

    db.languages.insert({
        "name": "nodejs",
        "codedetail": {
            "usecase": "system, web, server-side",
            "rank": 20,
            "script": false,
            "homepage": "https://nodejs.org/en/",
            "download": "https://nodejs.org/en/download/",
            "votes": 0
        }
    });
    ```
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

## Note:

## API External Access Verification

### Retrieve API Load Balancer Public FQDN

This command retrieves the public fully qualified domain name (FQDN) of the API service's load balancer using `kubectl`. The obtained FQDN will be used to access the API externally.

### Wait for DNS Propagation

This loop checks whether the DNS for the obtained FQDN has propagated successfully. It waits in a loop, checking the DNS resolution using `nslookup`. If the DNS is not yet propagated, it waits for 2 seconds and repeats the process. This step ensures that the DNS records have propagated and are accessible.

### Test API Endpoint

Once DNS propagation is confirmed, the script uses `curl` to send a request to the `/ok` endpoint of the API using the obtained FQDN. This is a simple way to check if the API is accessible externally and responding with an "ok" message. It serves as a verification step to confirm that the API is reachable and functioning as expected.

These steps collectively ensure that the API service's load balancer has a publicly accessible DNS, waits for DNS propagation, and then tests the API endpoint for external accessibility.


