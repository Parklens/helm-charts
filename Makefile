
helm.package.all:
	make helm.package.cam-server
	make helm.package.predictor-api
	make helm.package.predictor-worker
	make helm.package.cam-server-webapp

clear.deploys:
	rm .deploy/*

helm.package.cam-server:
	helm package charts/cam-server --destination .deploy

helm.package.predictor-api:
	helm package charts/predictor-api --destination .deploy

helm.package.predictor-worker:
	helm package charts/predictor-worker --destination .deploy

helm.package.cam-server-webapp:
	helm package charts/cam-server-webapp --destination .deploy

cr.index:
	git checkout gh-pages
	cr index -i ./index.yaml -p .deploy --charts-repo https://parklens.github.io/helm-charts/

cr.upload: 
	cr upload -p .deploy

helm.test.cam-server:
	helm template charts/cam-server

helm.test.webapp:
	helm template charts/cam-server-webapp