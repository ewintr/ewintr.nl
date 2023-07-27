
stage:
	/home/erik/bin/zola serve

deploy:
	/home/erik/bin/zola build
	scp -r public/* ewintr.nl:/var/www/ewintr.nl
