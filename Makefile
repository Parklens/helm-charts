
helm.package.all:
	helm package charts/{predictor-worker,predictor-api,cam-server} --destination .deploy

cr.index:
	git checkout gh-pages
	cr index -i ./index.yaml -p .deploy --charts-repo https://parklens.github.io/helm-charts/

