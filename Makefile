.PHONY: stage stage-drafs deploy

stage:
	/home/erik/bin/zola serve

stage-drafs:
	/home/erik/bin/zola serve --drafts

deploy:
	ssh ewintr.nl /home/erik/bin/deploy-ewintr-nl.sh

