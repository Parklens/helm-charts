# helm-charts

## SETUP

### Image Pull Secrets: 
Below is a tutorial that explains how to make the secret on the cluster for pulling a private image. 
https://medium.com/hackernoon/today-i-learned-pull-docker-image-from-gcr-google-container-registry-in-any-non-gcp-kubernetes-5f8298f28969s

### Chart Repositry Setup: 
https://tech.paulcz.net/blog/creating-a-helm-chart-monorepo-part-1/


## MAIN API SETUP

### NGINX K8 Ingress Controller Installation
https://kubernetes.github.io/ingress-nginx/deploy

### Cloud Storage Key Secret 
To create a Google Cloud Storage service account key and store it in a Kubernetes secret, follow these steps:

#### Create a service account: 

If you don't have a service account already, create one in the Google Cloud Console:

*  Go to the Google Cloud Console: https://console.cloud.google.com/
*  Navigate to "IAM & Admin" > "Service accounts."
*  Click "Create Service Account."
*  Provide a name and description for the service account and click "Create."
*  Grant the service account the necessary roles, such as "Storage Object Viewer" or "Storage Object Admin," depending on your use case. Click "Continue."
*  Click "Done" to create the service account.

#### Generate a JSON key for the service account:

* On the "Service accounts" page, click on the newly created service account.
* Click the "Keys" tab.
* Click "Add Key" and choose "JSON."
* A JSON key file will be downloaded to your computer.

#### Create a Kubernetes secret with the JSON key:

* Use the following kubectl command to create a secret with the JSON key file:

`kubectl create secret generic cloudstorage-key --from-file=key.json=/path/to/key-file.json`
* Replace /path/to/key-file.json with the actual path to the downloaded JSON key file.

Now, you can reference the cloudstorage-key secret in your Kubernetes configuration, as shown in the volumeMounts and volumes sections:

```
volumeMounts:
  - name: jwt
    mountPath: "/etc/jwt"
    readOnly: true
  - name: google-cloud-key
    mountPath: /var/secrets/google
    readOnly: true

volumes:
  - name: jwt
    secret:
      secretName: jwt-keys
  - name: google-cloud-key
    secret:
      secretName: cloudstorage-key
```
This configuration will mount the cloudstorage-key secret to the /var/secrets/google directory inside the container, making the JSON key file available at /var/secrets/google/key.json.

### Create jwt keys pair
`openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048`
`openssl rsa -pubout -in private_key.pem -out public_key.pem`

### Create Main API jwt-keys secret: 
`kubectl create secret generic jwt-keys --from-file=jwt_rsa=/path/to/private_key.pem --from-file=jwt_rsa.pub=/path/to/public_key.pem`

### Create Ingress TLS Secrets: 
`kubectl create secret tls secret-name --cert first-cert-file --key first-key-file`

### Create Registry Secret for Image Pulls:
`kubectl create secret generic parklens-gcr --from-file=key.json=/path/to/key-file.json`