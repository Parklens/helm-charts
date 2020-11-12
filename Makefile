
helm.package.all:
	helm package charts/predictor-worker --destination .deploy
	# helm package charts/predictor-api --destination .deploy
	# helm package charts/cam-server --destination .deploy

cr.index:
	git checkout gh-pages
	cr index -i ./index.yaml -p .deploy --charts-repo https://parklens.github.io/helm-charts/

cr.upload: 
	cr upload -p .deploy