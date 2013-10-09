#!/usr/bin/env sh
cd /home/feste/opt/aws-mturk-clt-1.3.1/bin
./loadHITs.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 -label /home/feste/CoCoLab/prior-elicitation/prior -input /home/feste/CoCoLab/prior-elicitation/prior.input -question /home/feste/CoCoLab/prior-elicitation/prior.question -properties /home/feste/CoCoLab/prior-elicitation/prior.properties -maxhits 1