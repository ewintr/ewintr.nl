
stage:
	zola serve

deploy:
	zola build
	flyctl deploy
