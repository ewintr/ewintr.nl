
stage:
	zola serve

deploy:
	zola build
	scp -r public/* web:/var/www/ewintr.nl
