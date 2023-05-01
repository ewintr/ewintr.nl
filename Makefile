
stage:
	/home/erik/bin/zola serve

deploy:
	/home/erik/bin/zola build
	scp -r -P 23 public/* vm.ewintr.nl:/var/www/ewintr.nl
